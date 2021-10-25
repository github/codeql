#Equals and hash

class Eq(object):

    def __init__(self, data):
        self.data = data

    def __eq__(self, other):
        return self.data == other.data

class Ne(object):

    def __init__(self, data):
        self.data = data

    def __ne__(self, other):
        return self.data != other.data

class Hash(object):

    def __init__(self, data):
        self.data = data

    def __hash__(self):
        return hash(self.data)
    
class Unhashable1(object):
    
    __hash__ = None
    

class EqOK1(Unhashable1):
    
    def __eq__(self, other):
        return False
    
    def __ne__(self, other):
        return True
    
class Unhashable2(object):

    #Not the idiomatic way of doing it, but not uncommon either
    def __hash__(self):
        raise TypeError("unhashable object")


class EqOK2(Unhashable2):

    def __eq__(self, other):
        return False

    def __ne__(self, other):
        return True

class ReflectiveNotEquals(object):

    def __ne__(self, other):
        return not self == other

class EqOK3(ReflectiveNotEquals, Unhashable1):

    def __eq__(self, other):
        return self.data == other.data
