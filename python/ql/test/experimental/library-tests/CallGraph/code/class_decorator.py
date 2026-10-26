# decorated class

def my_class_decorator(cls):
    print("dummy decorator")
    return cls

@my_class_decorator # $ pt=my_class_decorator tt=my_class_decorator
class A(object):
    def foo(self):
        pass

a = A()
a.foo() # $ pt,tt=A.foo

class B(A):
    def bar(self):
        self.foo() # $ pt,tt=A.foo


# decorated class, unknown decorator

from some_unknown_module import unknown_class_decorator

@unknown_class_decorator
class X(object):
    def foo(self):
        pass

x = X()
x.foo() # $ pt,tt=X.foo

class Y(X):
    def bar(self):
        self.foo() # $ pt,tt=X.foo
