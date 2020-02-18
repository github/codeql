def test(*args):
    pass

def swap_taint():
    a, b = SOURCE, "safe"
    test(a, b)
    a, b = b, a
    test(a, b)

def nested_assignment():
    # A contrived example, that is a bit silly (and is not even iterable unpacking).
    # We do handle this case though.
    ((t1, s1), t2, s2) = ((SOURCE, "safe"), SOURCE, "safe")
    test(t1, s1, t2, s2)
