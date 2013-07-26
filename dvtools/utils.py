#!/usr/bin/env python2.7

#######################################################################################
# Globals

Log = None

########################################################################################
# Imports

import os

#######################################################################################
class AreaError(Exception):
    pass

########################################################################################
def upDir(path):
    """
    Returns the directory above the current one.

    path : (str) A working directory path.
    =>   : (str) The directory above path.
    """

    return os.path.abspath(os.path.join(path, '..'))

########################################################################################
def gitscrub():
    """
    Clean out the area from the root directory
    """

    import subprocess

    root_dir = calc_root_dir()
    cwd = os.getcwd()
    os.chdir(root_dir)
    Log.info("Scrubbing area...")
    cmdlines = ('git reset HEAD verif rtl',
                'git clean -fxd -e newtb/tests',
                'git checkout verif rtl')

    for cmdline in cmdlines:
        Log.debug("Running '%s'" % cmdline)
        proc = subprocess.Popen(args=cmdline, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=file(os.devnull, 'r+'))
        proc.wait()

    os.chdir(cwd)

#######################################################################################
def calc_root_dir():
    """
    Calculate the root directory of the environment tree from which
    this script was run.  Returned as a string.

    views   : (bool) Deprecated. Does Nothing.
    dir     : (str) if given determines the directory from which to determine the project root.
                If it is not given, the cwd is used.
                Before it is used, it is made to be a real path, removing relative and usernmae references
    =>      : (str) The root directory of the project.

    """

    try:
        currPath = os.getcwd()
    except:
        raise AreaError, "Current working directory does not exist."

    originalPath = currPath

    target = '.git'

    while not os.path.exists(os.path.join(currPath, target)):
        currPath = upDir(currPath)
        if currPath == "/":
            raise AreaError, ' '.join([originalPath, "is not in a project tree."])

    return currPath
