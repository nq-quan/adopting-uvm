#!/usr/bin/env python2.7

__author__ = "Brian Hunter"
__email__  = "brian.hunter@cavium.com"

import area_utils
import os

########################################################################################
# Constants

# where we are located
UTUT_DIR   = os.path.dirname(os.path.realpath(__file__))

# Must be set by importer
Log = None

# Different types of patches available
TYPES = (LESSONS, FIXES) = xrange(2)

########################################################################################
def getDir(revision, myType):
    """
    Returns the name of the directory to use for either lessons or fixes

    revision  : (string) The name of the revision, such as 'v0.4'.
    myType      : LESSONS or FIXES
    =>        : (string)
    """

    if myType == LESSONS:
        return os.path.join(UTUT_DIR, revision, "lessons")
    else:
        return os.path.join(UTUT_DIR, revision, "fixes")

########################################################################################
def availablePatches(myType, revision):
    """
    Returns the list of patch files that are available.
    """

    try:
        cwd = os.getcwd()
    except:
        Log.critical("Unable to get current working directory.")

    dir = getDir(revision, myType)

    patches = os.listdir(dir)
    if myType == LESSONS:
        patches = [int(it[6:-6]) for it in patches if it.endswith(".patch")]
    else:
        patches = [int(it[3:-6]) for it in patches if it.endswith(".patch")]

    os.chdir(cwd)
    return patches

########################################################################################
def fetchPatch(myType, num, revision, rootDir=None):
    """
    Patches the current work directory with the given lesson or fix number.
    """

    import svn_tools as svn
    import subprocess
    svn.Log = Log

    typename = {LESSONS : "lesson",
                FIXES : "fix"}[myType]
    printedTypename = ("%s/chapter" % typename) if myType == LESSONS else typename
    dir = getDir(revision, myType)

    Log.plain_info("Patching with %s #%0d" % (printedTypename, num))

    # ensure that num is valid
    avail = availablePatches(myType, revision)
    if num not in avail:
        Log.critical("%s #%d is not a valid patch.  Available %s patches are: %s" % (printedTypename, num, avail))

    # change to the root directory
    if not rootDir:
        try:
            rootDir = area_utils.calcRootDir()
        except area_utils.AreaError:
            Log.critical("%s command must be run from within the project tree." % printedTypename)

    patchFile = os.path.join(dir, "%s%d.patch" % (typename, num))
    cmd = "patch -p0 -f -s --no-backup-if-mismatch -i %s" % patchFile

    try:
        cwd = os.getcwd()
    except:
        Log.critical("Unable to get current working directory.")

    os.chdir(rootDir)

    # run the patch, add any ? files, repeat until no ? files
    Log.info("Patching files...")
    Log.debug("Running '%s'" % cmd)
    subprocess.Popen(cmd.split(), stderr=subprocess.STDOUT, stdout=subprocess.PIPE, cwd=rootDir).communicate()

    results = svn.analyze_status(rootDir)
    addFiles = []
    for file in results:
        for item in results[file]:
            if (svn.NORMAL, "?") in item:
                addFiles.append(file)
                break
    if len(addFiles):
        svncmd = "add %s" % (' '.join(addFiles))
        svn.run(svncmd, rootDir, quiet=True)

    Log.info("Successfully updated %s with %s #%d" % (rootDir, printedTypename, num))

    os.chdir(cwd)

########################################################################################
if __name__ == '__main__':
    # test
    import logging
    import cn_logging
    Log = cn_logging.createLogger('log', logging.INFO)
    fetchPatch(LESSONS, 5, 'v1.0')
