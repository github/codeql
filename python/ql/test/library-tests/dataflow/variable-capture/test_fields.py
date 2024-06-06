import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

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

class MyObj(object):
    def setFoo(self, foo):
        self.foo = foo

    def getFoo(self):
        return self.foo

@expects(3)
def test_captured_field():
    foo = MyObj()
    foo.setFoo(NONSOURCE)

    def test():
        SINK(foo.getFoo()) #$ captured

    def read():
        return foo.getFoo()

    SINK_F(read())

    foo.setFoo(SOURCE)
    test()

    SINK(read()) #$ captured