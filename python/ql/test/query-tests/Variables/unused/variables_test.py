
__all__ = [ 'is_used_var1' ]

__author__ = "Mark"

__hidden_marker = False
















#Unused parameter, local and global

def u1(x):
    return 0

def u2():
    x = 1
    return 1

#These parameters are OK due to (potential overriding)
class C(object):

    @abstractmethod
    def ok2(self, p):
        pass

    def ok3(self, arg):
        pass

class D(C):

    def ok3(self, arg):
        pass

#Unused module variable
not_used_var1 = 17
not_used_var2 = 18
is_used_var1 = 19
is_used_var2 = 20

def func():
    return is_used_var2

#Redundant global declaration
global g_x

g_x = 0

#Use global

def uses_global(arg):
    global g_x
    g_x = arg

use(g_x)


#Unused but with acceptable names
unused_var3 = g_x

#Use at least one element of the tuple

_a, _b, c = t

use(c)

def f(t):
    _a, _b, c = t
    use(c)


# Entirely unused tuple

a,b,c = t

def f(t):
    a,b,c = t
    use(t)

def second_def_undefined():
    var = 0
    use(var)
    var = 1 # unused.

#And gloablly
glob_var = 0
use(glob_var)
glob_var = 1 # unused




#OK if marked as unused:
def ok_unused(unused_1):
    unused_2 = 1
    return 0

#Decorators count as a use:

@compound.decorator()
def _unused_but_decorated():
    pass

def decorated_inner_function():

    @flasklike.routing("/route")
    def end_point():
        pass

    @complex.decorator("x")
    class C(object):
        pass

    return 0



#FP observed https://lgtm.com/projects/g/torchbox/wagtail/alerts/ 
def test_dict_unpacking(queryset, field_name, value):
    #True positive
    for tag in value.split(','):
        queryset = queryset.filter(**{field_name + '__name': tag1})
    return queryset
    #False positive
    for tag in value.split(','):
        queryset = queryset.filter(**{field_name + '__name': tag})
    return queryset
