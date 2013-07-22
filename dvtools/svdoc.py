#!/usr/bin/env python2.7

########################################################################################
# Imports
import area_utils
import os
import subprocess
import sys
import re
import cn_logging, logging
import ConfigParser
import argparse

########################################################################################
# Constants

__version__       = "0.4"
__author__        = "Brian Hunter"
__email__         = 'brian.hunter@cavium.com'


MY_DIR      = os.path.dirname(os.path.realpath(__file__))
ALWAYS_EXCLUDE_DIRS = ('.svn', 'sim', 'obj', 'failures', 'project')

DESCRIPTION = """
* Should be run from a testbench directory.
* Looks for a file named svdoc.ini in the cwd (see below).
  If it finds one, then svdoc.py uses it to calculate what files
  should be parsed.
* By default, all vkits will be parsed.
* Creates the documentation in verif/tools/naturaldocs/docs
  Do not check this directory in.

INI File Format:
* Start with a group name enclosed in brackets.
* The group name is irrelevant, but must be some text.
* INI files can have one of two variables:
  * includes = <directories that shall be parsed>
  * excludes = <directories that must not be parsed>
* Directories should start from 'verif'.
* Directories should be separated by whitespace.

Example svdoc.ini file specifying only these directories:

[USB3]
includes = verif/usbh_uctl verif/vkits/usbh_uctl
   verif/vkits/gmncb
"""

########################################################################################
# Global Variables

RootDir     = area_utils.calcRootDir()
NaturalDocs = os.path.join(MY_DIR, "NaturalDocs/NaturalDocs")
VerifDir    = os.path.join(RootDir, "verif")
VkitsDir    = os.path.join(VerifDir, "vkits")
ProjectDir  = os.path.join(VerifDir, "tools/naturaldocs")
ProjectIni  = os.path.join(ProjectDir, "svdoc.ini")

# the global Logger
Log = None

# global options
Options = None

########################################################################################
def calculateProjectDirs():
   global OutputDir, IndexHtml, MenuFile

   OutputDir   = os.path.join(ProjectDir, "docs")
   IndexHtml   = os.path.join(OutputDir, "index.html")
   MenuFile    = os.path.join(ProjectDir, "Menu.txt")
      
########################################################################################
def parseArgs():
   "Set up the Log variable"

   global Log, Options

   # parse arguments
   p = argparse.ArgumentParser(
      prog='svdoc.py',
      formatter_class=argparse.RawDescriptionHelpFormatter,
      usage='svdoc.py',
      version='%(prog)s v' + __version__,
      description=DESCRIPTION)

   p.add_argument('--nolaunch', '-n', action='store_true', default=False, help="Do not launch Firefox when completed.")
   p.add_argument('--clean',    '-c', action='store_true', default=False, help="Cleans up all generated files.")
   p.add_argument('--groups',   '-g', action='store_true', default=False, help="Do not launch Naturaldocs. Just print the groups.")
   p.add_argument('--outdir',   '-o', action='store',      default=None,  help="Specify the directory where Naturaldocs will place its output.")
   p.add_argument('--frame',    '-f', action='store_true', default=False, help="Create HTML with frames.")
   p.add_argument('--dbg',      '-d', action='store_true', default=False, help="Turns on debug.")

   Options = p.parse_args()

   # Create the Log
   Log = cn_logging.getLogger('log')
   Log.setLevel({True:logging.DEBUG, False:logging.INFO}[Options.dbg])

   console = logging.StreamHandler()
   console.setFormatter(cn_logging.formatter)
   Log.addHandler(console)

   if Options.outdir:
      global ProjectDir
      ProjectDir = Options.outdir

   # ensure that ProjectDir exists
   if not os.path.exists(ProjectDir):
      Log.info("Creating %s" % ProjectDir)
      try:
         os.mkdir(ProjectDir)
      except:
         Log.critical("Unable to create directory '%s'" % ProjectDir)
         
   # set all global project filenames and directories
   calculateProjectDirs()
   
########################################################################################
def parseIniFiles():
   global IncludeDirs, ExcludeDirs

   cwd = os.getcwd()
   vars = ('includes', 'uvm_version', 'excludes')
   info = {}
   for var in vars:
      info[var] = []
   
   iniFiles = [ProjectIni]
   if os.path.exists(os.path.join(cwd, 'svdoc.ini')):
      iniFiles.append('svdoc.ini')

   parser = ConfigParser.SafeConfigParser()
   for iniFile in iniFiles:
      Log.info("Parsing .ini file: %s" % iniFile)
      try:
         parser.read(iniFile)
      except ConfigParser.ParsingError, err:
         Log.critical(err)
      
   blocks = parser.sections()
   for block in blocks:
      for var in vars:
         try:
            v = parser.get(block, var)
            v = [it for it in v.split() if it != '\\']
            info[var].extend(v)
         except ConfigParser.NoOptionError:
            pass

   IncludeDirs = [os.path.join(RootDir, it) for it in info['includes'] ]
   ExcludeDirs = [os.path.join(RootDir, it) for it in info['excludes'] ]

   # always include the current directory
   if cwd not in IncludeDirs:
      IncludeDirs.append(cwd)
      
   # add UVM vkits not in uvm_version to ExcludeDirs
   versions = os.listdir(os.path.join(VkitsDir, 'uvm'))
   ExcludeDirs.extend([os.path.join(VkitsDir, 'uvm', it) for it in versions if it not in info['uvm_version'] and it != ".svn"])

