from __future__ import unicode_literals
class C(object):

    z = None
    i = 1

    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.z = 1


def f(x, y, z):

    c = C(x, y)
    c.a = z
    c.b = 2

    c.x
    c.y
    c.z
    c.a
    c.b

#Beware of cross talk, via some non-mapping global object (e.g. None)
def g(x, i, j):
    if x:
        d1 = None
    else:
        d1 = []
    d1[i] = 0.7
    d1[j]


def h(x, i, j):
    if x:
        d2 = None
    else:
        d2 = []
    d2[i] = 3
    d2[j]

#class attributes
def j():
    C.__init__
    C.i
    C.z

#Locally redefined attribute
def k(cond):
    c1 = C()
    c2 = C()
    c3 = C()
    c1.z = 10
    if cond:
        c2.z = 20
    c1.z # FP here due to self.attribute and local attribute
    c2.z
    c3.z
    c3.z = 30

class D(object):

    def meth1(self):
        self.a = 0
        self.b = 1
        self.a
        self.b

    def meth2(self):
        self.a = 7.0
        self.c = 2
        self.meth1()
        self.a
        self.b
        self.c

class E(object):

    def __init__(self, cond):
        if cond:
            self.x = 0
        else:
            self.x = 1

E().x

#Make sure that we handle getattr and setattr as well

class F(object):

    def meth1(self):
        setattr(self, "a",  0)
        setattr(self, "b",  1)
        getattr(self, "a")
        getattr(self, "b")

    def meth2(self):
        setattr(self, "a",  7.0)
        setattr(self, "c",  2)
        self.meth1()
        getattr(self, "a")
        getattr(self, "b")
        getattr(self, "c")

class G(object):

    def __init__(self):
        setattr(self, "x", 0)

G().x

