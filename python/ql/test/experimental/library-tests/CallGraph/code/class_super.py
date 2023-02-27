def outside_def(self):
    print("outside_def")
    try:
        super().foo()
    except RuntimeError:
        pass


class A(object):
    def foo(self):
        print("A.foo")

    @classmethod
    def bar(cls):
        print("A.bar")

class B(A):
    def foo(self):
        print("B.foo")

    def foo_on_super(self):
        print("B.foo_on_super")
        super().foo() # $ pt,tt=A.foo
        super(B, self).foo() # $ pt,tt=A.foo

    od = outside_def

    @staticmethod
    def sm():
        try:
            super().foo()
        except RuntimeError:
            print("B.sm")
            pass

    @classmethod
    def bar(cls):
        print("B.bar")

    @classmethod
    def bar_on_super(cls):
        print("B.bar_on_super")
        super().bar() # $ tt=A.bar
        super(B, cls).bar() # $ tt=A.bar


b = B()
b.foo() # $ pt,tt=B.foo
b.foo_on_super() # $ pt,tt=B.foo_on_super
b.od() # $ pt=outside_def
b.sm() # $ pt,tt=B.sm

print("="*10, "static method")
B.bar() # $ pt,tt=B.bar
B.bar_on_super() # $ pt,tt=B.bar_on_super


print("="*10, "Manual calls to super")

super(B, b).foo() # $ pt,tt=A.foo

assert A.foo == super(B, B).foo
super(B, B).foo(b) # $ tt=A.foo

try:
    super(B, 42).foo()
except TypeError:
    pass

# For some reason, points-to isn't able to resolve any calls from here on. I've tried to
# comment out both try-except blocks, but that did not solve the problem :|

print("="*10, "C")

class C(B):
    def foo_on_A(self):
        print('C.foo_on_A')
        super(B, self).foo() # $ tt=A.foo

c = C()
c.foo_on_A() # $ tt=C.foo_on_A

print("="*10, "Diamon hierachy")

class X(object):
    def foo(self):
        print('X.foo')

class Y(X):
    def foo(self):
        print('Y.foo')
        super().foo() # $ tt=X.foo

class Z(X):
    def foo(self):
        print('Z.foo')
        super().foo() # $ tt=X.foo tt=Y.foo

print("! z.foo()")
z = Z()
z.foo() # $ tt=Z.foo

class ZY(Z, Y):
    pass

print("! zy.foo()")
zy = ZY()
zy.foo() # $ tt=Z.foo
