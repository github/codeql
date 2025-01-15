# This tests some of the common built-in functions and methods.
# We need a decent model of data flow through these in order to
# analyse most programs.
#
# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"

def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j

def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)

def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")


# Actual tests

## Container constructors

### List

@expects(2)
def test_list_from_list():
    l1 = [SOURCE, NONSOURCE]
    l2 = list(l1)
    SINK(l2[0]) #$ flow="SOURCE, l:-2 -> l2[0]"
    SINK_F(l2[1]) #$ SPURIOUS: flow="SOURCE, l:-3 -> l2[1]"

# -- skip list_from_string

@expects(2)
def test_list_from_tuple():
    t = (SOURCE, NONSOURCE)
    l = list(t)
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"
    SINK_F(l[1]) #$ SPURIOUS: flow="SOURCE, l:-3 -> l[1]"

def test_list_from_set():
    s = {SOURCE}
    l = list(s)
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"

@expects(2)
def test_list_from_dict():
    d = {SOURCE: 'v', NONSOURCE: 'v2'}
    l = list(d)
    SINK(l[0]) #$ MISSING: flow="SOURCE, l:-2 -> l[0]"
    SINK_F(l[1]) # expecting FP due to imprecise flow

### Tuple

@expects(2)
def test_tuple_from_list():
    l = [SOURCE, NONSOURCE]
    t = tuple(l)
    SINK(t[0]) #$ MISSING: flow="SOURCE, l:-2 -> t[0]"
    SINK_F(t[1])

@expects(2)
def test_tuple_from_tuple():
    t0 = (SOURCE, NONSOURCE)
    t = tuple(t0)
    SINK(t[0]) #$ flow="SOURCE, l:-2 -> t[0]"
    SINK_F(t[1])

def test_tuple_from_set():
    s = {SOURCE}
    t = tuple(s)
    SINK(t[0]) #$ MISSING: flow="SOURCE, l:-2 -> t[0]"

@expects(2)
def test_tuple_from_dict():
    d = {SOURCE: "v1", NONSOURCE: "v2"}
    t = tuple(d)
    SINK(t[0]) #$ MISSING: flow="SOURCE, l:-2 -> t[0]"
    SINK_F(t[1])


### Set

def test_set_from_list():
    l = [SOURCE]
    s = set(l)
    v = s.pop()
    SINK(v) #$ flow="SOURCE, l:-3 -> v"

def test_set_from_tuple():
    t = (SOURCE,)
    s = set(t)
    v = s.pop()
    SINK(v) #$ flow="SOURCE, l:-3 -> v"

def test_set_from_set():
    s0 = {SOURCE}
    s = set(s0)
    v = s.pop()
    SINK(v) #$ flow="SOURCE, l:-3 -> v"

def test_set_from_dict():
    d = {SOURCE: "val"}
    s = set(d)
    v = s.pop()
    SINK(v) #$ MISSING: flow="SOURCE, l:-3 -> v"


### Dict

@expects(2)
def test_dict_from_keyword():
    d = dict(k = SOURCE, k1 = NONSOURCE)
    SINK(d["k"]) #$ flow="SOURCE, l:-1 -> d['k']"
    SINK_F(d["k1"])

@expects(2)
def test_dict_from_list():
    d = dict([("k", SOURCE), ("k1", NONSOURCE)])
    SINK(d["k"]) #$ flow="SOURCE, l:-1 -> d['k']"
    SINK_F(d["k1"]) #$ SPURIOUS: flow="SOURCE, l:-2 -> d['k1']"  // due to imprecise list content

@expects(2)
def test_dict_from_dict():
    d1 = {'k': SOURCE, 'k1': NONSOURCE}
    d2 = dict(d1)
    SINK(d2["k"]) #$ flow="SOURCE, l:-2 -> d2['k']"
    SINK_F(d2["k1"])

