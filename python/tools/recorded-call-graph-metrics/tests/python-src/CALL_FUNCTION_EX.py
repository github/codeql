def func(*args, **kwargs):
    print("func", args, kwargs)


args = [1, 2, 3]
kwargs = {"a": 1, "b": 2}

# These gives rise to a CALL_FUNCTION_EX
func(*args)
func(**kwargs)
func(*args, **kwargs)


func(*args, foo="foo")
func(*args, foo="foo", **kwargs)
