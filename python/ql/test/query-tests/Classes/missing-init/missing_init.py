#Not calling an __init__ method:
class B1(object):

    def __init__(self):
        do_something()

class B2(B1):

    def __init__(self):
        B1.__init__(self)

class B3(B2):

    def __init__(self):
        B1.__init__(self)

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

class IUVT(IUT, UVT):
    pass

#False positive observed on LGTM
class M1(object):
    def __init__(self):
        print("A")

class M2(object):
    pass

class Mult(M2, M1):
    def __init__(self):
        super(Mult, self).__init__() # Calls M1.__init__

class X:
    def __init__(self):
        do_something()

class Y(X):
    @decorated
    def __init__(self):
        X.__init__(self)

class Z(Y):
    def __init__(self):
        Y.__init__(self)

class AA(object):

    def __init__(self):
        do_something()

class AB(AA):

    #Don't call super class init
    def __init__(self):
        do_something()

class AC(AB):

    def __init__(self):
        #Missing call to AA.__init__ but not AC's fault.
        super(AC, self).__init__()

import six
import abc

class BA(object):

    def __init__(self):
        do_something()

@six.add_metaclass(abc.ABCMeta)
class BB(BA):

    def __init__(self):
        super(BB,self).__init__()


@six.add_metaclass(abc.ABCMeta)
class CA(object):

    def __init__(self):
        do_something()

class CB(BA):

    def __init__(self):
        super(CB,self).__init__()

#ODASA-5799
class DA(object):

    def __init__(self):
        do_something()

class DB(DA):

    class DC(DA):

        def __init__(self):
            sup = super(DB.DC, self)
            sup.__init__()

#Simpler variants
class DD(DA):

    def __init__(self):
        sup = super(DD, self)
        sup.__init__()

class DE(DA):

    class DF(DA):

        def __init__(self):
            sup = super(DE.DF, self).__init__()

class FA(object):

    def __init__(self):
        pass

class FB(object):

    def __init__(self):
        do_something()

class FC(FA, FB):

    def __init__(self):
        #OK to skip call to FA.__init__ as that does nothing.
        FB.__init__(self)

#Potential false positives.

class ConfusingInit(B1):

    def __init__(self):
        super_call = super(ConfusingInit, self).__init__
        super_call()


# Library class
import collections

class G1(collections.Counter):

    def __init__(self):
        collections.Counter.__init__(self)

class G2(G1):

    def __init__(self):
        super(G2, self).__init__()

class G3(collections.Counter):

    def __init__(self):
        super(G3, self).__init__()

class G4(G3):

    def __init__(self):
        G3.__init__(self)

