# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")

# ------------------------------------------------------------------------------
# Actual tests
# ------------------------------------------------------------------------------

def test_while():
    x = NONSOURCE
    n = 2
    while n > 0:
        if n == 1:
            SINK(x) #$ flow="SOURCE, l:+1 -> x"
        x = SOURCE
        n -= 1

class MyObj(object):
    def __init__(self, foo):
        self.foo = foo

def setFoo(obj, x):
    obj.foo = x

def test_while_obj():
    myobj = MyObj(NONSOURCE)
    n = 2
    while n > 0:
        if n == 1:
            SINK(myobj.foo) #$ flow="SOURCE, l:+1 -> myobj.foo"
        setFoo(myobj, SOURCE)
        n -= 1

def setAndTestFoo(obj, x, test):
    if test:
        # This flow is not found, if self-loops are broken at the SSA level.
        SINK(obj.foo) #$ flow="SOURCE, l:+7 -> obj.foo"
    obj.foo = x

def test_while_obj_sink():
    myobj = MyObj(NONSOURCE)
    n = 2
    while n > 0:
        setAndTestFoo(myobj, SOURCE, n == 1)
        n -= 1