@expects(4)
def test_dict_from_multiple_args():
    d = dict([("k", SOURCE), ("k1", NONSOURCE)], k2 = SOURCE, k3 = NONSOURCE)
    SINK(d["k"]) #$ flow="SOURCE, l:-1 -> d['k']"
    SINK_F(d["k1"]) #$ SPURIOUS: flow="SOURCE, l:-2 -> d['k1']" // due to imprecise list content
    SINK(d["k2"]) #$ flow="SOURCE, l:-3 -> d['k2']"
    SINK_F(d["k3"]) #$ SPURIOUS: flow="SOURCE, l:-4 -> d['k3']" // due to imprecise list content

## Container methods

### List

def test_list_pop():
    l = [SOURCE]
    v = l.pop()
    SINK(v) #$ flow="SOURCE, l:-2 -> v"

def test_list_pop_index():
    l = [SOURCE]
    v = l.pop(0)
    SINK(v) #$ flow="SOURCE, l:-2 -> v"

def test_list_pop_index_imprecise():
    l = [SOURCE, NONSOURCE]
    v = l.pop(1)
    SINK_F(v) #$ SPURIOUS: flow="SOURCE, l:-2 -> v"

@expects(2)
def test_list_copy():
    l0 = [SOURCE, NONSOURCE]
    l = l0.copy()
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"
    SINK_F(l[1]) #$ SPURIOUS: flow="SOURCE, l:-3 -> l[1]"

def test_list_append():
    l = [NONSOURCE]
    l.append(SOURCE)
    SINK(l[1]) #$ flow="SOURCE, l:-1 -> l[1]"

### Set

def test_set_pop():
    s = {SOURCE}
    v = s.pop()
    SINK(v) #$ flow="SOURCE, l:-2 -> v"

def test_set_copy():
    s0 = {SOURCE}
    s = s0.copy()
    SINK(s.pop()) #$ flow="SOURCE, l:-2 -> s.pop()"

def test_set_add():
    s = set([])
    s.add(SOURCE)
    SINK(s.pop()) #$ flow="SOURCE, l:-1 -> s.pop()"

### Dict

def test_dict_keys():
    d = {SOURCE: "value"}
    keys = d.keys()
    key_list = list(keys)
    SINK(key_list[0]) #$ MISSING: flow="SOURCE, l:-3 -> key_list[0]"

def test_dict_values():
    d = {'k': SOURCE}
    vals = d.values()
    val_list = list(vals)
    SINK(val_list[0]) #$ flow="SOURCE, l:-3 -> val_list[0]"

@expects(4)
def test_dict_items():
    d = {'k': SOURCE, SOURCE: "value"}
    items = d.items()
    item_list = list(items)
    SINK_F(item_list[0][0]) # expecting FP due to imprecise flow
    SINK(item_list[0][1]) #$ flow="SOURCE, l:-4 -> item_list[0][1]"
    SINK(item_list[1][0]) #$ MISSING: flow="SOURCE, l:-5 -> item_list[1][0]"
    SINK_F(item_list[1][1]) #$ SPURIOUS: flow="SOURCE, l:-6 -> item_list[1][1]"

@expects(3)
def test_dict_pop():
    d = {'k': SOURCE}
    v = d.pop("k")
    SINK(v) #$ flow="SOURCE, l:-2 -> v"
    v1 = d.pop("k", NONSOURCE)
    SINK_F(v1) #$ SPURIOUS: flow="SOURCE, l:-4 -> v1"
    v2 = d.pop("non-existing", SOURCE)
    SINK(v2) #$ flow="SOURCE, l:-1 -> v2"

@expects(3)
def test_dict_get():
    d = {'k': SOURCE}
    v = d.get("k")
    SINK(v) #$ flow="SOURCE, l:-2 -> v"
    v1 = d.get("non-existing", SOURCE)
    SINK(v1) #$ flow="SOURCE, l:-1 -> v1"
    k = "k"
    v2 = d.get(k)
    SINK(v2) #$ flow="SOURCE, l:-7 -> v2"

@expects(2)
def test_dict_popitem():
    d = {'k': SOURCE}
    t = d.popitem() # could be any pair (before 3.7), but we only have one
    SINK_F(t[0])
    SINK(t[1]) #$ flow="SOURCE, l:-3 -> t[1]"

