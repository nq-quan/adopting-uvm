#!/usr/bin/env python2.7

__author__ = "Brian Hunter"
__email__  = "brian.hunter@cavium.com"

import sys
import cPickle
import os
import re

########################################################################################
# Constants
U_REVISION = 'v1.0'

########################################################################################
# Global Variables
Log = None

Rexp = re.compile(r'(\\[a-z]\S*\s)')
Rexp2 = re.compile(r"\\\'9[34]")

#######################################################################################
def start_snipping(line):
    return line.find("\\strokec6 {\\listtext\t1.\t}") == 0

#######################################################################################
def end_snipping(line):
    return line.startswith("\\f0") and line.endswith("\\kerning0\n")

#######################################################################################
def consume_escapes(line):
    if line.isspace():
        return line

    # special characters first
    line = line.replace('\\n', 'BOOGIES')
    line = line.replace(r'\\', '\\')
    line = line.replace(r'\{', '{').replace(r'\}', '}').replace(r"\'92", "'")

    Log.debug("line now= '%s'" % line)

    (new_line, numReplaced) = Rexp.subn('', line)
    new_line = new_line.replace('BOOGIES', '\\n')

    # if after consuming this stuff, it's actually just a plain new-line, then return that
    # (new_lines look like just a '\')
    if line == "\\\n":
        return "\n"

    # if after consuming there's nothing left, then ignore this line altogether
    if new_line.isspace():
        return None

    # replace trailing slash and new_line with just new_line
    new_line = new_line.replace('\\\n', '\n')

    # replace double-quotes
    Log.debug("In consume_escapes with new_line= '%s'" % new_line)
    (new_line, numReplaced) = Rexp2.subn('"', new_line)

    return new_line

#######################################################################################
def parse_rtf(file_name):
    """
    Given the .rtf file, looks for code samples and returns a dictionary.  Each item is
    keyed on the snippet number, and the value is a tuple.  The first item is any file_name
    that was present on the code# line.  The second is the list of lines in the code snippet.
    """

    code_num = 0
    codes = {}
    snipping = False
    snip_lines = []
    code_file_name = None
    prepending = None

    try:
        file = open(file_name)
    except:
        Log.critical("Unable to open", file_name)

    for (line_num, line) in enumerate(file.readlines()):
        if snipping:
            # Log.debug("Here with line: '%s'" % line)
            pass

        if not snipping:
            if start_snipping(line):
                code_num += 1

                code_file_name = line[line.find('verif'):].rstrip().rstrip('\\')
                Log.info("Found %d starting on line: %d with code_file_name: %s\n%s" % (code_num, line_num, code_file_name, line))
                snipping = True
                snip_lines = []
        else:
            if end_snipping(line):
                snipping = False
                codes[code_num] = (code_file_name, '\n'.join(snip_lines))
                Log.debug("Closed", code_num, "with", len(snip_lines), "lines on line", line_num)
            elif line == '\\\n':
                snip_lines.append("")
                Log.debug("Added an empty new line.")
            elif line.isspace():
                # prepend it to the next line printed
                prepending = line[:-1]
                Log.debug("Set prepending: '%s'" % prepending)
            else:
                new_line = consume_escapes(line)
                Log.debug("New_line now = '%s'" % new_line)
                if new_line:
                    if prepending:
                        new_line = prepending + new_line
                        Log.debug("Prepended '%s'" % prepending)
                        prepending = None
                    snip_lines.append(new_line.rstrip())
                    Log.debug("Added new_line: '%s'" % new_line)
    file.close()

    return codes

#######################################################################################
def pickle_codes(codes, pickleFile_name):
    pickled = cPickle.dumps(codes, protocol=2)

    try:
        file = open(pickleFile_name, 'w')
        file.writelines(pickled)
    except:
        Log.critical("Unable to create", pickleFile_name)

    file.close()

#######################################################################################
if __name__ == '__main__':
    import logging
    Log = utils.get_logger('log', logging.INFO)

    file_name = sys.argv[1]
    pFile_name = os.path.join(U_REVISION, os.path.split(file_name)[1] + ".pkl")
    codes = parse_rtf(file_name)
    pickle_codes(codes, pFile_name)

    for code_num in codes:
        (fname, lines) = codes[code_num]
        print code_num, ":", fname, "> ", lines.splitlines()
