#!/usr/bin/env python3

import sys
import datetime


def main():
    t1, t2 = map(parse, sys.argv[1:])
    print(t1 - t2)


def parse(s):
    # return datetime.datetime.strptime('%H:%M:%S', s)
    h, m, s = map(int, s.split(':'))
    return datetime.datetime.combine(
        datetime.date.today(), datetime.time(h, m, s))

if __name__ == '__main__':
    main()
