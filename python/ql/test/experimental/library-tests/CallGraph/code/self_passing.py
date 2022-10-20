# These test-cases illustrates what can happen if we allow the type trackers that are used
# for tracking class instances to flow into self parameters.

# This first case shows the problem of the call to `self.bar` inside A.foo, could be
# considered a call to B.bar, if we allow the flow from the `self` parameter of
# `Base.base_meth` to flow into A.foo (through the `self.foo` call). This is
# problematic, and causes us to have different results for the `self.bar()` calls in
# `A.foo` and `A.not_called`.

from inspect import isclass


class Base(object):
    def base_meth(self):
        print("Base.base_meth")
        self.foo() # $ pt,tt=Base.foo tt=A.foo tt=B.foo

    def foo(self):
        print("Base.foo")

class A(Base):
    def foo(self):
        print("A.foo")
        self.bar() # $ pt,tt=A.bar

    def not_called(self):
        self.bar() #$ pt,tt=A.bar

    def bar(self):
        print("A.bar")

class B(Base):
    def foo(self):
        print("B.foo")

    def bar(self):
        print("B.bar")

a = A()
a.foo() # $ pt,tt=A.foo

# Another problem is mixing up class instances and class references. In the example
# below since `func` takes BOTH an instance of X, and the class Y, we used to end up
# tracking _both_ to the self argument of X.foo, which meant that the self.meth() call
# in X.foo was resolved to BOTH X.meth and Y.meth.

class X(object):
    def meth(self):
        print("X.meth")

    def foo(self):
        print("X.foo")
        self.meth() # $ pt,tt=X.meth


class Y(object):
    def meth(self):
        print("Y.meth")

    @classmethod
    def cm(cls):
        print("Y.cm")


def func(obj):
    if isclass(obj):
        obj.cm() # $ tt=Y.cm
    else:
        obj.foo() # $ tt=X.foo

func(Y) # $ pt,tt=func
x = X()
func(x) # $ pt,tt=func


# While avoiding the two problems above is good, we have to be careful not to prune away
# _all_ type-tracking flow to the self parameter (since it's the local source node for
# all references to it within the function). So in the example below, we still want to
# be able to resolve that some_function is assigned to the attribute `func` on self.


class Example3(object):
    def wat(self, f):
        print("Example3.wat")
        self.func = f
        self.func() # $ pt,tt=some_function


def some_function():
    print("some_function")


ex3 = Example3()
ex3.wat(some_function) # $ pt,tt=Example3.wat
