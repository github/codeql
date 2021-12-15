

class C(object):

    def __init__(self, x):
        self.a0 = x

    def m1(self, y):
       self.a1 = y
       return self.a1

    def m2(self, z):
        self.a2 = z
        if cond:
            pass
        else:
            raise Error()
        return self.a2

    def m3(self):
        return self.a0

    def m4(self):
        if hasattr(self, 'a1'): 
            return self.a1