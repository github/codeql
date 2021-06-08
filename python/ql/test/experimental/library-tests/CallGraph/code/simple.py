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
foo()
# calls:foo
indirect_foo()
# calls:bar
bar()
# calls:lam
lam()

# python -m trace --trackcalls simple.py
