#Incomplete ordering

class LtWithoutLe(object): # $ Alert
    def __eq__(self, other):
        return self is other

    def __ne__(self, other):
        return self is not other

    def __hash__(self):
        return id(self)

    def __lt__(self, other):
        return False

# Don't alert on subclass
class LtWithoutLeSub(LtWithoutLe):
    pass

class LeSub(LtWithoutLe):
    def __le__(self, other):
        return self < other or self == other 
    
class GeSub(LtWithoutLe):
    def __ge__(self, other):
        return self > other or self == other 
    
class LendGeNoLt: # $ Alert
    def __le__(self, other):
        return True 
    
    def __ge__(self, other):
        return other <= self 
    
from functools import total_ordering

@total_ordering
class Total:
    def __le__(self, other):
        return True