# Originally we had module and functions as `DataFlowCallable``, and any call inside a
# class scope would not have a result for getEnclosingCallable. Since this was only a
# consistency error for calls, originally we added a new `DataFlowClassScope` only for
# those classes that had a call in their scope. That's why all the class definitions in
# this test do a call to the dummy function `func`.
#
# Note: this was shortsighted, since most DataFlow::Node use `getCallableScope` helper
# to define their .getEnclosingCallable(), which picks the first DataFlowCallable to
# contain the node. (so for some classes that would be DataFlowClassScope, and for some
# it would be the module/function containing the class definition)

def func(*args, **kwargs):
    print("func()")

class Cls:
    func()
    class Inner:
        func()

def other_func():
    class Cls2:
        func()
    return Cls2

x = other_func()
