
#Edge guards, aka pi-nodes.

def f(y):
    x = unknown() if cond else None

    if x is None:
        x = 7
    use(x)

    x = unknown() if cond else None

    if x is not None:
        x = 7
    use(x)

    x = unknown() if cond else None

    if not x:
        x = None
    use(x)

    x = unknown() if cond else None

    x = x if x else 1
    use(x)
    if unknown():
        x = 1
    use(x)

    x = unknown() if cond else 1
    if not x: #Negation
        x = 7
    use(x)

    assert isinstance(x, int)
    use(x)

v2 = thing()

v2.x = 1
if v2.y is not None:
    use(v2.x)
    use(v2.y)

#A home for pi and phi-nodes
pass


def g(x):
    if x:
        x

#Dead pi- and phi-nodes
def loop(seq):
    for v in seq:
        if v:
            use(v)

#This was causing the consistency check to fail, 
def double_attr_check(x, y):
    if x.b == 3:
        return
    if y:
        if (x.a == 0 and 
            x.a in seq):
            return

def h():
    b = unknown() if cond else True
    if not b:
        b = 7
    return b

def k():
    t = type
    if t is not object:
        t = object
    use(t)

def odasa6261(foo=True):
    if callable(foo):
        def bar():
            return foo()

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

def not_or_not(*a):
    if not isinstance(a, (tuple, list)):
        raise TypeError()
    if (not a or 
        not a[0]):
        raise Exception()
    "Hello"

def method_check(x):
    if x.m():
        use(x)
    else:
        use(x)


