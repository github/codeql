from __future__ import unicode_literals
import sys
class C(object):

    x = 'C_x'

    def __init__(self):
        self.y = 'c_y'

class D(C):
    pass

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

class X(object):
    @classmethod
    def method1(cls):
        pass

    @deco
    def method2(self):
        pass

v4 = g(f())

def deco(f):
    return f

class Y(object):

    @deco
    def method2(self):
        pass

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

from abc import abstractmethod
abstractmethod

from module import unknown
unknown

#Value of variables in inner functions
def outer():
    y = 1
    def inner(x):
        return x + y + z + unknown + list
    z = 2;
    return inner

def outer_use_vars(x):
    y = 1
    def inner():
        return x + y + z + unknown + list
    z = 2; 
    y + z
    return inner

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




z

def multiple_assignment():
    _tuple, _list = tuple, list
    _tuple
    _list

def vararg_kwarg(*t, **d):
    t
    d


class E(object):

    def _internal(arg):
        # arg is not a C
        def wrapper(args):
            return arg(args)
        return wrapper

    @_internal
    def method(self, *args):
        pass

x = 1
x


#Global in class scope
class F(object):
    
    x = x
    x
