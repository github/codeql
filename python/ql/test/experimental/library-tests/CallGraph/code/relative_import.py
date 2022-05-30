def test_relative_import():
    from .simple import foo
    foo() # $ pt,tt="code/simple.py:foo"

def test_aliased_relative_import():
    from .aliased_import import foo
    foo() # $ pt,tt="code/simple.py:foo"
