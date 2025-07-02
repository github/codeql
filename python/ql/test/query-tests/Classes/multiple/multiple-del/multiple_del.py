#Calling a method multiple times by using explicit calls when a base uses super()
class Base(object):

    def __del__(self):
        pass

class Y1(Base):

    def __del__(self):
        super(Y1, self).__del__()

class Y2(Base):

    def __del__(self):
        super(Y2, self).__del__()  #When `type(self) == Y3` this calls `Y1.__del__`

class Y3(Y2, Y1):

    def __del__(self):
        Y1.__del__(self)
        Y2.__del__(self)

#Calling a method multiple times by using explicit calls when a base inherits from other base
class Z1(object):

    def __del__(self):
        pass

class Z2(Z1):

    def __del__(self):
        Z1.__del__(self)

class Z3(Z2, Z1):

    def __del__(self):
        Z1.__del__(self)
        Z2.__del__(self)
