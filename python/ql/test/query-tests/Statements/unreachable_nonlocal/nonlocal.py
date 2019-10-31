
def nonlocal_fp():
    test = False
    def set_test():
        nonlocal test
        test = True
    set_test()
    if test:
        raise Exception("Foo")


# A couple of false negatives, roughly in order of complexity

# test is nonlocal, but not mutated
def nonlocal_fn1():
    test = False
    def set_test():
        nonlocal test
    set_test()
    if test:
        raise Exception("Foo")

# test is nonlocal and mutated, but does not change truthiness
def nonlocal_fn2():
    test = False
    def set_test():
        nonlocal test
        test = 0
    set_test()
    if test:
        raise Exception("Foo")

# test is nonlocal and changes truthiness, but the function is never called
def nonlocal_fn3():
    test = False
    def set_test():
        nonlocal test
        test = True
    if test:
        raise Exception("Foo")

# test is nonlocal and changes truthiness, but only if the given argument is true
def nonlocal_fn4(x):
    test = False
    def set_test():
        nonlocal test
        test = True
    if x:
        set_test()
    if test:
        raise Exception("Foo")
