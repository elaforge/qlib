''' python hackery
'''
import sys, traceback, os
import local.text

__all__ = (
  'trace',
  'repl',
  'get_stack',
)

def trace(filter=lambda *a: True, nfuncs=1, out=sys.stdout, print_argvals=1):
  'insert tracefunc f which will remove itself after nfuncs func calls'
  if nfuncs is not None:
    nfuncs += 1 # account for this function
  sys.setprofile(Tracef(nfuncs, filter, out, print_argvals))

def nlevels(n):
  return lambda lvl, event, name, fn: lvl <= n

def in_files(*fns):
  return lambda lvl, event, name, fn: fn.split('/')[-1] in fns

def in_dirs(*dirs):
  def f(lvl, event, name, fn):
    try:
      return fn.split('/')[-2] in dirs
    except IndexError:
      return False
  return f

class Tracef:
  indent_s = '  '
  def __init__(self, nfuncs, filter, out, print_argvals=1):
    self.nfuncs = nfuncs
    self.filter = filter
    self.out = out
    self.lvl = 0
    self.print_argvals = print_argvals
    self.argstack = []
  def __call__(self, frame, event, arg):
    if event == 'call':
      self.lvl += 1
      self.argstack.append(get_args(frame))
    co = frame.f_code
    # name = '%s/%s:%d' %(frame.f_code.co_name,
    #   os.path.basename(frame.f_code.co_filename),
    #   frame.f_code.co_firstlineno)
    name = co.co_name
    if (name != 'trace' and event in ('call', 'return')
        and self.filter(self.lvl, event, name, co.co_filename)):
      if event == 'call':
        out = fmt_func_call(name, get_args(frame), self.print_argvals)
      elif event == 'return':
        out = '%s -> %s' %(name, truncate(safe_repr(arg), 25, '..'))
        # out = '%s -> %s' %(
        #   fmt_func_call(name, self.argstack.pop(), self.print_argvals),
        #   truncate(safe_repr(arg), 25, '..'))
      self.out.write('* %s:%d %s%s\n' %(
        os.path.basename(co.co_filename), co.co_firstlineno,
        self.indent_s * self.lvl, out))
    if event == 'return':
      self.lvl -= 1
    if self.lvl == -1 and self.nfuncs is not None:
      self.nfuncs -= 1
    if self.nfuncs == 0:
      sys.setprofile(None)

def fmt_func_call(func_name, func_args, print_argvals):
  selfarg = None
  args = []
  for k, v in func_args:
    if k == 'self':
      selfarg = v
    else:
      if print_argvals:
        v = truncate(safe_repr(v), 25, '..')
        args.append('%s=%s' %(k, v))
      else:
        args.append(k)
  s = ''
  if selfarg is not None:
    s += '%s.' % selfarg.__class__.__name__
  s += '%s(%s)' %(func_name, ', '.join(args))
  return s

def truncate(s, maxlen, with='...'):
  if len(s) > maxlen:
    return s[:maxlen - len(with)] + with
  else:
    return s

code_vararg = 0x04
code_kwarg = 0x08

def safe_repr(o):
  try:
    return repr(o)
  except:
    return '*repr raised*'

def get_args(frame):
  c = frame.f_code
  loc = frame.f_locals
  # 'del arg' will make 'arg' not show up in loc
  args = [ (v, loc.get(v, '??')) for v in c.co_varnames[:c.co_argcount] ]
  argi = c.co_argcount
  if c.co_flags & code_vararg:
    a = c.co_varnames[argi]
    args.append(('*'+a, loc[a]))
    argi += 1
  if c.co_flags & code_kwarg:
    a = c.co_varnames[argi]
    args.append(('**'+a, loc[a]))
  return args

def get_frame(nlevels=0):
  try: 1/0
  except: f = sys.exc_info()[2].tb_frame
  for i in range(nlevels+1):
    f = f.f_back
  return f

def get_lineno(nlevels=0):
  return get_frame(1).f_lineno

def repl():
  import readline
  f = get_frame(1)
  globals, locals = f.f_globals, f.f_locals
  print '\tnamespace:', f.f_code.co_name
  exec 'from local.hack import *' in globals, locals
  while 1:
    try:
      s = raw_input(sys.ps1)
    except EOFError:
      print
      break
    if s.rstrip().endswith(':'):
      while 1:
        t += raw_input(sys.ps2)
        if t == '\n':
          break
        else:
          s += t
    try:
      try:
        v = eval(s, globals, locals)
        print repr(v)
      except SyntaxError:
        exec s in globals, locals
    except:
      traceback.print_exception(*sys.exc_info())

def get_stack(ncallers=None):
  f = get_frame(1)
  r = []
  while f and (ncallers is None or ncallers >= 0):
    c = f.f_code
    if c.co_name == '?':
      break
    r.append('%s:%s:%d' %(c.co_name, os.path.basename(c.co_filename),
        f.f_lineno))
    if ncallers is not None:
      ncallers -= 1
    f = f.f_back
  r.reverse()
  return '->'.join(r)


def a(j):
  b(4, j)
  b(j, 2)

def b(x, y):
  print x, y
  c(2)
  return 42
  # print get_stack(3)

def c(x):
  pass

def test():
  trace(4)
  a('hi')

class A:
  def __init__(self, x):
    print 'hi' # get_stack()

class B(A):
  def __init__(self, x):
    trace()
    A.__init__(self, x)

if __name__ == '__main__':
  trace()
  a(23)

  # a = B(4)
  # b(a, 4)
