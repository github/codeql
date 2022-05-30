class Base(object):
    def foo(self):
        print("Base.foo")

    def call_stuff(self):
        print("Base.call_stuff")
        self.foo() # $ pt,tt=Base.foo pt,tt=X.foo

class X(object):
    def __init__(self):
        print("X.__init__")

    def foo(self):
        print("X.foo")

class Y(object):
    def __init__(self):
        print("Y.__init__")

    def foo(self):
        print("Y.foo")

class Contrived(X, Y, Base):
    pass

contrived = Contrived() # $ tt=X.__init__
contrived.foo() # $ pt,tt=X.foo
contrived.call_stuff() # $ pt,tt=Base.call_stuff

# Ensure that we don't mix up __init__ resolution for Contrived() due to MRO
# approximation

class HasInit(object):
    def __init__(self):
        pass

class TryingToTrickYou(Contrived, HasInit):
    pass
