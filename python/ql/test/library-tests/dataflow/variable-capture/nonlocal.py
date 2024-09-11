# Here we test writing to a captured variable via the `nonlocal` keyword (see `out`).
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
    sinkO1 = ""
    def captureOut1():
        nonlocal sinkO1
        sinkO1 = SOURCE
    captureOut1()
    SINK(sinkO1) #$ captured

    sinkO2 = ""
    def captureOut2():
        def m():
            nonlocal sinkO2
            sinkO2 = SOURCE
        m()
    captureOut2()
    SINK(sinkO2) #$ captured

    nonSink1 = ""
    def captureOut1NotCalled():
        nonlocal nonSink1
        nonSink1 = SOURCE
    SINK_F(nonSink1)

    nonSink2 = ""
    def captureOut2NotCalled():
        # notice that `m` is not called
        def m():
            nonlocal nonSink2
            nonSink2 = SOURCE
    captureOut2NotCalled()
    SINK_F(nonSink2)

@expects(4)
def test_out():
    out()

def through(tainted):
    sinkO1 = ""
    def captureOut1():
        nonlocal sinkO1
        sinkO1 = tainted
    captureOut1()
    SINK(sinkO1) #$ captured

    sinkO2 = ""
    def captureOut2():
        def m():
            nonlocal sinkO2
            sinkO2 = tainted
        m()
    captureOut2()
    SINK(sinkO2) #$ captured

    nonSink1 = ""
    def captureOut1NotCalled():
        nonlocal nonSink1
        nonSink1 = tainted
    SINK_F(nonSink1)

    nonSink2 = ""
    def captureOut2NotCalled():
        # notice that `m` is not called
        def m():
            nonlocal nonSink2
            nonSink2 = tainted
    captureOut2NotCalled()
    SINK_F(nonSink2)

@expects(4)
def test_through():
    through(SOURCE)
