#!/usr/bin/env python

def f0(x):
    pass

def f1(x, y = None):
    pass

def f2(x, *y):
    pass

def f3(x, y = None, *z):
    pass

def f4(x, **y):
    pass

def f5(x, y = None, **z):
    pass

def f6(x, y):
    pass

def f7(x, y, z):
    pass

# Too few arguments

f0()
f1()
f2()
f3()
f4()
f5()
f6(1)
f7(1,2)

#Too many arguments

f0(1,2)
f1(1,2,3)
f5(1,2,3)
f6(1,2,3)
f6(1,2,3,4)

#OK

#Not too few
f7(*t)

#Not too many

f2(1,2,3,4,5,6)


#Illegal name
f0(y=1)
f1(z=1)
f2(x=0, y=1)


#Ok name
f0(x=0)
f1(x=0, y=1)
f4(q=4)

#This is correct, but a bit weird.
f6(**{'x':1, 'y':2})

l0 = lambda : 0
l1 = lambda x : 2 * x
l1d = lambda x = 0 : 2 *x

#OK
l0()
l1(1)
l1d()
l1d(1)

#Too many
l0(1)
l1(1,2)
l1d(1,2)

#Too few
l1()


t2 = (1,2)
t3 = (1,2,3)

#Ok
f(*t2)

#Too many
f6(*(1,2,3))
f6(*t3)

#Ok
f6(**{'x':1, 'y':2})

#Illegal name
f6(**{'x':1, 'y':2, 'z':3})

#Theoretically -1 arguments required. Don't report
class C(object):
    
    def f():
        pass
    
C().f()


#Too many and wrong name -- check only wrong name is flagged.
f1(x, y, z=1)


#Overriding and call is wrong.
class Eggs1(object):

    def spam(self):
        pass

class Eggs2(Eggs1):

    def spam(self, arg0, arg1):
        pass

e = Eggs1() if cond else Eggs2()
e.spam(0)

