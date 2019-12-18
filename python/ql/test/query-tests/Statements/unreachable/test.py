
#Unreachable code

def f(x):
    while x:
        print (x)
    while 0:
        asgn = unreachable()
    while False:
        return unreachable()
    while 7:
        print(x)

def g(x):
    if False:
        unreachable()
    else:
        reachable()
    print(x)
    return 5
    for x in first_unreachable_stmt():
        raise more_unreachable()

def h(a,b):
    if True:
        reachable()
    else:
        unreachable()

def intish(n):
    """"Regression test - the 'except' statement is reachable"""
    test = 0
    try:
        test += n
    except:
        return False
    return True

#ODASA-2033
def unexpected_return_result():
    try:
        assert 0, "async.Return with argument inside async.generator function"
    except AssertionError:
        return (None, sys.exc_info())

#Yield may raise -- E.g. in a context manager
def handle_yield_exception():
    resources = get_resources()
    try:
        yield resources
    except Exception as exc:
        log(exc)

#ODASA-ODASA-3790
def isnt_iter(seq):
    got_exc = False
    try:
        for x in seq:
            pass
    except Exception:
        got_exc = True
    return got_exc


class Odasa3686(object):

    def is_iterable(self, obj):
        #special case string
        if not object:
            return False
        if isinstance(obj, str):
            return False

        #Test for iterability
        try:
            None in obj
            return True
        except TypeError:
            return False

def odasa5387():
    try:
        str
    except NameError: # Unreachable 'str' is always defined
        pass
    try:
        unicode
    except NameError: # Reachable as 'unicode' is undefined in Python 3
        pass

#This is OK as type-hints require it
if False:
    from typing import Any

def foo():
    # type: () -> None
    return

#ODASA-6483
def deliberate_name_error(cond):
    if cond:
        x = 0
    try:
        x
    except NameError:
        x = 1
    return x

#ODASA-6783
def emtpy_gen():
    if False:
        yield None


def foo(x):
    if True:
        if x < 3:
            print(x, "< 3")
        if x == 0:
            print(x, "== 0")


# Unreachable catch-all case

def unreachable_catch_all_assert_false(x):
    if x < 0:
        return "negative"
    elif x >= 0:
        return "positive"
    else:
        assert False, x

def unreachable_catch_all_raise(x):
    if x < 0:
        pass
    elif x >= 0:
        pass
    else:
        raise ValueError(x)
