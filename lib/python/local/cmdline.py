'utility functions for cmdline programs'
import sys, getopt, os, string

prog_name = os.path.basename(sys.argv[0])

def fancy_getopt(usage, usaged=None, switches=None):
    '''fancy_getopt(usage, usaged=None, switches=None) -> opts, argv

        usage is help string. %(name)s, %(switches)s, and %(switch_doc)s
        automatically filled in

        usaged is a dict of other values to fill in

        switches is a dict of switches to help strings.  if a switch has more
        than one char, it takes an arg

        -h and bad options are automatically handled
    '''
    if not switches.has_key('h'):
        switches['h'] = 'show usage and help'
    d = {}
    d['name'] = prog_name
    if switches:
        s = switches.keys()
        s.sort()
        noargs = filter(lambda a: len(a) == 1, s)
        args = filter(lambda a: len(a) != 1, s)
        sw_str = []
        maxlen = 1
        if noargs:
            sw_str.append('-' + string.join(noargs, ''))
        if args:
            for a in args:
                sw_str.append('-' + a)
                maxlen = max(len(a), maxlen)
        d['switches'] = string.join(sw_str)
        s = map(lambda k, maxlen=maxlen:
                '    -%-*s %s' %(maxlen, k[0], k[1]), switches.items())
        s.sort()
        d['switch_doc'] = string.join(s, '\n')
    if usaged:
        d.update(usaged)
    getopt_str = string.join(noargs + map(lambda s: s[0]+':', args), '')
    try:
        opts, argv = getopt.getopt(sys.argv[1:], getopt_str)
    except getopt.error, s:
        gripe('%s (-h for usage)' % s)
    r = []
    for opt, optarg in opts:
        if opt == '-h':
            sys.stdout.write(usage % d)
            sys.exit(0)
        else:
            r.append((opt, optarg))
    return r, argv

def gripe(s, exitval=1):
    sys.stderr.write('%s: %s\n' %(prog_name, s))
    if exitval is not None:
        sys.exit(exitval)

def fdate(d, with_time=1, military=0):
    'format a pretty date'
    if with_time:
        if military:
            return d.strftime('%m-%d-%y %H:%M')
        else:
            s = d.strftime('%m-%d-%y %I:%M')
            if d.hour > 11:
                return s + 'pm'
            else:
                return s + 'am'

    else:
        return d.strftime('%d-%m-%y')
