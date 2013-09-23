#!/usr/bin/env python2.7

########################################################################################
# Constants

__version__ = '1.0'
__author__  = "Brian Hunter"
__email__   = "brian.hunter@cavium.com"

# These are the algorithms for determining a file's name
FILENAMES = {
    'agent'         : "vkit_name_temp.sv",
    'base_test'     : "temp.sv",
    'cfg'           : "vkit_name_temp.sv",
    'component'     : "vkit_name.sv",
    'drv'           : "vkit_name_temp.sv",
    'empty_file'    : "vkit_name.sv",
    'env'           : "vkit_name_temp.sv",
    'intf'          : "vkit_name_temp.sv",
    'item'          : "vkit_name_temp.sv",
    'mon'           : "vkit_name_temp.sv",
    'object'        : "vkit_name.sv",
    'pkg'           : "vkit_temp.sv",
    'reg_adapter'   : "vkit_name_temp.sv",
    'reg_block'     : "name_temp.sv",
    'seq'           : "vkit_name_temp.sv",
    'seq_lib'       : "vkit_name_temp.sv",
    'sqr'           : "vkit_name_temp.sv",
    'subscriber'    : "vkit_name_temp.sv",
    'tb_top'        : "name_temp.sv",
    'test'          : "name.sv",
    'vseq'          : "vkit_name_temp.sv",
    'vseq_lib'      : "vkit_name_temp.sv",
    'vsqr'          : "vkit_name_temp.sv",
}

# These are the algorithms for determining a class's name (if any)
CLASSNAMES = {
    'agent'         : "name_temp_c",
    'base_test'     : "temp_c",
    'cfg'           : "name_temp_c",
    'component'     : "name_c",
    'drv'           : "name_temp_c",
    'env'           : "name_temp_c",
    'intf'          : "vkit_name_temp",
    'item'          : "name_temp_c",
    'mon'           : "name_temp_c",
    'object'        : "name_c",
    'pkg'           : "vkit_temp",
    'reg_adapter'   : "name_temp_c",
    'reg_block'     : "name_temp_c",
    'seq'           : "name_temp_c",
    'seq_lib'       : "name_temp_c",
    'sqr'           : "name_temp_c",
    'subscriber'    : "name_temp_c",
    'tb_top'        : "name_temp",
    'test'          : "name_temp_c",
    'vseq'          : "name_temp_c",
    'vseq_lib'      : "name_temp_c",
    'vsqr'          : "name_temp_c",
}

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
import textwrap
import utils

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
def get_all_lines(template_name):
    """
    Fetch all the lines from a template file and return them.
    """

    # read in the template file
    temp_file_name = os.path.join(TemplateDir, template_name+'.sv')
    try:
        file = open(temp_file_name)
    except:
        Log.critical("Unable to find %s" % temp_file_name)
        sys.exit(1)

    lines = file.readlines()
    file.close()
    return lines

########################################################################################
def fetch_includes(all_lines):
    """
    Continuously fetch any included templates until no more are needed.
    Return the new set of lines, fully expanded.
    """

    rexp = re.compile('<@(.*)>')
    while True:
        done = True
        new_all_lines = []
        for line in all_lines:
            re_results = rexp.match(line)
            if re_results:
                done = False
                incFile = re_results.group(1)
                incLines = get_all_lines(incFile)
                new_all_lines.extend(incLines)
            else:
                new_all_lines.append(line)
        all_lines = new_all_lines[:]
        if done:
            break
    return new_all_lines

########################################################################################
def absorb_substitutions(all_lines, absorbed, temp_name):
    """
    Look for <$(name)> in the code and set Substitutions[name] equal to
    all of the following lines until <$end> is seen.
    Append name to the absorbed list, so that these Substitutions do not carry over to the
    next file.

    Return the new set of lines with the substitutions stripped out.
    """

    new_all_lines = []
    rexp = re.compile('<\$(.*)>')
    in_sub, sub_lines = False, []
    for lineno, line in enumerate(all_lines):
        if not in_sub:
            re_results = rexp.match(line)
            if re_results:
                in_sub = True
                subName = re_results.group(1)
                Log.debug("Saw substitution: %s" % subName)
            else:
                new_all_lines.append(line)
        elif line.startswith('<$end>'):
            sub = "<" + subName + ">"
            (sub_lines, junk) = make_substitutions(sub_lines, temp_name)
            Substitutions[sub] = sub_lines
            absorbed.append(sub)
            in_sub = False
            sub_lines = []
        else:
            sub_lines.append(line)
    return new_all_lines

