#Not calling an __init__ method:
class B1(object):

    def __init__(self):
        print("B1 init")

class B2(B1):

    def __init__(self):
        print("B2 init")
        B1.__init__(self)

class B3(B2): # $ Alert
    def __init__(self): 
        print("B3 init")
        B1.__init__(self)

B3()

#OK if superclass __init__ is builtin as
#builtin classes tend to rely on __new__
class MyException(Exception):

    def __init__(self):
        self.message = "Uninformative"

#ODASA-4107
class IUT(object):
    def __init__(self):  
        print("IUT init")

class UT(object):
    def __init__(self): 
        print("UT init")

class PU(object):
    pass

class UVT(UT, PU):
    pass

class IUVT(IUT, UVT): # $ Alert
    pass

print("IUVT")
IUVT()

class M1(object):
    def __init__(self):
        print("M1 init")

class M2(object):
    pass

class Mult(M2, M1):
    def __init__(self):
        print("Mult init")
        super(Mult, self).__init__() # OK - Calls M1.__init__

Mult()

class AA(object):

    def __init__(self):
        print("AA init")

class AB(AA): # $ Alert

    # Doesn't call super class init
    def __init__(self): 
        print("AB init")

class AC(AB):

    def __init__(self):
        # Doesn't call AA init, but we don't alert here as the issue is with AB.
        print("AC init")
        super(AC, self).__init__()

AC()

import six
import abc

class BA(object):

    def __init__(self):
        print("BA init")

@six.add_metaclass(abc.ABCMeta)
class BB(BA):

    def __init__(self):
        print("BB init")
        super(BB,self).__init__()

BB()


@six.add_metaclass(abc.ABCMeta)
class CA(object):

    def __init__(self):
        print("CA init")

class CB(CA):

    def __init__(self):
        print("CB init")
        super(CB,self).__init__()

CB()

#ODASA-5799
class DA(object):

    def __init__(self):
        print("DA init")

class DB(DA):

    class DC(DA): # $ SPURIOUS: Alert # We only consider direct super calls, so have an FP here

        def __init__(self): 
            print("DC init")
            sup = super(DB.DC, self)
            sup.__init__()

DB.DC()

#Simpler variants
class DD(DA): # $ SPURIOUS: Alert # We only consider direct super calls, so have an FP here

    def __init__(self): 
        print("DD init")
        sup = super(DD, self)
        sup.__init__()

DD()

class DE(DA):

    class DF(DA): # No alert here

        def __init__(self): 
            print("DF init")
            sup = super(DE.DF, self).__init__()

DE.DF()

class FA(object):

    def __init__(self):
        pass # does nothing, thus is considered a trivial method and ok to not call

class FB(object):

    def __init__(self):
        print("FB init")

class FC(FA, FB):

    def __init__(self):
        # No alert here - ok to skip call to trivial FA init
        FB.__init__(self)

#Potential false positives.

class ConfusingInit(B1):

    def __init__(self): # We track this correctly and don't alert.
        super_call = super(ConfusingInit, self).__init__
        super_call()


class G1:
    def __init__(self):
        print("G1 init")

class G2:
    def __init__(self):
        print("G2 init")

class G3(G1, G2):
    def __init__(self): 
        print("G3 init")
        for cls in self.__class__.__bases__:
            cls.__init__(self) # We dont track which classes this could refer to, but assume it calls all required init methods and don't alert.

G3()

class H1:
    def __init__(self):
        print("H1 init")

class H2:
    def __init__(self):
        print("H2 init")

class H3(H1, H2): # $ Alert # The alert should also mention that H1.__init__ may be missing a call to super().__init__
    def __init__(self): 
        print("H3 init")
        super().__init__()

H3()