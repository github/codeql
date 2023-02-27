class A(object):
    class B(object):
        @staticmethod
        def foo():
            print("A.B.foo")

        @staticmethod
        def bar():
            print("A.B.bar")
            A.B.foo() # $ pt,tt=A.B.foo


A.B.bar() # $ pt,tt=A.B.bar


ab = A.B()
ab.bar() # $ pt,tt=A.B.bar

# ==============================================================================

class OuterBase(object):
    def foo(self):
        print("OuterBase.foo")

class InnerBase(object):
    def foo(self):
        print("InnerBase.foo")

class Outer(OuterBase):
    def foo(self):
        print("Outer.foo")
        super().foo() # $ pt,tt=OuterBase.foo

    class Inner(InnerBase):
        def foo(self):
            print("Inner.foo")
            super().foo() # $ pt,tt=InnerBase.foo

outer = Outer()
outer.foo() # $ pt,tt=Outer.foo

inner = Outer.Inner()
inner.foo() # $ pt,tt=Outer.Inner.foo

# ==============================================================================

class Base(object):
    def foo(self):
        print("Base.foo")

class Base2(object):
    def foo(self):
        print("Base2.foo")

class X(Base):
    def meth(self):
        print("X.meth")
        super().foo() # $ pt,tt=Base.foo

        def inner_func():
            print("inner_func")
            try:
                super().foo()
            except RuntimeError:
                print("RuntimeError, as expected")

        inner_func() # $ pt,tt=X.meth.inner_func

        def inner_func2(this_works):
            print("inner_func2")
            super().foo() # $ MISSING: tt=Base.foo

        inner_func2(self) # $ pt,tt=X.meth.inner_func2

    def class_def_in_func(self):
        print("X.class_def_in_func")
        class Y(Base2):
            def meth(self):
                print("Y.meth")
                super().foo() # $ pt,tt=Base2.foo

        y = Y()
        y.meth() # $ tt=X.class_def_in_func.Y.meth

x = X()
x.meth() # $ pt,tt=X.meth
x.class_def_in_func() # $ pt=X.class_def_in_func tt=X.class_def_in_func
