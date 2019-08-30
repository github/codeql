
def f1(arg):
    return arg

def f2(arg):
    return f1(arg)

def f3(arg):
    return f2(arg)

def f4(arg):
    return f3(arg)

def f5(arg):
    return f4(arg)

def f6(arg):
    return f5(arg)

x = f6(SOURCE)

SINK(x)

