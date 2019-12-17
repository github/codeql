class Wat(str):

    def upper(self):
        return self.lower()

def outside_func(self, x):
    print(x)

class Base(object):

    foo = lambda self, x: x+1

    bar = staticmethod(lambda x: x+1)

    baz = 123

    def normal(self):
        pass

    tricky = outside_func

class Sub(Base):

    normal = False

class Sub2(Base):

    def foo(self, y):
        return y * 100

    def tricky(self, x):
        print('nice!', x)

class Sub2Sub(Sub2):

    def foo(self, z):
        return z / 123

    def baz(self):
        print('python is a bit crazy sometimes')


ws = Wat('asdf')
print(ws.upper(), len(ws))

b = Base()
print(b.foo(1))
print(b.bar(10))


ss = SubSub()
print(ss.foo(1))
ss.baz()
