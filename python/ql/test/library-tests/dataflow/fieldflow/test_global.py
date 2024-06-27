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

# def test_indirect_assign():
myobj1 = MyObj("OK")
setFoo(myobj1, SOURCE)
SINK(myobj1.foo) # $ flow="SOURCE, l:-1 -> myobj1.foo"


# def test_indirect_assign_method():
myobj2 = MyObj("OK")
myobj2.setFoo(SOURCE)
SINK(myobj2.foo) # $ flow="SOURCE, l:-1 -> myobj2.foo"


# def test_direct_assign():
myobj3 = MyObj(NONSOURCE)
myobj3.foo = SOURCE
SINK(myobj3.foo) # $ flow="SOURCE, l:-1 -> myobj3.foo"


# def test_direct_assign_overwrite():
myobj4 = MyObj(NONSOURCE)
myobj4.foo = SOURCE
myobj4.foo = NONSOURCE
SINK_F(myobj4.foo)

# def test_direct_if_assign(cond = False):

# this way, our analysis isn't able to understand that `cond` is just False,
# and therefore isn't able to determine that the if below will not hold.
cond = eval("False")

myobj5 = MyObj(NONSOURCE)
myobj5.foo = SOURCE
if cond:
    myobj5.foo = NONSOURCE
    SINK_F(myobj5.foo)
# SPLITTING happens here, so in one version there is flow, and in the other there isn't
# that's why it has both a flow and a MISSING: flow annotation
SINK(myobj5.foo) # $ flow="SOURCE, l:-6 -> myobj5.foo" MISSING: flow


# def test_direct_if_always_assign(cond = True):
myobj6 = MyObj(NONSOURCE)
myobj6.foo = SOURCE
if cond:
    myobj6.foo = NONSOURCE
    SINK_F(myobj6.foo)
else:
    myobj6.foo = NONSOURCE
    SINK_F(myobj6.foo)
SINK_F(myobj6.foo)


# def test_getattr():
myobj7 = MyObj(NONSOURCE)
myobj7.foo = SOURCE
SINK(getattr(myobj7, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"


# def test_setattr():
myobj8 = MyObj(NONSOURCE)
setattr(myobj8, "foo", SOURCE)
SINK(myobj8.foo) # $ flow="SOURCE, l:-1 -> myobj8.foo"


# def test_setattr_getattr():
myobj9 = MyObj(NONSOURCE)
setattr(myobj9, "foo", SOURCE)
SINK(getattr(myobj9, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"


# def test_setattr_getattr_overwrite():
myobj10 = MyObj(NONSOURCE)
setattr(myobj10, "foo", SOURCE)
setattr(myobj10, "foo", NONSOURCE)
SINK_F(getattr(myobj10, "foo"))


# def test_constructor_assign():
obj2 = MyObj(SOURCE)
SINK(obj2.foo) # $ flow="SOURCE, l:-1 -> obj2.foo"


# def test_constructor_assign_kw():
obj3 = MyObj(foo=SOURCE)
SINK(obj3.foo) # $ flow="SOURCE, l:-1 -> obj3.foo"


def fields_with_local_flow(x):
    obj0 = MyObj(x)
    a0 = obj0.foo
    return a0

# def test_fields():
SINK(fields_with_local_flow(SOURCE)) # $ flow="SOURCE -> fields_with_local_flow(..)"

# ------------------------------------------------------------------------------
# Nested Object
# ------------------------------------------------------------------------------

class NestedObj(object):
    def __init__(self):
        self.obj = MyObj("OK")

    def getObj(self):
        return self.obj


# def test_nested_obj():
x1 = SOURCE
a1 = NestedObj()
a1.obj.foo = x1
SINK(a1.obj.foo) # $ flow="SOURCE, l:-3 -> a1.obj.foo"


# def test_nested_obj_method():
x2 = SOURCE
a2 = NestedObj()
a2.getObj().foo = x2
SINK(a2.obj.foo) # $ flow="SOURCE, l:-3 -> a2.obj.foo"

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
