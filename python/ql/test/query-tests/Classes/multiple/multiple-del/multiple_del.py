#Calling a method multiple times by using explicit calls when a base uses super()
class Base(object):

    def __del__(self):
        print("Base del")

class Y1(Base):

    def __del__(self):
        print("Y1 del")
        super(Y1, self).__del__()

class Y2(Base):

    def __del__(self):
        print("Y2 del")
        super(Y2, self).__del__()  #When `type(self) == Y3` this calls `Y1.__del__`

class Y3(Y2, Y1):

    def __del__(self): # $ Alert
        print("Y3 del")
        Y1.__del__(self)
        Y2.__del__(self)

a = Y3()
del a

#Calling a method multiple times by using explicit calls when a base inherits from other base
class Z1(object):

    def __del__(self):
        print("Z1 del")

class Z2(Z1):

    def __del__(self):
        print("Z2 del")
        Z1.__del__(self)

class Z3(Z2, Z1):

    def __del__(self): # $ Alert
        print("Z3 del")
        Z1.__del__(self)
        Z2.__del__(self)

b = Z3()
del b
