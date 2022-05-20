
#OK
a = b = 1
a == b
a.x == b.x

#Same variables
a == a
a.x == a.x

#Compare constants
1 == 1
1 == 2

#Maybe missing self
class X(object):
    
    def __init__(self, x):
        self.x = x
        
    def missing_self(self, x):
        if x == x:
            print ("Yes")

#Compare constants in assert -- ok
assert(1 == 1)
