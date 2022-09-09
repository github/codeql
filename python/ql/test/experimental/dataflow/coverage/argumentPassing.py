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

    with_star(arg1)  #$ MISSING: arg1 func=test_pos_star.with_star


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
    SINK3_F(kwargs["c"])

@expects(4*3)
def test_mixed():
    mixed(a=arg1, b=arg2, c="safe") # $ arg1 arg2

    args = {"b": arg2, "c": "safe"} # $ arg2 func=mixed
    mixed(a=arg1, **args) # $ arg1

    args = {"a": arg1, "b": arg2, "c": "safe"} # $ arg1 arg2 func=mixed
    mixed(**args)
