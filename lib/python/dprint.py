import sys, os, time
import traceback

__all__ = [
    'dprint', 'DEBUG', 'NOTICE', 'WARNING', 'ERROR',
]

DEBUG, NOTICE, WARNING, ERROR = 1, 2, 3, 4
log_level = DEBUG
log_file = None
subsystem_log_level = {}
subsystem_log_file = {}

show_info = 1

def dprint(subsystem, s, prio=DEBUG, exc_info=None, caller=0, extra_info=''):
    ''' big complicated error logging mechanism.
        subsystem - subsystem that emitted the msg
        s - error msg
        prio - msg priority
        exc_info - either an exc_info triplet, in which case a full traceback
            is printed, or an exception, which will be printed.  exception
            info is printed after the msg line on lines beginning with '+'
        caller - levels above the caller to report the calling function as
        extra_info - optional extra info which may be turned off independent
            of log_level
    '''
    if prio < subsystem_log_level.get(subsystem, log_level):
        return
    if show_info:
        c = get_caller(caller + 2, code_obj=1) # 1 for get_caller, 1 for dprint
        time_s = time.strftime('%m-%d:%H:%m:%S', time.localtime(time.time()))
        info = '%-4s %s %s %s:%s' %('*' * prio, subsystem, time_s,
            os.path.basename(c.co_filename), c.co_firstlineno)
        if extra_info:
            info += ' ' + extra_info
        s = '%s | %s' %(info, s)
    es = []
    if type(exc_info) is type(()):
        es += traceback.format_exception(*exc_info)
    elif isinstance(exc_info, Exception):
        es += [str(exc_info) + '\n'] # plain exception
    # format_* lists may have internal \n, split them to prepend +
    lines = ''.join(es).split('\n')[:-1]
    es = ''.join([ '+   ' + line + '\n' for line in lines ])
    s += '\n' + es
    if subsystem_log_file.get(subsystem) or log_file:
        try:
            fp = open(subsystem_log_file.get(subsystem, log_file), 'a')
        except IOError, exc:
            fp = sys.stderr
            fp.write("** Log file %r unwritable: %s, logging to stderr:\n"
                %(log_file, exc))
        fp.write(s)
        fp.close()
    else:
        sys.stderr.write(s)
        sys.stderr.flush()

def get_caller(n=1, code_obj=0):
    try:
        raise 'hi'
    except:
        f = sys.exc_info()[2].tb_frame
    for i in range(n):
        f = f.f_back
    if code_obj:
        return f.f_code
    else:
        return f.f_code.co_name
