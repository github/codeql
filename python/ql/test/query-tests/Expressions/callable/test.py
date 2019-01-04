
#Non-callable called
class NonCallable(object):
    pass

class MaybeCallable(Unknown, object):
    pass

class IsCallable(object):

    def __call__(self):
        pass

def call_non_callable(arg):
    non = NonCallable()
    non(arg)
    ()()
    []()
    dont_know = MaybeCallable()
    dont_know() # Not a violation
    ok = IsCallable()
    ok()
    if hasattr(non, "__call__"):
        non(arg) # OK due to guard
    if hasattr(non, "__init__"):
        non(arg) # Not OK due to wrong guard

import six

#ODASA-4812
def call_six_guarded(arg=None):
    # If it's a callable, call it
    if six.callable(arg):
        arg = arg()

#ODASA-6261
def experimental_jit_scope(compile_ops=True, separate_compiled_gradients=False):
    if callable(compile_ops):
        def xla_compile(node_def):
            return attr_value_pb2.AttrValue(b=compile_ops(node_def))

def foo():
    #This is so common, we have a different query for it
    raise NotImplemented()

def bar():
    return NotImplemented()

