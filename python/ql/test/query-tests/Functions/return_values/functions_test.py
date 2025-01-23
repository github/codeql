
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



def ok4(x):
    return len(x)






































def use_implicit_return_value(arg):
    x = do_nothing()
    return call_non_callable(arg)

#The return in the lambda is OK as it is auto-generated
y = lambda x : do_nothing()

def do_nothing():
    pass









































































def return_value_ignored():
    ok2()
    ok4()
    sorted([1,2])

d = {}

def use_return_values():
    x = ok2()
    x = ok2()
    x = ok3()
    x = ok3()
    x = ok4()
    x = ok4()
    x = y()
    x = y()
    x = returns_self()
    x = returns_self()
    x = sorted(x)
    x = sorted(x)
    x = ok2()
    x = ok2()
    x = ok3()
    x = ok3()
    x = ok4()
    x = ok4()
    x = y()
    x = y()
    x = returns_self()
    x = returns_self()
    x = sorted(x)
    x = sorted(x)

def ok_to_ignore():
    ok1
    do_nothing()
    returns_self()
    ok3()
    y()














@decorator
def nested_call_implicit_return_func_ok(arg):
    do_nothing()






#OK as it returns result of a call to super().__init__()
class InitCallsInit(InitCallsError):

    def __init__(self):
        return super(InitCallsInit, self).__init__()

#Harmless, so we allow it.
def use_implicit_return_value_ok(arg):
    return do_nothing()

def mutli_return(arg):
    if arg:
        return do_something()
    else:
        return do_nothing()

#Modification of parameter with default

def augassign(x = []):
    x += ["x"]


#Possible FPs for non-self. ODASA-2439

class C(object):
    def _func(f):
        return f

    _func(x)

    #or
    @_func
    def meth(self):
        pass


def dont_care(arg):
    pass

class C(object):

    meth = dont_care

class Meta(type):

    #__new__ is an implicit class method, so the first arg is the metaclass
    def __new__(metacls, name, bases, cls_dict):
        return super(Meta, metacls).__new__(metacls, name, bases, cls_dict)

#ODASA 3658
from sys import exit
#Consistent returns
def ok5():
    try:
        may_raise()
        return 0
    except ValueError as e:
        print(e)
        exit(EXIT_ERROR)



#ODASA-6514
if unknown():
    def foo(x):
        pass
else:
    def foo(x):
        return x+1

#This is OK since at least one of the `foo`s returns a value.
y = foo()












# Returning tuples with different sizes

def returning_different_tuple_sizes(x):
    if x:
        return 1,2
    else:
        return 1,2,3

def ok_tuple_sizes(x):
    if x:
        return 1,2
    else:
        return 2,3

def function_returning_2_tuple():
    return 1,2

def function_returning_3_tuple():
    return 1,2,3

def indirectly_returning_different_tuple_sizes(x):
    if x:
        return function_returning_2_tuple()
    else:
        return function_returning_3_tuple()
    

def mismatched_multi_assign(x):
    a,b = returning_different_tuple_sizes(x)
    return a,b


def ok_match(x):  # FP
    match x:
        case True | 'true':
            return 0
        case _:
            raise ValueError(x)


def ok_match2(x):  # FP
    match x:
        case None:
            return 0
        case _:
            return 1
