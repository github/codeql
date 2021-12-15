class Base2(object):

    def __init__(self):
        super(Base2, self).__init__()



class Derived4(Base2):

    def __init__(self):
        super(Base2, self)
        return super(Derived4, self).__init__()

class Base1(object):

    def meth(self):
        return 7

class Derived1(Base1):

    def meth(self):
        return super(Derived1, self).meth()

class Derived2(Derived1):

    def meth(self):
        return super(Derived2, self).meth()

class Derived5(Derived1):

    def meth(self):
        return super(Derived5, self).meth()

#Incorrect use of super()
class Wrong1(Derived5, Derived2):

    def meth(self):
        return super(Derived5, self).meth()

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
            super(DE.DF, self).__init__()

class N(object):
    pass

class M(N):

    def __init__(self):
        s = super(M, self)
        i = s.__init__
        i()
