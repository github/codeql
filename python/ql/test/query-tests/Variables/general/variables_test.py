
__all__ = [ 'is_used_var1' ]

#Shadow Builtin

def sh1(x):
    len = x + 2 #Shadows
    len = x + 0 # no shadowing warning for 2nd def
    return len

#Shadow Global

def sh2(x):
    sh1 = x + 1 #Shadows
    sh1 = x + 0 # no shadowing warning for 2nd def
    return sh1

#This is OK
import module1
def ok1():
    import module1

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
unused_var1 = 17
unused_var2 = 18
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

#Benign case of global shadowing:
if __name__ == "__main__":
    #x is used as a local throughout this file
    x = 0
    use(x)
    
import pytest
#Shadow global in pytest.fixture:
@pytest.fixture
def the_fixture():
    pass

#Use it
the_fixture(1)

def test_function(the_fixture):
    #Use it
    return the_fixture

#This is OK. ODASA-2908
def odasa2908_global(g_x=g_x):
    #Use arg cached in function object for speed 
    return g_x

def odasa2908_builtin(arg, len=len):
    #Use arg cached in function object for speed 
    return len(arg)

#OK if marked as unused:
def ok_unused(unused_1):
    unused_2 = 1
    return 0
