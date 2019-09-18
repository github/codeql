
def f(arg0, arg1, arg2):
    pass

class C(object):

    m = f

    def n(self, arg1):
        pass

w = 0
x = 1
y = 2
z = 3

def calls():
    outer = False
    f(w, x, y)
    def inner():
        f(y, w, z)
    c = C()
    c.m(w, z)
    c.n(x)
    C.n(y, z)

class D(object):

    @staticmethod
    def foo(arg):
        return arg

D.foo(1)
D().foo(2)
