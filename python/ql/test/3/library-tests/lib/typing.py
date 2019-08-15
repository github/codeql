#Fake typing module for testing.

class ComplexMetaclass(type):

    def __new__(self):
        pass

class ComplexBaseClass(metaclass=ComplexMetaclass):

    def __new__(self):
        pass

class _Optional(ComplexBaseClass, extras=...):

    def __new__(self):
        pass

Optional = _Optional("Optional")

class Collections(ComplexBaseClass, extras=...):
    pass

class Set(Collections):
    pass

class List(Collections):
    pass

Optional
