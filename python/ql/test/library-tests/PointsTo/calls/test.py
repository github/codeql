
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

l = [1,2,3]
l.append(4)
len(l)

f(arg0=0, arg1=1, arg2=2)
c = C()
c.n(arg1=1)

# positional/keyword arguments for a builtin function
open("foo.txt", "rb") # TODO: Not handled by getNamedArgumentForCall
open(file="foo.txt", mode="rb")

# Testing how arguments to *args and **kwargs are handled
def foo(a, *args):
    pass
foo(1, 2, 3)

def bar(a, **kwargs):
    pass
bar(a=1, b=2, c=3)
