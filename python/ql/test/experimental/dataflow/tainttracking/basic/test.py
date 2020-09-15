# Module level taint is different from inside functions, since shared dataflow library
# relies on `getEnclosingCallable`
tainted = SOURCE
SINK(tainted)

def func():
    also_tainted = SOURCE
    SINK(also_tainted)


# Various instances where flow is undesirable

tainted2 = NON_SOURCE
SINK(tainted2)

def write_global():
    global tainted2
    tainted2 = SOURCE

tainted3 = SOURCE
tainted3 = NON_SOURCE
SINK(tainted3)

def use_of_tainted3():
    global tainted3
    tainted3 = NON_SOURCE
