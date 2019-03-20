
class C(object):

    def m(self, arg1):
        return arg1

c = C()

def func_and_method():
    C.m
    c.m
    c.m(3)

def flow_bound_method():
    t = c.m
    t
    t(4)

class D(object):

    @staticmethod
    def foo(arg):
        return arg
D
D.foo
D.foo(1)
D().foo(2)
