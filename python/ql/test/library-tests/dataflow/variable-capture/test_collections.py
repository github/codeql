# Here we test the case where a captured variable is being read.

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

l = [NONSOURCE]
SINK_F(l[0])

l_mod = [SOURCE for x in l]
SINK(l_mod[0]) #$ captured

l_mod_lambda = [(lambda a : SOURCE)(x) for x in l]
SINK(l_mod_lambda[0]) #$ captured

def mod(x):
    return SOURCE

l_mod_function = [mod(x) for x in l]
SINK(l_mod_function[0]) #$ captured

def mod_list(l):
    def mod_local(x):
        return SOURCE

    return [mod_local(x) for x in l]

l_modded = mod_list(l)
SINK(l_modded[0]) #$ captured

def mod_list_first(l):
    def mod_local(x):
        return SOURCE

    return [mod_local(l[0])]

l_modded_first = mod_list_first(l)
SINK(l_modded_first[0]) #$ captured
