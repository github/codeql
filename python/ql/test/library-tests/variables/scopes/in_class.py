foo = "foo"
bar = "bar"


class MyClass(object):
    baz = "baz"

    def foo(self):
        print("foo()")

    def use(self):
        print("! use()")
        print(foo)
        print(bar)
        try:
            print(baz)
        except NameError:
            pass

        print("=== access on self ===")
        print(self.foo)
        print(self.baz)

    def func(arg):
        print("! func()", arg)
        return 42

    ex = func(baz)

mc = MyClass()
print()
mc.use()

print("\n! mc.ex")
print(mc.ex)
