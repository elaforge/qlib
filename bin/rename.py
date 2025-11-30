#!/usr/bin/env python3

import sys, re, os


def main():
    if len(sys.argv) < 3:
        sys.exit('usage: $0 from-re subst fn1 fn2 ...')
    from_re = re.compile(sys.argv[1])
    subst = sys.argv[2]

    renames = []
    if not sys.argv[3:]:
        sys.exit('no files to rename')
    for fname in sys.argv[3:]:
        m = from_re.search(fname)
        if m:
            to = re.sub(from_re, subst, fname)
            print(fname, '->\n ', to)
            renames.append((fname, to))
        else:
            print('no match on', from_re, fname)

    if not renames:
        print('no matches')
    elif input('ok? ') == 'y':
        for fname, to in renames:
            os.rename(fname, to)

if __name__ == '__main__':
    main()
