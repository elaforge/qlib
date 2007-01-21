'''subprocess utils'''

def run(cmd, verbose=False):
    '''Return 'cmd's stdout, passing stderr through.  If 'verbose', pass
        stdout through as well.  raise OSError if cmd returns non-zero.'''
    p = popen2.Popen3(cmd, capturestderr=1, bufsize=0)
    p.tochild.close()
    if verbose:
        s = []
        while 1:
            line = p.fromchild.readline()
            if not line: break
            sys.stdout.write(line)
            s.append(line)
        s = ''.join(s)
    else:
        s = p.fromchild.read()
    sys.stderr.write(p.childerr.read())
    r = p.wait()
    if r != 0:
        st = str(os.WEXITSTATUS(r))
        if os.WIFSIGNALED(r):
            st += ' (sig %d)' %(os.WTERMSIG(r))
        raise OSError, 'cmd %s returned %s' %(cmd, st)
    return s
