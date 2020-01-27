# Extended Iterable Unpacking -- PEP 3132
# https://www.python.org/dev/peps/pep-3132/


def test(*args):
    pass


def extended_unpacking():
    first, *rest, last = TAINTED_LIST
    test(first, rest, last) # TODO: mark `rest` as [taint]


def also_allowed():
    *a, = TAINTED_LIST
    test(a) # TODO: mark `a` as [taint]

    # for b, *c in [(1, 2, 3), (4, 5, 6, 7)]:
        # print(c)
        # i=0; c=[2,3]
        # i=1; c=[5,6,7]

    for b, *c in [TAINTED_LIST, TAINTED_LIST]:
        test(b, c) # TODO: mark `c` as [taint]
