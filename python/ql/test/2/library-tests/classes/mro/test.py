from undefined import unknown
k = 1
l = []

class OldStyle:

    def meth1(self):
        pass
        
    a1 = k
    a2 = l
    a3 = unknown
    l = l

class OldStyleDerived(OldStyle):

    def meth2(self):
        pass
      

class NewStyle(object):

    def meth3(self):
        pass
        
    a1 = k
    a2 = l
    a3 = unknown
    l = l

class NewStyleDerived(NewStyle):

    def meth4(self):
        pass






class Meta(type):

    def __init__(cls, name, bases, dct):
        type.__init__(cls, name, bases, dct)
        cls.defined_in_meta = 1
        
    def meth5(self):
        pass
        
class WithMeta(object):

    def meth6(self):
        pass
        
    a1 = k
    a2 = l
    a3 = unknown
    l = l

#MRO tests

#Inconsistent MRO

class X(object):
    pass

class Y(X):
    pass
    
#Inconsistent MRO
class Z(X, Y):
    pass
   
#Ok
class W(Y, X):
    pass
    
class O:
    pass
    
#This is OK
class N(object, O):
    pass

#
# Assign builtin objects to class atttibutes

len = len

ord = 10
    
class Unhashable(object):
    
    __hash__ = None
    
class Oddities(object):
    
    int = int
    float = float
    l = len
    h = hash
    
class Sub(Oddities, Unhashable):
    pass

def nested_class():
    class A(BaseException):
        pass
    class B(X):
        pass
    
def NestedClass(object):
    class C(BaseException):
        pass
    class D(X):
        pass
    






