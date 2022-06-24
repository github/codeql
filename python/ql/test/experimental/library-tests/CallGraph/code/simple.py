def foo():
    print("foo called")


indirect_foo = foo


def bar():
    print("bar called")


lam = lambda: print("lambda called")


foo() # $ pt=foo
indirect_foo() # $ pt=foo
bar() # $ pt=bar
lam() # $ pt=lambda[simple.py:12:7]

# python -m trace --trackcalls simple.py
