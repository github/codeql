class Base(object):

    def meth(self):
        pass

class Derived1(Base):

    def meth(self):
        return super().meth()

class Derived2(Derived1):

    def meth(self):
        return super().meth()

class Derived3(Derived1):
    pass

class Derived4(Derived3, Derived2):

    def meth(self):
        return super().meth()

class Derived5(Derived1):

    def meth(self):
        return super().meth()

class Derived6(Derived5, Derived2):

    def meth(self):
        return super().meth()