@expects(2)
def test_dict_copy():
    d = {'k': SOURCE, 'k1': NONSOURCE}
    d1 = d.copy()
    SINK(d1["k"]) #$ flow="SOURCE, l:-2 -> d1['k']"
    SINK_F(d1["k1"])


## Functions on containers

### sorted

def test_sorted_list():
    l0 = [SOURCE]
    l = sorted(l0)
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"

def test_sorted_tuple():
    t = (SOURCE,)
    l = sorted(t)
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"

def test_sorted_set():
    s = {SOURCE}
    l = sorted(s)
    SINK(l[0]) #$ flow="SOURCE, l:-2 -> l[0]"

def test_sorted_dict():
    d = {SOURCE: "val"}
    l = sorted(d)
    SINK(l[0]) #$ MISSING: flow="SOURCE, l:-2 -> l[0]"

### reversed

@expects(2)
def test_reversed_list():
    l0 = [SOURCE, NONSOURCE]
    r = reversed(l0)
    l = list(r)
    SINK_F(l[0]) #$ SPURIOUS: flow="SOURCE, l:-3 -> l[0]"
    SINK(l[1]) #$ flow="SOURCE, l:-4 -> l[1]"

@expects(2)
def test_reversed_tuple():
    t = (SOURCE, NONSOURCE)
    r = reversed(t)
    l = list(r)
    SINK_F(l[0]) #$ SPURIOUS: flow="SOURCE, l:-3 -> l[0]"
    SINK(l[1]) #$ flow="SOURCE, l:-4 -> l[1]"

@expects(2)
def test_reversed_dict():
    d = {SOURCE: "v1", NONSOURCE: "v2"}
    r = reversed(d)
    l = list(r)
    SINK_F(l[0])
    SINK(l[1]) #$ MISSING: flow="SOURCE, l:-4 -> l[1]"

### iter

def test_iter_list():
    l0 = [SOURCE]
    i = iter(l0)
    l = list(i)
    SINK(l[0]) #$ flow="SOURCE, l:-3 -> l[0]"

def test_iter_tuple():
    t = (SOURCE,)
    i = iter(t)
    l = list(i)
    SINK(l[0]) #$ flow="SOURCE, l:-3 -> l[0]"

def test_iter_set():
    t = {SOURCE}
    i = iter(t)
    l = list(i)
    SINK(l[0]) #$ flow="SOURCE, l:-3 -> l[0]"

def test_iter_dict():
    d = {SOURCE: "val"}
    i = iter(d)
    l = list(i)
    SINK(l[0]) #$ MISSING: flow="SOURCE, l:-3 -> l[0]"

def test_iter_iter():
    # applying iter() to the result of iter() is basically a no-op
    l0 = [SOURCE]
    i = iter(iter(l0))
    l = list(i)
    SINK(l[0]) #$ flow="SOURCE, l:-3 -> l[0]"

### next

def test_next_list():
    l = [SOURCE]
    i = iter(l)
    n = next(i)
    SINK(n) #$ flow="SOURCE, l:-3 -> n"

def test_next_tuple():
    t = (SOURCE,)
    i = iter(t)
    n = next(i)
    SINK(n) #$ flow="SOURCE, l:-3 -> n"

def test_next_set():
    s = {SOURCE}
    i = iter(s)
    n = next(i)
    SINK(n) #$ flow="SOURCE, l:-3 -> n"

def test_next_dict():
    d = {SOURCE: "val"}
    i = iter(d)
    n = next(i)
    SINK(n) #$ MISSING: flow="SOURCE, l:-3 -> n"

### map

@expects(4)
def test_map_list():
    l1 = [SOURCE]
    l2 = [NONSOURCE]

    def f(p1,p2):
        SINK(p1)  #$ flow="SOURCE, l:-4 -> p1"
        SINK_F(p2)

        return p1,p2

    rl = list(map(f, l1, l2))
    SINK(rl[0][0]) #$ flow="SOURCE, l:-10 -> rl[0][0]"
    SINK_F(rl[0][1])

