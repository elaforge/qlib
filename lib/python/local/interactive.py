'utility functions for interactive programs'

import string

def percent(n, total, display=5):
    total = float(total)
    percent = n / total * 100
    last_percent = (n - 1) / total * 100
    if percent % display < last_percent % display:
        return '%d/%d\t%02d%%' %(n, total, percent)

def ask(s, default):
    if default == 'y':
        default = 1
    else:
        default = 0
    while 1:
        c = raw_input('%s (%s) ' %(s, default and 'y' or 'n'))
        if c == '':
            return default
        elif c == 'y' or c == 'Y' or c == 'yes':
            return 1
        elif c == 'n' or c == 'N' or c == 'no':
            return 0
        else:
            print 'answer y or n or press return for', default and 'y' or 'n'

def confirm(s, default):
    c = raw_input('%s (%s): ' %(s, default))
    if c == '':
        if default == '':
            return None
        return default
    elif c == 'none' or c == 'None':
        return None
    else:
        return c

def choice(s, choices, default=None):
    prompt = '%s [%s] ' %(s, string.join(choices.keys() + ['?'], ', '))
    if default:
        prompt = prompt + '(%s) ' % default

    while 1:
        c = string.strip(raw_input(prompt))
        if not c and default:
            return choices[default]
        elif c in choices.keys():
            return choices[c]
        else:
            print 'choose one:'
            for i in choices.keys():
                print '\t%s\t%s' %(i, choices[i])
            if default:
                print 'default is', default
