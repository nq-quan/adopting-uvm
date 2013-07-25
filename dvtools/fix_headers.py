#!/usr/bin/env python2.7

def fix_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    start, end = (0, 0)
    for (num, line) in enumerate(lines):
        if (line.find("CAVIUM CONFIDENTIAL") != -1 or
            line.find("CAVIUM NETWORKS CONFIDENTIAL") != -1):
            start = num
        elif line.find("without the prior written consent") != -1:
            end = num
        elif (line.find("All rights reserved") != -1 or
              line.find("without the prior written consent") != -1):
            lines[num] = line[0:20] + '\n'

    if start and end:
        new_lines = lines[0:start] + lines[end+1:]
        new_lines.insert(start, "// *\n")
        new_lines.insert(start, "// * legal mumbo jumbo\n")
        new_lines.insert(start, "// *\n")

        print "Fixing %s" % filename
        with open(filename, 'w') as f:
            f.writelines(new_lines)

if __name__ == '__main__':
    import os
    import glob

    for it in os.walk(os.getcwd()):
        mydir = it[0]
        files = glob.glob('%s/*.*v' % mydir)
        files += glob.glob('%s/*.py' % mydir)
        for fname in files:
            fix_file(fname)
