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
TYPES = (CHAPTERS, FIXES) = xrange(2)

########################################################################################
def getDir(revision, myType):
    """
    Returns the name of the directory to use for either chapters or fixes

    revision  : (string) The name of the revision, such as 'v0.4'.
    myType      : CHAPTERS or FIXES
    =>        : (string)
    """

    if myType == CHAPTERS:
        return os.path.join(UTUT_DIR, revision, "chapters")
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
    print dir
    print patches
    if myType == CHAPTERS:
        patches = [int(it[7:-6]) for it in patches if it.endswith(".patch")]
    else:
        patches = [int(it[3:-6]) for it in patches if it.endswith(".patch")]

    os.chdir(cwd)
    return patches

########################################################################################
def fetchPatch(myType, num, revision, rootDir=None):
    """
    Patches the current work directory with the given chapter or fix number.
    """

    import subprocess

    typename = {CHAPTERS : "chapter",
                FIXES : "fix"}[myType]
    printedTypename = ("%s/chapter" % typename) if myType == CHAPTERS else typename
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
    cmd = "git apply %s" % patchFile

    try:
        cwd = os.getcwd()
    except:
        Log.critical("Unable to get current working directory.")

    os.chdir(rootDir)

    # run the patch, add any ? files, repeat until no ? files
    Log.info("Patching files...")
    Log.debug("Running '%s'" % cmd)
    subprocess.Popen(cmd.split(), stderr=subprocess.STDOUT, stdout=subprocess.PIPE, cwd=rootDir).communicate()

    Log.info("Successfully updated %s with %s #%d" % (rootDir, printedTypename, num))
    os.chdir(cwd)

########################################################################################
if __name__ == '__main__':
    # test
    import logging
    log = logging.getLogger('log')
    log.setLevel(logging.INFO)
    console = logging.StreamHandler()
    log.addHandler(console)

    fetchPatch(CHAPTERS, 5, 'v1.0')
