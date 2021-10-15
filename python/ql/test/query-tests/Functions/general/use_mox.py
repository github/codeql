import mox

#Use mox
mox

def f():
    pass

#This may be OK as it might be mocked

f().AndReturns("Something")
