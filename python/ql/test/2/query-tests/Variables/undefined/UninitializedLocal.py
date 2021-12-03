
def const_xrange():
    for i in xrange(4):
        x = i
    return x

def rec1(a):
    if a > 0:
        rec1(a - 1)

def rec2(b):
    [rec2(b - 1) for c in range(b)]
