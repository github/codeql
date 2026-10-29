#Edge guards.

def f():
    x = None

    if x is None:
        x = 7
    use(x)

    x = unknown() if cond else None

    if x is not None:
        x = 7
    use(x)

    x = None

    if x is None:
        x = None
    use(x)

    x = None

    if not x:
        x = 7
    use(x)

    x = unknown() if cond else None

    if x:
        x = 7
    use(x)

    x = None

    if not x:
        x = None
    use(x)

    i = 0
    if i == 0:
        i = 1.0
    use(i)

    i = 0
    if i != 0:
        i = 1.0
    use(i)

    i = 0
    if i == 0:
        i = 0
    use(i)

    i = 0
    if not i:
        i = 1.0
    use(i)

    i = unknown() if cond else 0
    if i:
        i = 1.0
    use(i)

    i = 0
    if not i:
        i = 0
    use(i)


    i = 7
    if i == 7:
        i = 1.0
    use(i)

    i = 7
    if i != 7:
        i = 1.0
    use(i)

    i = 7
    if i == 7:
        i = 7
    use(i)

    b = True

    if b:
        b = 7
    use(b)

    b = unknown() if cond else True

    if not b:
        b = 7
    use(b)


    b = unknown() if cond else False

    if b:
        b = 7
    use(b)

    b = False

    if not b:
        b = 7
    use(b)

    t = type
    if t is object:
        t = float
    use(t)

    t = type
    if t is not object:
        t = object
    use(t)

    u = unknown_thing()

    if u is None:
        u = 7
    use(u)

    u = unknown_thing()

    if u is not None:
        u = 7
    use(u)

    u = unknown_thing()

    if u:
        u = 7
    use(u)

    u = unknown_thing()

    if not u:
        u = 7
    use(u)

    K = unknown_thing()

    u = unknown_thing()

    if u is K:
        u = 7
    use(u)

    u = unknown_thing()

    if u is not K:
        u = 7
    use(u)

#String and float consts.

    s = "not this"
    if s == "not this":
        s = 1.0
    use(s)

    f = 0.7
    if f == 0.7:
        f = 0
    use(f)

#Sentinel guards
SENTINEL = object()
def g(x = SENTINEL):
    if x is SENTINEL:
        x = 0
    use(x)

def h(x = SENTINEL):
    if x == SENTINEL:
        x = 0
    use(x)

def j(x = SENTINEL):
    if x is not SENTINEL:
        x = 0
    use(x)

#ODASA-4056
def format_string(s, formatter='minimal'):
    """Format the given string using the given formatter."""
    if not callable(formatter):
        formatter = get_formatter_for_name(formatter)
    use(formatter)

def guard_callable(s, f=j):
    """Format the given string using the given formatter."""
    if callable(f):
        f=0
    use(f)

class C1(object):pass
class C2(C1):pass

def guard_subclass(s = C2):
    if issubclass(s, C1):
        s = type
    use(s)

def guard_subclass2(s = C2):
    if not issubclass(s, C1):
        use(s)
        s = type
    else:
        use(s)
    use(s)

def instance_guard(s, f=1.0):
    if isinstance(s, float):
        s = 0
    use(s)


#ODASA-4056
def format_string(s, formatter='minimal'):
    """Format the given string using the given formatter."""
    if not callable(formatter):
        formatter = get_formatter_for_name(formatter)
    use(formatter)

func_type = type(j)
def guard_callable(s, f=j):
    if isinstance(f, func_type):
        f=0
    use(f)


#Attribute points-to
class C(object):

    def __init__(self):
        self._init()
        self.x = 1

    def _init(self):
        self.y = 2
        self._init2()

    def _init2(self):
        self.z = 3

    def method(self):
        use(self.x)
        if isinstance(self.y, int):
            use(self.y)
        if not isinstance(self.z, int):
            use(self.z)

#Guarded None in nested function
def f(x=None):
    def inner(arg):
        if x:
            use(x)



#Guards on whole scope...
class D(object):

    def __init__(self, x = None):
        if x is None:
            x = 1
        use(x)
        self.x = x

    def f(self):
        use(self.x)

#Biased splitting & pruning
def f(cond):
    if cond:
        y = None
        x = False
    else:
        y = something()
        x = some_condition()
    use(y) # y can be None here
    if x:
        use(y) # Should not infer that y is None here

#Splittings with boolean expressions:
def split_bool1(x=None,y=None):
    if x and y:
        raise
    if not (x or y):
        raise
    if x:
        use(y)
    else:
        use(y)
    if y:
        use(x)
    else:
        use(x)

def split_bool2(x,y=None,z=7):
    if x and not y or x and use(y):
        pass
    if x and not z or x and use(z):
        pass

def split_bool3(a=None, b=None):
    if a or b:
        if a:
            use(b)
        else:
            use(b) # Should not infer b to be None.

#Guard on instance attribute
class E(object):

    def __init__(self):
        self.y = None if rand() else 4

    x = None if rand() else 3

    def a(self):
        e = E()
        #Do not mutate
        if e.x:
            use(e.x)
        if e.y:
            use(e.y)

    def b(self):
        possibly_mutate(self)
        if self.x:
            use(self.x)
        if self.y:
            use(self.y)

def k():
    e = E()
    possibly_mutate(e)
    if e.x:
        use(e.x)
    if e.y:
        use(e.y)


#Global assignment in local scope
g1 = None

def assign_global():
    global g1
    if not g1:
        g1 = 7.0
    use(g1) # Cannot be None

#Assignment in local scope, but called from module level

g2 = None

def init():
    global g2
    if not g2:
        g2 = 2.0

init()
use(g2) # Cannot be None

#Global set in init method
g3 = None

class Ugly(object):

    def __init__(self):
        global g3
        if not g3:
            g3 = True

    def meth(self):
        use(g3)  # Cannot be None

g4 = None

def get_g4():
    if not g4:
        set_g4()
    use(g4) # Cannot be None

def set_g4():
    set_g4_indirect()

def set_g4_indirect():
    global g4
    g4 = 7

#Assertions
def f(cond):
    x = None if cond else thing()
    assert x
    use(x)

def f(cond, x = 1):
    if cond:
        x = 1.0
    assert isinstance(x, int)
    use(x)

#ODASA-5018
def f(x,y=None, z=0):
    if (x and y) or (y and not z):
        #y cannot be None here.
        use(y)

class C(object):

    def __init__(self, x=None):
        self.x = x
        use(self.x)

    def meth(self):
        if self.x is not None:
            use(self.x)
            return lambda : use(self.x)
        else:
            use(self.x)
            return lambda : use(self.x)


def test_on_unknown_attr():
    e = E()
    y = 1
    if e.attr:
        use(y)
