'''Random text formatting and manipulation bits that aren't in string.'''

import string, re, operator, sys
from string import lower, upper, replace, split, join

def strip_suffixes(s, sufs):
    "strip first suffix in 'sufs' from 's'"
    for suf in sufs:
        if s.endswith(suf):
            return s[:-len(suf)]
    return s

## the below is old.  modern python stdlib does much of this

tab = "    "

columns = 80
def fmt_cols(a, cols=None):
    a = map(str, a)
    if not cols:
        maxlen = 0
        for i in a:
            maxlen = max(maxlen, len(i) + 1)
        cols = columns / maxlen
    cols_per_word = columns / cols
    words = []
    r = []
    for w in a:
        if (len(words) + 1) % cols == 0:
            words.append(w)
            r.append(join(words) + '\n')
            words = []
        else:
            words.append('%-*s' %(cols_per_word, w))
    if words:
        r.append(join(words) + '\n')
    return join(r, '')

def print_cols(a, cols=None):
    sys.stdout.write(fmt_cols(a, cols))

def format(s, cols=78):
    r = []
    newline = ''
    for line in split(s, '\n'):
        for word in split(line):
            if len(newline) + len(word) <= cols:
                if newline:
                    newline = newline + ' ' + word
                else:
                    newline = word
            else:
                r.append(newline)
                newline = word
    r.append(newline)
    return join(r, '\n')
            
def untab(s):
    '''Remove initial tabbing.  Designed for triple-strings.

        Excepting the first line, all lines are scanned and the one with the
        least leading spaces (empty lines are ignored) gives the value to strip
        the rest by.
    '''

    def count(c, s):
        n = 0
        for i in range(len(s)):
            if s[i] == c:
                n = n + 1
            else:
                break
        return n

    lines = string.split(s, "\n")
    if len(lines) <= 1:
        return string.lstrip(s)

    indent = sys.maxint
    for i in lines:
        if string.rstrip(i) == "":
            continue
        indent = min(indent, count(" ", i))

    a = []
    if count(" ", lines[0]) >= indent:
        a.append(lines[0][indent:])
    else:
        a.append(lines[0])

    for i in lines[1:]:
        a.append(i[indent:])

    return string.join(a, "\n")

def tab(s, prepend=tab):
    ret = []
    for line in string.split(s, "\n"):
        s = prepend + line
        if string.strip(s) != "":
            ret.append(prepend + line)
    return string.join(ret, "\n")

def capitalize(s): # strop's capitalize lowers all other chars
    if s == '':
        return s
    return upper(s[0]) + s[1:]

def truncate(s, maxlen=25, with='...'):
    if len(s) > maxlen:
        if len(s) > maxlen:
            s = s[:maxlen-len(with)] + with
    return s

