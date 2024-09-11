import sys
import os

# Simple summary
tainted = TTS_identity(tracked)  # $ tracked
tainted  # $ tracked

# Lambda summary
tainted_lambda = TTS_apply_lambda(lambda x: x, tracked)  # $ tracked
tainted_lambda  # $ tracked

# A lambda that directly introduces taint
bad_lambda = TTS_apply_lambda(lambda x: tracked, 1)  # $ tracked
bad_lambda  # $ tracked

# A lambda that breaks the flow
untainted_lambda = TTS_apply_lambda(lambda x: 1, tracked)  # $ tracked
untainted_lambda

# Collection summaries
tainted_list = TTS_reversed([tracked])  # $ tracked
tl = tainted_list[0]
tl  # $ MISSING: tracked

# Complex summaries
def add_colon(x):
    return x + ":"

tainted_mapped = TTS_list_map(add_colon, [tracked])  # $ tracked
tm = tainted_mapped[0]
tm  # $ MISSING: tracked

def explicit_identity(x):
    return x

tainted_mapped_explicit = TTS_list_map(explicit_identity, [tracked])  # $ tracked
tainted_mapped_explicit[0]  # $ MISSING: tracked

tainted_mapped_summary = TTS_list_map(identity, [tracked])  # $ tracked
tms = tainted_mapped_summary[0]
tms  # $ MISSING: tracked

another_tainted_list = TTS_append_to_list([], tracked)  # $ tracked
atl = another_tainted_list[0]
atl  # $ MISSING: tracked

# This will not work, as the call is not found by `getACallSimple`.
from json import loads as json_loads
tainted_resultlist = json_loads(tracked)  # $ tracked
tr = tainted_resultlist[0]
tr  # $ MISSING: tracked

x.secret = tracked # $ tracked=secret tracked
r = TTS_read_secret(x) # $ tracked=secret tracked
r  # $ tracked

y # $ tracked=secret
TTS_set_secret(y, tracked) # $ tracked tracked=secret
y.secret  # $ tracked tracked=secret

# Class methods are not handled right now

class MyClass:
    @staticmethod
    def foo(x):
        return x

    def bar(self, x):
        return x

through_staticmethod = TTS_apply_lambda(MyClass.foo, tracked)  # $ tracked
through_staticmethod  # $ MISSING: tracked

mc = MyClass()
through_method = TTS_apply_lambda(mc.bar, tracked)  # $ tracked
through_method  # $ MISSING: tracked
