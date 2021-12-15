

class C(object):

    @property
    def p(self):
        return 0

class D(object):

    def __init__(self):
        self.v = 0

    @property
    def q(self):
        return self.v

    @q.setter
    def q(self, value):
        self.v = value

class E(C, D):
    pass

C.p
D.q
E.p
E.q
