#Subclass shadowing

# BAD: `shadow` method shadows attribute
class Base:

    def __init__(self):
        self.shadow = 4

class Derived(Base):

    def shadow(self): # $ Alert 
        pass
    
    
# OK: Allow if superclass also shadows its own method, as this is likely intended.
# Example: stdlib JSONEncoder.default uses this pattern.  
class Base2:

    def __init__(self, default=None):
        if default:
            self.default = default

    def default(self):
        pass

class Derived2(Base2):

    def default(self): # No alert
        return 0

# Properties 

class Base3:
    def __init__(self):
        self.foo = 1 
        self.bar = 2 

class Derived3(Base3):
    # BAD: Write to foo in superclass init raises an error.
    @property 
    def foo(self): # $ Alert
        return 2 
    
    # OK: This property has a setter, so the write is OK.
    @property 
    def bar(self): # No alert
        return self._bar 
    
    @bar.setter 
    def bar(self, val):
        self._bar = val