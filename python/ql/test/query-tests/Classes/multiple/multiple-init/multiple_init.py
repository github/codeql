#Calling a method multiple times by using explicit calls when a base uses super()
class Base(object):

    def __init__(self):
        print("Base init")

class C1(Base):

    def __init__(self):
        print("C1 init")
        super(C1, self).__init__()

class C2(Base):

    def __init__(self):
        print("C2 init")
        super(C2, self).__init__()  #When `type(self) == C3` this calls `C1.__init__`

class C3(C2, C1):

    def __init__(self): # $ Alert
        print("C3 init")
        C1.__init__(self)
        C2.__init__(self)

C3()

#Calling a method multiple times by using explicit calls when a base inherits from other base
class D1(object):

    def __init__(self):
        print("D1 init")

class D2(D1):

    def __init__(self):
        print("D2 init")
        D1.__init__(self)

class D3(D2, D1):

    def __init__(self): # $ Alert
        print("D3 init")
        D1.__init__(self)
        D2.__init__(self)

D3()

#OK to call object.__init__ multiple times
class E1(object):

    def __init__(self):
        print("E1 init")
        super(E1, self).__init__()

class E2(object):

    def __init__(self):
        print("E2 init")
        object.__init__(self)

class E3(E2, E1): 

    def __init__(self): # OK: builtin init methods are fine.
        E1.__init__(self)
        E2.__init__(self)

E3()


class F1:
    pass 

class F2(F1):
    def __init__(self):
        print("F2 init") 
        super().__init__()

class F3(F1):
    def __init__(self):
        print("F3 init")

class F4(F2, F3):
    def __init__(self): # $ Alert # F2's super call calls F3
        print("F4 init")
        F2.__init__(self)
        F3.__init__(self)

F4()

class G1:
    def __init__(self):
        print("G1 init") 

class G2(G1):
    def __init__(self):
        print("G2 init") 
        G1.__init__(self)

class G3(G1):
    def __init__(self):
        print("G3 init") 
        G1.__init__(self)

class G4(G1):
    def __init__(self):
        print("G4 init") 
        G1.__init__(self)

class G5(G2,G3,G4):
    def __init__(self): # $ Alert # Only one alert is generated, that mentions the first two calls
        print("G5 init") 
        G2.__init__(self)
        G3.__init__(self)
        G4.__init__(self)

G5()