import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import *

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


def SINK1(x):
    SINK(x, expected=arg1)


def SINK2(x):
    SINK(x, expected=arg2)


def SINK2_F(x):
    SINK_F(x, unexpected=arg2)


def SINK3(x):
    SINK(x, expected=arg3)


def SINK4(x):
    SINK(x, expected=arg4)


def SINK5(x):
    SINK(x, expected=arg5)


def SINK6(x):
    SINK(x, expected=arg6)


def SINK7(x):
    SINK(x, expected=arg7)


def argument_passing(
    a,
    b,
    /,
    c,
    d=arg4,
    *,
    e=arg5,
    f,
    **g,
):
    SINK1(a) #$ arg1="arg1, l:89 -> a" arg1="arg1, l:94 -> a"
    SINK2(b) #$ arg2="arg2, l:94 -> b" MISSING:arg2="arg2, l:89 -> b"
    SINK3(c) #$ arg3="arg3, l:94 -> c" MISSING: arg3="arg3, l:89 -> c"
    SINK4(d) #$ MISSING: arg4="arg4, l:89 -> d"
    SINK5(e) #$ MISSING: arg5="arg5, l:89 -> e"
    SINK6(f) #$ MISSING: arg6="arg6, l:89 -> f"
    try:
        SINK7(g["g"]) #$ arg7="arg7, l:89 -> g['g']"
    except:
        print("OK")


@expects(7)
def test_argument_passing1():
    argument_passing(arg1, *(arg2, arg3, arg4), e=arg5, **{"f": arg6, "g": arg7})


@expects(7)
def test_argument_passing2():
    argument_passing(arg1, arg2, arg3, f=arg6)


def with_pos_only(a, /, b):
    SINK1(a) #$ arg1="arg1, l:104 -> a" arg1="arg1, l:105 -> a" arg1="arg1, l:106 -> a"
    SINK2(b) #$ arg2="arg2, l:104 -> b" arg2="arg2, l:105 -> b" MISSING: arg2="arg2, l:106 -> b"


@expects(6)
def test_pos_only():
    with_pos_only(arg1, arg2)
    with_pos_only(arg1, b=arg2)
    with_pos_only(arg1, *(arg2,))


def with_multiple_kw_args(a, b, c):
    SINK1(a) #$ arg1="arg1, l:117 -> a" arg1="arg1, l:118 -> a" arg1="arg1, l:119 -> a" arg1="arg1, l:120 -> a"
    SINK2(b) #$ arg2="arg2, l:117 -> b" arg2="arg2, l:120 -> b" MISSING: arg2="arg2, l:118 -> b" arg2="arg2, l:119 -> b"
    SINK3(c) #$ arg3="arg3, l:117 -> c" arg3="arg3, l:119 -> c" arg3="arg3, l:120 -> c" MISSING: arg3="arg3, l:118 -> c"


@expects(9)
def test_multiple_kw_args():
    with_multiple_kw_args(b=arg2, c=arg3, a=arg1)
    with_multiple_kw_args(arg1, *(arg2,), arg3)
    with_multiple_kw_args(arg1, **{"c": arg3}, b=arg2)
    with_multiple_kw_args(**{"b": arg2}, **{"c": arg3}, **{"a": arg1})


def with_default_arguments(a=arg1, b=arg2, c=arg3):
    SINK1(a) #$ arg1="arg1, l:132 -> a" MISSING:arg1="arg1, l:123 -> a"
    SINK2(b) #$ arg2="arg2, l:133 -> b" MISSING: arg2="arg2, l:123 -> b"
    SINK3(c) #$ arg3="arg3, l:134 -> c" MISSING: arg3="arg3, l:123 -> c"


@expects(12)
def test_default_arguments():
    with_default_arguments()
    with_default_arguments(arg1)
    with_default_arguments(b=arg2)
    with_default_arguments(**{"c": arg3})


# Nested constructor pattern
def grab_foo_bar_baz(foo, **kwargs):
    SINK1(foo) #$ arg1="arg1, l:160 -> foo"
    grab_bar_baz(**kwargs)


# It is not possible to pass `bar` into `kwargs`,
# since `bar` is a valid keyword argument.
def grab_bar_baz(bar, **kwargs):
    SINK2(bar) #$ arg2="arg2, l:160 -> bar"
    try:
        SINK2_F(kwargs["bar"])
    except:
        print("OK")
    grab_baz(**kwargs)


def grab_baz(baz):
    SINK3(baz) #$ arg3="arg3, l:160 -> baz"


@expects(4)
def test_grab():
    grab_foo_bar_baz(baz=arg3, bar=arg2, foo=arg1)


# All combinations
def test_pos_pos():
    def with_pos(a):
        SINK1(a) #$ arg1="arg1, l:168 -> a"

    with_pos(arg1)


def test_pos_pos_only():
    def with_pos_only(a, /):
        SINK1(a) #$ arg1="arg1, l:175 -> a"

    with_pos_only(arg1)


def test_pos_star():
    def with_star(*a):
        if len(a) > 0:
            SINK1(a[0]) #$ arg1="arg1, l:183 -> a[0]"

    with_star(arg1)


def test_pos_kw():
    def with_kw(a=""):
        SINK1(a) #$ arg1="arg1, l:190 -> a"

    with_kw(arg1)


def test_kw_pos():
    def with_pos(a):
        SINK1(a) #$ arg1="arg1, l:197 -> a"

    with_pos(a=arg1)


def test_kw_kw():
    def with_kw(a=""):
        SINK1(a) #$ arg1="arg1, l:204 -> a"

    with_kw(a=arg1)


def test_kw_doublestar():
    def with_doublestar(**a):
        SINK1(a["a"]) #$ arg1="arg1, l:211 -> a['a']"

    with_doublestar(a=arg1)
