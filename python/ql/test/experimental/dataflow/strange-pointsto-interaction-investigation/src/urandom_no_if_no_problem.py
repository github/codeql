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

# ------------------------------------------------------------------------------
# Actual tests
# ------------------------------------------------------------------------------

def give_src():
    return SOURCE

foo = give_src()
SINK(foo) # $ flow="SOURCE, l:-3 -> foo"

import os
cond = os.urandom(1)[0] > 128 # $ unresolved_call=os.urandom(..)

# if cond:
#     pass
#
# if cond:
#     pass

foo = give_src()
SINK(foo) # $ flow="SOURCE, l:-15 -> foo"
