#!/usr/bin/env python2.7

__author__  = "Brian Hunter"
__email__   = "brian.hunter@cavium.com"

import sys
import cPickle
import os.path

Log = None

########################################################################################
# Constants

PKL_FILENAME = "TXT.rtf.pkl"

########################################################################################
def unpickle(fileName):
    try:
        file = open(fileName)
    except:
        print "Unable to open", fileName
        sys.exit(1)

    codes = cPickle.load(file)
    file.close()
    return codes

########################################################################################
def fetchCode(items, u_revision):
    pklDir  = os.path.join(os.path.dirname(os.path.realpath(__file__)), u_revision)
    pklFile = os.path.join(pklDir, PKL_FILENAME)

    results = {}
    codes = unpickle(pklFile)

    for item in items:
        try:
            results[item] = codes[item]
        except KeyError:
            Log.critical("Code #%0d does not exist in revision %s" % (item, u_revision))
    return results
