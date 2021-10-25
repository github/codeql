
f1 = 1.0
dict
tuple
i1 = 0
s = ()

def func():
    pass

class C(object):
    pass

def vararg_kwarg(*t, **d):
    t
    d

def multi_loop(seq):
    x = None
    for x, y in seq:
        x

def with_definition(x):
    with x as y:
        y

def multi_loop_in_try(x):
    try: # This causes additional exception edges, such that:
        for p, q in x: # `x` and `p` are not in the same BB.
            p
    except KeyError:
        pass

def f(*args, **kwargs):
    not args[0]
    not kwargs["x"]

def multi_assign_and_packing(a, b="b", c="c"):
    t = 1, 2, 3
    w = a, b, c
    p, q, r = t
    x, y, z = w
    p
    q
    r
    x
    y
    z
    g, h, i = a, b, c
    g
    h
    i
    l, m = (1,) + (2,)
    l
    m
    s, u = a
    s
    u

