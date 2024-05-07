# Here we test writing to a captured variable via a dictionary (see `out`).
# We also test reading one captured variable and writing the value to another (see `through`).

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


def out():
    sinkO1 = { "x": "" }
    def captureOut1():
        sinkO1["x"] = SOURCE
    captureOut1()
    SINK(sinkO1["x"]) #$ captured

    sinkO2 = { "x": "" }
    def captureOut2():
        def m():
            sinkO2["x"] = SOURCE
        m()
    captureOut2()
    SINK(sinkO2["x"]) #$ captured

    nonSink0 = { "x": "" }
    def captureOut1NotCalled():
        nonSink0["x"] = SOURCE
    SINK_F(nonSink0["x"])

    def captureOut2NotCalled():
        def m():
            nonSink0["x"] = SOURCE
    captureOut2NotCalled()
    SINK_F(nonSink0["x"])

@expects(4)
def test_out():
    out()

def through(tainted):
    sinkO1 = { "x": "" }
    def captureOut1():
        sinkO1["x"] = tainted
    captureOut1()
    SINK(sinkO1["x"]) #$ captured

    sinkO2 = { "x": "" }
    def captureOut2():
        def m():
            sinkO2["x"] = tainted
        m()
    captureOut2()
    SINK(sinkO2["x"]) #$ captured

    nonSink1 = { "x": "" }
    def captureOut1NotCalled():
        nonSink1["x"] = tainted
    SINK_F(nonSink1["x"])

    nonSink2 = { "x": "" }
    def captureOut2NotCalled():
        # notice that `m` is not called
        def m():
            nonSink2["x"] = tainted
    captureOut2NotCalled()
    SINK_F(nonSink2["x"])

@expects(4)
def test_through():
    through(SOURCE)
