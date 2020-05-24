#!/usr/bin/env hempy

import sys
import datetime
import re

from dateutil import tz

formats = [
    # 2019-05-17T23:05:31.722048186Z
    '%Y-%m-%dT%H:%M:%S.%fZ',
    # '%Y-%m-%dT%H:%M:%S',
]

def main():
    s = sys.argv[1]
    s = re.sub(r'(\d{6})\d{3}Z', r'\1Z', s)
    date = None
    try:
        ts = float(s)
        date = datetime.datetime.fromtimestamp(ts)
    except ValueError:
        pass
    if date is None:
        for format in formats:
            try:
                date = datetime.datetime.strptime(s, format)
                date = date.replace(tzinfo=datetime.timezone.utc)
            except ValueError as exc:
                print(exc)
                continue
            break
        else:
            print('no parse')
            sys.exit(1)
    date = date.astimezone(tz.tzlocal())
    print(date, date.tzinfo)

if __name__ == '__main__':
    main()
