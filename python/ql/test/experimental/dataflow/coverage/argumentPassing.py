import sys
import os
import functools

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

SOURCE = "source"
arg = "source"
arg1 = "source1"
arg2 = "source2"
arg3 = "source3"
arg4 = "source4"
arg5 = "source5"
arg6 = "source6"
arg7 = "source7"


def SINK_TEST(x, test):
    if test(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK(x, expected=arg):
    SINK_TEST(x, test=lambda x: x == expected)


def SINK_F(x, unexpected=arg):
    SINK_TEST(x, test=lambda x: x != unexpected)


SINK1 = functools.partial(SINK, expected=arg1)
SINK2 = functools.partial(SINK, expected=arg2)
SINK3 = functools.partial(SINK, expected=arg3)
SINK4 = functools.partial(SINK, expected=arg4)
SINK5 = functools.partial(SINK, expected=arg5)
SINK6 = functools.partial(SINK, expected=arg6)
SINK7 = functools.partial(SINK, expected=arg7)

SINK1_F = functools.partial(SINK_F, unexpected=arg1)
SINK2_F = functools.partial(SINK_F, unexpected=arg2)
SINK3_F = functools.partial(SINK_F, unexpected=arg3)
SINK4_F = functools.partial(SINK_F, unexpected=arg4)
SINK5_F = functools.partial(SINK_F, unexpected=arg5)
SINK6_F = functools.partial(SINK_F, unexpected=arg6)
SINK7_F = functools.partial(SINK_F, unexpected=arg7)


def argument_passing(
    a,
    b,
    /,
    c,
    d=arg4,  #$ arg4 func=argument_passing
    *,
    e=arg5,  #$ arg5 func=argument_passing
    f,
    **g,
):
    SINK1(a)
    SINK2(b)
    SINK3(c)
    SINK4(d)
    SINK5(e)
    SINK6(f)
    try:
        SINK7(g["g"])
    except:
        print("OK")


@expects(7)
def test_argument_passing1():
    argument_passing(arg1, *(arg2, arg3, arg4), e=arg5, **{"f": arg6, "g": arg7})  #$ arg1 arg5 arg6 arg7 func=argument_passing MISSING: arg2 arg3 arg4


@expects(7)
def test_argument_passing2():
    argument_passing(arg1, arg2, arg3, f=arg6)  #$ arg1 arg2 arg3 arg6


def with_pos_only(a, /, b):
    SINK1(a)
    SINK2(b)


@expects(6)
def test_pos_only():
    with_pos_only(arg1, arg2)  #$ arg1 arg2
    with_pos_only(arg1, b=arg2)  #$ arg1 arg2
    with_pos_only(arg1, *(arg2,))  #$ arg1 MISSING: arg2


def with_multiple_kw_args(a, b, c):
    SINK1(a)
    SINK2(b)
    SINK3(c)


@expects(12)
def test_multiple_kw_args():
    with_multiple_kw_args(b=arg2, c=arg3, a=arg1)  #$ arg1 arg2 arg3
    with_multiple_kw_args(arg1, *(arg2,), arg3)  #$ arg1 MISSING: arg2 arg3
    with_multiple_kw_args(arg1, **{"c": arg3}, b=arg2)  #$ arg1 arg2 arg3 func=with_multiple_kw_args
    with_multiple_kw_args(**{"b": arg2}, **{"c": arg3}, **{"a": arg1})  #$ arg1 arg2 arg3 func=with_multiple_kw_args


def with_default_arguments(a=arg1, b=arg2, c=arg3):  #$ arg1 arg2 arg3 func=with_default_arguments
    SINK1(a)
    SINK2(b)
    SINK3(c)


@expects(12)
def test_default_arguments():
    with_default_arguments()
    with_default_arguments(arg1)  #$ arg1
    with_default_arguments(b=arg2)  #$ arg2
    with_default_arguments(**{"c": arg3})  #$ arg3 func=with_default_arguments


# All combinations
def test_pos_pos():
    def with_pos(a):
        SINK1(a)

    with_pos(arg1)  #$ arg1 func=test_pos_pos.with_pos


def test_pos_pos_only():
    def with_pos_only(a, /):
        SINK1(a)

    with_pos_only(arg1)  #$ arg1 func=test_pos_pos_only.with_pos_only


def test_pos_star():
    def with_star(*a):
        if len(a) > 0:
            SINK1(a[0])

    with_star(arg1)  #$ arg1 func=test_pos_star.with_star


def test_pos_kw():
    def with_kw(a=""):
        SINK1(a)

    with_kw(arg1)  #$ arg1 func=test_pos_kw.with_kw


def test_kw_pos():
    def with_pos(a):
        SINK1(a)

    with_pos(a=arg1)  #$ arg1 func=test_kw_pos.with_pos


def test_kw_kw():
    def with_kw(a=""):
        SINK1(a)

    with_kw(a=arg1)  #$ arg1 func=test_kw_kw.with_kw


def test_kw_doublestar():
    def with_doublestar(**kwargs):
        SINK1(kwargs["a"])

    with_doublestar(a=arg1)  #$ arg1 func=test_kw_doublestar.with_doublestar


def only_kwargs(**kwargs):
    SINK1(kwargs["a"])
    SINK2(kwargs["b"])
    # testing precise content tracking, that content from `a` or `b` does not end up here.
    SINK3_F(kwargs["c"])

@expects(3)
def test_kwargs():
    args = {"a": arg1, "b": arg2, "c": "safe"} # $ arg1 arg2 func=only_kwargs
    only_kwargs(**args)


def mixed(a, **kwargs):
    SINK1(a)
    try:
        SINK1_F(kwargs["a"]) # since 'a' is a keyword argument, it cannot be part of **kwargs
    except KeyError:
        print("OK")
    SINK2(kwargs["b"])
    # testing precise content tracking, that content from `a` or `b` does not end up here.
    SINK3_F(kwargs["c"])

@expects(4*3)
def test_mixed():
    mixed(a=arg1, b=arg2, c="safe") # $ arg1 arg2

    args = {"b": arg2, "c": "safe"} # $ arg2 func=mixed
    mixed(a=arg1, **args) # $ arg1

    args = {"a": arg1, "b": arg2, "c": "safe"} # $ arg1 arg2 func=mixed
    mixed(**args)


def kwargs_same_name_as_positional_only(a, /, **kwargs):
    SINK1(a)
    SINK2(kwargs["a"])

@expects(2*2)
def test_kwargs_same_name_as_positional_only():
    kwargs_same_name_as_positional_only(arg1, a=arg2) # $ arg1 SPURIOUS: bad1="arg2" MISSING: arg2

    kwargs = {"a": arg2} # $ func=kwargs_same_name_as_positional_only SPURIOUS: bad1="arg2" MISSING: arg2
    kwargs_same_name_as_positional_only(arg1, **kwargs) # $ arg1


def starargs_only(*args):
    SINK1(args[0])
    SINK2(args[1])
    SINK3_F(args[2])

@expects(5*3)
def test_only_starargs():
    starargs_only(arg1, arg2, "safe") # $ arg1 arg2 SPURIOUS: bad2,bad3="arg1" bad1,bad3="arg2"

    args = (arg2, "safe") # $ MISSING: arg2
    starargs_only(arg1, *args) # $ arg1 SPURIOUS: bad2,bad3="arg1"

    args = (arg1, arg2, "safe") # $ arg1 arg2 func=starargs_only
    starargs_only(*args)

    empty_args = ()

    args = (arg1, arg2, "safe") # $ arg1 arg2 func=starargs_only
    starargs_only(*args, *empty_args)
    args = (arg1, arg2, "safe") # $ MISSING: arg1 arg2 func=starargs_only
    starargs_only(*empty_args, *args)


def starargs_mixed(a, *args):
    SINK1(a)
    SINK2(args[0])
    SINK3_F(args[1])

@expects(3*8)
def test_stararg_mixed():
    starargs_mixed(arg1, arg2, "safe") # $ arg1 arg2 SPURIOUS: bad3="arg2"

    args = (arg2, "safe") # $ arg2 func=starargs_mixed
    starargs_mixed(arg1, *args) # $ arg1

    args = (arg1, arg2, "safe")
    starargs_mixed(*args) # $ MISSING: arg1 arg2

    args = (arg1, arg2, "safe")
    more_args = ("foo", "bar")
    starargs_mixed(*args, *more_args) # $ MISSING: arg1 arg2

    empty_args = ()

    # adding first/last
    starargs_mixed(arg1, arg2, "safe", *empty_args) # $ arg1 arg2 SPURIOUS: bad3="arg2"
    starargs_mixed(*empty_args, arg1, arg2, "safe") # $ MISSING: arg1 arg2

    # adding before/after *args
    args = (arg2, "safe") # $ arg2 func=starargs_mixed
    starargs_mixed(arg1, *args, *empty_args) # $ arg1
    args = (arg2, "safe")
    starargs_mixed(arg1, *empty_args, *args) # $ arg1 MISSING: arg2

# ------------------------------------------------------------------------------
# Test updating field of argument
# ------------------------------------------------------------------------------

class MyClass: pass

def kwargsSideEffect(**kwargs):
    kwargs["a"].foo = kwargs["b"]

@expects(2)
def test_kwargsSideEffect():
    a = MyClass()
    kwargs = {"a": a, "b": SOURCE}
    kwargsSideEffect(**kwargs)
    SINK(a.foo) # $ MISSING: flow

    a = MyClass()
    kwargsSideEffect(a=a, b=SOURCE)
    SINK(a.foo) # $ MISSING: flow


def keywordArgSideEffect(a, b):
    a.foo = b

@expects(2)
def test_keywordArgSideEffect():
    a = MyClass()
    kwargs = {"a": a, "b": SOURCE}
    keywordArgSideEffect(**kwargs)
    SINK(a.foo) # $ MISSING: flow

    a = MyClass()
    keywordArgSideEffect(a=a, b=SOURCE)
    SINK(a.foo) # $ flow="SOURCE, l:-1 -> a.foo"


def starargsSideEffect(*args):
    args[0].foo = args[1]

@expects(2)
def test_starargsSideEffect():
    a = MyClass()
    args = (a, SOURCE)
    starargsSideEffect(*args)
    SINK(a.foo) # $ MISSING: flow

    a = MyClass()
    starargsSideEffect(a, SOURCE)
    SINK(a.foo) # $ MISSING: flow


def positionalArgSideEffect(a, b):
    a.foo = b

@expects(2)
def test_positionalArgSideEffect():
    a = MyClass()
    args = (a, SOURCE)
    positionalArgSideEffect(*args)
    SINK(a.foo) # $ MISSING: flow

    a = MyClass()
    positionalArgSideEffect(a, SOURCE)
    SINK(a.foo) # $ flow="SOURCE, l:-1 -> a.foo"
