#Global

n = None
t = True
f = False

n
t
f

if n:
    t
else:
    f


def foo():
    n = None
    t = True
    f = False

    n
    t
    f

    if n:
        t
    else:
        f

    not n
    not t
    not f

    if t == f:
        t
    else:
        f

    if t is not f:
        t
    else:
        f

