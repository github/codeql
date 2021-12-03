

def f():
    while 0:
        pass
    return 1

def g():
    while 1:
        pass
    return unreachable

def h(x):
    if x:
        return x
    else:
        return None




def k(a, b):
    for x in a or b:
        pass
    return 0

def l(a, b, c):
    if a or b or c:
        return a or b or c   
    else:
        return None

def m(a, b, c):
    if a and b and c:
        return a and b and c   
    else:
        return None