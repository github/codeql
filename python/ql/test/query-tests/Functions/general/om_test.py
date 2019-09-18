
#Signature overridden wrong

class Base(object):

    def ok1(self, arg1, arg2 = 2):
        return arg1, arg2

    def ok2(self, arg1, arg2 = 2):
        return arg1, arg2

    def grossly_wrong1(self, arg1, arg2):
        return arg1, arg2

    def grossly_wrong2(self, arg1, arg2):
        return arg1, arg2

    def strictly_wrong1(self, arg1, arg2 = 2):
        return arg1, arg2

    def strictly_wrong2(self, arg1, arg2 = 2):
        return arg1, arg2

class Derived(Base):

    def ok1(self, arg1, arg2 = 2):
        return arg1, arg2

    def ok2(self, arg1, arg2 = 2, arg3 = 3):
        return arg1, arg2, arg3

    def grossly_wrong1(self, arg1):
        return arg1

    def grossly_wrong2(self, arg1, arg2, arg3):
        return arg1, arg2, arg3

    def strictly_wrong1(self, arg1):
        return arg1

    def strictly_wrong2(self, arg1, arg2, arg3 = 3):
        return arg1, arg2, arg3

#Special method signatures

class Special(object):

    def __add__(self, x):
        return self, x

    def __pos__(self):
        return self

    def __str__(self):
        return repr(self)

class WrongSpecials(object):

    def __div__(self, x, y):
        return self, x, y

    def __mul__(self):
        return self

    def __neg__(self, other):
        return self, other

    def __exit__(self, arg0, arg1):
        return arg0 == arg1

    def __repr__():
        pass

    def __add__(self, other="Unused default"):
       pass
   
    @staticmethod
    def __abs__():
        return 42

class OKSpecials(object):
    
    def __del__():
        state = some_state()

        def __del__(self):
            use_the_state(state)
            
        return __del__
            
    __del__ = __del__()
    
    __add__ = lambda x, y : do_add(x, y)
    
class NotOKSpecials(object):
    
    __sub__ = lambda x : do_neg(x)
    
#Correctly overridden builtin method
class LoggingDict(dict):
    
    def pop(self):
        print("pop")
        return dict.pop(self)

        

