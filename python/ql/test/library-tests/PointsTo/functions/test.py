class Base(object):
    
    def meth(self):
        pass
    
class Derived1(Base):
    
    def uses_meth(self):
        return self.meth()
    
class Derived2(Derived1):
    
    def uses_meth(self):
        return self.meth()
