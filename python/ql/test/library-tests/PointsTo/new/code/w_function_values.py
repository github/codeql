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


def test_redefinition():
    def foo():
        return "foo"
        
    f = foo

    def foo():
        return "foo redefined"

    sink_foo = f()
    sink_redefined = foo()
    return sink_foo, sink_redefined
    
foo, redefined = test_redefinition()
assert foo == "foo"
assert redefined == "foo redefined"
