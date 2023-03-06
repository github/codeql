def outside(self):
    print("outside", self)

def outside_sm():
    print("outside_sm")

def outside_cm(cls):
    print("outside_cm", cls)

class A(object):
    def foo(self):
        print("A.foo")

    foo_ref = foo

    outside_ref = outside
    outside_sm = staticmethod(outside_sm)
    outside_cm = classmethod(outside_cm)

a = A()
a.foo_ref() # $ pt=A.foo
a.outside_ref() # $ pt=outside

a.outside_sm() # $ pt=outside_sm
a.outside_cm() # $ pt=outside_cm

# ===

print("\n! B")

# this pattern was seen in django
class B(object):
    def _gen(value):
        def func(self):
            print("B._gen.func", value)
        return func

    foo = _gen("foo") # $ pt=B._gen
    bar = _gen("bar") # $ pt=B._gen

b = B()
b.foo() # $ pt=B._gen.func
b.bar() # $ pt=B._gen.func
