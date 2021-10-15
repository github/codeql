# Simple classmethod

class Foo(object):

    @classmethod
    def foo(cls, arg):
        print(cls, arg)

Foo.foo(42)


# classmethod defined by metaclass

class BarMeta(type):

    def bar(cls, arg):
        print(cls, arg)

class Bar(metaclass=BarMeta):
    pass

Bar.bar(42) # TODO: No points-to

# If this is solved, please update python/ql/src/Variables/UndefinedExport.ql which has a
# work-around for this behavior
