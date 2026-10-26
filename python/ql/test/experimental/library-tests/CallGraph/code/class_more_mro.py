class Base(object):
    def foo(self):
        print("Base.foo")


class A(Base):
    def foo(self):
        print("A.foo")
        super().foo() # $ pt,tt=Base.foo

class ASub(A):
    pass

class B(Base):
    def foo(self):
        print("B.foo")
        # NOTE: If this missing result is fixed, please update the QLDoc for
        # `getNextClassInMro` as well
        super().foo() # $ pt,tt=Base.foo MISSING: pt,tt=A.foo

class BSub(B):
    def bar(self):
        print("BSub.bar")
        super().foo() # $ pt,tt=B.foo SPURIOUS: tt=A.foo

bs = BSub()
bs.foo() # $ pt,tt=B.foo
bs.bar() # $ pt,tt=BSub.bar

print("! Indirect")
class Indirect(BSub, ASub):
    pass

Indirect().foo() # $ pt,tt=B.foo SPURIOUS: tt=A.foo
Indirect().bar() # $ pt,tt=BSub.bar
