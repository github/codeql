
#Edge guards, aka pi-nodes.

def f(y):
    x = unknown() if cond else None

    if x is None:
        x

    x = 0 if cond else 1

    if x:
        x

    x = 0 if cond else 1

    if x == 0:
        x


    x = ((1,2) if cond else (1,2,3)) if unknown() else [1,2]

    if len(x):
        pass

    if len(x) == 2:
        pass

    if isinstance(x, tuple):
        pass

    y.a = unknown() if cond else None

    if y.a is None:
        pass

    y.a = 0 if cond else 1

    if y.a:
        pass

    y.a = 0 if cond else 1

    if y.a == 0:
        pass


    y.a = ((1,2) if cond else (1,2,3)) if unknown() else [1,2]

    if isinstance(y.a, tuple):
        pass

    if len(y.a) == 2:
        pass

def others(x):

    x = bool if cond else type

    if issubclass(x, int):
        x

    x = 0 if cond else float

    if hasattr(x, "bit_length"):
        pass

    if callable(x):
        pass

def compound(x=1, y=0):

    if x or y:
        x + y

    if x and y:
        x + y

def h():
    b = unknown() if cond else True
    if b:
        b
    b = unknown() if cond else True
    if not b:
        b

    if unknown() == 3:
        pass

    x = unknown() if cond else None
    if x:
        x

    x = unknown() if cond else None
    if not x:
        pass

def complex_test(x): # Was failing consistency check.
    if not (foo(x) and bar(x)):
        use(x)
    pass
