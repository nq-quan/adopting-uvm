#!/usr/bin/env python2.7

__version__ = '0.3.0'
__author__  = "Brian Hunter"
__email__   = "brian.hunter@cavium.com"
__description__ = "UVM New Testbench Generator, v%s" % __version__

########################################################################################
# Imports
import os
import utg
import logging
import argparse
import sys
import shutil
import utils

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
        description=__description__)

    p.add_argument('tb_name',           action='append',     nargs='+',   default=None)
    p.add_argument('-f', '--force',     action='store_true',              default=False,   help="Force creation of new testbench even if it already exists.")
    p.add_argument('-d', '--dbg',       action='store_true',              default=False,   help="Turns on debug lines.")

    try:
        Options = p.parse_args()
    except:
        print "Usage error: See untb -h for more information."
        sys.exit(1)

    verbosity = {False: logging.INFO, True: logging.DEBUG}[Options.dbg]
    Log = utils.get_logger('log', verbosity)
    utg.Log = Log

    try:
        RootDir = utils.calc_root_dir()
    except utils.AreaError:
        Log.critical("CWD is not in an Octeon Tree.")
        sys.exit(255)

    VerifDir = os.path.join(RootDir, "verif")

########################################################################################
def create_tb(path, tb_name):
    Log.info("Creating Testbench %s" % path)

    newtb_path = os.path.join(os.path.dirname(__file__), 'newtb')

    if Options.force and os.path.exists(path):
        Log.info("Removing existing testbench: %s" % path)
        shutil.rmtree(path)

    # copy files into new path
    try:
        shutil.copytree(newtb_path, path)
    except OSError, err:
        Log.critical("Unable to create new directory: %s" % err)
        sys.exit(255)

    # replace all instances of <TB> in all the files
    os.chdir(path)

    # replace any <TB> found in any file
    for (dirpath, dirnames, filenames) in os.walk('.'):
        # remove the .gitignore in the tests directory, it is only there to ensure
        # that the directory can be added to git
        if filenames[0] == '.gitignore':
            os.remove(os.path.join(path, dirpath, filenames[0]))
            continue
        for filename in filenames:
            file = open(filename)
            lines = file.readlines()
            newlines = []
            for line in lines:
                newlines.append(line.replace('<TB>', tb_name))
            file.close()
            file = open(filename, 'w')
            file.writelines(newlines)
            file.close()

    # rename TB.flist to tb_name.flist
    os.rename('TB.flist', '%s.flist' % tb_name)

    # create any utg files
    use_utg(tb_name)

########################################################################################
def use_utg(tb_name):
    cwd = os.getcwd()

    # create <tb_name>_tb_top.sv
    arguments = ("tb_top -n %s -f -q" % tb_name).split()
    utg.main(arguments)

    # create tests/base_test.sv
    print os.getcwd()
    os.chdir('tests')
    arguments = ("base_test -n %s -f -q" % tb_name).split()
    utg.main(arguments)

    # create tests/basic.sv
    arguments = ("test -n basic -f -q").split()
    utg.main(arguments)

    os.chdir(cwd)

########################################################################################
def main():
    # from cmdline import logUsage
    # logUsage('untb.py', __version__)

    setup()
    for tb_name in Options.tb_name[0]:
        # create directory
        tbPath = os.path.join(VerifDir, tb_name)
        create_tb(tbPath, tb_name)

########################################################################################
if __name__ == '__main__':
    main()
