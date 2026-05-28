"""Class definitions — evaluation order."""

from timer import test


@test
def test_simple_class(t):
    """Simple class definition and instantiation."""
    class Foo:
        pass
    obj = (Foo @ t[0])() @ t[1]


@test
def test_class_with_bases(t):
    """Base class expressions evaluated at class definition time."""
    class Base:
        pass
    class Derived(Base @ t[0]):
        pass
    obj = (Derived @ t[1])() @ t[2]


@test
def test_class_with_methods(t):
    """Object evaluated before method is called."""
    class Foo:
        def greet(self, name):
            return ("hello " @ t[5] + name @ t[6]) @ t[7]
    obj = (Foo @ t[0])() @ t[1]
    msg = ((obj @ t[2]).greet @ t[3])("world" @ t[4]) @ t[8]


@test
def test_class_instantiation(t):
    """Arguments to __init__ evaluate before instantiation completes."""
    class Foo:
        def __init__(self, x):
            (self @ t[3]).x = x @ t[2]
    obj = (Foo @ t[0])(42 @ t[1]) @ t[4]
    val = (obj @ t[5]).x @ t[6]


@test
def test_method_call(t):
    """Method arguments evaluate left-to-right before the call."""
    class Calculator:
        def __init__(self, value):
            (self @ t[3]).value = value @ t[2]
        def add(self, x):
            return ((self @ t[8]).value @ t[9] + x @ t[10]) @ t[11]
    calc = (Calculator @ t[0])(10 @ t[1]) @ t[4]
    result = ((calc @ t[5]).add @ t[6])(5 @ t[7]) @ t[12]


@test
def test_class_level_attribute(t):
    """Multiple attribute accesses in a single expression."""
    class Config:
        debug = True @ t[0]
        version = 1 @ t[1]
    x = ((Config @ t[2]).debug @ t[3], (Config @ t[4]).version @ t[5]) @ t[6]


@test
def test_class_decorator(t):
    """Decorator expression evaluated, class defined, then decorator called."""
    def add_marker(cls):
        (cls @ t[2]).marked = True @ t[1]
        return cls @ t[3]
    @(add_marker @ t[0])
    class Foo:
        pass
    result = (Foo @ t[4]).marked @ t[5]
