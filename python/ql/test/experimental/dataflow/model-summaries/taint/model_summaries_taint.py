
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


from Foo import MS_identity, MS_apply_lambda, MS_reversed, MS_list_map, MS_append_to_list

# Simple summary
tainted = MS_identity(SOURCE)
SINK(tainted)  # $ flow="SOURCE, l:-1 -> tainted"

# Lambda summary
tainted_lambda = MS_apply_lambda(lambda x: x + 1, SOURCE)
SINK(tainted_lambda)  # $ flow="SOURCE, l:-1 -> tainted_lambda"

# A lambda that breaks the flow
untainted_lambda = MS_apply_lambda(lambda x: 1, SOURCE)
SINK_F(untainted_lambda)

# Collection summaries
tainted_list = MS_reversed([SOURCE])
SINK(tainted_list[0])  # $ flow="SOURCE, l:-1 -> tainted_list[0]"

# Complex summaries
def add_colon(x):
    return x + ":"

tainted_mapped = MS_list_map(add_colon, [SOURCE])
SINK(tainted_mapped[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped[0]"

def explicit_identity(x):
    return x

tainted_mapped_explicit = MS_list_map(explicit_identity, [SOURCE])
SINK(tainted_mapped_explicit[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped_explicit[0]"

tainted_mapped_summary = MS_list_map(MS_identity, [SOURCE])
SINK(tainted_mapped_summary[0])  # $ flow="SOURCE, l:-1 -> tainted_mapped_summary[0]"

tainted_list = MS_append_to_list([SOURCE], NONSOURCE)
SINK(tainted_list[0])  # $ flow="SOURCE, l:-1 -> tainted_list[0]"

from json import MS_loads as json_loads
tainted_resultlist = json_loads(SOURCE)
SINK(tainted_resultlist[0])  # $ flow="SOURCE, l:-1 -> tainted_resultlist[0]"
