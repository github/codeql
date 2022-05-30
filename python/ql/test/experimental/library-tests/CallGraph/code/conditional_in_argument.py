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
    x.bar(1 if cond else 0) # $ pt,tt=X.bar
    x.foo() # $ pt=X.foo MISSING: tt=X.foo


func() # $ pt,tt=func
