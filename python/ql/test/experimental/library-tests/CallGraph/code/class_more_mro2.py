class A(object):
    def foo(self):
        print("A.foo")

class B(A):
    pass

b = B()
b.foo() # $ pt,tt=A.foo

class C(A):
    def foo(self):
        print("C.foo")

class BC(B, C):
    def bar(self):
        print("BC.bar")
        super().foo() # $ pt,tt=C.foo SPURIOUS: tt=A.foo

bc = BC()
bc.foo() # $ pt,tt=C.foo SPURIOUS: tt=A.foo
bc.bar() # $ pt,tt=BC.bar
