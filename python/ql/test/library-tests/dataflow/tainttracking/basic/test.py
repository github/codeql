# Module level taint is different from inside functions, since shared dataflow library
# relies on `getEnclosingCallable`
tainted = SOURCE
SINK(tainted)

def func():
    also_tainted = SOURCE
    SINK(also_tainted)
