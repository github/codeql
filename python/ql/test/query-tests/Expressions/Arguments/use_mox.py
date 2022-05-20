
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

f0()
f1(1)

#As are normal methods
C().m0()
C().m1(1)
