import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__)))) # $ unresolved_call=sys.path.append(..)
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

class MyObj(object):
    def __init__(self, foo):
        self.foo = foo

    def setFoo(self, foo):
        self.foo = foo

def setFoo(obj, x):
    SINK_F(obj.foo)
    obj.foo = x

@expects(2) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_indirect_assign():
    myobj = MyObj("OK")

    setFoo(myobj, SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"


def test_indirect_assign_method():
    myobj = MyObj("OK")

    myobj.setFoo(SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"


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


@expects(2) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
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
    SINK(a.obj.foo) # $ flow="SOURCE, l:-3 -> a.obj.foo"

# ------------------------------------------------------------------------------
# Bound Method calls
# ------------------------------------------------------------------------------

class Foo:
    def __init__(self, x):
        self.x = x

    def update_x(self, x):
        self.x = x

@expects(7) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_bound_method_call():
    # direct assignment
    foo = Foo(None)
    SINK_F(foo.x)
    foo.x = SOURCE
    SINK(foo.x) # $ flow="SOURCE, l:-1 -> foo.x"
    foo.x = None
    SINK_F(foo.x)

    # assignment through function
    foo = Foo(SOURCE)
    SINK(foo.x) # $ flow="SOURCE, l:-1 -> foo.x"
    foo.update_x(None)
    SINK_F(foo.x) # $ flow="SOURCE, l:-3 -> foo.x"

    # assignment through bound-method calls
    foo = Foo(SOURCE)
    ux = foo.update_x
    SINK(foo.x) # $ flow="SOURCE, l:-2 -> foo.x"
    ux(None)
    SINK_F(foo.x) # $ SPURIOUS: flow="SOURCE, l:-4 -> foo.x"


def call_with_source(func):
    func(SOURCE)

def test_bound_method_passed_as_arg():
    foo = Foo(None)
    call_with_source(foo.update_x)
    SINK(foo.x) # $ MISSING: flow="SOURCE, l:-5 -> foo.x"


# ------------------------------------------------------------------------------
# Crosstalk test -- using different function based on conditional
# ------------------------------------------------------------------------------

class CrosstalkTestX:
    def __init__(self):
        self.x = None
        self.y = None

    def setx(self, value):
        self.x = value

    def setvalue(self, value):
        self.x = value

    def do_nothing(self, value):
        pass


class CrosstalkTestY:
    def __init__(self):
        self.x = None
        self.y = None

    def sety(self ,value):
        self.y = value

    def setvalue(self, value):
        self.y = value


@expects(8) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_no_crosstalk_reference(cond=True):
    objx = CrosstalkTestX()
    SINK_F(objx.x)
    SINK_F(objx.y)

    objy = CrosstalkTestY()
    SINK_F(objy.x)
    SINK_F(objy.y)

    if cond:
        objx.setvalue(SOURCE)
    else:
        objy.setvalue(SOURCE)

    SINK(objx.x) # $ flow="SOURCE, l:-4 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK_F(objy.y) # $ flow="SOURCE, l:-5 -> objy.y"


@expects(8) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_potential_crosstalk_different_name(cond=True):
    objx = CrosstalkTestX()
    SINK_F(objx.x)
    SINK_F(objx.y)

    objy = CrosstalkTestY()
    SINK_F(objy.x)
    SINK_F(objy.y)

    if cond:
        func = objx.setx
    else:
        func = objy.sety

    func(SOURCE)

    SINK(objx.x) # $ flow="SOURCE, l:-2 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK_F(objy.y) # $ flow="SOURCE, l:-5 -> objy.y"


@expects(8) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_potential_crosstalk_same_name(cond=True):
    objx = CrosstalkTestX()
    SINK_F(objx.x)
    SINK_F(objx.y)

    objy = CrosstalkTestY()
    SINK_F(objy.x)
    SINK_F(objy.y)

    if cond:
        func = objx.setvalue
    else:
        func = objy.setvalue

    func(SOURCE)

    SINK(objx.x) # $ flow="SOURCE, l:-2 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK_F(objy.y) # $ flow="SOURCE, l:-5 -> objy.y"


@expects(10) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_potential_crosstalk_same_name_object_reference(cond=True):
    objx = CrosstalkTestX()
    SINK_F(objx.x)
    SINK_F(objx.y)

    objy = CrosstalkTestY()
    SINK_F(objy.x)
    SINK_F(objy.y)

    if cond:
        obj = objx
    else:
        obj = objy

    obj.setvalue(SOURCE)

    SINK(objx.x) # $ MISSING: flow="SOURCE, l:-2 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK_F(objy.y) # $ MISSING: flow="SOURCE, l:-5 -> objy.y"

    SINK(obj.x) # $ flow="SOURCE, l:-7 -> obj.x"
    SINK_F(obj.y) # $ flow="SOURCE, l:-8 -> obj.y"


@expects(4) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_potential_crosstalk_same_class(cond=True):
    objx1 = CrosstalkTestX()
    SINK_F(objx1.x)

    objx2 = CrosstalkTestX()
    SINK_F(objx2.x)

    if cond:
        func = objx1.setvalue
    else:
        func = objx2.do_nothing

    # We want to ensure that objx2.x does not end up getting tainted, since that would
    # be cross-talk between the self arguments are their functions.
    func(SOURCE)

    SINK(objx1.x) # $ flow="SOURCE, l:-2 -> objx1.x"
    SINK_F(objx2.x)


# ------------------------------------------------------------------------------
# Global scope
# ------------------------------------------------------------------------------

# since these are defined on global scope, and we still want to run them with
# `validTest.py`, we have them defined in a different file, and have hardcoded this
# number that reflects how many OK we expect to see ...  Not an ideal solution, but at
# least we know that the tests are actually valid.
#
# Notice that since the tests are run in a random order, we cannot split the global
# scope tests into multiple functions, since we wouldn't know which one did the initial
# import that does all the printing :|

@expects(18 + 2) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_global_scope():
    import fieldflow.test_global

    fieldflow.test_global.func_defined_before() # $ unresolved_call=fieldflow.test_global.func_defined_before()
    fieldflow.test_global.func_defined_after() # $ unresolved_call=fieldflow.test_global.func_defined_after()

# ------------------------------------------------------------------------------
# Global flow cases that doesn't work in this file, but works in test_global.py
# ------------------------------------------------------------------------------

# --------------------------------------
# method calls _before_ those ifs
# --------------------------------------

# def test_indirect_assign_method():
myobj2 = MyObj("OK")
myobj2.setFoo(SOURCE)
SINK(myobj2.foo) # $ flow="SOURCE, l:-1 -> myobj2.foo"

# def test_nested_obj_method():
x2 = SOURCE
a2 = NestedObj()
a2.getObj().foo = x2
SINK(a2.obj.foo) # $ flow="SOURCE, l:-3 -> a2.obj.foo"


# --------------------------------------
# using constructor
# --------------------------------------

# def test_constructor_assign():
obj2 = MyObj(SOURCE)
SINK(obj2.foo) # $ flow="SOURCE, l:-1 -> obj2.foo"

# apparently these if statements below makes a difference :O
# but one is not enough
cond = os.urandom(1)[0] > 128 # $ unresolved_call=os.urandom(..)

if cond:
    pass

# def test_constructor_assign():
obj2 = MyObj(SOURCE)
SINK(obj2.foo) # $ flow="SOURCE, l:-1 -> obj2.foo"

if cond:
    pass

# def test_constructor_assign():
obj2 = MyObj(SOURCE)
SINK(obj2.foo) # $ flow="SOURCE, l:-1 -> obj2.foo"

# def test_constructor_assign_kw():
obj3 = MyObj(foo=SOURCE)
SINK(obj3.foo) # $ flow="SOURCE, l:-1 -> obj3.foo"

# def test_fields():
SINK(fields_with_local_flow(SOURCE)) # $ flow="SOURCE -> fields_with_local_flow(..)"

# --------------------------------------
# method calls _after_ those ifs
# --------------------------------------

# def test_indirect_assign_method():
myobj2 = MyObj("OK")
myobj2.setFoo(SOURCE)
SINK(myobj2.foo) # $ flow="SOURCE, l:-1 -> myobj2.foo"

# def test_nested_obj_method():
x2 = SOURCE
a2 = NestedObj()
a2.getObj().foo = x2
SINK(a2.obj.foo) # $ flow="SOURCE, l:-3 -> a2.obj.foo"
