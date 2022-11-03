from python.ql.test.experimental.dataflow.testDefinitions import *

# Preamble


class MyObj(object):
    def __init__(self, foo):
        self.foo = foo


class NestedObj(object):
    def __init__(self):
        self.obj = MyObj("OK")

    def getObj(self):
        return self.obj


# Example 1
def setFoo(obj, x):
    SINK_F(obj.foo)
    obj.foo = x


myobj = MyObj("OK")

setFoo(myobj, SOURCE)
SINK(myobj.foo)

# Example 2
x = SOURCE

a = NestedObj()

a.obj.foo = x

SINK(a.obj.foo)

# Example 2 with method call
x = SOURCE

a = NestedObj()

a.getObj().foo = x

SINK(a.obj.foo)  # Flow missing

# Example 3
obj = MyObj(SOURCE)
SINK(obj.foo)

# Local flow
def fields_with_local_flow(x):
    obj = MyObj(x)
    a = obj.foo
    return a


SINK(fields_with_local_flow(SOURCE))
