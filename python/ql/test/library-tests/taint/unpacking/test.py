def test(*args):
    pass


def unpacking():
    l = TAINTED_LIST
    a, b, c = l
    test(a, b, c)


def unpacking_to_list():
    l = TAINTED_LIST
    [a, b, c] = l
    test(a, b, c)


def nested():
    l = TAINTED_LIST
    ll = [l, l, l]

    # list
    [[a1, a2, a3], b, c] = ll
    test(a1, a2, a3, b, c)

    # tuple
    ((a1, a2, a3), b, c) = ll
    test(a1, a2, a3, b, c)

    # mixed
    [(a1, a2, a3), b, c] = ll
    test(a1, a2, a3, b, c)


def unpack_from_set():
    # no guarantee on ordering ... don't know why you would ever do this
    a, b, c = {"foo", "bar", TAINTED_STRING}
    # either all should be tainted, or none of them
    test(a, b, c)


def contrived_1():
    # A contrived example. Don't know why anyone would ever actually do this.
    tainted_list = TAINTED_LIST
    no_taint_list = [1,2,3]

    # We don't handle this case currently, since we mark `d`, `e` and `f` as tainted.
    (a, b, c), (d, e, f) = tainted_list, no_taint_list
    test(a, b, c, d, e, f)


def contrived_2():
    # A contrived example. Don't know why anyone would ever actually do this.

    # We currently only handle taint nested 2 levels.
    [[[ (a,b,c) ]]] = [[[ TAINTED_LIST ]]]
    test(a, b, c)

# For Python 3, see https://www.python.org/dev/peps/pep-3132/
