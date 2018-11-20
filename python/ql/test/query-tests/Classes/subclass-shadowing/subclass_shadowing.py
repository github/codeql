#Subclass shadowing

class Base(object):

    def __init__(self):
        self.shadow = 4

class Derived(Base):

    def shadow(self):
        pass
    
    
#OK if the super class defines the method as well.
#Since the original method must exist for some reason.
#See JSONEncoder.default for real example

class Base2(object):

    def __init__(self, shadowy=None):
        if shadowy:
            self.shadow = shadowy

    def shadow(self):
        pass

class Derived2(Base2):

    def shadow(self):
        return 0
