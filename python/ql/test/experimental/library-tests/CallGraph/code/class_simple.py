class A(object):

    def __init__(self, arg):
        print('A.__init__', arg)
        self.arg = arg

    def some_method(self):
        print('A.some_method', self)

    @staticmethod
    def some_staticmethod():
        print('A.some_staticmethod')

    @classmethod
    def some_classmethod(cls):
        print('A.some_classmethod', cls)


# TODO: Figure out how to annotate class instantiation (and add one here).
# Current points-to says it's a call to the class (instead of __init__/__new__/metaclass-something).
# However, current test setup uses "callable" for naming, and expects things to be Function.
a = A(42)

a.some_method() # $ pt=A.some_method
a.some_staticmethod() # $ pt=A.some_staticmethod
a.some_classmethod() # $ pt=A.some_classmethod

A.some_staticmethod() # $ pt=A.some_staticmethod
A.some_classmethod() # $ pt=A.some_classmethod