@expects(4)
def test_map_set():
    s1 = {SOURCE}
    s2 = {NONSOURCE}

    def f(p1,p2):
        SINK(p1)  #$ flow="SOURCE, l:-4 -> p1"
        SINK_F(p2)

        return p1,p2

    rl = list(map(f, s1, s2))
    SINK(rl[0][0]) #$ flow="SOURCE, l:-10 -> rl[0][0]"
    SINK_F(rl[0][1])

@expects(4)
def test_map_tuple():
    t1 = (SOURCE,)
    t2 = (NONSOURCE,)

    def f(p1,p2):
        SINK(p1)  #$ flow="SOURCE, l:-4 -> p1"
        SINK_F(p2)

        return p1,p2

    rl = list(map(f, t1, t2))
    SINK(rl[0][0]) #$ flow="SOURCE, l:-10 -> rl[0][0]"
    SINK_F(rl[0][1])


@expects(4)
def test_map_dict():
    d1 = {SOURCE: "v1"}
    d2 = {NONSOURCE: "v2"}

    def f(p1,p2):
        SINK(p1)  #$ MISSING: flow="SOURCE, l:-4 -> p1"
        SINK_F(p2)

        return p1,p2

    rl = list(map(f, d1, d2))
    SINK(rl[0][0]) #$ MISSING: flow="SOURCE, l:-10 -> rl[0][0]"
    SINK_F(rl[0][1])

@expects(4)
def test_map_multi_list():
    l1 = [SOURCE]
    l2 = [SOURCE]

    def f(p1,p2):
        SINK(p1)  #$ flow="SOURCE, l:-4 -> p1"
        SINK(p2)  #$ flow="SOURCE, l:-4 -> p2"
        return p1,p2

    rl = list(map(f, l1, l2))
    SINK(rl[0][0]) #$ flow="SOURCE, l:-9 -> rl[0][0]"
    SINK(rl[0][1]) #$ flow="SOURCE, l:-9 -> rl[0][1]"

@expects(4)
def test_map_multi_tuple():
    l1 = (SOURCE,)
    l2 = (SOURCE,)

    def f(p1,p2):
        SINK(p1)  #$ flow="SOURCE, l:-4 -> p1"
        SINK(p2)  #$ MISSING: flow="SOURCE, l:-4 -> p2" # Tuples are not tracked beyond the first list argument for performance.
        return p1,p2

    rl = list(map(f, l1, l2))
    SINK(rl[0][0]) #$ flow="SOURCE, l:-9 -> rl[0][0]"
    SINK(rl[0][1]) #$ MISSING: flow="SOURCE, l:-9 -> rl[0][1]"

### filter 

@expects(2)
def test_filter_list():
    l = [SOURCE]

    def f(p):
        SINK(p) #$ flow="SOURCE, l:-3 -> p"
        return True 

    rl = list(filter(f,l))
    SINK(rl[0]) #$ flow="SOURCE, l:-7 -> rl[0]"

@expects(2)
def test_filter_set():
    s = {SOURCE}

    def f(p):
        SINK(p) #$ flow="SOURCE, l:-3 -> p"
        return True 

    rl = list(filter(f,s))
    SINK(rl[0]) #$ flow="SOURCE, l:-7 -> rl[0]"

@expects(2)
def test_filter_tuple():
    t = (SOURCE,)

    def f(p):
        SINK(p) #$ flow="SOURCE, l:-3 -> p"
        return True 

    rl = list(filter(f,t))
    SINK(rl[0]) #$ flow="SOURCE, l:-7 -> rl[0]"

@expects(2)
def test_filter_dict():
    d = {SOURCE: "v"}

    def f(p):
        SINK(p) #$ MISSING: flow="SOURCE, l:-3 -> p"
        return True 

    rl = list(filter(f,d))
    SINK(rl[0]) #$ MISSING: flow="SOURCE, l:-7 -> rl[0]"

@expects(1)
def test_enumerate_list():
    l = [SOURCE]

    e = list(enumerate(l))

    SINK(e[0][1]) #$ flow="SOURCE, l:-4 -> e[0][1]"

