# A very basic test of DataFlowCall
#
# see `coverage/argumentRoutingTest.ql` for a more in depth test of argument routing
# handling.

def func(arg):
    pass


class MyClass(object):
    def __init__(self, arg):
        pass

    def my_method(self, arg):
        pass

    def __getitem__(self, key):
        pass


func("foo") # $ call=func(..) qlclass=FunctionCall arg_0="foo"
x = MyClass(1) # $ call=MyClass(..) qlclass=ClassCall arg_0=[pre]MyClass(..) arg_1=1
x.my_method(2) # $ call=x.my_method(..) qlclass=MethodCall arg_0=x arg_1=2
mm = x.my_method
mm(2) # $ call=mm(..) qlclass=MethodCall arg_1=2 MISSING: arg_0=x
x[3] # $ call=x[3] qlclass=SpecialCall arg_0=x arg_1=3


try:
    # These are included to show how we handle absent things with points-to where
    # `mypkg.foo` is a `missing module variable`, but `mypkg.subpkg.bar` is compeltely
    # ignored.
    import mypkg
    mypkg.foo(42)
    mypkg.subpkg.bar(43)
except:
    pass
