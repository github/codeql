class MyClass:
    def __init__(self, value):
        self.value = value

    def get_value(self):
        return self.value


def source():
    return MyClass("tainted")


def sink(obj):
    print("sink", obj)


################################################################################


def test_simple():
    src = source()
    sink(src.get_value())


################################################################################


def test_alias():
    src = source()
    foo = src
    bound_method = foo.get_value
    val = bound_method()
    sink(val)


################################################################################


def sink_func(arg):
    val = arg.get_value()
    sink(val)


def test_accross_functions():
    src = source()
    sink_func(src)


################################################################################


def deeply_nested_sink(arg):
    val = arg.get_value()
    sink(val)


def deeply_nested_passthrough_1(arg):
    deeply_nested_sink(arg)


def deeply_nested_passthrough_2(arg):
    deeply_nested_passthrough_1(arg)


def deeply_nested_passthrough_3(arg):
    deeply_nested_passthrough_2(arg)


def test_deeply_nested():
    src = source()
    deeply_nested_passthrough_3(src)


################################################################################


def recv_bound_method(bm):
    val = bm()
    sink(val)


def test_pass_bound_method():
    src = source()
    recv_bound_method(src.get_value)


################################################################################

def deeply_nested_bound_method_sink(bm):
    val = bm()
    sink(val)


def deeply_nested_bound_method_passthrough_1(bm):
    deeply_nested_bound_method_sink(bm)


def deeply_nested_bound_method_passthrough_2(bm):
    deeply_nested_bound_method_passthrough_1(bm)


def deeply_nested_bound_method_passthrough_3(bm):
    deeply_nested_bound_method_passthrough_2(bm)


def test_deeply_nested_bound_method():
    src = source()
    deeply_nested_bound_method_passthrough_3(src.get_value)
