class A:

    def __add__(self, other): # No alert - Always allow NotImplementedError
        raise NotImplementedError() 

    def __getitem__(self, index): # $ Alert
        raise ZeroDivisionError() 

    def __getattr__(self, name): # $ Alert
        raise ZeroDivisionError() 

    def __bool__(self): # $ Alert
        raise ValueError() 
    
    def __int__(self): # $ Alert # Cast method need not be defined to always raise
        raise ValueError() 

    def __float__(self): # No alert - OK to raise conditionally
        if self.z:
            return 0 
        else:
            raise ValueError()

    def __hash__(self): # $ Alert # should use __hash__=None rather than stub implementation to make class unhashable
        raise NotImplementedError()

class B:
    def __sub__(self, other): # $ Alert # should return NotImplemented instead
        if not isinstance(other,B):
            raise TypeError()
        return self
        
    def __add__(self, other): # No alert - allow add to raise a TypeError, as it is sometimes used for sequence concatenation as well as arithmetic 
        if not isinstance(other,B):
            raise TypeError()
        return self

    def __setitem__(self, key, val): # No alert - allow setitem to raise arbitrary exceptions as they could be due to the value, rather than a LookupError relating to the key
        if val < 0:
            raise ValueError()

    def __getitem__(self, key): # No alert - indexing method allowed to raise TypeError or subclasses of LookupError. 
        if not isinstance(key, int):
            raise TypeError()
        if key < 0:
            raise KeyError()
        return 3

    def __getattribute__(self, name):
        if name != "a":
            raise AttributeError() 
        return 2

    def __div__(self, other):
        if other == 0:
            raise ZeroDivisionError()
        return self 

    
class D:
    def __int__(self):
        return 2 

class E(D):
    def __int__(self): # No alert - cast method may override to raise exception
        raise TypeError()