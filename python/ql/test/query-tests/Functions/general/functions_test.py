
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


def use_implicit_return_value(arg):
    x = do_nothing()
    return call_non_callable(arg)

#The return in the lambda is OK as it is auto-generated
y = lambda x : do_nothing()

def do_nothing():
    pass


def returns_self(self):
    return self

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

class DeprecatedSliceMethods(object):

    def __getslice__(self, start, stop):
        pass

    def __setslice__(self, start, stop, value):
        pass

    def __delslice__(self, start, stop):
        pass



@decorator
def nested_call_implicit_return_func_ok(arg):
    do_nothing()








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



# indirect modification of parameter with default
def aug_assign_argument(x):
    x += ['x']

def mutate_argument(x):
    x.append('x')

def indirect_modification(y = []):
    aug_assign_argument(y)
    mutate_argument(y)

def guarded_modification(z=[]):
    if z:
        z.append(0)
    return z

# This function causes a discrepancy between the
# Python 2 and 3 versions of the analysis.
# We comment it out until we have resoved the issue.
#
# def issue1143(expr, param=[]):
#     if not param:
#         return result
#     for i in param:
#         param.remove(i) # Mutation here


# Type guarding of modification of parameter with default:

def do_stuff_based_on_type(x):
    if isinstance(x, str):
        x = x.split()
    elif isinstance(x, dict):
        x.setdefault('foo', 'bar')
    elif isinstance(x, list):
        x.append(5)
    elif isinstance(x, tuple):
        x = x.unknown_method()

def str_default(x="hello world"):
    do_stuff_based_on_type(x)

def dict_default(x={'baz':'quux'}):
    do_stuff_based_on_type(x)

def list_default(x=[1,2,3,4]):
    do_stuff_based_on_type(x)

def tuple_default(x=(1,2)):
    do_stuff_based_on_type(x)

# Modification of parameter with default (safe method)

def safe_method(x=[]):
    return x.count(42)
