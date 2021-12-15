from __future__ import print_function

def undefined_in_3():
    [x for x in range(3)]
    print(x)

def different_in_3():
    y = 10
    [y for y in range(3)]
    print(y)

def ok():
    [z for z in range(4)]

#FP observed in sembuild
def use_in_loop(seq):
    [x for x in range(3)]
    for x in seq:
        use(x) #x redefined -- fine in 2 and 3.

def test_6395(dev):
    ret = {}

    res = foo(dev)
    if not res:
        return False

    for line in res.splitlines():  # pylint: disable=no-member
        line = line.strip()
        if not line:
            continue

        key, val = [val.strip() for val in bar(line)]
        if not (key and val):
            continue

        mval = None
        if ' ' in val:
            rval, mval = [val.strip() for val in bar(val)]
            mval = mval[1:-1]
        else:
            rval = val

    return ret

def test_6441(seq):
    for var in seq:
        foo(var)
        [var for var in bar()]
