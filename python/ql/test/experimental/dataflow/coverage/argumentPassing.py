import sys
import os
import functools

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

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
    argument_passing(arg1, *(arg2, arg3, arg4), e=arg5, **{"f": arg6, "g": arg7})  #$ arg1 arg7 func=argument_passing MISSING: arg2 arg3="arg3 arg4 arg5 arg6


@expects(7)
def test_argument_passing2():
    argument_passing(arg1, arg2, arg3, f=arg6)  #$ arg1 arg2 arg3


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
    with_multiple_kw_args(arg1, **{"c": arg3}, b=arg2)  #$ arg1 arg3 func=with_multiple_kw_args MISSING: arg2
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


# Nested constructor pattern
def grab_foo_bar_baz(foo, **kwargs):
    SINK1(foo)
    grab_bar_baz(**kwargs)


# It is not possible to pass `bar` into `kwargs`,
# since `bar` is a valid keyword argument.
def grab_bar_baz(bar, **kwargs):
    SINK2(bar)
    try:
        SINK2_F(kwargs["bar"])
    except:
        print("OK")
    grab_baz(**kwargs)


def grab_baz(baz):
    SINK3(baz)


@expects(4)
def test_grab():
    grab_foo_bar_baz(baz=arg3, bar=arg2, foo=arg1)  #$ arg1 arg2 arg3 func=grab_bar_baz func=grab_baz


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
    def with_doublestar(**a):
        SINK1(a["a"])

    with_doublestar(a=arg1)  #$ arg1 func=test_kw_doublestar.with_doublestar
