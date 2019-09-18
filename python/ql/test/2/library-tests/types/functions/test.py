
#Consistent Returns

__all__ = [ '' ]

def ok1(x):
    if x:
        return None
    else:
        return

def ok2(x):
    if x:
        return 4
    else:
        return "Hi"

def cr1(x):
    if x:
        return 4

def cr2(x):
    if x:
        return 4
    else:
        return
    
def ok3(x):
    try:
        return
    finally:
        do_something()

#Modification of parameter with default

def ok4(x = []):
    return len(x)

def mpd(x = []):
    x.append("x")

def mpd2(x = []):
    return x.append("x")

class ExplicitReturnNoneInInit(object):

    def __init__(self):
        return None

class PlainReturnInInit(object):

    def __init__(self):
        return
    
def error():
    raise Exception()

class InitCallsError(object):

    def __init__(self):
        return error()
    
class InitCallsInit(InitCallsError):

    def __init__(self):
        return InitCallsError.__init__(self)

def use_implicit_return_value(arg):
    x = do_nothing()
    return call_non_callable(arg)


y = lambda x : do_nothing()

def do_nothing():
    pass

#Using name other than 'cls' for first parameter in methods.
# This shouldn't apply to classmethods (first parameter should be 'cls' or similar)
# or static methods (first parameter can be anything)

class Normal(object):

    def n_ok(self):
        pass

    @staticmethod
    def n_smethod(ok):
        pass

    @classmethod
    def n_cmethod(self):
        pass

def return_value_ignored():
    ok2()
    ok4()
    sorted([1,2])
    
d = {}
 

class InitCallsInit2(InitCallsError):

    def __init__(self):
        return super(InitCallsInit2, self).__init__()
    
#Harmless, so we allow it.
def use_implicit_return_value_ok(arg):
    return do_nothing()
   
def multi_return(arg):
    if arg:
        return do_something()
    else:
        return do_nothing()
    
def do_something():
    print ("Hello")
    Normal().n_ok()
    return 17

def with_flow():
    x = do_something()
    print("Bye")
    return x

def return_default(x=()):
    return x
