

class C(object):

    def __init__(self, a=17):
        self.a = a

    def foo(self, other):
        self.a
        other.a

C().foo(C())
C().foo(C(100))
