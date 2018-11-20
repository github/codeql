import functools

def annotate(value):
    def inner(func):
        func.annotation = value
        return func
    return inner

def wraps1(func):
    def wrapper(*args):
        res = func(*args)
        return res
    return wrapper

def wraps2(func):
    @functools.wraps(func)
    def wrapper(*args):
        res = func(*args)
        return res
    return wrapper

@annotate(100)
def func1():
    pass

@wraps1
def func2():
    pass

@wraps2
def func3():
    pass








func1
func2
func3