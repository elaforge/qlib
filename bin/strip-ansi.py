#!/usr/bin/env python3
import sys, re

def main():
    for line in sys.stdin:
        sys.stdout.write(re.sub(r'[^m]*m', '', line))

if __name__ == '__main__':
    main()
