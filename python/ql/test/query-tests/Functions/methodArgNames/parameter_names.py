# Using name other than 'self' for first parameter in methods.
# This shouldn't apply to classmethods (first parameter should be 'cls' or similar)
# or static methods (first parameter can be anything)


class Normal(object):

    def n_ok(self):
        pass

    @staticmethod
    def n_smethod(ok):
        pass

    # not ok
    @classmethod
    def n_cmethod(self): # $shouldBeCls
        pass

    # not ok
    @classmethod
    def n_cmethod2(): # $shouldBeCls
        pass

    @classmethod
    @id
    def n_dec(any_name): # $shouldBeCls
        pass


# Metaclass - normal methods should be named cls, though self is also accepted
class Class(type):

    def __init__(cls):
        pass

    def c_method(y):  # $shouldBeCls
        pass

    def c_ok(cls):
        pass

    # technically we could alert on mixing self for metaclasses with cls for metaclasses in the same codebase, 
    # but it's probably not too significant.
    def c_self_ok(self):
        pass


class NonSelf(object):

    def __init__(x): # $shouldBeSelf
        pass

    def s_method(y): # $shouldBeSelf
        pass

    def s_method2(): # $shouldBeSelf
        pass

    def s_ok(self):
        pass

    @staticmethod
    def s_smethod(ok):
        pass

    @classmethod
    def s_cmethod(cls):
        pass

    # we allow methods that are used in class initialization, but only detect this case when they are called. 
    def s_smethod2(ok): # $ SPURIOUS: shouldBeSelf
        pass
    s_smethod2 = staticmethod(s_smethod2)

    def s_cmethod2(cls): # $ SPURIOUS: shouldBeSelf
        pass
    s_cmethod2 = classmethod(s_cmethod2)

#Possible FPs for non-self. ODASA-2439

class Acceptable1(object):
    def _func(f):
        return f
    _func(x)

class Acceptable2(object):
    def _func(f):
        return f

    @_func
    def meth(self):
        pass

# Handling methods defined in a different scope than the class it belongs to,
# gets problmematic since we need to show the full-path from method definition
# to actually adding it to the class. We tried to enable warnings for these in
# September 2019, but ended up sticking to the decision from ODASA-2439 (where
# results are both obvious and useful to the end-user).
def dont_care(arg):
    pass

class Acceptable3(object):

    meth = dont_care

# OK
class Meta(type):

    #__new__ is an implicit class method, so the first arg is the metaclass
    def __new__(metacls, name, bases, cls_dict):
        return super(Meta, metacls).__new__(metacls, name, bases, cls_dict)

#ODASA-6062
import zope.interface
class Z(zope.interface.Interface):

    def meth(arg):
        pass

Z().meth(0)

def weird_decorator(f):
    def g(self):
        return f()
    return g 

class B:
    @weird_decorator
    def f(): # allow no-arg functions with a decorator
        pass

# The `__init_subclass__` (introduced in Python 3.6)
# and `__class_getitem__` (introduced in Python 3.7) methods are methods
# which do not follow the normal conventions, and are in fact class methods
# despite not being marked as such with other means. The name alone is what
# makes it such. As a consequence, the query `py/not-named-self` and other
# relevant queries need to account for this.
#
# This has come up in the wild as a false positive. For example,
# `__init_subclass__`:
#   https://docs.python.org/3/reference/datamodel.html#customizing-class-creation
# `__class_getitem__`:
#   https://docs.python.org/3/reference/datamodel.html#emulating-generic-types

class SpecialMethodNames(object):
    def __init_subclass__(cls):
        pass

    def __class_getitem__(cls):
        pass

from dataclasses import dataclass, field

@dataclass 
class A:
    # Lambdas used in initilisation aren't methods.
    x: int = field(default_factory = lambda: 2)