def foo(n=0):
    print("foo", n)
    if n > 0:
        foo(n-1) # $ pt,tt=foo

foo(1) # $ pt,tt=foo


def test():
    def foo():
        print("test.foo")

    foo() # $ pt,tt=test.foo


class A(object):
    def foo(self):
        print("A.foo")
        foo() # $ pt,tt=foo

a = A()
a.foo() # $ pt,tt=A.foo
