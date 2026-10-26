class Base(object):

    def meth(self):
        pass

class Derived1(Base):

    def meth(self):
        return super(Derived1, self).meth()

class Derived2(Derived1):

    def meth(self):
        return super(Derived2, self).meth()

class Derived3(Derived1):
    pass

class Derived4(Derived3, Derived2):

    def meth(self):
        return super(Derived4, self).meth()

class Derived5(Derived1):

    def meth(self):
        return super(Derived5, self).meth()

class Derived6(Derived5, Derived2):

    def meth(self):
        return super(Derived6, self).meth()

#Incorrect use of super()
class Wrong1(Derived5, Derived2):

    def meth(self):
        return super(Derived5, self).meth()

class Wrong2(Derived3, Derived2):

    def meth(self):
        return super(Derived3, self).meth()

UT = type.__new__(no_name, no_args)
UV = UT()

class Missing1(UT):
    def a(self):
        pass

class Missing2(Base, UT):
    def b(self):
        pass

class Missing3(UT, Base):
    def c(self):
        pass

