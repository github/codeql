# Here we test writing to a captured global variable via the `global` keyword (see `out`).
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


sinkO1 = ""
sinkO2 = ""
nonSink1 = ""
nonSink2 = ""

def out():
    def captureOut1():
        global sinkO1
        sinkO1 = SOURCE
    captureOut1()
    SINK(sinkO1) #$ captured

    def captureOut2():
        def m():
            global sinkO2
            sinkO2 = SOURCE
        m()
    captureOut2()
    SINK(sinkO2) #$ captured

    def captureOut1NotCalled():
        global nonSink1
        nonSink1 = SOURCE
    SINK_F(nonSink1) #$ SPURIOUS: captured

    def captureOut2NotCalled():
        # notice that `m` is not called
        def m():
            global nonSink2
            nonSink2 = SOURCE
    captureOut2NotCalled()
    SINK_F(nonSink2) #$ SPURIOUS: captured

@expects(4)
def test_out():
    out()

sinkT1 = ""
sinkT2 = ""
nonSinkT1 = ""
nonSinkT2 = ""
def through(tainted):
    def captureOut1():
        global sinkT1
        sinkT1 = tainted
    captureOut1()
    SINK(sinkT1) #$ captured

    def captureOut2():
        def m():
            global sinkT2
            sinkT2 = tainted
        m()
    captureOut2()
    SINK(sinkT2) #$ captured

    def captureOut1NotCalled():
        global nonSinkT1
        nonSinkT1 = tainted
    SINK_F(nonSinkT1)

    def captureOut2NotCalled():
        # notice that `m` is not called
        def m():
            global nonSinkT2
            nonSinkT2 = tainted
    captureOut2NotCalled()
    SINK_F(nonSinkT2)

@expects(4)
def test_through():
    through(SOURCE)
