

class Base(object):

    class C(object): pass

    def meth(self):
        pass

class Derived(Base):

    def meth(self):
        super(Derived, self).meth()
        super(Derived, self).x

class Derived2(Base):

    def meth(self):
        pass

    class C(object): pass
