
#Make sure that we handle getattr and setattr as well as they are needed for protobuf stubs.

class C(object):

    def meth1(self):
        setattr(self, "a",  0)
        setattr(self, "b",  1)
        getattr(self, "a")
        getattr(self, "c")

    def meth2(self):
        setattr(self, "a",  7.0)
        setattr(self, "c",  2)
        self.meth1()
        getattr(self, "a")
        getattr(self, "b")
        getattr(self, "c")

#Locally redefined attribute
def k(cond):
    c1 = C()
    c2 = C()
    c3 = C()
    c1.a = 10
    if cond:
        c2.a = 20
    c1.a
    c2.a
    c3.a
    c3.a = 30
