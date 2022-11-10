# This should cover all the syntactical constructs that we hope to support.
# Headings refer to https://docs.python.org/3/reference/expressions.html,
# and are selected whenever they incur dataflow.
# Intended sources should be the variable `SOURCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).
#
# Functions whose name ends with "_with_local_flow" will also be tested for local flow.
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

def test_as_binding():
    try:
        e_with_source = Exception()
        e_with_source.a = SOURCE
        raise e_with_source
    except Exception as e:
        SINK(e.a) # $ MISSING: flow
