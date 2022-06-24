# name:foo
def foo():
    print("foo called")


indirect_foo = foo


# name:bar
def bar():
    print("bar called")


# name:lam
lam = lambda: print("lambda called")


# calls:foo
foo() # $ pt=foo
# calls:foo
indirect_foo() # $ pt=foo
# calls:bar
bar() # $ pt=bar
# calls:lam
lam() # $ pt=lambda[simple.py:15:7]

# python -m trace --trackcalls simple.py
