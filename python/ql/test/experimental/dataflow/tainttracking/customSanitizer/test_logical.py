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

def is_unsafe(arg):
    return arg == TAINTED_STRING


def test_basic():
    s = TAINTED_STRING

    if is_safe(s):
        ensure_not_tainted(s)
    else:
        ensure_tainted(s) # $ tainted

    if not is_safe(s):
        ensure_tainted(s) # $ tainted
    else:
        ensure_not_tainted(s)


def test_if_in_depth():
    s = TAINTED_STRING

    # ensure that value is still considered tainted after guard check
    if is_safe(s):
        ensure_not_tainted(s)
    ensure_tainted(s) # $ tainted

    # ensure new tainted assignment to variable is not treated as safe by guard
    if is_safe(s):
        ensure_not_tainted(s)
        s = TAINTED_STRING
        ensure_tainted(s) # $ tainted


def test_or():
    s = TAINTED_STRING

    # x or y
    if is_safe(s) or random_choice():
        # might be tainted
        ensure_tainted(s) # $ tainted
    else:
        # must be tainted
        ensure_tainted(s) # $ tainted

    # not (x or y)
    if not(is_safe(s) or random_choice()):
        # must be tainted
        ensure_tainted(s) # $ tainted
    else:
        # might be tainted
        ensure_tainted(s) # $ tainted

    # not (x or y) == not x and not y   [de Morgan's laws]
    if not is_safe(s) and not random_choice():
        # must be tainted
        ensure_tainted(s) # $ tainted
    else:
        # might be tainted
        ensure_tainted(s) # $ tainted


def test_and():
    s = TAINTED_STRING

    # x and y
    if is_safe(s) and random_choice():
        # cannot be tainted
        ensure_not_tainted(s)
    else:
        # might be tainted
        ensure_tainted(s) # $ tainted

    # not (x and y)
    if not(is_safe(s) and random_choice()):
        # might be tainted
        ensure_tainted(s) # $ tainted
    else:
        # cannot be tainted
        ensure_not_tainted(s)

    # not (x and y) == not x or not y   [de Morgan's laws]
    if not is_safe(s) or not random_choice():
        # might be tainted
        ensure_tainted(s) # $ tainted
    else:
        # cannot be tainted
        ensure_not_tainted(s)


def test_tricky():
    s = TAINTED_STRING

    x = is_safe(s)
    if x:
        ensure_not_tainted(s) # $ SPURIOUS: tainted

    s_ = s
    if is_safe(s):
        ensure_not_tainted(s_) # $ SPURIOUS: tainted


def test_nesting_not():
    s = TAINTED_STRING

    if not(not(is_safe(s))):
        ensure_not_tainted(s)
    else:
        ensure_tainted(s) # $ tainted

    if not(not(not(is_safe(s)))):
        ensure_tainted(s) # $ tainted
    else:
        ensure_not_tainted(s)


# Adding `and True` makes the sanitizer trigger when it would otherwise not. See output in
# SanitizedEdges.expected and compare with `test_nesting_not` and `test_basic`
def test_nesting_not_with_and_true():
    s = TAINTED_STRING

    if not(is_safe(s) and True):
        ensure_tainted(s) # $ tainted
    else:
        ensure_not_tainted(s)

    if not(not(is_safe(s) and True)):
        ensure_not_tainted(s)
    else:
        ensure_tainted(s) # $ tainted

    if not(not(not(is_safe(s) and True))):
        ensure_tainted(s) # $ tainted
    else:
        ensure_not_tainted(s)


def test_with_return():
    s = TAINTED_STRING

    if not is_safe(s):
        return

    ensure_not_tainted(s)


def test_with_return_neg():
    s = TAINTED_STRING

    if is_unsafe(s):
        return

    ensure_not_tainted(s)


def test_with_exception():
    s = TAINTED_STRING

    if not is_safe(s):
        raise Exception("unsafe")

    ensure_not_tainted(s)

def test_with_exception_neg():
    s = TAINTED_STRING

    if is_unsafe(s):
        raise Exception("unsafe")

    ensure_not_tainted(s)

# Make tests runable

test_basic()
test_if_in_depth()
test_or()
test_and()
test_tricky()
test_nesting_not()
test_nesting_not_with_and_true()
test_with_return()
test_with_return_neg()
try:
    test_with_exception()
except:
    pass
try:
    test_with_exception_neg()
except:
    pass
