
#OK
a = b = 1
a == b
a.x == b.x

#Same variables
a == a # $ Alert[py/comparison-of-identical-expressions]
a.x == a.x # $ Alert[py/comparison-of-identical-expressions]

#Compare constants
1 == 1 # $ Alert[py/comparison-of-constants]
1 == 2 # $ Alert[py/comparison-of-constants]

#Maybe missing self
class X(object):
    
    def __init__(self, x):
        self.x = x
        
    def missing_self(self, x):
        if x == x: # $ Alert[py/comparison-missing-self]
            print ("Yes")

#Compare constants in assert -- ok
assert(1 == 1)
