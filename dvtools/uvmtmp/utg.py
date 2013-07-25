#!/usr/bin/env python2.7

########################################################################################
# Constants

__version__ = '0.10'
__author__  = "Brian Hunter"
__email__   = "brian.hunter@cavium.com"

# These templates are named whatever the name was specified as
DIRECTLY_NAMED = ('test', 'object', 'component', 'empty_file')

# These templates are included within other templates and are not available for usage
# on the command line
EXCLUDED_TEMPLATES = ('class_border', 'endif', 'ifndef', 'method_border', 'section_border', )

########################################################################################
# Imports
import os
import time
import sys
import argparse
import re
import logging
import cn_logging
import textwrap

########################################################################################
# Exceptions
class SkipLine(Exception):
    pass

########################################################################################
# Global Variables
UtgDir = os.path.dirname(os.path.realpath(__file__))
TemplateDir = os.path.join(UtgDir, 'uvm_templates')

# Set by setup()
Options = None
Log = None

# These substitutions do not stick between templates if they were prompted for
ClearedSubstitutions = ('<description>',)

Substitutions = None

########################################################################################
def getAllLines(templateName):
    """
    Fetch all the lines from a template file and return them.
    """

    # read in the template file
    tempFileName = os.path.join(TemplateDir, templateName+'.sv')
    try:
        file = open(tempFileName)
    except:
        Log.critical("Unable to find %s" % tempFileName)

    lines = file.readlines()
    file.close()
    return lines

########################################################################################
def fetchIncludes(allLines):
    """
    Continuously fetch any included templates until no more are needed.
    Return the new set of lines, fully expanded.
    """

    rexp = re.compile('<@(.*)>')
    while True:
        done = True
        newAllLines = []
        for line in allLines:
            reResults = rexp.match(line)
            if reResults:
                done = False
                incFile = reResults.group(1)
                incLines = getAllLines(incFile)
                newAllLines.extend(incLines)
            else:
                newAllLines.append(line)
        allLines = newAllLines[:]
        if done:
            break
    return newAllLines

########################################################################################
def absorbSubstitutions(allLines, absorbed, tempName):
    """
    Look for <$(name)> in the code and set Substitutions[name] equal to
    all of the following lines until <$end> is seen.
    Append name to the absorbed list, so that these Substitutions do not carry over to the
    next file.

    Return the new set of lines with the substitutions stripped out.
    """

    newAllLines = []
    rexp = re.compile('<\$(.*)>')
    inSub, subLines = False, []
    for lineno, line in enumerate(allLines):
        if not inSub:
            reResults = rexp.match(line)
            if reResults:
                inSub = True
                subName = reResults.group(1)
                Log.debug("Saw substitution: %s" % subName)
            else:
                newAllLines.append(line)
        elif line.startswith('<$end>'):
            sub = "<" + subName + ">"
            (subLines, junk) = makeSubstitutions(subLines, tempName)
            Substitutions[sub] = subLines
            absorbed.append(sub)
            inSub = False
            subLines = []
        else:
            subLines.append(line)
    return newAllLines

########################################################################################
def makeSubstitutions(allLines, tempName):
    """
    Go line-by-line.  Repeat until no substitutions need to be made.
    Return the new list of lines, and the list of substitutions that were prompted for.
    """

    answeredSubs = []
    rexp = re.compile('<(?P<sub>[^\>\?]*)(?P<maybe>\?*)>')

    Log.debug("Here with Substitutions= %s" % Substitutions)

    inClass = False  # set when we're on a line that's inside the class
    newLines = []
    for line in allLines:
        Log.debug("Looking at '%s'" % line.rstrip())
        # make the substitutions
        try:
            reResults = rexp.finditer(line)
            if reResults:
                line = handleMatch(reResults, line, answeredSubs, newLines, tempName)

            # detect class
            if not inClass and (line.startswith('class ') or line.startswith('interface ')):
                inClass = True

            # add it to the lines?
            if not Options.classonly or inClass:
                Log.debug("Adding: '%s'" % line)
                newLines.append(line)

            # detect end of class
            if inClass and (line.startswith('endclass ') or line.startswith('endinterface ')):
                inClass = False

        except SkipLine:
            Log.debug("Skipping line because it is empty.")
            continue

    return newLines, answeredSubs

########################################################################################
def handleMatch(reResults, line, answeredSubs, newLines, tempName):
    newLine = line

    if reResults:
        for reResult in reResults:
            Log.debug("reResults = %s" % str(reResult.groups()))
            sub, maybe = ("<%s>" % reResult.group('sub')), (reResult.group('maybe') == '?')

            Log.debug("Here with sub = %s, maybe = %s" % (sub, maybe))

            # get the substitution, or prompt for it
            if sub not in Substitutions:
                Log.debug("%s not in Substitutions." % sub)

                # Conditional substitutions just get skipped
                if maybe:
                    Log.debug("Replacing '%s' with ''" % reResult.group(0))
                    newLine = newLine.replace(reResult.group(0), "")
                    if not newLine.rstrip():
                        raise SkipLine

                # otherwise, require that the user fill in the value
                if not Options.quiet:
                    fetchAnswer(tempName, sub)
                    answeredSubs.append(sub)
                else:
                    # just leave the text alone
                    Substitutions[sub] = sub
                    answeredSubs.append(sub)

            # make the substitution:  either just a simple string replacement, or a list of lines
            if type(Substitutions[sub]) == str:
                Log.debug("Replacing %s with %s on line %s" % (sub, Substitutions[sub], newLine))
                newLine = newLine.replace(sub, Substitutions[sub])
            else:
                # happens when the substitution is a list of lines
                newLines.extend(Substitutions[sub])
                raise SkipLine

    return newLine

