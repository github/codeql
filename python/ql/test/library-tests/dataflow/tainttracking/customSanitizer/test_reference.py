import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

"""Testing logical constructs not/and/or works out of the box.
"""

import random


def random_choice():
    return bool(random.randint(0, 1))


def is_safe(arg):
    return arg == "safe"


def test_basic():
    s = TAINTED_STRING
    s2 = s

    if is_safe(s):
        ensure_not_tainted(s, s2) # $ SPURIOUS: tainted
    else:
        ensure_tainted(s, s2) # $ tainted


def test_identical_call():
    """This code pattern is being used in real world code"""
    s = TAINTED_STRING

    if is_safe(s.strip()):
        ensure_not_tainted(s.strip()) # $ SPURIOUS: tainted
    else:
        ensure_tainted(s.strip()) # $ tainted


class C(object):
    def __init__(self, value):
        self.foo = value


def test_class_attribute_access():
    s = TAINTED_STRING
    c = C(s)

    if is_safe(c.foo):
        ensure_not_tainted(c.foo) # $ SPURIOUS: tainted
    else:
        ensure_tainted(c.foo) # $ tainted


# Make tests runable

test_basic()
test_identical_call()
test_class_attribute_access()
