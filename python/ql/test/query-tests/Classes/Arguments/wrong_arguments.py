# Test cases corresponding to /Expressions/Arguments/wrong_arguments.py

class F0(object):
    def __init__(self, x):
        pass

class F1(object):
    def __init__(self, x, y = None):
        pass

class F2(object):
    def __init__(self, x, *y):
        pass

class F3(object):
    def __init__(self, x, y = None, *z):
        pass

class F4(object):
    def __init__(self, x, **y):
        pass

class F5(object):
    def  __init__(self, x, y = None, **z):
        pass

class F6(object):
    def  __init__(self, x, y):
        pass

class F7(object):
    def  __init__(self, x, y, z):
        pass

# Too few arguments

F0() # $ Alert[py/call/wrong-number-class-arguments]
F1() # $ Alert[py/call/wrong-number-class-arguments]
F2() # $ Alert[py/call/wrong-number-class-arguments]
F3() # $ Alert[py/call/wrong-number-class-arguments]
F4() # $ Alert[py/call/wrong-number-class-arguments]
F5() # $ Alert[py/call/wrong-number-class-arguments]
F6(1) # $ Alert[py/call/wrong-number-class-arguments]
F7(1,2) # $ Alert[py/call/wrong-number-class-arguments]

#Too many arguments

F0(1,2) # $ Alert[py/call/wrong-number-class-arguments]
F1(1,2,3) # $ Alert[py/call/wrong-number-class-arguments]
F5(1,2,3) # $ Alert[py/call/wrong-number-class-arguments]
F6(1,2,3) # $ Alert[py/call/wrong-number-class-arguments]
F6(1,2,3,4) # $ Alert[py/call/wrong-number-class-arguments]

#OK

#Not too few
F7(*t)

#Not too many

F2(1,2,3,4,5,6)


#Illegal name
F0(y=1) # $ Alert[py/call/wrong-named-class-argument]
F1(z=1) # $ Alert[py/call/wrong-named-class-argument]
F2(x=0, y=1) # $ Alert[py/call/wrong-named-class-argument]


#Ok name
F0(x=0)
F1(x=0, y=1)
F4(q=4)

#This is correct, but a bit weird.
F6(**{'x':1, 'y':2})

t2 = (1,2)
t3 = (1,2,3)

#Ok
f(*t2)

#Too many
F6(*(1,2,3)) # $ Alert[py/call/wrong-number-class-arguments]
F6(*t3) # $ Alert[py/call/wrong-number-class-arguments]

#Ok
F6(**{'x':1, 'y':2})

#Illegal name
F6(**{'x':1, 'y':2, 'z':3}) # $ Alert[py/call/wrong-named-class-argument]

