class MyStr(str):

    def upper(self):
        return self.lower()


s = MyStr('asdf')
print(s.upper(), len(s))


def outside_func(self, x):
    print(x)

class Base(object):

    foo = lambda self, x: x+1

    bar = staticmethod(lambda x: x+1)

    baz = 123

    def normal(self):
        pass

    tricky = outside_func

class Foo(Base):

    normal = False

class Bar(Base):

    def foo(self, y):
        return y * 100

    def tricky(self, x):
        print('tricky!', x)

class SpecialBar(Bar):

    def foo(self, z):
        return z / 123

    def baz(self):
        print('baz')


b = Base()
print(b.foo(1))
print(b.bar(10))

sb = SpecialBar()
print(sb.foo(1))
sb.baz()
