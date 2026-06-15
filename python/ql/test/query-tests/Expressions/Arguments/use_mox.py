
import mox

#Use it
mox

def f0(x):
    pass

def f1(x, y):
    pass

class C(object):
    
    def m0(self, x):
        pass
    
    def m1(self, x, y):
        pass
    
# These are treated as magically OK since we are using mox

C.m0(1)
C.m1(1,2)

#But normal functions are treated normally

f0() # $ Alert[py/call/wrong-arguments]
f1(1) # $ Alert[py/call/wrong-arguments]

#As are normal methods
C().m0() # $ Alert[py/call/wrong-arguments]
C().m1(1) # $ Alert[py/call/wrong-arguments]
