# Python 2 specific tests, like the one in coverage/classes.py
#
# User-defined methods, both instance methods and class methods, can be called in many non-standard ways
# i.e. differently from simply `c.f()` or `C.f()`. For example, a user-defined `__await__` method on a
# class `C` will be called by the syntactic construct `await c` when `c` is an instance of `C`.
#
# These tests should cover all the class calls that we hope to support.
# It is based on https://docs.python.org/3/reference/datamodel.html, and headings refer there.
#
# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects


def SINK1(x):
    pass


def SINK2(x):
    pass


def SINK3(x):
    pass


def SINK4(x):
    pass


def OK():
    print("OK")


# 3.3.8. Emulating numeric types

# object.__index__(self)
class With_index:
    def __index__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_index():
    import operator

    with_index = With_index()  #$ MISSING: arg1="SSA variable with_index" func=With_index.__index__
    operator.index(with_index)
