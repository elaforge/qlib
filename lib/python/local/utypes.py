import sys

class Memo_property(object):
    __slots__ = ('thunk', 'memo_set', 'memo_exc', 'memo')
    def __init__(self, thunk):
        self.thunk = thunk
        self.memo_set = False
        self.memo_exc = None
        self.memo = None
    def __get__(self, obj, typ=None):
        if not self.memo_set:
            try:
                self.memo = self.thunk(obj)
            except:
                self.memo_exc = sys.exc_info()
            self.memo_set = True
        if self.memo_exc:
            raise self.memo_exc[0], self.memo_exc[1], self.memo_exc[2]
        else:
            return self.memo
