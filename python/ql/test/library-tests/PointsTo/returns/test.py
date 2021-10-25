


def f(x):
    if x:
        return 1
    else:
        return None
    
def g(x, y):
    if x:
        return f(y)
    else:
        return 0.7
    
def h(a, b, c, d):
    t = f(a)
    v = g(b, c)
    if d:
        return t
    else:
        return v
    
h(1,2,3,4)

def not_none(a, b):
    if a:
        return True
    elif b:
        return False
    #No fall through
    raise Exception()

def gen():
    yield 0
