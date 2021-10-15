import sys

class C(object):

    x = 'C_x'

    def __init__(self):
        self.y = 'c_y'

type(C())
type(sys)
type(name, (object,), {})

def k(arg):
    type(C())
    type(sys)
    type(arg)
    type(name, (object,), {})


#ODASA-3263
#Django does this
class Base(object):

    def __init__(self, choice):
        if choice == 1:
            self.__class__ = Derived1
        elif choice == 2:
            self.__class__ = Derived2
        else:
            self.__class__ = Derived3

class Derived1(Base):
    pass

class Derived2(Base):
    pass

class Derived3(Base):
    pass

thing = Base(unknown())


def f(arg0, arg1, arg2):
    pass

class D(object):

    m = f #Use function as a method.

    def n(self, arg1):
        pass

int()
type("")()
list()
dict()
bool("hi")
bool(0)
