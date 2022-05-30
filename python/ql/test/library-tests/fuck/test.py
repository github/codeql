def my_func(arg):
    print("my_func", arg)

class Foo:
    def foo(self, arg=42):
        print("Foo.foo", self, arg)


my_func(43)

import random
if random.choice([True, False]):
    func = my_func
else:
    func = Foo.foo

func(44)
