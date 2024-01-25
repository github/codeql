
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

from foo import MS_identity, MS_apply_lambda, MS_reversed, MS_list_map, MS_append_to_list

# Simple summary
via_identity = MS_identity(SOURCE)
SINK(via_identity)  # $ flow="SOURCE, l:-1 -> via_identity"

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
