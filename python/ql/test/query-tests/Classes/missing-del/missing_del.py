#Not calling an __del__ method:
class X1(object):

    def __del__(self):
        pass

class X2(X1):

    def __del__(self):
        X1.__del__(self)

class X3(X2):

    def __del__(self):
        X1.__del__(self)
