# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

def const_eq_clears_taint():
    ts = TAINTED_STRING
    if ts == "safe":
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts)
    # ts should still be tainted after exiting the if block
    ensure_tainted(ts)


def const_eq_clears_taint2():
    ts = TAINTED_STRING
    if ts != "safe":
        return
    ensure_not_tainted(ts)


def non_const_eq_preserves_taint(x="foo"):
    ts = TAINTED_STRING
    if ts == ts:
        ensure_tainted(ts)
    if ts == x:
        ensure_tainted(ts)


def is_safe(x):
    return x == "safe"


def const_eq_through_func():
    ts = TAINTED_STRING
    if is_safe(ts):
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts)
    # ts should still be tainted after exiting the if block
    ensure_tainted(ts)


# Make tests runable

const_eq_clears_taint()
const_eq_clears_taint2()
non_const_eq_preserves_taint()
