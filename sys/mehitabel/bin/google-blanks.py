#!/usr/bin/env python2.3

import sys
from local.cmdline import gripe

def main():
    if len(sys.argv) != 3:
        print >>sys.stderr, 'usage: %s spaces_after_defn spaces_after_class' %(
            sys.argv[0])
        sys.exit(1)
    spaces_after_defn = int(sys.argv[1])
    spaces_after_class = int(sys.argv[2])
    plines = []
    while 1:
        line = sys.stdin.readline()
        if not line or line.startswith('def ') or line.startswith('class '):
            while plines and not plines[-1].strip():
                del plines[-1]
            map(sys.stdout.write, plines)
            #  Two blank lines between top-level definitions, be they function
            #  or class definitions.
            if line and plines:
                sys.stdout.write('\n' * spaces_after_defn)
            plines = []
        if not line:
            break
        plines.append(line)
        # One blank line between method definitions and between the class line
        # and the first method.
        # XXX WTF?
        if line.startswith('class '):
            plines.append('\n' * spaces_after_class)

if __name__ == '__main__':
    main()
