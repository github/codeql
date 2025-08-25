
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


# Simple summary
tainted = identity(SOURCE)
SINK(tainted)  # $ flow="SOURCE, l:-1 -> tainted"

# Lambda summary
tainted_lambda = apply_lambda(lambda x: x + 1, SOURCE)
SINK(tainted_lambda)  # $ flow="SOURCE, l:-1 -> tainted_lambda"

# A lambda that breaks the flow
untainted_lambda = apply_lambda(lambda x: 1, SOURCE)
SINK_F(untainted_lambda)

# Collection summaries
tainted_list = reversed([SOURCE])
SINK(tainted_list[0])  # $ flow="SOURCE, l:-1 -> tainted_list[0]"

# Complex summaries
def add_colon(x):
    return x + ":"

tainted_mapped = list_map(add_colon, [SOURCE])
SINK(tainted_mapped[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped[0]"

def explicit_identity(x):
    return x

tainted_mapped_explicit = list_map(explicit_identity, [SOURCE])
SINK(tainted_mapped_explicit[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped_explicit[0]"

tainted_mapped_summary = list_map(identity, [SOURCE])
SINK(tainted_mapped_summary[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped_summary[0]"

tainted_list = append_to_list([], SOURCE)
SINK(tainted_list[0])  # $ flow="SOURCE, l:-1 -> tainted_list[0]"

from json import loads as json_loads
tainted_resultlist = json_loads(SOURCE)
SINK(tainted_resultlist[0])  # $ flow="SOURCE, l:-1 -> tainted_resultlist[0]"


# Class methods are not handled right now

class MyClass:
    @staticmethod
    def foo(x):
        return x

    def bar(self, x):
        return x

through_staticmethod = apply_lambda(MyClass.foo, SOURCE)
through_staticmethod  # $ MISSING: flow

mc = MyClass()
through_method = apply_lambda(mc.bar, SOURCE)
through_method  # $ MISSING: flow
