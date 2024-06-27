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

# Capture the parameter of an outer function.
def inParam(tainted):
    def captureIn1():
        sinkI1 = tainted
        SINK(sinkI1) #$ captured
    captureIn1()

    def captureIn2():
        def m():
            sinkI2 = tainted
            SINK(sinkI2) #$ captured
        m()
    captureIn2()

    captureIn3 = lambda arg: SINK(tainted) #$ captured
    captureIn3("")

    def captureIn1NotCalled():
        nonSink1 = tainted
        SINK_F(nonSink1)

    def captureIn2NotCalled():
        # notice that `m` is not called
        def m():
            nonSink1 = tainted
            SINK_F(nonSink1)
    captureIn2NotCalled()

@expects(3)
def test_inParam():
    inParam(SOURCE)

# Capture the local variable of an outer function.
def inLocal():
    tainted = SOURCE

    def captureIn1():
        sinkI1 = tainted
        SINK(sinkI1) #$ captured
    captureIn1()

    def captureIn2():
        def m():
            sinkI2 = tainted
            SINK(sinkI2) #$ captured
        m()
    captureIn2()

    captureIn3 = lambda arg: SINK(tainted) #$ captured
    captureIn3("")

    def captureIn1NotCalled():
        nonSink1 = tainted
        SINK_F(nonSink1)

    def captureIn2NotCalled():
        # notice that `m` is not called
        def m():
            nonSink2 = tainted
            SINK_F(nonSink2)
    captureIn2NotCalled()

@expects(3)
def test_inLocal():
    inLocal()
