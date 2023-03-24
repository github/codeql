class X(object):
    def foo(self, *args):
        print("X.foo", args)


def func(cond=True):
    x = X() # $ def=x

    print(x) # $ def-use=x:7

    y = x # $ def=y use-use=x:9
    print(y) # $ def-use=y:11

    x.foo() # $ use-use=x:11

    x.foo(1 if cond else 0) # $ use-use=x:14
    x.foo() # $ MISSING: use-use=x:16
    print(x) # $ use-use=x:17

func()
