from __future__ import unicode_literals
import sys
class C(object):

    x = 'C_x'

    def __init__(self):
        self.y = 'c_y'

class D(object):

    x = 'D_x'

    def __init__(self):
        self.y = 'd_y'
#Comment here
if len(sys.argv) > 2:
    v1 = C
else:
    v1 = D
v2 = v1()

def f():
    if len(sys.argv) >  3:
       v3 = C()
    else:
       v3 = D()
    return v3

def g(arg):
    return arg

v4 = g(f())

class X(object):
    @classmethod
    def method1(cls):
        pass

    @deco
    def method2(self):
        pass

def deco(f):
    return f

v1
v2
v3
v4
list

def h(args):
    if len(sys.argv) >  4:
       v5 = C()
    else:
       v5 = D()
    return v5, list(args)

def j():
    return tuple, dict
dict
dict = 7
dict
tuple = tuple
tuple


X.method1
X.method2

from abc import abstractmethod
abstractmethod

type(C())
type(sys)
from module import unknown
type(unknown)
type(name, (object,), {})

def k(arg):
    type(C())
    type(sys)
    type(arg)
    type(name, (object,), {})

#Value of variables in inner functions
def outer(x):
    y = 1
    def inner():
        return y + z
    z = 2;
    return inner

def never_none(x):
    if test(x):
        y = 1.0
    else:
        y = None
    if y is None:
        y = 0.0
    return y

def outer_use_vars(x):
    y = 1
    def inner():
        return y + z
    z = 2; 
    y + z
    return inner

def literals_in_func():
    True
    None
    1346
    0.7
    class X(object): pass
    def f(): pass
    (a, b)
    [a, b]

y = lambda x : following()

def following():
    pass

def params_and_defaults(a, b={}, c = 1):
    a
    b
    c

def inner_cls():
    class A(BaseException):
        pass
    a = A()
    raise a

from xyz import *
import xyz
xyz.x
z

#ODASA-3263
#Django does this
class Base(object):

    def __init__(self, choice):
        if choice == 1:
            self.__class__ = Derived1
        elif choice == 2:
            self.__class__ = Derived2
        else:
            self.__class__ = Derived3

class Derived1(Base):
    pass

class Derived2(Base):
    pass

class Derived3(Base):
    pass

thing = Base(unknown())


def multiple_assignment():
    _tuple, _list = tuple, list
    _tuple
    _list


class Base2(object):

    def __init__(self):
        pass

    x = 1

class Derived4(Base2):

    def __init__(self):
        super(Derived4, self).x
        return super(Derived4, self).__init__()


def vararg_kwarg(*t, **d):
    t
    d


#ODASA-4055
class E(object):

    def _internal(arg):
        # arg is not a C
        def wrapper(args):
            return arg(args)
        return wrapper

    @_internal
    def method(self, *args):
        pass

#Builtin function calls
def calls_next(seq):
    it = iter(seq)
    n = next(it)
    return n


#Check imports from builtin modules
from sys import exit


#Global assignment in local scope
g1 = None

def assign_global():
    global g1
    g1 = 101
    return g1 # Cannot be None

#Assignment in local scope, but called from module level

g2 = None

def init():
    global g2
    g2 = 102 # Cannot be None

init()
g2  # Cannot be None

#Global set in init method 
g3 = None

class Ugly(object):

    def __init__(self):
        global g3
        g3 = 103

    def meth(self):
        return g3 # Cannot be None

#Global in class scope
class F(object):

    g3 = g3
    g3

#Locally redefined attribute
class G(object):

    attr = 0

    def __init__(self):
        self.attr = 1

    def meth(self):
        self.attr = 2
        self.attr = 3
        self.attr

# Self can only be of a class that is instantiated.
Derived4()


class DiGraph(object):

    def __init__(self):
        self.pred = {}

    def add_node(self, n):
        self.pred[n] = 0

