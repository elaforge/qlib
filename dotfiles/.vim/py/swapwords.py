"""
Swap two words.  Either space separated or delimiter separated.

Space separated should select one word.  If it's (, then find the matching ),
if it's " then find the matching close quote.  It has to do full tokenizing
in case there are parens inside a string or \" or something like that.

Delimiter separated should also skip over the delimiter inside of ()s or ""s.
Also, it must handle the final word, which doesn't end with a delimiter.

They should also leave whitespace intact, so you can swap with a word on the
next line.

(a, b, c) ==> (b, a, c)
(a, b) ==> (b, a)
(a,         ==> (b,
    b, c)           a, c)
(a->b) -> c ==> c -> (a->b)

The tokenizer considers a sequence of 'word_chars' a token, and a sequence of
symbols is also a token, with some exceptions like )}] (so that '))' won't be
considered a single token).
"""

from __future__ import print_function
import re, string

# This may need to be adjusted for languages with other rules for identifiers.
letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
word_chars = letters + string.digits + '_.'

# vim_* functions take the 'vim' module and try to adapt this to vim's awkward
# list of lines API.  The tokenizer could probably be adapted to (row, col)
# indices, but it's such a pain I just join a few lines and pretend the input
# is a flat string.  This will break if the word swap must span many lines,
# but that should be rare.

def vim_swap_word(vim):
    vim_call(vim, swap_words)

def vim_swap_delim(vim):
    """Figure out from the current line which delimiter to use."""
    (row, col) = vim.current.window.cursor
    row -= 1 # vim starts from 1
    if type_signature(vim.current.buffer, row):
        vim_call(vim, lambda text, start:
            swap_delim(text, start, '->', [DEDENT]))
    else:
        vim_call(vim, lambda text, start:
            swap_delim(text, start, ',', list('])}')))

def type_signature(lines, i):
    """Guess if lines[i] is a type signature by looking for ::s, either on
        this line or previous ones if this one is indented.
    """
    while i >= 0:
        if re.match('[a-zA-Z_][0-9a-zA-Z_\']* :: ', lines[i]):
            return True
        elif lines[i].startswith(' '):
            i -= 1
        else:
            return False
    return False

def vim_call(vim, f):
    (row, col) = vim.current.window.cursor
    row -= 1 # vim starts from 1
    # Last line won't have \n but it's ok because I use split later.
    text = '\n'.join(line for line in vim.current.buffer[row:row+3])
    (range1, range2, cursor) = f(text, col)
    text = swap(text, range1, range2)
    (new_row, new_col) = index_to_cursor(text, cursor)
    vim.current.buffer[row:row+3] = text.split('\n')
    vim.current.window.cursor = (row + new_row + 1, new_col)


# swap functions

def swap_words(text, start):
    """Return (range1, range2, cursor_pos)."""
    end = token_end(text, start)
    next_start = whitespace(text, end)
    next_end = token_end(text, next_start)
    diff = (next_end-next_start) - (end-start)
    return ((start, end), (next_start, next_end), next_start + diff)

def swap_delim(text, start, delim, end_tokens):
    end = until(text, start, delim, end_tokens)
    next_start = whitespace(text, whitespace(text, end) + len(delim))
    next_end = until(text, next_start, delim, end_tokens)
    diff = (next_end-next_start) - (end-start)
    return ((start, end), (next_start, next_end), next_start + diff)

def until(text, start, delim, end_tokens):
    i = start
    while True:
        end = token_end(text, i)
        toks = tokens(text, i, end)
        if any(tok in ('', delim) or tok in end_tokens for tok in toks):
            return i
        i = end

def index_to_cursor(text, i):
    row = 0
    start = 0
    while True:
        end = text.find('\n', start)
        length = end - start + 1 # +1 for newline
        if end == -1 or length > i:
            break
        i -= length
        start = end + 1
        row += 1
    return (row, i)

