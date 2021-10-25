
def test1():
    SINK(SOURCE)

def test2():
    s = SOURCE
    SINK(s)

def source():
    return SOURCE

def sink(arg):
    SINK(arg)

def test3():
    t = source()
    SINK(t)

def test4():
    t = SOURCE
    sink(t)

def test5():
    t = source()
    sink(t)

def test6(cond):
    if cond:
        t = "Safe"
    else:
        t = SOURCE
    if cond:
        SINK(t)

def test7(cond):
    if cond:
        t = SOURCE
    else:
        t = "Safe"
    if cond:
        SINK(t)

def source2(arg):
    return source(arg)

def sink2(arg):
    sink(arg)

def sink3(cond, arg):
    if cond:
        sink(arg)

def test8(cond):
    t = source2()
    sink2(t)

#False positive
def test9(cond):
    if cond:
        t  = "Safe"
    else:
        t = SOURCE
    sink3(cond, t)

def test10(cond):
    if cond:
        t = SOURCE
    else:
        t = "Safe"
    sink3(cond, t)

def hub(arg):
    return arg

def test11():
    t = SOURCE
    t = hub(t)
    SINK(t)

def test12():
    t = "safe"
    t = hub(t)
    SINK(t)

import module

def test13():
    t = module.dangerous
    SINK(t)

def test14():
    t = module.safe
    SINK(t)

def test15():
    t = module.safe2
    SINK(t)

def test16():
    t = module.dangerous_func()
    SINK(t)

class C(object): pass

def x_sink(arg):
    SINK(arg.x)

def test17():
    t = C()
    t.x = module.dangerous
    SINK(t.x)

def test18():
    t = C()
    t.x = module.dangerous
    t = hub(t)
    x_sink(t)

def test19():
    t = CUSTOM_SOURCE
    t = hub(TAINT_FROM_ARG(t))
    CUSTOM_SINK(t)

def test20(cond):
    if cond:
        t = CUSTOM_SOURCE
    else:
        t = SOURCE
    if cond:
        CUSTOM_SINK(t)
    else:
        SINK(t)

def test21(cond):
    if cond:
        t = CUSTOM_SOURCE
    else:
        t = SOURCE
    if not cond:
        CUSTOM_SINK(t)
    else:
        SINK(t)

def test22(cond):
    if cond:
        t = CUSTOM_SOURCE
    else:
        t = SOURCE
    t = TAINT_FROM_ARG(t)
    if cond:
        CUSTOM_SINK(t)
    else:
        SINK(t)

from module import dangerous as unsafe
SINK(unsafe)

def test23():
    with SOURCE as t:
        SINK(t)

def test24():
    s = SOURCE
    SANITIZE(s)
    SINK(s)

def test_update_extend(x, y):
    l = [SOURCE]
    d = {"key" : SOURCE}
    x.extend(l)
    y.update(d)
    SINK(x[0])
    SINK(y["key"])
    l2 = list(l)
    d2 = dict(d)

def test_truth():
    t = SOURCE
    if t:
        SINK(t)
    else:
        SINK(t)
    if not t:
        SINK(t)
    else:
        SINK(t)

def test_early_exit():
    t = FALSEY
    if not t:
        return
    t

def flow_through_type_test_if_no_class():
    t = SOURCE
    if isinstance(t, str):
        SINK(t)
    else:
        SINK(t)

def flow_in_iteration():
    t = ITERABLE_SOURCE
    for i in t:
        i
    return i

def flow_in_generator():
    seq = [SOURCE]
    for i in seq:
        yield i

def flow_from_generator():
    for x in flow_in_generator():
        SINK(x)

def const_eq_clears_taint():
    tainted = SOURCE
    if tainted == "safe":
        SINK(tainted) # safe
    SINK(tainted) # unsafe

def const_eq_clears_taint2():
    tainted = SOURCE
    if tainted != "safe":
        return
    SINK(tainted) # safe

def non_const_eq_preserves_taint(x):
    tainted = SOURCE
    if tainted == tainted:
        SINK(tainted) # unsafe
    if tainted == x:
        SINK(tainted) # unsafe
