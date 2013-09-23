#!/usr/bin/env python2.7

__author__ = "Brian Hunter"
__email__  = "brian.hunter@cavium.com"

import utils
import os
import sys

########################################################################################
# Constants

# where we are located
UTUT_DIR   = os.path.dirname(os.path.realpath(__file__))

# Must be set by importer
Log = None

# Different types of patches available
TYPES = (CHAPTERS, FIXES) = xrange(2)

########################################################################################
def get_dir(revision, my_type):
    """
    Returns the name of the directory to use for either chapters or fixes

    revision  : (string) The name of the revision, such as 'v0.4'.
    my_type   : CHAPTERS or FIXES
    =>        : (string)
    """

    if my_type == CHAPTERS:
        return os.path.join(UTUT_DIR, revision, "chapters")
    else:
        return os.path.join(UTUT_DIR, revision, "fixes")

########################################################################################
def available_patches(my_type, revision):
    """
    Returns the list of patch files that are available.
    """

    try:
        cwd = os.getcwd()
    except:
        Log.critical("Unable to get current working directory.")
        sys.exit(248)

    dir = get_dir(revision, my_type)

    patches = os.listdir(dir)
    if my_type == CHAPTERS:
        patches = [int(it[7:-6]) for it in patches if it.endswith(".patch")]
    else:
        patches = [int(it[3:-6]) for it in patches if it.endswith(".patch")]

    os.chdir(cwd)
    return patches

########################################################################################
def fetch_patch(my_type, num, revision, root_dir=None):
    """
    Patches the current work directory with the given chapter or fix number.
    """

    import subprocess

    typename = {CHAPTERS : "chapter",
                FIXES : "fix"}[my_type]
    printed_typename = ("%s/chapter" % typename) if my_type == CHAPTERS else typename
    dir = get_dir(revision, my_type)

    Log.info("Patching with %s #%0d" % (printed_typename, num))

    # ensure that num is valid
    avail = available_patches(my_type, revision)
    if num not in avail:
        Log.critical("%s #%d is not a valid patch.  Available patches are: %s" % (printed_typename, num, sorted(avail)))
        sys.exit(251)

    # change to the root directory
    if not root_dir:
        try:
            root_dir = utils.calc_root_dir()
        except utils.AreaError:
            Log.critical("%s command must be run from within the project tree." % printed_typename)
            sys.exit(250)

    patch_file = os.path.join(dir, "%s%d.patch" % (typename, num))
    cmd = "git apply %s" % patch_file

    try:
        cwd = os.getcwd()
    except:
        Log.critical("Unable to get current working directory.")
        sys.exit(249)

    os.chdir(root_dir)

    # run the patch, add any ? files, repeat until no ? files
    Log.info("Patching files...")
    Log.debug("Running '%s'" % cmd)
    subprocess.Popen(cmd.split(), stderr=subprocess.STDOUT, stdout=subprocess.PIPE, cwd=root_dir).communicate()

    Log.info("Successfully updated %s with %s #%d" % (root_dir, printed_typename, num))
    os.chdir(cwd)

########################################################################################
if __name__ == '__main__':
    # test
    import logging
    log = utils.get_logger('log', logging.INFO)
    fetch_patch(CHAPTERS, 5, 'v1.0')
