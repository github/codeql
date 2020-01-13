
def const_xrange():
    for i in xrange(4):
        x = i
    return x

def rec1(a):
    if a > 0:
        rec1(a - 1)

def rec2(b):
    [rec2(b - 1) for c in range(b)]


def deliberate_name_error4(cond, my_list):
    if cond:
        x = 0 # x is uninitialised, but guarded. So don't report it.
    try:
        x = my_list[x + 42]
    # FIXME: With this query, only reports IndexError  (doesn't seem possible to find NameError :O)
    #
    # from Try t, ExceptStmt except
    # where except = t.getAHandler()
    # select t, except.getType(), t.getLocation()
    except IndexError, NameError: # ONLY VALID IN PYTHON2
        x = -1
    return x
