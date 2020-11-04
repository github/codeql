def func(self, arg):
    print("func", self, arg)


class Foo(object):
    def __init__(self, arg):
        print("Foo.__init__", self, arg)

    def some_method(self):
        print("Foo.some_method", self)
        return self

    f = func

    @staticmethod
    def some_staticmethod():
        print("Foo.some_staticmethod")

    @classmethod
    def some_classmethod(cls):
        print("Foo.some_classmethod", cls)


foo = Foo(42)
foo.some_method()
foo.f(10)
foo.some_staticmethod()
foo.some_classmethod()
foo.some_method().some_method().some_method()


Foo.some_staticmethod()
Foo.some_classmethod()


class Bar(object):
    def wat(self):
        print("Bar.wat")


# these calls to Bar() are not recorded (since no __init__ function)
bar = Bar()
bar.wat()
Bar().wat()
