class Foo:
    def method(self):
        pass

def test_parameter_annotation(x: Foo):
    x.method() #$ tt=Foo.method

def test_no_parameter_annotation(x):
    x.method()

def function_with_return_annotation() -> Foo:
    return eval("Foo()")

def test_return_annotation():
    x = function_with_return_annotation() #$ pt,tt=function_with_return_annotation
    x.method() #$ tt=Foo.method

def function_without_return_annotation():
    return eval("Foo()")

def test_no_return_annotation():
    x = function_without_return_annotation() #$ pt,tt=function_without_return_annotation
    x.method()

def test_variable_annotation():
    x = eval("Foo()")
    x : Foo
    # Currently fails because there is no flow from the class definition to the type annotation.
    x.method() #$ MISSING: tt=Foo.method

def test_no_variable_annotation():
    x = eval("Foo()")
    x.method()