########################################################################################
def make_substitutions(all_lines, temp_name):
    """
    Go line-by-line.  Repeat until no substitutions need to be made.
    Return the new list of lines, and the list of substitutions that were prompted for.
    """

    answered_subs = []
    rexp = re.compile('<(?P<sub>[^\>\?]*)(?P<maybe>\?*)>')

    Log.debug("Here with Substitutions= %s" % Substitutions)

    in_class = False  # set when we're on a line that's inside the class
    new_lines = []
    for line in all_lines:
        Log.debug("Looking at '%s'" % line.rstrip())
        # make the substitutions
        try:
            re_results = rexp.finditer(line)
            if re_results:
                line = handle_match(re_results, line, answered_subs, new_lines, temp_name)

            # detect class
            if not in_class and (line.startswith('class ') or line.startswith('interface ')):
                in_class = True

            # add it to the lines?
            if not Options.classonly or in_class:
                Log.debug("Adding: '%s'" % line)
                new_lines.append(line)

            # detect end of class
            if in_class and (line.startswith('endclass ') or line.startswith('endinterface ')):
                in_class = False

        except SkipLine:
            Log.debug("Skipping line because it is empty.")
            continue

    return new_lines, answered_subs

########################################################################################
def handle_match(re_results, line, answered_subs, new_lines, temp_name):
    newLine = line

    if re_results:
        for re_result in re_results:
            Log.debug("re_results = %s" % str(re_result.groups()))
            sub, maybe = ("<%s>" % re_result.group('sub')), (re_result.group('maybe') == '?')

            Log.debug("Here with sub = %s, maybe = %s" % (sub, maybe))

            # get the substitution, or prompt for it
            if sub not in Substitutions:
                Log.debug("%s not in Substitutions." % sub)

                # Conditional substitutions just get skipped
                if maybe:
                    Log.debug("Replacing '%s' with ''" % re_result.group(0))
                    newLine = newLine.replace(re_result.group(0), "")
                    if not newLine.rstrip():
                        raise SkipLine

                # otherwise, require that the user fill in the value
                if not Options.quiet:
                    fetch_answer(temp_name, sub)
                    answered_subs.append(sub)
                else:
                    # just leave the text alone
                    Substitutions[sub] = sub
                    answered_subs.append(sub)

            # make the substitution:  either just a simple string replacement, or a list of lines
            if type(Substitutions[sub]) == str:
                Log.debug("Replacing %s with %s on line %s" % (sub, Substitutions[sub], newLine))
                newLine = newLine.replace(sub, Substitutions[sub])
            else:
                # happens when the substitution is a list of lines
                new_lines.extend(Substitutions[sub])
                raise SkipLine

    return newLine

########################################################################################
def fetch_answer(temp_name, sub):
    name = Options.name if Options.name else ""
    answer = raw_input("%s %s: Enter substitution for %s: " % (name, temp_name, sub))
    if answer == "":
        answer = sub.replace('<', '[').replace('>', ']')

    # trim _pkg from answer
    if sub in ("<vkit_name>", "<VKIT_NAME>") and (answer.endswith('_pkg') or answer.endswith('_PKG')):
        answer = answer[:-4]

    # set the substitutions for sub and SUB
    Substitutions[sub] = answer
    Substitutions[sub.swapcase()] = answer.swapcase()

########################################################################################
def print_lines(all_lines):
    """
    Print all of the lines, either to stdout or to the correct file.
    """

    if Options.file:
        fileName = Substitutions['<filename>']
        target = open(fileName, 'w')
    else:
        target = sys.stdout

    for line in all_lines:
        print >>target, line,

    if Options.file:
        target.close()

########################################################################################
def determine_name(temp_name, stylesheet):
    """
    Figures out what the filename should be based on all the information available and returns it.
    """

    try:
        style = stylesheet[temp_name]
    except:
        Log.critical("%(temp_name)s never gets its own name!:\n%(stylesheet)s" % locals())
        sys.exit(1)

    Log.debug("setting name with '%(style)s', '%(temp_name)s'" % locals())

    result = style
    if "vkit" in style:
        if "<vkit_name>" in Substitutions:
            result = result.replace('vkit', Substitutions["<vkit_name>"], 1)
        else:
            result = result.replace('vkit_', '', 1)

    if "name" in style:
        if Options.name:
            name = Options.name
        elif "<name>" not in Substitutions:
            fetch_answer(temp_name, "<name>")

        name = Substitutions["<name>"]
        if name == "[name]":
            result = result.replace('name_', '', 1)
        else:
            result = result.replace('name', name, 1)

    if "temp" in style:
        result = result.replace('temp', temp_name, 1)

    return result

