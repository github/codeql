def afunc():
    print("afunc called")
    return 1

from not_root.baz.foo import foo_func
foo_func() # $ pt,tt="not_root/baz/foo.py:foo_func"