def swap(text, se1, se2):
    """Swap the two ranges given."""
    (s1, e1) = se1
    (s2, e2) = se2
    return text[:s1] + text[s2:e2] + text[e1:s2] + text[s1:e1] + text[e2:]


# parsing

class DEDENT(object):
    def __repr__(self): return 'DEDENT'
DEDENT = DEDENT()

def token_end(text, start):
    """Given text and a starting index, return the end of the next token.
        This skips initial whitespace so start:end will look like '   xyz'.
    """
    # An awkward tokenizer.  Surely there's a better way.
    i = whitespace(text, start)
    if i >= len(text):
        return len(text)
    elif text[i] in word_chars:
        while i < len(text) and text[i] in word_chars:
            i = i + 1
        return i
    elif text[i] in '([{':
        bracket = text[i]
        s = i + 1
        while s < len(text):
            e = token_end(text, s)
            if text[s:e].strip() == closing[bracket]:
                return e
            s = e
        raise ParseError('unterminated ' + bracket)
    elif text[i] in ('"', "'"):
        quote = text[i]
        s = i+1
        while s < len(text):
            if text[s] == quote:
                return s+1
            elif text[s] == '\\':
                s = s + 2
            else:
                s = s + 1
        raise ParseError('unterminated ' + quote)
    elif text[i] in '}])': # some symbols don't group together
        return i + 1
    else: # symbol
        while (i < len(text) and text[i] not in word_chars
                and not text[i].isspace()
                and text[i] not in special):
            i += 1
        return i

closing = { '(': ')', '{': '}', '[': ']'}
special = set(list(closing.keys()) + list(closing.values()) + list('"\''))

def tokens(text, start, end):
    """token_end just gives the index of the end of the token.  Figure out
        the actual tokens in that range.  There may be 2 because DEDENT is
        considered a token.
    """
    val = text[start:end]
    if '\n' not in val:
        return [val.strip()]
    val = val.split('\n')[-1]
    indent = whitespace(val, 0)
    prev = text.rfind('\n', 0, start)
    if prev == -1:
        prev = 0
    else:
        prev += 1 # skip \n
    prev_indent = whitespace(text, prev) - prev
    if indent < prev_indent:
        return [DEDENT, val.strip()]
    else:
        return [val.strip()]

def whitespace(text, i):
    while i < len(text) and text[i].isspace():
        i += 1
    return i

class ParseError(Exception): pass


# testing

def t0():
    print(tokenize(s0))
    print(tokens(s0, 13, 17))
    # import pdb; pdb.set_trace()
    print(swap_delim(s0, 7, '->', [DEDENT]))

s0 = '''foo :: (b -> c) -> d
    -> a -> e
foo a (a, b) c d = [a, a+b, c*e+f]
'''
s0 = '''\
    -> a -> e
foo a (a, b) c d = [a, a+b, c*e+f]
'''

def tokenize(text):
    s = 0
    ts = []
    while True:
        e = token_end(text, s)
        print((s, e))
        if e is not None and text[s:e]:
            ts.extend(tokens(text, s, e))
            s = e
        else:
            return ts


# Either hack this up to try to do (row, col) indexing, and turn clip()
# into a bunch of line modifications.
# Or, write an external program and filter current line + n through it
# The problem with that is vim's support for errors sucks.

# class Buffer(object):
#     def __init__(self, lines):
#         self.lines = lines
#     def __getitem__(self, i):
#         if isinstance(i, slice):
#             pass # too much work!
#         else:
#             line = self.lines[i.row]
#             if i.col == len(line):
#                 return '\n' # vim helpfully omits the \n
#             else:
#                 return line[i.col]
#
# class Index(object):
#     def __init__(self, lines, row, col):
#         self.lines = lines
#         self.row = row
#         self.col = col
#     def __add__(self, n):
#         row = self.row
#         col = self.col + n
#         while col >= len(self.lines[row]):
#             # +1 because vim omits the \n
#             col -= len(self.lines[row]) + 1
#             row += 1
#         return Index(self.lines, row, col)


if __name__ == '__main__':
    t0()
