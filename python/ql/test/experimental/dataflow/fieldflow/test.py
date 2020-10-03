# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")


# Preamble
class MyObj(object):
    def __init__(self, foo):
        self.foo = foo

    def setFoo(self, foo):
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


def test_example1_method():
    myobj = MyObj("OK")

    myobj.setFoo(SOURCE)
    SINK(myobj.foo)


def test_example2():
    x = SOURCE

    a = NestedObj()

    a.obj.foo = x

    SINK(a.obj.foo)


def test_example2_method():
    x = SOURCE

    a = NestedObj()

    a.getObj().foo = x

    SINK(a.obj.foo)


def test_example3():
    obj = MyObj(SOURCE)
    SINK(obj.foo)


def test_example3_kw():
    obj = MyObj(foo=SOURCE)
    SINK(obj.foo)


def fields_with_local_flow(x):
    obj = MyObj(x)
    a = obj.foo
    return a


def test_fields():
    SINK(fields_with_local_flow(SOURCE))
