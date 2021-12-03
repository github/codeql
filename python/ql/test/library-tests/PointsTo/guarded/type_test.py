
def f(d = {}):

    if isinstance(d, dict):
        use(d)
    else:
        use(d)

def g(cond):

    x = 0 if cond else 1.0

    if isinstance(x, int):
        use(x)
    elif isinstance(x, float):
        use(x)
    else:
        use(x)

def h(arg=int):
    if issubclass(arg, int):
        use(arg)
    else:
        use(arg)

class D(object):
    pass

class E(D):
    pass

def j(arg=E()):

    if isinstance(arg, E):
        use(arg)
    else:
        use(arg)

def k(arg=E()):

    if isinstance(arg, D):
        use(arg)
    else:
        use(arg)


def l(arg=E):
    if issubclass(arg, E):
        use(arg)
    else:
        use(arg)

def m(arg=E):
    if issubclass(arg, D):
        use(arg)
    else:
        use(arg)

number = int, float

def n(cond):
    x = 0 if cond else 1.0

    if not isinstance(x, number):
        use(x)
    else:
        use(x)

import sys
if sys.version < "3":
    from collections import Iterable, Sequence, Set
else:
    from collections.abc import Iterable, Sequence, Set

def p():
    if issubclass(list, Iterable):
        use(0)
    else:
        use(1)

def q():
    if issubclass(list, Sequence):
        use(0)
    else:
        use(1)

def p():
    if isinstance({0}, Iterable):
        use(0)
    else:
        use(1)

def q():
    if isinstance({0}, Set):
        use(0)
    else:
        use(1)
