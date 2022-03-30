# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

def test_eq():
    ts = TAINTED_STRING
    if ts == "safe":
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts) # $ tainted
    # ts should still be tainted after exiting the if block
    ensure_tainted(ts) # $ tainted


def test_eq_unsafe(x="foo"):
    """This test-case might seem strange, but it was a FP in our old points-to based analysis."""
    ts = TAINTED_STRING
    if ts == ts:
        ensure_tainted(ts) # $ tainted
    if ts == x:
        ensure_tainted(ts) # $ tainted


def test_eq_with_or():
    ts = TAINTED_STRING
    if ts == "safe" or ts == "also_safe":
        ensure_not_tainted(ts) # $ SPURIOUS: tainted
    else:
        ensure_tainted(ts) # $ tainted


def test_non_eq1():
    ts = TAINTED_STRING
    if ts != "safe":
        ensure_tainted(ts) # $ tainted
    else:
        ensure_not_tainted(ts)


def test_non_eq2():
    ts = TAINTED_STRING
    if not ts == "safe":
        ensure_tainted(ts) # $ tainted
    else:
        ensure_not_tainted(ts) # $ SPURIOUS: tainted


def test_in_list():
    ts = TAINTED_STRING
    if ts in ["safe", "also_safe"]:
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts) # $ tainted


def test_in_tuple():
    ts = TAINTED_STRING
    if ts in ("safe", "also_safe"):
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts) # $ tainted


def test_in_set():
    ts = TAINTED_STRING
    if ts in {"safe", "also_safe"}:
        ensure_not_tainted(ts)
    else:
        ensure_tainted(ts) # $ tainted


def test_in_local_variable():
    ts = TAINTED_STRING
    safe = ["safe", "also_safe"]
    if ts in safe:
        ensure_not_tainted(ts) # $ SPURIOUS: tainted
    else:
        ensure_tainted(ts) # $ tainted


SAFE = ["safe", "also_safe"]


def test_in_global_variable():
    ts = TAINTED_STRING
    if ts in SAFE:
        ensure_not_tainted(ts) # $ SPURIOUS: tainted
    else:
        ensure_tainted(ts) # $ tainted


# these global variables can be modified, so should not be considered safe
SAFE_mod_1 = ["safe", "also_safe"]
SAFE_mod_2 = ["safe", "also_safe"]
SAFE_mod_3 = ["safe", "also_safe"]


def make_modification(x):
    global SAFE_mod_2, SAFE_mod_3
    SAFE_mod_1.append(x)
    SAFE_mod_2 += [x]
    SAFE_mod_3 = SAFE_mod_3 + [x]


def test_in_modified_global_variable():
    ts = TAINTED_STRING
    if ts in SAFE_mod_1:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_tainted(ts) # $ tainted

    if ts in SAFE_mod_2:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_tainted(ts) # $ tainted

    if ts in SAFE_mod_3:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_tainted(ts) # $ tainted


def test_in_unsafe1(xs):
    ts = TAINTED_STRING
    if ts in xs:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_tainted(ts) # $ tainted


def test_in_unsafe2(x):
    ts = TAINTED_STRING
    if ts in ["safe", x]:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_tainted(ts) # $ tainted


def test_not_in1():
    ts = TAINTED_STRING
    if ts not in ["safe", "also_safe"]:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_not_tainted(ts)


def test_not_in2():
    ts = TAINTED_STRING
    if not ts in ["safe", "also_safe"]:
        ensure_tainted(ts) # $ tainted
    else:
        ensure_not_tainted(ts) # $ SPURIOUS: tainted


def is_safe(x):
    return x == "safe"


def test_eq_thorugh_func():
    ts = TAINTED_STRING
    if is_safe(ts):
        ensure_not_tainted(ts) # $ SPURIOUS: tainted
    else:
        ensure_tainted(ts) # $ tainted


# Make tests runable

test_eq()
test_eq_unsafe()
test_eq_with_or()
test_non_eq1()
test_non_eq2()
test_in_list()
test_in_tuple()
test_in_set()
test_in_local_variable()
test_in_global_variable()
make_modification("unsafe")
test_in_modified_global_variable()
test_in_unsafe1(["unsafe", "foo"])
test_in_unsafe2("unsafe")
test_not_in1()
test_not_in2()
test_eq_thorugh_func()
