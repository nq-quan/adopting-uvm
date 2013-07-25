#!/usr/bin/env python
#-*- mode: Python;-*-

# ***********************************************************************
# * File        : untb
# * Author      : bhunter
# * Description : UVM New Testbench
# ***********************************************************************

__version__ = '0.3.0'
__author__  = "Brian Hunter"
__email__   = "brian.hunter@cavium.com"

########################################################################################
# Imports
import os
import utg
import logging
import cn_logging
import argparse
import sys
import area_utils
import shutil

########################################################################################
# Constants

########################################################################################
# Globals
Options = None
Log = None
RootDir, VerifDir = None, None
TbPath = None

########################################################################################
def setup():
    global Options
    global Log
    global RootDir, VerifDir

    p = argparse.ArgumentParser(
        prog='untb',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        usage="untb <tb_name>",
        version="%(prog)s v"+str(__version__),
        description="""UVM New Testbench Generator, v%s""" % __version__)

    p.add_argument('tbname',            action='append',     nargs='+',   default=None)
    p.add_argument('-f', '--force',     action='store_true',              default=False,   help="Force creation of new testbench even if it already exists.")
    p.add_argument('-d', '--dbg',       action='store_true',              default=False,   help="Turns on debug lines.")

    try:
        Options = p.parse_args()
    except:
        print "Usage error: See untb -h for more information."
        sys.exit(1)

    verbosity = {False: logging.INFO, True: logging.DEBUG}[Options.dbg]
    Log = cn_logging.createLogger('log', verbosity)
    utg.Log = Log

    try:
        RootDir = area_utils.calcRootDir(views=True)
    except area_utils.AreaError:
        Log.critical("CWD is not in an Octeon Tree.")

    VerifDir = os.path.join(RootDir, "verif")

########################################################################################
def createTb(path, tbname):
    Log.info("Creating Testbench %s" % path)

    newtbPath = os.path.join(os.path.dirname(__file__), 'newtb')

    if Options.force and os.path.exists(path):
        Log.info("Removing existing testbench: %s" % path)
        shutil.rmtree(path)

    # copy files into new path
    try:
        shutil.copytree(newtbPath, path)
    except OSError, err:
        Log.critical("Unable to create new directory: %s" % err)

    # replace all instances of <TB> in all the files
    os.chdir(path)

    # remove .svn if it exists
    try:
        shutil.rmtree('.svn')
        shutil.rmtree('tests/.svn')
    except:
        pass

    # replace any <TB> found in any file
    for (dirpath, dirnames, filenames) in os.walk('.'):
        for filename in filenames:
            file = open(filename)
            lines = file.readlines()
            newlines = []
            for line in lines:
                newlines.append(line.replace('<TB>', tbname))
            file.close()
            file = open(filename, 'w')
            file.writelines(newlines)
            file.close()

    # rename TB.flist to tbname.flist
    os.rename('TB.flist', '%s.flist' % tbname)

    # create any utg files
    useUtg(tbname)

########################################################################################
def useUtg(tbname):
    cwd = os.getcwd()

    # create <tbname>_tb_top.sv
    arguments = ("tb_top -n %s -f -q" % tbname).split()
    utg.main(arguments)

    # create tests/base_test.sv
    os.chdir('tests')
    arguments = ("base_test -n %s -f -q" % tbname).split()
    utg.main(arguments)

    # create tests/basic.sv
    arguments = ("test -n basic -f -q").split()
    utg.main(arguments)

    os.chdir(cwd)

########################################################################################
def main():
    from cmdline import logUsage
    logUsage('untb.py', __version__)

    setup()
    for tbName in Options.tbname[0]:
        # create directory
        tbPath = os.path.join(VerifDir, tbName)
        createTb(tbPath, tbName)

########################################################################################
if __name__ == '__main__':
    main()
