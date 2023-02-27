# We want to ensure that the __new__ method is considered a classmethod even though it
# doesn't have a decorator. This means that the `cls` parameter should be considered a
# reference to the class (or subclass), and not an instance of the class. We can detect
# this from looking at the arguments passed in the `cls.foo` call. if we see a `self`
# argument, this means it has correct behavior (because we're targeting a classmethod),
# if there is no `self` argument, this means we've only considered `cls` to be a class
# instance, since we don't want to pass that to the `cls` parameter of the classmethod `WithNewImpl.foo`.

class WithNewImpl(object):
    def __new__(cls):
        print("WithNewImpl.foo")
        cls.foo() # $ call=cls.foo() callType=CallTypeClassMethod arg[self]=cls

    @classmethod
    def foo(cls):
        print("WithNewImpl.foo")