########################################################################################
def fetchAnswer(tempName, sub):
    answer = raw_input("%s %s: Enter substitution for %s: " % (Options.name, tempName, sub))
    if answer == "":
        answer = sub.replace('<', '[').replace('>', ']')

    # trim _pkg from answer
    if sub in ("<pkg_name>", "<PKG_NAME>") and (answer.endswith('_pkg') or answer.endswith('_PKG')):
        answer = answer[:-4]

    # set the substitutions for sub and SUB
    Substitutions[sub] = answer
    Substitutions[sub.swapcase()] = answer.swapcase()

########################################################################################
def printLines(allLines):
    """
    Print all of the lines, either to stdout or to the correct file.
    """

    if Options.file:
        fileName = Substitutions['<filename>']
        target = open(fileName, 'w')
    else:
        target = sys.stdout

    for line in allLines:
        print >>target, line,

    if Options.file:
        target.close()

########################################################################################
def determineFilename(tempName):
    """
    Figures out what the filename should be based on all the information available and returns it.
    """

    if Options.filename:
        return Options.filename

    if tempName == 'base_test':
        return 'base_test.sv'

    if tempName in DIRECTLY_NAMED:
        if Options.name is not None:
            filename = Options.name
        else:
            filename = tempName
    else:
        filename = tempName if not Options.name else ("%s_%s" % (Options.name, tempName))

    if "<name>" not in Substitutions:
        fetchAnswer(tempName, "<name>")
    name = Substitutions["<name>"]
    if not name.endswith("_%s" % tempName):
        filename = "%s_%s" % (name, tempName)
    else:
        filename = name

    # add .sv?
    if not filename.endswith('.sv'):
        filename += ".sv"

    # prepend package name?
    try:
        pkgName = Substitutions["<pkg_name>"]
        if not filename.startswith("%s_" % pkgName):
            filename = "%s_%s" % (pkgName, filename)
    except KeyError:
        pass

    return filename

########################################################################################
def templateVkit(createVcomponent=False):
    import area_utils

    global Substitutions

    vDirName = {False: 'vkits', True: 'vcomponents'}[createVcomponent]

    if not Options.name:
        Log.critical("No name for the %s was specified on the command-line." % vDirName)
    else:
        vkName = Options.name

    rootDir = area_utils.calcRootDir()
    vkitDir = os.path.join(rootDir, "verif/%s" % vDirName)
    newDir = os.path.join(vkitDir, vkName)

    if os.path.exists(newDir):
        Log.critical("Path %s already exists!" % newDir)

    os.mkdir(newDir)

    # create an flist file there
    lines = ["+incdir+../../verif/%s/%s\n" % (vDirName, vkName),
             "../../verif/%s/%s/%s_pkg.sv\n" % (vDirName, vkName, vkName)
             ]
    flistFileName = os.path.join(newDir, "%s.flist" % vkName)
    file = open(flistFileName, 'w')
    file.writelines(lines)
    file.close()

    os.chdir(newDir)
    Options.file = True
    Substitutions['<description>'] = "%s package" % vkName
    Substitutions['<name>'] = vkName
    Substitutions['<pkg_name>'] = vkName
    templateIt('pkg')

    Log.info("Created %s %s" % (vDirName, vkName))

########################################################################################
def templateIt(tempName):
    """
    Load the template file, perform the substitutions, and print it out.
    """

    # set the template variable
    className = tempName if not Options.name else ("%s_%s" % (Options.name, tempName))
    Substitutions['<template>'] = className
    Substitutions['<TEMPLATE>'] = className.upper()

    if not Options.classonly:
        filename = determineFilename(tempName)

        Substitutions['<filename>'] = filename
        # for `ifndef headers:
        Substitutions['<FILENAME>'] = filename.replace(".sv", "").upper()

    if Options.file:
        Log.info("Creating %s" % filename)

    # Get the template
    lines = getAllLines(tempName)

    # expand all of the includes
    lines = fetchIncludes(lines)

    # check for options
    lines = checkOptions(lines)

    # absorb any substitutions from the file
    absorbedSubs = []
    lines = absorbSubstitutions(lines, absorbedSubs, tempName)

    # Make substitutions
    lines, answeredSubs = makeSubstitutions(lines, tempName)

    # print out the template
    printLines(lines)

    # remove substitutions that don't cross templates if they were prompted (substitution, for example)
    for sub in ClearedSubstitutions:
        if sub in answeredSubs:
            del Substitutions[sub]

    # remove any absorbed substitutions
    for sub in absorbedSubs:
        if sub in Substitutions:
            Log.debug("Removing %s" % sub)
            del Substitutions[sub]

