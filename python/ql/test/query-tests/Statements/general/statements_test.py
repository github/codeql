
#Constant in conditional

def cc1():
    if True:
        print("Hi")

def cc2():
    if 3:
        print("Hi")

def not_cc():
    #Don't treat __debug__ as a constant. It may be immutable, but it is not constant from run to run.
    if __debug__:
        print("Hi")

#Mismatch in multiple assignment
def mima():
    x, y, z = 1, 2
    return x, y, z

#Statement has no effect (4 statements, 3 of which are violations)
"Not a docstring" # This is acceptable as strings can be used as comments.
len
sys.argv + []
3 == 4

#The 'sys' statements have an effect
try:
    sys
except:
    do_something()

def exec_used(val):
    exec (val)

#This has an effect:
def effectful(y):
    [x for x in y]





#Redundant assignment

ok = 1
# some people use self-assignment to shut Pyflakes up
ok = ok # Pyflakes

class Redundant(object):

    x = x # OK
    x = x # violation

    def __init__(self, args):
        args = args # violation

if sys.version_info < (3,):
    bytes = str
else:
    bytes = bytes # Should not be flagged

#Pointless else clauses
for x in range(10):
    func(x)
else:
    do_something()

while x < 10:
    func(x)
else:
    do_something()

#OK else clauses:
for x in range(10):
    if func(x):
        break
else:
    do_something()

while x < 10:
    if func(x):
        break
else:
    do_something()











#Not a redundant assignment if a property.
class WithProp(object):

    @property
    def x(self):
        return self._x

    @prop.setter
    def set_x(self, x):
        side_effect(x)
        self._x = x

    def meth(self):
        self.x = self.x

def maybe_property(x):
    x.y = x.y

class WithoutProp(object):

    def meth(self):
        self.x = self.x

#Accessing a property has an effect:
def prop_acc():
    p = WithProp()
    p.x

#Fake Enum class

class EnumMeta(type):
    def __iter__(self):
        return unknown()

import six

@six.add_metaclass(EnumMeta)
class Enum:
    pass

#ODASA-3777
class EnumDerived(Enum):
    a = 0
    b = 1

for e in EnumDerived:
    print(e)

class SideEffectingAttr(object):

    def __init__(self):
        self.foo = 'foo'

    def __setattr__(self, name, val):
        print("hello!")
        super().__setattr__(name, val)

s = SideEffectingAttr()
s.foo = s.foo

#Unreachable, so don't flag as constant test.
if False:
    a = 1







def error_mismatched_multi_assign_list():
    a,b,c = [1,2,3,4,5]

def returning_different_tuple_sizes(x):
    if x:
        return 1,2,3,4,5
    else:
        return 1,2,3,4,5,6

def error_indirect_mismatched_multi_assign(x):
    a, b, c = returning_different_tuple_sizes(x)
    return a, b, c




#ODASA-6754
def error_unnecessary_delete():
    x = big_object()
    del x

def ok_delete_in_loop():
    y = 0
    for i in range(10):
        x = big_object(i)
        y += calculation(x)
        del x

def ok_delete_yield():
    x = big_object()
    y = calculation(x)
    del x
    yield y

def ok_delete_exc_info_cycle_breaker():
    import sys
    t, v, tb = sys.exc_info()
    y = calculation(t,v,tb)
    del t, v, tb
