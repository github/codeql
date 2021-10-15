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

F0()
F1()
F2()
F3()
F4()
F5()
F6(1)
F7(1,2)

#Too many arguments

F0(1,2)
F1(1,2,3)
F5(1,2,3)
F6(1,2,3)
F6(1,2,3,4)

#OK

#Not too few
F7(*t)

#Not too many

F2(1,2,3,4,5,6)


#Illegal name
F0(y=1)
F1(z=1)
F2(x=0, y=1)


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
F6(*(1,2,3))
F6(*t3)

#Ok
F6(**{'x':1, 'y':2})

#Illegal name
F6(**{'x':1, 'y':2, 'z':3})