########################################################################################
def checkOptions(lines):
    """
    When a line is of the form: <?blah>, then check to see if Options.blah is set.  If it
    isn't, then skip lines until <?end>.  Otherwise, keep these lines.
    """

    rexp = re.compile(r'\<\?(\w+)\>')
    result = []
    skipping = False

    for line in lines:
        res = rexp.match(line)
        if res:
            option = res.group(1)
            if option == 'end':
                skipping = False
            else:
                try:
                    if not vars(Options)[option]:
                        skipping = True
                except KeyError:
                    Log.critical("Line '%s' contains an unrecognized option." % line)
        else:
            if not skipping:
                result.append(line)

    return result

########################################################################################
def createSubstitutions():
    global Substitutions

    Substitutions = {
        '<author>'      : os.environ['LOGNAME'],
        '<year>'        : str(time.localtime()[0]),
        '<utgversion>'  : __version__,
        '<template>'    : None,    # the name of the template, filled in later
    }

    # Create Upper-case versions of Substitutions:
    if Options.name:
        Substitutions['<name>'] = Options.name
        Substitutions['<NAME>'] = Options.name.upper()

    if Options.description:
        Substitutions['<description>'] = Options.description

    # if sitting in a vkits/vcomponents directory, then use that directory name as the pkg_name
    cwd = os.getcwd().split('/')
    if cwd[-2] in ('vkits', 'vcomponents'):
        Substitutions['<pkg_name>'] = cwd[-1]
        Substitutions['<PKG_NAME>'] = Substitutions['<pkg_name>'].upper()

########################################################################################
def setup(argv):
    global Options
    global Log

    # investigate utemplates directory for available templates
    allTemplates = [it[:-3] for it in os.listdir(TemplateDir) if it.endswith('.sv') and it[:-3] not in EXCLUDED_TEMPLATES]
    if not allTemplates:
        Log.critical("There are No Templates in the directory %s. Cannot continue!" % TemplateDir)

    # this template is not part of other templates
    allTemplates.extend(["vkit", "vcomponent"])
    allTemplatesStr = textwrap.fill(', '.join(allTemplates), width=80)

    p = argparse.ArgumentParser(
        prog='utg',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        usage="utg <template0> [<template1> ...] [options]",
        version="%(prog)s v"+str(__version__),
        description="""UVM Template Generator, v%s

These templates are currently available:

%s

Examples:
> utg agent -n foo -f
First prompts the user for a description, and then writes out the file foo_agent.sv.

> utg agent drv mon sqr -n foo --classonly
Prints out just the classes foo_agent_c, foo_drv_c, foo_mon_c, and foo_sqr_c to the screen.

> utg phases -n foo

Prints out the standard component phases to the screen.
""" % (__version__, allTemplatesStr))

    p.add_argument('templates',           action='append',    nargs='+',    default=None,     choices=allTemplates)
    p.add_argument('-n', '--name',        action='store',                   default=None,     help="Name of the component(s)")
    p.add_argument('-d', '--description', action='store',                   default=None,     help="Brief description for the header")
    p.add_argument('-f', '--file',        action='store_true',              default=False,    help="Write it out to the appropriately named file")
    p.add_argument('--filename',          action='store',                   default=None,     help="The filename to use (only legal when there is one template given).")
    p.add_argument('-c', '--classonly',   action='store_true',              default=False,    help="When set, only create the class or interface and skip the header")
    p.add_argument('-q', '--quiet',       action='store_true',              default=False,    help="When set, do not prompt for unknown variables, just leave them in <template> format")
    p.add_argument('--dbg',               action='store_true',              default=False,    help="Turns on debug-level information.")

    try:
        Options = p.parse_args(argv)
    except:
        print "Usage error: See utg -h for more information."
        sys.exit(1)

    verbosity = {False: logging.INFO, True: logging.DEBUG}[Options.dbg]

    if not Log:
        Log = cn_logging.createLogger('log', verbosity)

    # check legality
    if Options.filename and len(Options.templates[0]) != 1:
        Log.critical("You may not specify a filename when more than one template is on the command-line.")

    if Options.filename:
        Options.file = True

    if Options.classonly:
        Log.critical("--classonly may not be used at the same time.")

    # create all of the substitution variables
    createSubstitutions()

########################################################################################
def main(argv=None):
    from cmdline import logUsage
    logUsage('utg', __version__)

    if not argv:
        argv = sys.argv[1:]

    # parse the arguments and create the default substitution variables
    setup(argv)

    # for each template, do it
    allTemplates = Options.templates[0]
    if 'vkit' in allTemplates:
        templateVkit(createVcomponent=False)
        Log.info("Exiting.")
        sys.exit(0)

    if 'vcomponent' in allTemplates:
        templateVkit(createVcomponent=True)
        Log.info("Exiting.")
        sys.exit(0)

    for template in allTemplates:
        templateIt(template)
        if len(allTemplates) > 1 and not Options.file:
            Log.info("<----- %s CUT HERE ----->" % template)

########################################################################################
if __name__ == "__main__":
    main()
