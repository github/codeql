class X(object):
    def foo(self, *args):
        print("X.foo", args)

    def bar(self, *args):
        print("X.bar", args)


def func(cond=True):
    x = X()

    # ok
    x.foo() # $ pt,tt=X.foo
    x.bar() # $ pt,tt=X.bar

    # the conditional in the argument makes us stop tracking the class instance :|
    x.foo(1 if cond else 0) # $ pt,tt=X.foo
    x.bar() # $ pt=X.bar MISSING: tt=X.bar


func() # $ pt,tt=func

def func2(cond=True):
    y = X()

    # ok
    y.foo() # $ pt,tt=X.foo
    y.bar() # $ pt,tt=X.bar

    if cond:
        arg = 1
    else:
        arg = 0

    y.foo(arg) # $ pt,tt=X.foo
    y.bar() # $ pt,tt=X.bar
