# Copyright 2005 Google Inc.
# All Rights Reserved.
# Original author: elaforge
# $Id: //depot/google3/ops/hardware/touchpad/lib/qtraceback.py#2 $
""" 
A replacement for the stdlib traceback module to format tracebacks the way
both Peter and I like them, with function arguments and file:lineno format.

functions:
usual traceback module stuff
Install
ExceptHook

Functions are named to be coincident with the traceback module's function
names.
"""
__author__ = 'elaforge'
# this is all ugly, but that's mostly traceback's fault
# TODO(elaforge) the new inspect module seems to do some of the same stuff

import sys
import os
import traceback
import linecache
import pdb
import inspect
import re

# each arg in the traceback is truncated to this many characters
ARGLIST_TRUNCATE = 16

# regular expression to clean up file names in par's tracebacks
# only clean up make-opt'd tracebacks.  Here's the result of this:
#
# /home/psolodov/touchpad/build/google3/obj/gcc-2.95.3-piii-linux-opt/\
# bin/ops/hardware/touchpad/src/tp.runfiles/google3/third_party/\
# python/quixote/publish.py
#
# to
#
# google3/third_party/python/quixote/publish.py
#
# only remove if par is a released one, compiled with make-opt and has
# linux-opt in path.  Unreleased tracebacks should not be changed as it's not
# supposed to happen.
PAR_BUILD_PATH_REGEX = re.compile(r'^.*linux-opt/bin/.*\.runfiles/')

def Install():
  """Patch the stdlib traceback to format things the way I like them.
  """
  traceback.print_list = print_list
  traceback.format_list = format_list
  traceback.extract_tb = extract_tb
  traceback.extract_stack = extract_stack
  traceback.print_exception = print_exception


def InstallPdb():
  """Patch pdb to format file:lineno style.
  """
  pdb.Pdb = Pdb


def ExceptHook(typ, val, tb):
  """Rebind sys.excepthook to this to have qtraceback style tracebacks at the
    REPL.
  """
  s = ''.join(format_exception(typ, val, tb))
  for line in s.split('\n'):
    if line.strip():
      sys.stdout.write('# %s\n' % line)


def format_exception(typ, val, tb, limit=None):
  if tb:
    r = ['Traceback (most recent call last): ' + '-'*7 + '\n']
    r += format_list(extract_tb(tb, limit))
  else:
    r = []
  r += traceback.format_exception_only(typ, val)
  return r


def format_list(extracted_list):
  r = []
  for fn, lineno, name, line, fargs in extracted_list:
    args = []
    selfarg = None
    for k, v in fargs:
      if k == 'self':
        selfarg = v
      else:
        v = SafeRepr(v)
        trunc = os.environ.get('qtraceback_truncate', ARGLIST_TRUNCATE)
        if trunc:
          v = Truncate(v, trunc, '..')
        args.append('%s=%s' %(k, v))
    # s = '%s:%d in ' %(PAR_BUILD_PATH_REGEX.sub('', fn), lineno)
    s = '%s:%d in ' % (os.path.basename(fn), lineno)
    if selfarg is not None:
      s += '%s.' % selfarg.__class__.__name__
    s += '%s(%s)\n' %(name, ', '.join(args))
    if line:
      s += '\t%s\n' % Truncate(line, 70, '..')
    r.append(s)
  return r


# traceback is badly factored and I have to replace essentially everything
# how does code like this make it to the stdlib?

def _print(fp, s='', terminator='\n'):
  fp.write(s + terminator)


def print_list(extracted_list, file=None):
  if file is None:
    file = sys.stderr
  _print(file, ''.join(format_list(extracted_list)))


def print_exception(typ, val, tb, limit=None, file=None):
  if file is None:
    file = sys.stderr
  _print(file, ''.join(format_exception(typ, val, tb)))


def format_exception_only(etype, value):
  list = []
  if type(etype) == types.ClassType:
    stype = etype.__name__
  else:
    stype = etype
  if value is None:
    list.append(str(stype) + '\n')
  else:
    if etype is SyntaxError:
      try:
        msg, (filename, lineno, offset, line) = value
      except:
        pass
      else:
        if not filename: filename = "<string>"
        list.append('%s:%d\n' % (filename, lineno))
        if line is not None:
          i = 0
          while i < len(line) and line[i].isspace():
            i = i+1
          list.append('  %s\n' % line.strip())
          if offset is not None:
            s = '  '
            for c in line[i:offset-1]:
              if c.isspace():
                s = s + c
              else:
                s = s + ' '
            list.append('%s^\n' % s)
          value = msg
    s = _some_str(value)
    if s:
      list.append('%s: %s\n' % (str(stype), s))
    else:
      list.append('%s\n' % str(stype))
  return list


def extract_tb(tb, limit=None):
  if limit is None:
    if hasattr(sys, 'tracebacklimit'):
      limit = sys.tracebacklimit
  list = []
  n = 0
  while tb is not None and (limit is None or n < limit):
    f = tb.tb_frame
    lineno = tb.tb_lineno
    co = f.f_code
    filename = co.co_filename
    name = co.co_name
    # linecache.checkcache(filename) # old python takes 0 args
    linecache.checkcache()
    line = linecache.getline(filename, lineno)
    if line: line = line.strip()
    else: line = None
    list.append((filename, lineno, name, line, GetArgs(f)))
    tb = tb.tb_next
    n = n+1
  return list


def extract_stack(f=None, limit = None):
  if limit is None:
    if hasattr(sys, 'tracebacklimit'):
      limit = sys.tracebacklimit
  list = []
  n = 0
  while f is not None and (limit is None or n < limit):
    lineno = f.f_lineno
    co = f.f_code
    filename = co.co_filename
    name = co.co_name
    # linecache.checkcache(filename)
    linecache.checkcache()
    line = linecache.getline(filename, lineno)
    if line: line = line.strip()
    else: line = None
    list.append((filename, lineno, name, line, GetArgs(f)))
    f = f.f_back
    n = n+1
  list.reverse()
  return list


class Pdb(pdb.Pdb):
  def format_stack_entry(self, frame_lineno, lprefix=': '):
    import linecache, repr
    frame, lineno = frame_lineno
    filename = self.canonic(frame.f_code.co_filename)
    s = '%s:%r ' % (filename, lineno)
    if frame.f_code.co_name:
      s = s + frame.f_code.co_name
    else:
      s = s + "<lambda>"
    if '__args__' in frame.f_locals:
      args = frame.f_locals['__args__']
    else:
      args = None
    if args:
      s = s + repr.repr(args)
    else:
      s = s + '()' 
    if '__return__' in frame.f_locals:
      rv = frame.f_locals['__return__']
      s = s + '->'
      s = s + repr.repr(rv)
    line = linecache.getline(filename, lineno)
    if line: s = s + lprefix + line.strip()
    return s


# copy and paste from other local libs

def Truncate(s, maxlen=25, with='...'):
  if len(s) > maxlen:
    if len(s) > maxlen:
      s = s[:maxlen-len(with)] + with
  return s


def SafeRepr(o):
  try:
    return repr(o)
  except:
    return '*repr raised*'


def GetArgs(frame):
  c = frame.f_code
  loc = frame.f_locals
  args = [(v, loc[v]) for v in c.co_varnames[:c.co_argcount]]
  argi = c.co_argcount
  if c.co_flags & inspect.CO_VARARGS:
    a = c.co_varnames[argi]
    args.append(('*'+a, loc[a]))
    argi += 1
  if c.co_flags & inspect.CO_VARKEYWORDS:
    a = c.co_varnames[argi]
    args.append(('**'+a, loc[a]))
  return args
