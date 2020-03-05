from __future__ import print_function
import sys, re


def to_snake(vim):
    start, end = get_word(vim)
    (row, col) = vim.current.window.cursor
    line = vim.current.buffer[row-1]
    word = camel_to_snake(line[start:end])
    print(word)
    vim.current.buffer[row-1] = line[:start] + word + line[end:]

    # vim.current.buffer[row:row+3] = text.split('\n')
    # vim.current.window.cursor = (row + new_row + 1, new_col)

def camel_to_snake(word):
    return re.sub(r'[A-Z]', lambda m: '_' + m.group().lower(), word)

def get_word(vim):
    (row, col) = vim.current.window.cursor
    line = vim.current.buffer[row-1]
    return expand_word(line, col)

def expand_word(line, col):
    # This is broken for unicode, but vim gives the col index in bytes, and
    # python gives no way to convert byte index to unicode index, short of
    # decoding myself.  And even if I did, python uses UTF16 so it would
    # still be wrong for unicode above U+FFFF.
    start = col
    while start > 0 and is_keyword(line[start-1]):
        start -= 1
    end = col
    while end < len(line) and is_keyword(line[end]):
        end += 1
    return start, end

def is_keyword(c):
    return c.isalnum() or c in "'_"
