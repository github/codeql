def afunc():
    print("afunc called")
    return 1

from foo.foo import foo_func
foo_func() # $ pt,tt="foo/foo.py:foo_func"
