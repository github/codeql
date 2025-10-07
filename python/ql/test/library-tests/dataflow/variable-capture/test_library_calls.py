# Here we test the case where a captured variable is being written inside a library call.

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

# Actual tests start here

@expects(2)
def test_library_call():
    captured = {"x": NONSOURCE}

    def set(x):
        captured["x"] = SOURCE
        return x

    SINK_F(captured["x"])

    for x in map(set, [1]):
        pass

    SINK(captured["x"]) #$ captured
