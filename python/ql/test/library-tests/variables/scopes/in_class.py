foo = "foo-text"
bar = "bar-text"


class MyClass(object):
    baz = "baz"

    def foo(self):
        print("foo()")

    def use(self):
        print("! use()")
        print(foo) # foo-text
        print(bar) # bar-text
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

    class Sub(object):
        stuff = foo

mc = MyClass()
print()
mc.use()

print("\n! mc.ex")
print(mc.ex)

print("\n! MyClass.Sub.stuff")
print(MyClass.Sub().stuff) # foo-text
