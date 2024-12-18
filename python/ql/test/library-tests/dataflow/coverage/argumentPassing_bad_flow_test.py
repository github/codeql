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


def bad_argument_flow_func(arg):
    SINK1_F(arg)

def bad_argument_flow_func2(arg):
    SINK2(arg)

def test_bad_argument_flow():
    # this is just a test to show that the testing setup works

    # in the first one, we pretend we expected no flow for arg1
    bad_argument_flow_func(arg1) # $ bad1="arg1"

    # in the second one, we pretend we wanted flow for arg2 instead
    bad_argument_flow_func2(arg1) # $ bad2="arg1"
