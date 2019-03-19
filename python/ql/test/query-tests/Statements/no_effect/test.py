

















import sys


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

#Accessing a property has an effect:
def prop_acc():
    p = WithProp()
    p.x


def mydecorator(func):
    return property(fget=func)

class X(object):

    @mydecorator
    def deco(self):
        pass

    def func(self):
        pass

x = X()
x.deco
x.deco + 2

#No effect
x.func

#Cannot infer what attribute is, so be conservative
x.thing
other_thing.func

#Name Error

try:
    unicode
except NameError:
    #Python 3
    unicode = str

try:
    ascii
except NameError:
    #Python 2
    def ascii(obj):
        pass


#Overridden operator. yuck.
class Horrible(object):

    def __add__(self, other):
        fire_missiles_at(other)

    def __lt__(self, other):
        fire_guns_at(other)


def possible_fps(x):
    h = Horrible()
    h + "innocent bystander"
    h < "upstanding citizen"
    x - 3 #True positive


# Forgotten raise.

def do_action_forgotten_raise(action):
    if action == "go":
        start()
    elif action == "stop":
        stop()
    else:
        ValueError(action)

def do_action(action):
    if action == "go":
        start()
    elif action == "stop":
        stop()
    else:
        raise ValueError(action)

#Python 2 print
print >> out, message

