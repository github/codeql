
def j():
    return tuple, dict
dict
dict = 7
dict
tuple = tuple
tuple




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
    g2 = 102

init()
g2 # Cannot be None

#Global set in init method
g3 = None

class Ugly(object):

    def __init__(self):
        global g3
        g3 = 103

    def meth(self):
        return g3 # Cannot be None

#Redefine
x = 0
x = 1
x
if cond:
    x = 3

if other_cond:
    y = 1
else:
    y = 2
    if cond3:
        pass
    else:
        pass
y
v3

class X(object):
    y = y
    v4 = v3
    X # Undefined
    g3

type

def k(arg):
    type

g4 = None

def get_g4():
    if not g4:
        set_g4()
    return g4 # Cannot be None

def set_g4():
    set_g4_indirect()

def set_g4_indirect():
    global g4
    g4 = False

class modinit(object): #ODASA-5486

    global z
    z = 0

del modinit

#ODASA-4688
def outer():
    def inner():
        global glob
        glob = 100
        return glob

    def otherInner():
        return glob

    inner()


def redefine():
    global z, glob
    z
    z = 1
    z
    glob
    glob = 50
    glob



class D(object):

    def __init__(self):
        pass

    def foo(self):
        return dict

def use_list_attribute():
    l = []
    list.append(l, 0)
    return l

