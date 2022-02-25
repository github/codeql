"""
This file contains a copy of the tests from `test.py` along with some cases that check
the interaction between global variables and assignment on global scope.

You might think that these are a bit useless since field-flow should work just the same
on global or non-global scope, but then you would be wrong!
"""

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

class MyObj(object):
    def __init__(self, foo):
        self.foo = foo

    def setFoo(self, foo):
        self.foo = foo

def setFoo(obj, x):
    SINK_F(obj.foo)
    obj.foo = x


myobj = MyObj("OK")

setFoo(myobj, SOURCE)
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj("OK")

myobj.setFoo(SOURCE)
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
myobj.foo = NONSOURCE
SINK_F(myobj.foo)


# this way, our analysis isn't able to understand that `cond` is just False,
# and therefore isn't able to determine that the if below will not hold.
cond = eval("False")

myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
if cond:
    myobj.foo = NONSOURCE
    SINK_F(myobj.foo)
# SPLITTING happens here, so in one version there is flow, and in the other there isn't
# that's why it has both a flow and a MISSING: flow annotation
SINK(myobj.foo) # $ flow="SOURCE, l:-6 -> myobj.foo" MISSING: flow



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
if cond:
    myobj.foo = NONSOURCE
    SINK_F(myobj.foo)
else:
    myobj.foo = NONSOURCE
    SINK_F(myobj.foo)
SINK_F(myobj.foo)



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
SINK(getattr(myobj, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"



myobj = MyObj(NONSOURCE)
setattr(myobj, "foo", SOURCE)
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj(NONSOURCE)
setattr(myobj, "foo", SOURCE)
SINK(getattr(myobj, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"



myobj = MyObj(NONSOURCE)
setattr(myobj, "foo", SOURCE)
setattr(myobj, "foo", NONSOURCE)
SINK_F(getattr(myobj, "foo"))



obj2 = MyObj(SOURCE)
SINK(obj2.foo) # $ flow="SOURCE, l:-1 -> obj2.foo"



obj3 = MyObj(foo=SOURCE)
SINK(obj3.foo) # $ flow="SOURCE, l:-1 -> obj3.foo"



def fields_with_local_flow(x):
    obj = MyObj(x)
    a = obj.foo
    return a

SINK(fields_with_local_flow(SOURCE)) # $ flow="SOURCE -> fields_with_local_flow(..)"

# ------------------------------------------------------------------------------
# Nested Object
# ------------------------------------------------------------------------------

class NestedObj(object):
    def __init__(self):
        self.obj = MyObj("OK")

    def getObj(self):
        return self.obj

x = SOURCE
a = NestedObj()
a.obj.foo = x
SINK(a.obj.foo) # $ flow="SOURCE, l:-3 -> a.obj.foo"



x = SOURCE
a = NestedObj()
a.getObj().foo = x
SINK(a.obj.foo) # $ flow="SOURCE, l:-3 -> a.obj.foo"

# ------------------------------------------------------------------------------
# Global scope interaction
# ------------------------------------------------------------------------------

def func_defined_before():
    SINK(global_obj.foo) # $ MISSING: flow="SOURCE, l:+3 -> global_obj.foo"

global_obj = MyObj(NONSOURCE)
global_obj.foo = SOURCE
SINK(global_obj.foo) # $ flow="SOURCE, l:-1 -> global_obj.foo"

def func_defined_after():
    SINK(global_obj.foo) # $ MISSING: flow="SOURCE, l:-4 -> global_obj.foo"
