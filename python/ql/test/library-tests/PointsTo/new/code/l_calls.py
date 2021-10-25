

def foo(x = []):
    return x.append("x")

def bar(x = []):
    return len(x)

foo()
bar()

class Owner(object):

    @classmethod
    def cm(cls, arg):
        return cls

    @classmethod
    def cm2(cls, arg):
        return arg

    #Normal method
    def m(self):
        a = self.cm(0)
        return a.cm2(1)

# *args

def f(*args):
    return args

class E(object):
    def m(self, *args):
        self
        return args

f(1, 2, 3)
E().m(2, 3, 4)
E.m(3, 4, 5)

t = 'a', 'b', 'c'
f(*t)

def g(a, b, c):
    return a

class F(object):
    def m(self, x, y, z=None):
        return x

g(*t)
F().m(*t)
F.m(*t)

# Calls to built-in methods

# Methods with a known return type.
a = int.bit_length
b = int.bit_length(5)

# Methods without a known return type.
c = dict.get
d = dict.get({"foo":5}, 5)
check(a,b,c,d)
