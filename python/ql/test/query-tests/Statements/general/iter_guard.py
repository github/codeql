def iter_guard_ok(xs):
    try:
        iter(xs)
    except TypeError:
        raise TypeError("Supplied argument is not an iterator")
    for x in xs:
        print(x)

try:
    iter_guard_ok(5)
except TypeError:
    pass



def iter_guard_bad(xs):
    try:
        not_iter(xs)
    except TypeError:
        raise TypeError("Supplied argument is not an iterator")
    for x in xs:
        print(x)

try:
    iter_guard_bad(5)
except TypeError:
    pass


# A somewhat contrived false positive
def iter_guard_indirect(xs):
    ys = xs
    try:
        iter(ys)
    except TypeError:
        raise TypeError("Supplied argument is not an iterator")
    for x in xs:
        print(x)

try:
    iter_guard_indirect(5)
except TypeError:
    pass



def iter_no_guard(xs):
    for x in iter(xs):
        print(x)

try:
    iter_no_guard(5)
except TypeError:
    pass
