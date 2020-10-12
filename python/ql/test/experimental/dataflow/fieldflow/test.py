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


def setFoo(obj, x):
    SINK_F(obj.foo)
    obj.foo = x


def test_example1():
    myobj = MyObj("OK")

    setFoo(myobj, SOURCE)
    SINK(myobj.foo)


def test_example2():
    x = SOURCE

    a = NestedObj()

    a.obj.foo = x
    a.getObj().foo = x

    SINK(a.obj.foo)


def test_example3():
    obj = MyObj(SOURCE)
    SINK(obj.foo)


def fields_with_local_flow(x):
    obj = MyObj(x)
    a = obj.foo
    return a


def test_fields():
    SINK(fields_with_local_flow(SOURCE))
