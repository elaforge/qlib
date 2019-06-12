#!/usr/bin/env python3

import sys
import datetime
import re

formats = [
    # 2019-05-17T23:05:31.722048186Z
    '%Y-%m-%dT%H:%M:%S.%fZ',
    # '%Y-%m-%dT%H:%M:%S',
]

def main():
    s = sys.argv[1]
    s = re.sub(r'(\d{6})\d{3}Z', r'\1Z', s)
    for format in formats:
        try:
            date = datetime.datetime.strptime(s, format)
        except ValueError as exc:
            print(exc)
            continue
        break
    else:
        print('no parse')
        sys.exit(1)

    print(date.utcnow())

if __name__ == '__main__':
    main()
