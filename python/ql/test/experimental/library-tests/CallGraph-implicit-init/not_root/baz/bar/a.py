def afunc():
    print("afunc called")
    return 1

from baz.foo import foo_func
foo_func() # $ MISSING: pt,tt="baz/foo.py:foo_func"
