'''Various user-defined sequence and mapping types.'''

import string, operator
from UserDict import UserDict
from types import *

class MsgDict(UserDict):
    '''Returns string 'key: val' if it has the key, or 'key: (nothing given)'
        it doesn't have the key or the key is an empty string or list.
        If val is a list, it is joined with ', '.
    '''
    def __init__(self, data=None):
        if data is None:
            self.data = {}
        else:
            self.data = data
    def __getitem__(self, key):
        data = self.data
        if not data.has_key(key) \
            or (type(data[key]) is StringType and string.strip(data[key]) == '')\
            or (type(data[key]) is ListType and data[key] == []):
            return '%s: (nothing given)' % key

        if type(self.data[key]) is ListType:
            return '%s: %s' %(key, string.join(self.data[key], ', '))
        else:
            return '%s: %s' %(key, self.data[key])
    def __str__(self):
        ret = []
        for i in self.keys():
            ret.append(self[i] + '\n')
        return string.join(ret, '')
    def has_key(self, key):
        return 1
    def raw_lookup(self, key):
        return self.data[key]

class UnionDict:
    '''Overlays dicts and checks for key in order.  raises KeyError if the key
        isn't in any of them.
    '''
    def __init__(self, *dicts):
        if dicts is ():
            raise TypeError, 'need at least one dict'
        self.dicts = dicts
    def push(self, dict):
        self.dicts.append(dict)
    def pop(self):
        d = self.dicts[-1]
        del self.dicts[-1]
        return d
    def __getitem__(self, key):
        for i in self.dicts:
            if i.has_key(key):
                return i[key]
        else:
            raise KeyError, "UnionDict() couldn't find key: " + `key`

class DefaultDict(UserDict):
    '''Like a normal dict except that it returns default on KeyError.'''
    def __init__(self, default, dict):
        self.default = default
        self.data = dict
    def __getitem__(self, key):
        return self.data.get(key, self.default)

class PrettyDict(UserDict):
    '''Makes a dict that is pretty-printed when str()ed.

        ints and strings are printed as 'key = value'
        PrettyDicts are str()ed
        lists and tuples are printed as::
            
            key:
                val1
                val2
                ...
        
        dicts are PrettyDict()ed and str()ed
    '''
    level = [0]
    def __init__(self, dict=None):
        if dict is None:
            self.data = {}
        else:
            self.data = dict
    def tab(self):
        return self.level[0] * '    '
    def incr(self):
        self.level[0] = self.level[0] + 1
    def decr(self):
        self.level[0] = self.level[0] - 1
    def __str__(self):
        # I get an extra space when mixing ret and print... track down this
        # and post to c.l.py? (and recursion?)
        # print 'entering level', self.level
        ret = []
        a = ret.append
        sub_dicts = {}
        vals = {}
        for name, val in self.data.items():
            if isinstance(val, self.__class__) or type(val) is DictType:
                sub_dicts[name] = val
            else:
                vals[name] = val
        
        maxlen = 0
        for key in vals.keys():
            if type(key) is StringType:
                maxlen = max(maxlen, len(key))
            elif operator.isNumberType(key):
                maxlen = max(maxlen, len(`key`))

        k = vals.keys()
        k.sort()
        for key in k:
            if (operator.isSequenceType(vals[key])
                    and type(vals[key]) is not StringType):
                if len(vals[key]) is 0:
                    a('%s%s: empty\n' %(self.tab(), key))
                else:
                    a('%s%s:\n' %(self.tab(), key))
                    self.incr()
                    for i in vals[key]:
                        a('%s%s\n' %(self.tab(), i))
                    self.decr()
            else:
                fmt = '%s%-' + `maxlen` + 's = %s\n'
                a(fmt %(self.tab(), key, vals[key]))

        k = sub_dicts.keys()
        k.sort()
        for key in k:
            a('%s%s:\n' %(self.tab(), key))
            self.incr()
            if type(sub_dicts[key]) is DictType:
                sub_dicts[key] = apply(self.__class__, sub_dicts[key])
            a(str(sub_dicts[key]))
            self.decr()
        
        return string.join(ret, '')

class FalseString:
    def __init__(self, s):
        self.s = s
    def __nonzero__(self):
        return 0
    def __str__(self):
        return self.s
