''' utils for filesystem operations
also utils for file-like objects
'''
import os, select, popen2, itertools

class Merged_file:
    '''Merge streams.  currently only readline is supported
    add more methods as needed'''
    bufsz = 1024
    def __init__(self, *fps):
        self.fds = [ fp.fileno() for fp in fps ]
        self.bufs = dict([ (fd, ([], False)) for fd in self.fds ])
    def readline(self):
        while 1:
            if not [ None for (b, eof) in self.bufs.values() if eof == False ]:
                return ''
            for fd, (b, eof) in self.bufs.items():
                b = ''.join(b)
                if eof and b:
                    self.bufs[fd][0][:] = []
                    return b
                elif '\n' in b:
                    s, self.bufs[fd][0][:] = b.split('\n', 1)
                    return s
            for fd in select.select(self.fds, (), ())[0]:
                s = os.read(fd, self.bufsz)
                if not s:
                    self.bufs[fd] = self.bufs[fd][0], True
                else:
                    self.bufs[fd][0].append(s)
    def __iter__(self):
        while 1:
            s = self.readline()
            if not s:
                break
            yield s

def path_head(fn):
    "first path element, excluding '/'"
    if fn.startswith('/'):
        fn = fn[1:]
    return os.path.normpath(fn).split(os.path.sep, 1)[0]

def try_fnames(pref):
    yield pref
    for i in itertools.count():
        yield '%s.%d' %(pref, i)
