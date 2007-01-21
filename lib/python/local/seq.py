'''sequence utilies'''

def uniq(a):
    '''uniqify sequence 'a'.  'a's order is lost.'''
    d = {}
    for e in a:
        d[e] = None
    return d.keys()
