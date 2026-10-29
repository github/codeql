def foo():
    print("foo called")


indirect_foo = foo


def bar():
    print("bar called")


lam = lambda: print("lambda called")


foo() # $ pt,tt=foo
indirect_foo() # $ pt,tt=foo
bar() # $ pt,tt=bar
lam() # $ pt,tt=lambda[simple.py:12:7]

# python -m trace --trackcalls simple.py
