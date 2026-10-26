# This file is a simple test of which nodes are included with AttrRead/AttrWrite.
# For actual data-flow tests, see fieldflow/ dir.

class MyObj(object):
    def __init__(self, foo):
        self.foo = foo

myobj = MyObj("foo")
myobj.foo = "bar"
myobj.foo

setattr(myobj, "foo", 42)
getattr(myobj, "foo")