########################################################################################
def createGroup(startingDir, dirName, spaces, file):
   """
   Creates a group for the Menu file.
   Does this by examining what's in the starting directory, and recursively walking
   down each directory unless it's in ALWAYS_EXCLUDE_DIRS.  Since Naturaldocs will
   find these, it also adds these to ExcludeDirs.
   """

   global ExcludeDirs

   # get the groupName
   groupName = dirName.replace(startingDir, '')[1:]

   listing = os.listdir(dirName)
   allDirs = [os.path.join(dirName, it) for it in listing if it not in ALWAYS_EXCLUDE_DIRS]
   allDirs = filter(os.path.isdir, allDirs)
   allDirs = filter(lambda x: x not in ExcludeDirs, allDirs)
   allDirs = sorted(allDirs)

   print >>file, "%sGroup: %s {" % (spaces*' ',groupName)
   Log.plain_info("%sGroup: %s" % (spaces*' ',groupName))
   for dir in allDirs:
      if not IncludeDirs or (dir in IncludeDirs):
         createGroup(dirName, dir, spaces+3, file)

   print >>file, r"   } # Group: %s" % groupName
   print >>file, ""

   # Ensure that Naturaldocs does not parse these found directories
   foundExcludeDirs = [os.path.join(dirName, it) for it in listing if it in ALWAYS_EXCLUDE_DIRS]
   ExcludeDirs.extend(foundExcludeDirs)

########################################################################################
def createMenuFile():
   """
   """

   fileName = os.path.join(ProjectDir, "Menu.txt")
   if os.path.exists(fileName):
      os.remove(fileName)

   file = open(fileName, 'w')
   print >>file, """Format: 1.52

Don't Index: Interfaces

"""

   # put all of the groups in there
   for incDir in IncludeDirs:
      createGroup(VerifDir, incDir, 0, file)

   print >>file, r"""##### Do not change or remove these lines. #####
Data: 1(h3333\c639pf/h3YRN\tGH36Iu9T3/GH8c3/A8t6)
Data: 1(D3333\c639pf/h3YRN\tGH36Iu9T3/GH8c36Iu9)
"""

   file.close()
   
########################################################################################
def fixMenu():
   """
   Reads in the Menu.txt file and fixes stuff that UVM puts in there which confuses Naturaldocs.
   """
   
   rexp = re.compile(r'(\s*)File:\s+(.*)\s+(#.*;)\s+(\S+)')

   Log.info("Examining %s" % MenuFile)
   
   newLines = []
   file = open(MenuFile)
   fixed = False
   for line in file:
      rexpResults = rexp.match(line)
      if rexpResults:
         Log.debug("Fixing line: %s" % line)
         line = "%sFile: %s %s" % (rexpResults.group(1), rexpResults.group(2), rexpResults.group(4))
         fixed = True
      newLines.append(line)
   file.close()
   
   # if a fix was made, then re-write the file
   if fixed:
      file = open(MenuFile, 'w')
      file.writelines(newLines)
      file.close()
   
########################################################################################
def launchNaturalDocs():
   """
   Launches a command that looks something like this:

   % NaturalDocs -i spoc/ -i vkits/ -xi spoc/sim -p tools/naturaldocs/ -o HTML tools/naturaldocs/docs/
   """

   # create OutputDir to ensure that it exists
   rebuild = not os.path.exists(OutputDir)
   if rebuild:
      os.mkdir(OutputDir)
   
   cmd = NaturalDocs + " -i " + " -i ".join(IncludeDirs)
   cmd += " -xi " + " -xi ".join(ExcludeDirs)
   cmd += " -p " + ProjectDir
   outputType = {False:'HTML', True:'FramedHTML'}[Options.frame]
   cmd += " -o " + outputType
   cmd += " " + OutputDir

   if rebuild:
      cmd += " -ro"
   
   #print "Sending command: '%s'" % cmd
   Log.info("Running NaturalDocs...")
   Log.debug("...with command '%s'" % cmd)

   p = subprocess.Popen(args=cmd, stdin=file(os.devnull, "r+"), stderr=subprocess.PIPE, shell=True)
   (stdout, stderr) = p.communicate()

   if p.returncode:
      Log.critical("Error!\n%s" % stderr)

########################################################################################
def launchFirefox():
   if not os.path.exists(IndexHtml):
      Log.critical("%s was not created." % IndexHtml)

   cmd = "firefox " + IndexHtml
   p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=None)
   sys.exit(0)

########################################################################################
def cleanup():
   """
   Removes all generated files from naturaldocs directory.
   """

   from shutil import rmtree

   dirs = [OutputDir, os.path.join(ProjectDir, "Data")]

   for dir in dirs:
      if os.path.exists(dir):
         Log.info("Removing %s..." % dir)
         rmtree(dir, ignore_errors=True)
      
   files = ['Topics.txt', 'Menu.txt', 'Languages.txt']

   for file in files:
      full_name = os.path.join(ProjectDir, file)
      if os.path.exists(full_name):
         Log.info("Removing %s..." % full_name)
         try:
            os.remove(full_name)
         except:
            Log.critical("Unable to remove '%s'" % full_name)
   
########################################################################################
def main():

   try:
      # setup logger (for now)
      parseArgs()

      if Options.clean:
         cleanup()
         sys.exit()

      parseIniFiles()

      createMenuFile()

      if not Options.groups:
         #fixMenu()
         launchNaturalDocs()

         if not Options.nolaunch:
            launchFirefox()
   except KeyboardInterrupt:
      Log.plain_info("Ctrl-C Detected. Aborting.")
      sys.exit(1)
      
########################################################################################
if __name__ == '__main__':
   from cmdline import logUsage
   from exceptions import SystemExit

   logUsage('svdoc.py', __version__)
   
   try:
      main()
   except SystemExit, e:
      exit(int(str(e)))
   except:
      import email_utils
      email_utils.mail_traceback('webmaster@cavium.com', __email__,
                                 'svdoc.py v%s Error Detected' % __version__)
      raise
         