########################################################################################
def template_vkit():
    global Substitutions

    if not Options.name:
        Log.critical("No name for the vkit was specified on the command-line.")
        sys.exit(1)
    else:
        vkit_name = Options.name

    try:
        vkit_dir = os.path.join(utils.calc_root_dir(), "verif/vkits")
    except utils.AreaError:
        Log.critical("Unable to determine root directory.")
        sys.exit(1)

    new_dir = os.path.join(vkit_dir, vkit_name)

    if os.path.exists(new_dir):
        Log.critical("Path %s already exists!" % new_dir)
        sys.exit(1)

    try:
        os.mkdir(new_dir)
    except OSError:
        Log.critical("Unable to create %s" % new_dir)
        sys.exit(1)

    # create an flist file there
    lines = ["+incdir+../../verif/vkits/%s\n" % (vkit_name),
             "../../verif/vkits/%s/%s_pkg.sv\n" % (vkit_name, vkit_name)
             ]
    flist_file_name = os.path.join(new_dir, "%s.flist" % vkit_name)
    file = open(flist_file_name, 'w')
    file.writelines(lines)
    file.close()

    os.chdir(new_dir)
    Options.file = True
    Substitutions['<description>'] = "%s package" % vkit_name
    Substitutions['<name>'] = Substitutions['<vkit_name>'] = vkit_name
    template_it('pkg')

    Log.info("Created vkit %s" % (vkit_name))

########################################################################################
def template_it(temp_name):
    """
    Load the template file, perform the substitutions, and print it out.
    """

    # set the template variable
    if temp_name in CLASSNAMES:
        class_name = determine_name(temp_name, CLASSNAMES)
        Substitutions['<template>'] = Substitutions['<class_name>'] = class_name
    else:
        Substitutions['<template>'] = temp_name
    Substitutions['<TEMPLATE>'] = Substitutions['<template>'].upper()

    if not Options.classonly:
        filename = determine_name(temp_name, FILENAMES)

        Substitutions['<filename>'] = filename
        # for `ifndef headers:
        Substitutions['<FILENAME>'] = filename.replace(".sv", "").upper()

    if Options.file:
        Log.info("Creating %s" % filename)

    # Get the template
    lines = get_all_lines(temp_name)

    # expand all of the includes
    lines = fetch_includes(lines)

    # check for options
    lines = check_options(lines)

    # absorb any substitutions from the file
    absorbed_subs = []
    lines = absorb_substitutions(lines, absorbed_subs, temp_name)

    # Make substitutions
    lines, answered_subs = make_substitutions(lines, temp_name)

    # print out the template
    print_lines(lines)

    # remove substitutions that don't cross templates if they were prompted (substitution, for example)
    for sub in ClearedSubstitutions:
        if sub in answered_subs:
            del Substitutions[sub]

    # remove any absorbed substitutions
    for sub in absorbed_subs:
        if sub in Substitutions:
            Log.debug("Removing %s" % sub)
            del Substitutions[sub]

########################################################################################
def check_options(lines):
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
                    sys.exit(1)
        else:
            if not skipping:
                result.append(line)

    return result

########################################################################################
def create_substitutions():
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

    # if sitting in a vkits directory, then use that directory name as the vkit_name
    cwd = os.getcwd().split('/')
    if cwd[-2] == 'vkits':
        Substitutions['<vkit_name>'] = cwd[-1]
        Substitutions['<VKIT_NAME>'] = Substitutions['<vkit_name>'].upper()

########################################################################################
def setup(argv):
    global Options
    global Log

    # investigate utemplates directory for available templates
    all_templates = [it[:-3] for it in os.listdir(TemplateDir) if it.endswith('.sv') and it[:-3] not in EXCLUDED_TEMPLATES]
    if not all_templates:
        Log.critical("There are No Templates in the directory %s. Cannot continue!" % TemplateDir)
        sys.exit(1)

    # this template is not part of other templates
    all_templates.append("vkit")
    all_templates_str = textwrap.fill(', '.join(all_templates), width=80)

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
""" % (__version__, all_templates_str))

    p.add_argument('templates',           action='append',    nargs='+',    default=None,     choices=all_templates)
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
        Log = utils.get_logger('log', verbosity)

    # check legality
    if Options.filename and len(Options.templates[0]) != 1:
        Log.critical("You may not specify a filename when more than one template is on the command-line.")
        sys.exit(1)

    if Options.filename:
        Options.file = True

    # create all of the substitution variables
    create_substitutions()

########################################################################################
def main(argv=None):
    # from cmdline import logUsage
    # logUsage('utg', __version__)

    if not argv:
        argv = sys.argv[1:]

    # parse the arguments and create the default substitution variables
    setup(argv)

    # for each template, do it
    all_templates = Options.templates[0]
    if 'vkit' in all_templates:
        template_vkit()
        Log.info("Exiting.")
        sys.exit(0)

    for template in all_templates:
        template_it(template)
        if len(all_templates) > 1 and not Options.file:
            Log.info("<----- %s CUT HERE ----->" % template)

########################################################################################
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print "Ctrl-C Detected. Exiting."
        sys.exit(1)
