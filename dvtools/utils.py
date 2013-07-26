#!/usr/bin/env python2.7

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
