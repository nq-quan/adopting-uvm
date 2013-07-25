#!/usr/bin/env python2.7
#-*- mode: Python;-*-

# ***********************************************************************
# File:   extractor
# Author: bhunter
# About:  Extracts code snippets from UVM Tutorial RTF file
# ***********************************************************************

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

def StartSnipping(line):
    return line.find("\\strokec6 {\\listtext\t1.\t}") == 0

def EndSnipping(line):
    return line.startswith("\\f0") and line.endswith("\\kerning0\n")

#######################################################################################
def consumeEscapes(line):
    if line.isspace():
        return line

    # special characters first
    line = line.replace('\\n', 'BOOGIES')
    line = line.replace(r'\\', '\\')
    line = line.replace(r'\{', '{').replace(r'\}', '}').replace(r"\'92", "'")

    Log.debug("line now= '%s'" % line)

    (newLine, numReplaced) = Rexp.subn('', line)
    newLine = newLine.replace('BOOGIES', '\\n')

    # if after consuming this stuff, it's actually just a plain new-line, then return that
    # (newlines look like just a '\')
    if line == "\\\n":
        return "\n"

    # if after consuming there's nothing left, then ignore this line altogether
    if newLine.isspace():
        return None

    # replace trailing slash and newline with just newline
    newLine = newLine.replace('\\\n', '\n')

    # replace double-quotes
    Log.debug("In consumeEscapes with newLine= '%s'" % newLine)
    (newLine, numReplaced) = Rexp2.subn('"', newLine)

    return newLine

#######################################################################################
def parseRtf(fileName):
    """
    Given the .rtf file, looks for code samples and returns a dictionary.  Each item is
    keyed on the snippet number, and the value is a tuple.  The first item is any filename
    that was present on the code# line.  The second is the list of lines in the code snippet.
    """

    codeNum = 0
    codes = {}
    snipping = False
    snipLines = []
    codeFileName = None
    prepending = None

    try:
        file = open(fileName)
    except:
        Log.critical("Unable to open", fileName)

    for (lineNum, line) in enumerate(file.readlines()):
        if snipping:
            # Log.debug("Here with line: '%s'" % line)
            pass

        if not snipping:
            if StartSnipping(line):
                codeNum += 1

                codeFileName = line[line.find('verif'):].rstrip().rstrip('\\')
                Log.info("Found %d starting on line: %d with codeFileName: %s\n%s" % (codeNum, lineNum, codeFileName, line))
                snipping = True
                snipLines = []
        else:
            if EndSnipping(line):
                snipping = False
                codes[codeNum] = (codeFileName, '\n'.join(snipLines))
                Log.debug("Closed", codeNum, "with", len(snipLines), "lines on line", lineNum)
            elif line == '\\\n':
                snipLines.append("")
                Log.debug("Added an empty new line.")
            elif line.isspace():
                # prepend it to the next line printed
                prepending = line[:-1]
                Log.debug("Set prepending: '%s'" % prepending)
            else:
                newLine = consumeEscapes(line)
                Log.debug("Newline now = '%s'" % newLine)
                if newLine:
                    if prepending:
                        newLine = prepending + newLine
                        Log.debug("Prepended '%s'" % prepending)
                        prepending = None
                    snipLines.append(newLine.rstrip())
                    Log.debug("Added newLine: '%s'" % newLine)
    file.close()

    return codes

#######################################################################################
def pickleCodes(codes, pickleFileName):
    pickled = cPickle.dumps(codes, protocol=2)

    try:
        file = open(pickleFileName, 'w')
        file.writelines(pickled)
    except:
        Log.critical("Unable to create", pickleFileName)

    file.close()

#######################################################################################
if __name__ == '__main__':
    import logging
    import cn_logging
    Log = cn_logging.createLogger('log', logging.INFO)

    fileName = sys.argv[1]
    pFileName = os.path.join(U_REVISION, os.path.split(fileName)[1] + ".pkl")
    Log.debug("Here I am with %s, %s" % (fileName, pFileName))
    codes = parseRtf(fileName)
    pickleCodes(codes, pFileName)

    for codeNum in codes:
        (fname, lines) = codes[codeNum]
        print codeNum, ":", fname, "> ", lines.splitlines()
