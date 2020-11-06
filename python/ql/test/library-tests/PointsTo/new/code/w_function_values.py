def test_conditoinal_function(cond):
    def foo():
        return "foo"

    def bar():
        return "bar"

    if cond:
        f = foo
    else:
        f = bar

    sink = f()
    return sink


f_false = test_conditoinal_function(False)
f_true = test_conditoinal_function(True)


def foo():
    return "foo"


def test_redefinition():
    f = foo

    def foo():
        return "refined"

    sink = f()
    return sink