#Inconsistent MRO

class X(object):
    pass

class Y(X):
    pass

class Z(X, Y):
    pass
    
class O:
    pass
    
#This is OK in Python 2
class N(object, O):
    pass