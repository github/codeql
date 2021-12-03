#Calling a method multiple times by using explicit calls when a base uses super()
class Base(object):

    def __init__(self):
        pass

class C1(Base):

    def __init__(self):
        super(C1, self).__init__()

class C2(Base):

    def __init__(self):
        super(C2, self).__init__()  #When `type(self) == C3` this calls `C1.__init__`

class C3(C2, C1):

    def __init__(self):
        C1.__init__(self)
        C2.__init__(self)

#Calling a method multiple times by using explicit calls when a base inherits from other base
class D1(object):

    def __init__(self):
        pass

class D2(D1):

    def __init__(self):
        D1.__init__(self)

class D3(D2, D1):

    def __init__(self):
        D1.__init__(self)
        D2.__init__(self)

#OK to call object.__init__ multiple times
class E1(object):

    def __init__(self):
        super(E1, self).__init__()

class E2(object):

    def __init__(self):
        object.__init__(self)

class E3(E2, E1): 

    def __init__(self):
        E1.__init__(self)
        E2.__init__(self)

#Two invocations, but can only be called once
class F1(Base):

    def __init__(self, cond):
        if cond:
            Base.__init__(self)
        else:
            Base.__init__(self)

#Single call, splitting causes what seems to be multiple invocations.
class F2(Base):

    def __init__(self, cond):
        if cond:
            pass
        if cond:
            pass
        Base.__init__(self)


