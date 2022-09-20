import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__)))) # $ unresolved_call=sys.path.append(..)
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x, *, not_present_at_runtime=False):
    # not_present_at_runtime supports use-cases where we want flow from data-flow layer
    # (so we want to use SINK), but we end up in a siaution where it's not possible to
    # actually get flow from a source at runtime. The only use-case is for the
    # cross-talk tests, where our ability to use if-then-else is limited because doing
    # so would make cfg-splitting kick in, and that would solve the problem trivially
    # (by the splitting).
    if not_present_at_runtime:
        print("OK")
        return

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
    obj.foo = x


@expects(3) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_indirect_assign():
    myobj = MyObj(NONSOURCE)
    SINK_F(myobj.foo)

    setFoo(myobj, SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"

    setFoo(myobj, NONSOURCE)
    SINK_F(myobj.foo) # $ SPURIOUS: flow="SOURCE, l:-4 -> myobj.foo"


@expects(3) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_indirect_assign_method():
    myobj = MyObj(NONSOURCE)
    SINK_F(myobj.foo)

    myobj.setFoo(SOURCE)
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"

    myobj.setFoo(NONSOURCE)
    SINK_F(myobj.foo) # $ SPURIOUS: flow="SOURCE, l:-4 -> myobj.foo"


@expects(3) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_indirect_assign_bound_method():
    myobj = MyObj(NONSOURCE)
    SINK_F(myobj.foo)

    sf = myobj.setFoo

    sf(SOURCE)
    SINK(myobj.foo) # $ MISSING: flow="SOURCE, l:-1 -> myobj.foo"

    sf(NONSOURCE)
    SINK_F(myobj.foo)


@expects(3) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_direct_assign():
    myobj = MyObj(NONSOURCE)
    SINK_F(myobj.foo)

    myobj.foo = SOURCE
    SINK(myobj.foo) # $ flow="SOURCE, l:-1 -> myobj.foo"

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
# Field access on compound arguments
# ------------------------------------------------------------------------------

# TODO: Add support for this, see https://github.com/github/codeql/pull/10444

@expects(5) # $ unresolved_call=expects(..) unresolved_call=expects(..)(..)
def test_field_on_compound_arg(cond_true=True, cond_false=False):
    class Ex:
        def __init__(self):
            self.attr = None

    def set_attr(obj):
        obj.attr = SOURCE

    x = Ex()
    y = Ex()
    set_attr(x if cond_true else y)
    SINK(x.attr) # $ MISSING: flow

    x = Ex()
    y = Ex()
    set_attr(x if cond_false else y)
    SINK(y.attr) # $ MISSING: flow

    x = Ex()
    y = Ex()
    z = Ex()
    set_attr(x if cond_false else (y if cond_true else z))
    SINK_F(x.attr) # $ MISSING: flow
    SINK(y.attr) # $ MISSING: flow
    SINK_F(z.attr) # $ MISSING: flow

# ------------------------------------------------------------------------------
# Crosstalk test -- using different function based on conditional
# ------------------------------------------------------------------------------
# NOTE: These tests use `SINK(objy.y, not_present_at_runtime=True)` since it's not
# possible to use if-then-else statements, since that would make cfg-splitting kick in,
# and that would solve the problem trivially (by the splitting).

class CrosstalkTestX:
    def __init__(self):
        self.x = None
        self.y = None

    def setx(self, value):
        self.x = value

    def setvalue(self, value):
        self.x = value


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
    SINK(objy.y, not_present_at_runtime=True) # $ flow="SOURCE, l:-5 -> objy.y"


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

    SINK(objx.x) # $ MISSING: flow="SOURCE, l:-2 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK(objy.y, not_present_at_runtime=True) # $ MISSING: flow="SOURCE, l:-5 -> objy.y"


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

    SINK(objx.x) # $ MISSING: flow="SOURCE, l:-2 -> objx.x"
    SINK_F(objx.y)
    SINK_F(objy.x)
    SINK(objy.y, not_present_at_runtime=True) # $ MISSING: flow="SOURCE, l:-5 -> objy.y"


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
    SINK(objy.y, not_present_at_runtime=True) # $ MISSING: flow="SOURCE, l:-5 -> objy.y"

    SINK(obj.x) # $ flow="SOURCE, l:-7 -> obj.x"
    SINK(obj.y, not_present_at_runtime=True) # $ flow="SOURCE, l:-8 -> obj.y"


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
cond = os.urandom(1)[0] > 128

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
