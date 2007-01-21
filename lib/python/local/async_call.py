import sys, os, select, signal
import cPickle, cStringIO, traceback
import threading

def dump(v, fp):
    cPickle.dump(v, fp, cPickle.HIGHEST_PROTOCOL)
load = cPickle.load

def th_call(timeout, f, *a, **kw):
    r = []
    def callf():
        r.append(f(*a, **kw))
    th = threading.Thread(target=callf)
    th.setDaemon(1)
    th.start()
    th.join(timeout)
    if r:
        return True, r[0]
    else:
        return False, None

def parallel(*fs):
    'Execute each f in parallel.  Return first 'f' to complete and its index.'

def call(timeout, f, *a, **kw):
    '''make pipe and fork.  child uses pipe to write pickled return value
    back.  Parent select()s on pipe.  If pickle comes through, reconstruct
    and return.  If select() times out, kill child and return False.  If
    child throws, exception comes through pipe and is raised.  If child just
    dies... ?'''
    rpfd, wpfd = os.pipe()
    child = os.fork()
    if not child:
        os.close(rpfd)
        call_child(os.fdopen(wpfd, 'w'), f, a, kw)
        assert 0, 'notreached'
    os.close(wpfd)
    exc = None
    if select.select([rpfd], [], [], timeout)[0]:
        rp = os.fdopen(rpfd)
        s = rp.read()
        rpio = cStringIO.StringIO(s)
        r = load(rpio)
        if rpio.tell() < len(s):
            typ = r
            val = load(rpio)
            tb = load(rpio)
            exc = typ, val, tb
        else:
            r = (True, r)
        rp.close()
    else:
        print 'select failed'
        os.close(rpfd)
        os.kill(child, signal.SIGKILL)
        r = (False, None)
    print 'wait', os.waitpid(child, 0)
    if exc:
        # XXX don't know how to fake up a real tb for raise
        print 'Child traceback:'
        print exc[2]
        raise exc[0], exc[1]
    else:
        return r

def call_child(wp, f, a, kw):
    try:
        try:
            r = f(*a, **kw)
        except:
            ty, val, tb = sys.exc_info()
            dump(ty, wp)
            dump(val, wp)
            # can't pickle tracebacks, so format it here
            dump(''.join(format_tb(tb)), wp)
        else:
            print 'dump', `r`
            dump(r, wp)
    finally:
        wp.close()
        os._exit(0)
