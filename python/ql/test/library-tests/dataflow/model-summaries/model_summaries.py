
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

ensure_tainted = ensure_not_tainted = print
TAINTED_STRING = "TAINTED_STRING"

from foo import MS_identity, MS_apply_lambda, MS_reversed, MS_list_map, MS_append_to_list, MS_spread, MS_spread_all, Impl

# Simple summary
via_identity = MS_identity(SOURCE)
SINK(via_identity)  # $ flow="SOURCE, l:-1 -> via_identity"

# Simple summary keyword
via_identity_kw = MS_identity(x = SOURCE)
SINK(via_identity_kw)  # $ flow="SOURCE, l:-1 -> via_identity_kw"

# Lambda summary
via_lambda = MS_apply_lambda(lambda x: [x], SOURCE)
SINK(via_lambda[0])  # $ flow="SOURCE, l:-1 -> via_lambda[0]"

# A lambda that breaks the flow
not_via_lambda = MS_apply_lambda(lambda x: 1, SOURCE)
SINK_F(not_via_lambda)


# Collection summaries
via_reversed = MS_reversed([SOURCE])
SINK(via_reversed[0])  # $ flow="SOURCE, l:-1 -> via_reversed[0]"

tainted_list = MS_reversed(TAINTED_LIST)
ensure_tainted(
    tainted_list,  # $ tainted
    tainted_list[0],  # $ tainted
)

# Complex summaries
def box(x):
    return [x]

via_map = MS_list_map(box, [SOURCE])
SINK(via_map[0][0])  # $ flow="SOURCE, l:-1 -> via_map[0][0]"

tainted_mapped = MS_list_map(box, TAINTED_LIST)
ensure_tainted(
    tainted_mapped,  # $ tainted
    tainted_mapped[0][0],  # $ tainted
)

def explicit_identity(x):
    return x

via_map_explicit = MS_list_map(explicit_identity, [SOURCE])
SINK(via_map_explicit[0])  # $ flow="SOURCE, l:-1 -> via_map_explicit[0]"

tainted_mapped_explicit = MS_list_map(explicit_identity, TAINTED_LIST)
ensure_tainted(
    tainted_mapped_explicit,  # $ tainted
    tainted_mapped_explicit[0],  # $ tainted
)

via_map_summary = MS_list_map(MS_identity, [SOURCE])
SINK(via_map_summary[0])  # $ flow="SOURCE, l:-1 -> via_map_summary[0]"

tainted_mapped_summary = MS_list_map(MS_identity, TAINTED_LIST)
ensure_tainted(
    tainted_mapped_summary,  # $ tainted
    tainted_mapped_summary[0],  # $ tainted
)

via_append_el = MS_append_to_list([], SOURCE)
SINK(via_append_el[0])  # $ flow="SOURCE, l:-1 -> via_append_el[0]"

tainted_list_el = MS_append_to_list([], TAINTED_STRING)
ensure_tainted(
    tainted_list_el,  # $ tainted
    tainted_list_el[0],  # $ tainted
)

via_append = MS_append_to_list([SOURCE], NONSOURCE)
SINK(via_append[0])  # $ flow="SOURCE, l:-1 -> via_append[0]"

tainted_list_implicit = MS_append_to_list(TAINTED_LIST, NONSOURCE)
ensure_tainted(
    tainted_list,  # $ tainted
    tainted_list[0],  # $ tainted
)

a, b = MS_spread(SOURCE, NONSOURCE)
SINK(a)  # $ flow="SOURCE, l:-1 -> a"
SINK_F(b)
x, y = MS_spread(NONSOURCE, SOURCE)
SINK_F(x)
SINK(y)  # $ flow="SOURCE, l:-2 -> y"

a, b = MS_spread_all(SOURCE)
SINK(a)  # $ flow="SOURCE, l:-1 -> a"
SINK(b)  # $ flow="SOURCE, l:-2 -> b"

from foo import MS_Class, MS_Class_transitive, get_instance, get_class, MS_Factory

# Class summaries
class_via_positional = MS_Class(SOURCE)
SINK(class_via_positional.config)  # $ flow="SOURCE, l:-1 -> class_via_positional.config"

class_via_kw = MS_Class(x = SOURCE)
SINK(class_via_kw.config)  # $ flow="SOURCE, l:-1 -> class_via_kw.config"

class C(MS_Class_transitive):
    pass

subclass_via_positional = C(SOURCE)
SINK(subclass_via_positional.config)  # $ flow="SOURCE, l:-1 -> subclass_via_positional.config"

subclass_via_kw = C(x = SOURCE)
SINK(subclass_via_kw.config)  # $ flow="SOURCE, l:-1 -> subclass_via_kw.config"

SINK(subclass_via_kw.instance_method(SOURCE))  # $ flow="SOURCE -> subclass_via_kw.instance_method(..)"

class D(MS_Class_transitive):
    def __init__(x, y):
        # special handling of y
        super().__init__(x)

SINK(D(SOURCE, NONSOURCE).config)  # $ flow="SOURCE -> D(..).config"
SINK(D(x = SOURCE, y = NONSOURCE).config)  # $ flow="SOURCE -> D(..).config"

class E(MS_Class_transitive):
    # Notice the swapped order of the arguments
    def __init__(y, x):
        # special handling of y
        super().__init__(x)

SINK(E(NONSOURCE, SOURCE).config)  # $ MISSING: flow="SOURCE -> E(..).config"
SINK(E(x = SOURCE, y = NONSOURCE).config)  # $ flow="SOURCE -> E(..).config"

c = MS_Class()
a, b = c.instance_method(SOURCE)
SINK_F(a)
SINK(b)  # $ flow="SOURCE, l:-2 -> b"

# Call the instance method on the class to expose the self argument
x, y = MS_Class.instance_method(SOURCE, NONSOURCE)
SINK(x)  # $ MISSING: flow="SOURCE, l:-1 -> x"
SINK_F(y)

# Call the instance method on the class to expose the self argument
# That self argument is not referenced by `Argument[self:]`
SINK_F(MS_Class.explicit_self(SOURCE))
# Instead, `Argument[self:]` refers to a keyword argument named `self` (which you are allowed to do in Python)
SINK(c.explicit_self(self = SOURCE))  # $ flow="SOURCE -> c.explicit_self(..)"


instance = get_instance()
SINK(instance.instance_method(SOURCE)[1])  # $ flow="SOURCE -> instance.instance_method(..)[1]"

returned_class = get_class()
SINK(returned_class(SOURCE).config)  # $ flow="SOURCE -> returned_class(..).config"

SINK(returned_class().instance_method(SOURCE)[1])  # $flow="SOURCE -> returned_class().instance_method(..)[1]"

fatory_instance = MS_Factory.get_instance()
SINK(fatory_instance.instance_method(SOURCE)[1])  # $ flow="SOURCE -> fatory_instance.instance_method(..)[1]"

factory = MS_Factory()
SINK(factory.make().instance_method(SOURCE)[1])  # $ flow="SOURCE -> factory.make().instance_method(..)[1]"

also_instance = Impl.MS_Class_Impl()
SINK(also_instance.instance_method(SOURCE)[1])  # $ flow="SOURCE -> also_instance.instance_method(..)[1]"

# Modeled flow-summary is not value preserving
from json import MS_loads as json_loads

# so no data-flow
SINK_F(json_loads(SOURCE))
SINK_F(json_loads(SOURCE)[0])

# but has taint-flow
tainted_resultlist = json_loads(TAINTED_STRING)
ensure_tainted(
    tainted_resultlist,  # $ tainted
    tainted_resultlist[0], # $ tainted
)
