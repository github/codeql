#Not calling an __del__ method:
class X1(object):

    def __del__(self):
        print("X1 del")

class X2(X1):

    def __del__(self):
        print("X2 del")
        X1.__del__(self)

class X3(X2):  # $ Alert - skips X2 del

    def __del__(self):
        print("X3 del")
        X1.__del__(self)

a = X3()
del a
