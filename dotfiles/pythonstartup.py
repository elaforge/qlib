# nice to have these for interactive sessions
import sys, os

sys.path.insert(1, os.path.join(os.environ['HOME'], 'qlib/lib/python'))

sys.ps1 = sys.ps2 = ''
def _eh(typ, val, tb):
    import local.qtraceback
    s = ''.join(local.qtraceback.format_exception(typ, val, tb))
    for line in s.split('\n'):
        if line.strip():
            sys.stdout.write('# %s\n' % line)
sys.excepthook = _eh
del _eh

def _dh(object):
    if object is None:
        return
    sys.stdout.write('#-> ')
    sys.stdout.write(repr(object))
    sys.stdout.write('\n')
    __builtins__._ = object
sys.displayhook = _dh
del _dh
