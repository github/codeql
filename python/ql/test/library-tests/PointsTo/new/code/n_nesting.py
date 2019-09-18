
# Guarded inner closure creation
# See ODASA-6212
# TO DO:
#    1. Split on tests that control closure creation
#    2. Link scope-entry definition at inner scope entry
#       to the corresponding exit definition.
def foo(compile_ops=True):
    if callable(compile_ops):
        def inner(node_def):
            return compile_ops(node_def)
    else:
        def inner(node_def):
            return compile_ops(node_def)
    attrs = {
        "inner": inner
    }
    return attrs

#Track globals across deeply nested calls-- ODASA-6673

def f1():
    C.flag = 1 # Sufficiently deeply nested that we won't track `C` to here in the import context
def f2():
    f1()
def f3():
    f2()
def f4():
    f3()
class C(object): pass
f4()
class D(C): # But we should track `C` to here even though we can't track all the way down to `f1`
    pass
C = 1
