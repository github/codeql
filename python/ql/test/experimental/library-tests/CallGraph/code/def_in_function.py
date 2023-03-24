def test():
    def foo():
        print("foo")

    foo() # $ pt,tt=test.foo

    def bar():
        print("bar")
        def baz():
            print("baz")
        baz() # $ pt,tt=test.bar.baz
        return baz

    baz_ref = bar() # $ pt,tt=test.bar
    baz_ref() # $ pt,tt=test.bar.baz

    class A(object):
        def foo(self):
            print("A.foo")

    a = A()
    a.foo() # $ tt=test.A.foo

test() # $ pt,tt=test