@expects(1)
def test_enumerate_set():
    s = {SOURCE}

    e = list(enumerate(s))

    SINK(e[0][1]) #$ flow="SOURCE, l:-4 -> e[0][1]"

@expects(1)
def test_enumerate_tuple():
    t = (SOURCE,)

    e = list(enumerate(t))

    SINK(e[0][1]) #$ flow="SOURCE, l:-4 -> e[0][1]"

@expects(2)
def test_enumerate_list_for():
    l = [SOURCE]

    for i, x in enumerate(l):
        SINK(x) #$ flow="SOURCE, l:-3 -> x" 

    for t in enumerate(l):
        SINK(t[1]) #$ flow="SOURCE, l:-6 -> t[1]"

@expects(1)
def test_enumerate_dict():
    d = {SOURCE:"v"}

    e = list(enumerate(d))

    SINK(e[0][1]) # $ MISSING: flow="SOURCE, l:-4 -> e[0][1]"

@expects(8)
def test_zip_list():
    l1 = [SOURCE, SOURCE]
    l2 = [SOURCE, NONSOURCE]
    l3 = [NONSOURCE, SOURCE]
    l4 = [NONSOURCE, NONSOURCE]
    
    z =  list(zip(l1,l2,l3,l4))

    SINK(z[0][0])  #$ flow="SOURCE, l:-7 -> z[0][0]"
    SINK(z[0][1])  #$ flow="SOURCE, l:-7 -> z[0][1]"
    SINK_F(z[0][2])  #$ SPURIOUS: flow="SOURCE, l:-7 -> z[0][2]"
    SINK_F(z[0][3])
    SINK(z[1][0])  #$ flow="SOURCE, l:-11 -> z[1][0]"
    SINK_F(z[1][1]) #$ SPURIOUS: flow="SOURCE, l:-11 -> z[1][1]"
    SINK(z[1][2]) #$ flow="SOURCE, l:-11 -> z[1][2]"
    SINK_F(z[1][3])

@expects(4)
def test_zip_set():
    s1 = {SOURCE}
    s2 = {NONSOURCE}
    s3 = {SOURCE}
    s4 = {NONSOURCE}
    
    z =  list(zip(s1,s2,s3,s4))

    SINK(z[0][0])  #$ flow="SOURCE, l:-7 -> z[0][0]"
    SINK_F(z[0][1])
    SINK(z[0][2]) #$ flow="SOURCE, l:-7 -> z[0][2]"
    SINK_F(z[0][3])

@expects(8)
def test_zip_tuple():
    t1 = (SOURCE, SOURCE)
    t2 = (SOURCE, NONSOURCE)
    t3 = (NONSOURCE, SOURCE)
    t4 = (NONSOURCE, NONSOURCE)
    
    z =  list(zip(t1,t2,t3,t4))

    SINK(z[0][0])  #$ flow="SOURCE, l:-7 -> z[0][0]"
    SINK(z[0][1])  #$ flow="SOURCE, l:-7 -> z[0][1]"
    SINK_F(z[0][2])  
    SINK_F(z[0][3])
    SINK(z[1][0])  #$ flow="SOURCE, l:-11 -> z[1][0]"
    SINK_F(z[1][1]) #$ SPURIOUS: flow="SOURCE, l:-11 -> z[1][1]"
    SINK(z[1][2]) #$ MISSING: flow="SOURCE, l:-11 -> z[1][2]" # Tuple contents are not tracked beyond the first two arguments for performance.
    SINK_F(z[1][3])

@expects(4)
def test_zip_dict():
    d1 = {SOURCE: "v"}
    d2 = {NONSOURCE: "v"}
    d3 = {SOURCE: "v"}
    d4 = {NONSOURCE: "v"}
    
    z =  list(zip(d1,d2,d3,d4))

    SINK(z[0][0])  #$ MISSING: flow="SOURCE, l:-7 -> z[0][0]"
    SINK_F(z[0][1]) 
    SINK(z[0][2]) #$ MISSING: flow="SOURCE, l:-7 -> z[0][2]"
    SINK_F(z[0][3])