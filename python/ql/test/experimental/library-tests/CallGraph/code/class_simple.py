class A(object):

    def __init__(self, arg):
        print('A.__init__', arg)
        self.arg = arg

    # name:A.some_method
    def some_method(self):
        print('A.some_method', self)

    @staticmethod
    # name:A.some_staticmethod
    def some_staticmethod():
        print('A.some_staticmethod')

    @classmethod
    # name:A.some_classmethod
    def some_classmethod(cls):
        print('A.some_classmethod', cls)


# TODO: Figure out how to annotate class instantiation (and add one here).
# Current points-to says it's a call to the class (instead of __init__/__new__/metaclass-something).
# However, current test setup uses "callable" for naming, and expects things to be Function.
a = A(42)

# calls:A.some_method
a.some_method()
# calls:A.some_staticmethod
a.some_staticmethod()
# calls:A.some_classmethod
a.some_classmethod()

# calls:A.some_staticmethod
A.some_staticmethod()
# calls:A.some_classmethod
A.some_classmethod()
