import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import *

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

@expects(2)
def test_indirect_assign():
    myobj = MyObj("OK")

    setFoo(myobj, SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"


def test_indirect_assign_method():
    myobj = MyObj("OK")

    myobj.setFoo(SOURCE)
    SINK(myobj.foo) # $ MISSING: flow


def test_direct_assign():
    myobj = MyObj(NONSOURCE)
    myobj.foo = SOURCE
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"


def test_direct_assign_overwrite():
    myobj = MyObj(NONSOURCE)
    myobj.foo = SOURCE
    myobj.foo = NONSOURCE
    SINK_F(myobj.foo)


def test_direct_if_assign(cond = False):
    myobj = MyObj(NONSOURCE)
    myobj.foo = SOURCE
    if cond:
        myobj.foo = NONSOURCE
        SINK_F(myobj.foo)
    SINK(myobj.foo) # $ flow="SOURCE, l:-4 -> myobj.foo"


@expects(2)
def test_direct_if_always_assign(cond = True):
    myobj = MyObj(NONSOURCE)
    myobj.foo = SOURCE
    if cond:
        myobj.foo = NONSOURCE
        SINK_F(myobj.foo)
    else:
        myobj.foo = NONSOURCE
        SINK_F(myobj.foo)
    SINK_F(myobj.foo)


def test_getattr():
    myobj = MyObj(NONSOURCE)
    myobj.foo = SOURCE
    SINK(getattr(myobj, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"


def test_setattr():
    myobj = MyObj(NONSOURCE)
    setattr(myobj, "foo", SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"


def test_setattr_getattr():
    myobj = MyObj(NONSOURCE)
    setattr(myobj, "foo", SOURCE)
    SINK(getattr(myobj, "foo")) # $ flow="SOURCE, l:-1 -> getattr(..)"


def test_setattr_getattr_overwrite():
    myobj = MyObj(NONSOURCE)
    setattr(myobj, "foo", SOURCE)
    setattr(myobj, "foo", NONSOURCE)
    SINK_F(getattr(myobj, "foo"))


def test_constructor_assign():
    obj = MyObj(SOURCE)
    SINK(obj.foo) # $ flow="SOURCE, l:-1 -> obj.foo"


def test_constructor_assign_kw():
    obj = MyObj(foo=SOURCE)
    SINK(obj.foo) # $ flow="SOURCE, l:-1 -> obj.foo"


def fields_with_local_flow(x):
    obj = MyObj(x)
    a = obj.foo
    return a

def test_fields():
    SINK(fields_with_local_flow(SOURCE)) # $ flow="SOURCE -> fields_with_local_flow(..)"

# ------------------------------------------------------------------------------
# Nested Object
# ------------------------------------------------------------------------------

class NestedObj(object):
    def __init__(self):
        self.obj = MyObj("OK")

    def getObj(self):
        return self.obj


def test_nested_obj():
    x = SOURCE
    a = NestedObj()
    a.obj.foo = x
    SINK(a.obj.foo) # $ flow="SOURCE, l:-3 -> a.obj.foo"


def test_nested_obj_method():
    x = SOURCE
    a = NestedObj()
    a.getObj().foo = x
    SINK(a.obj.foo) # $ MISSING: flow

# ------------------------------------------------------------------------------
# Global scope
# ------------------------------------------------------------------------------

def func_defined_before():
    SINK(global_obj.foo) # $ MISSING: flow="SOURCE, l:+3 -> global_obj.foo"

global_obj = MyObj(NONSOURCE)
global_obj.foo = SOURCE
SINK(global_obj.foo) # $ flow="SOURCE, l:-1 -> global_obj.foo"

def func_defined_after():
    SINK(global_obj.foo) # $ MISSING: flow="SOURCE, l:-4 -> global_obj.foo"

@expects(2)
def test_global_funcs():
    func_defined_before()
    func_defined_after()

# ------------------------------------------------------------------------------
# All the other tests, but also in global scope.
#
# You might think that these are just the same... but it turns out they are not :O
# ------------------------------------------------------------------------------


myobj = MyObj("OK")

setFoo(myobj, SOURCE)
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj("OK")

myobj.setFoo(SOURCE)
SINK(myobj.foo) # $ MISSING: flow



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"



myobj = MyObj(NONSOURCE)
myobj.foo = SOURCE
myobj.foo = NONSOURCE
SINK_F(myobj.foo)



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
SINK(obj2.foo) # $ MISSING: flow="SOURCE, l:-1 -> obj2.foo"



obj3 = MyObj(foo=SOURCE)
SINK(obj3.foo) # $ MISSING: flow="SOURCE, l:-1 -> obj3.foo"


SINK(fields_with_local_flow(SOURCE)) # $ MISSING: flow="SOURCE -> fields_with_local_flow(..)"

# ------------------------------------------------------------------------------
# Nested Object
# ------------------------------------------------------------------------------


x = SOURCE
a = NestedObj()
a.obj.foo = x
SINK(a.obj.foo) # $ flow="SOURCE, l:-3 -> a.obj.foo"



x = SOURCE
a = NestedObj()
a.getObj().foo = x
SINK(a.obj.foo) # $ MISSING: flow
