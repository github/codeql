
x = 7
assert isinstance(x, int)
assert issubclass(type(x), object)
d = dict
assert issubclass(d, dict)
assert not issubclass(d, list)

x = 0 if condition else ()
if isinstance(x, tuple):
    pass
isinstance(3, unknown())
assert isinstance(x, int)
assert isinstance(x, (list, int))
assert issubclass(type(x), (list, int))
if issubclass(type(x), (float, dict)):
    pass

