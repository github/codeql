import dotted

__all__ = ["foo", "bar", "baz", "not_defined"] # $ Alert[py/undefined-export]


@dotted.decorator
def foo():
    pass

@undotted_decorator # $ Alert[py/undefined-global-variable]
def bar():
    pass

@not_imported.but_dotted # $ Alert[py/undefined-global-variable]
def baz():
    pass
