# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

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


def Out():
    sinkO1 = ""
    def captureOut1():
        nonlocal sinkO1
        sinkO1 = "source"
    captureOut1()
    SINK(sinkO1) #$ MISSING:captured

    sinkO2 = ""
    def captureOut2():
        def m():
            nonlocal sinkO2
            sinkO2 = "source"
        m()
    captureOut2()
    SINK(sinkO2) #$ MISSING:captured

    nonSink0 = ""
    def captureOut1NotCalled():
        nonlocal nonSink0
        nonSink0 = "source"
    SINK_F(nonSink0)

    def captureOut2NotCalled():
        def m():
            nonlocal nonSink0
            nonSink0 = "source"
    captureOut2NotCalled()
    SINK_F(nonSink0)

@expects(4)
def test_Out():
    Out()

def Through(tainted):
    sinkO1 = ""
    def captureOut1():
        nonlocal sinkO1
        sinkO1 = tainted
    captureOut1()
    SINK(sinkO1) #$ MISSING:captured

    sinkO2 = ""
    def captureOut2():
        def m():
            nonlocal sinkO2
            sinkO2 = tainted
        m()
    captureOut2()
    SINK(sinkO2) #$ MISSING:captured

    nonSink0 = ""
    def captureOut1NotCalled():
        nonlocal nonSink0
        nonSink0 = tainted
    SINK_F(nonSink0)

    def captureOut2NotCalled():
        def m():
            nonlocal nonSink0
            nonSink0 = tainted
    captureOut2NotCalled()
    SINK_F(nonSink0)

@expects(4)
def test_Through():
    Through(SOURCE)
