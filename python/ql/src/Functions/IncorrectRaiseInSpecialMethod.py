#Incorrect unhashable class
class MyMutableThing(object):
    
    def __init__(self):
        pass
    
    def __hash__(self):
        raise NotImplementedError("%r is unhashable" % self)

#Make class unhashable in the standard way
class MyCorrectMutableThing(object):
    
    def __init__(self):
        pass
    
    __hash__ = None
