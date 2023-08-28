def explicit_afunc():
    print("explicit_afunc called")
    return 1

from foo_explicit.foo_explicit import foo_explicit_func
foo_explicit_func() # $ pt,tt="foo_explicit/foo_explicit.py:foo_explicit_func"
