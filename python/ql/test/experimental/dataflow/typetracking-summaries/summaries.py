
import sys
import os

# Simple summary
tainted = identity(tracked)  # $ tracked
tainted  # $ tracked

# Lambda summary
# I think the missing result is expected because type tracking
# is not allowed to flow back out of a call.
tainted_lambda = apply_lambda(lambda x: x, tracked)  # $ tracked
tainted_lambda  # $ MISSING: tracked

# A lambda that directly introduces taint
bad_lambda = apply_lambda(lambda x: tracked, 1)  # $ tracked
bad_lambda  # $ tracked

# A lambda that breaks the flow
untainted_lambda = apply_lambda(lambda x: 1, tracked)  # $ tracked
untainted_lambda

# Collection summaries
tainted_list = reversed([tracked])  # $ tracked
tl = tainted_list[0]
tl  # $ MISSING: tracked

# Complex summaries
def add_colon(x):
    return x + ":"

tainted_mapped = list_map(add_colon, [tracked])  # $ tracked
tm = tainted_mapped[0]
tm  # $ MISSING: tracked

def explicit_identity(x):
    return x

tainted_mapped_explicit = list_map(explicit_identity, [tracked])  # $ tracked
tainted_mapped_explicit[0]  # $ MISSING: tracked

tainted_mapped_summary = list_map(identity, [tracked])  # $ tracked
tms = tainted_mapped_summary[0]
tms  # $ MISSING: tracked

another_tainted_list = append_to_list([], tracked)  # $ tracked
atl = another_tainted_list[0]
atl  # $ MISSING: tracked

from json import loads as json_loads
tainted_resultlist = json_loads(tracked)  # $ tracked
tr = tainted_resultlist[0]
tr  # $ MISSING: tracked
