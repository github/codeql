import os

class Base:
    def foo(self):
        print("Base.foo")

    def call(self):
        if isinstance(self, A):
            self.foo() # $ tt=A.foo tt=ASub.foo SPURIOUS: tt=B.foo tt=Base.foo

        # This is a silly test, but just to show that second argument of isinstance as
        # tuple is handled
        if isinstance(self, (A, B)):
            self.foo() # $ tt=A.foo tt=ASub.foo tt=B.foo SPURIOUS: tt=Base.foo

        if isinstance(self, ASubNoDef):
            self.foo() # $ tt=A.foo SPURIOUS: tt=ASub.foo tt=B.foo tt=Base.foo


class A(Base):
    def foo(self):
        print("A.foo")

class ASub(A):
    def foo(self):
        print("ASub.foo")

class ASubNoDef(A): pass

class B(Base):
    def foo(self):
        print("B.foo")

cond = os.urandom(1)[0] > 128

x = A() if cond else B()
x.foo() # $ pt,tt=A.foo pt,tt=B.foo

if isinstance(x, A):
    x.foo() # $ pt,tt=A.foo SPURIOUS: tt=B.foo
