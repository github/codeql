# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

def unpacking():
    l = TAINTED_LIST[0:3]
    a, b, c = l
    ensure_tainted(a, b, c)


def unpacking_to_list():
    l = TAINTED_LIST[0:3]
    [a, b, c] = l
    ensure_tainted(a, b, c)


def nested():
    l = TAINTED_LIST[0:3]
    ll = [l, l, l]

    # list
    [[a1, a2, a3], b, c] = ll
    ensure_tainted(a1, a2, a3, b, c)

    # tuple
    ((a1, a2, a3), b, c) = ll
    ensure_tainted(a1, a2, a3, b, c)

    # mixed
    [(a1, a2, a3), b, c] = ll
    ensure_tainted(a1, a2, a3, b, c)


def unpack_from_set():
    # no guarantee on ordering ... don't know why you would ever do this
    a, b, c = {"foo", "bar", TAINTED_STRING}
    # either all should be tainted, or none of them
    ensure_tainted(a, b, c)


def contrived_1():
    # A contrived example. Don't know why anyone would ever actually do this.
    tainted_list = TAINTED_LIST[0:3]
    no_taint_list = [1,2,3]

    (a, b, c), (d, e, f) = tainted_list, no_taint_list
    ensure_tainted(a, b, c)
    ensure_not_tainted(d, e, f) # FP: we mark `d`, `e` and `f` as tainted.


def contrived_2():
    # A contrived example. Don't know why anyone would ever actually do this.

    # Old taint tracking was only able to handle taint nested 2 levels in sequences,
    # so would not mark a, b, c as tainted
    [[[ (a, b, c) ]]] = [[[ TAINTED_LIST[0:3] ]]]
    ensure_tainted(a, b, c)


# Make tests runable

unpacking()
unpacking_to_list()
nested()
unpack_from_set()
contrived_1()
contrived_2()
