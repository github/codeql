
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import *

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


def test_tuple():
    match (NONSOURCE, SOURCE):
        case x, y:
            SINK_F(x)
            SINK(y) #$ flow="SOURCE, l:-3 -> y"
