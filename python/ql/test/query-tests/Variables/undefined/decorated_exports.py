import dotted

__all__ = ["foo", "bar", "baz", "not_defined"]


@dotted.decorator
def foo():
    pass

@undotted_decorator
def bar():
    pass

@not_imported.but_dotted
def baz():
    pass
