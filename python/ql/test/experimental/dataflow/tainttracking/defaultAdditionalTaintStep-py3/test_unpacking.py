# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *

# Actual tests

# Extended Iterable Unpacking -- PEP 3132
# https://www.python.org/dev/peps/pep-3132/


def extended_unpacking():
    first, *rest, last = TAINTED_LIST
    ensure_tainted(first, rest, last)


def also_allowed():
    *a, = TAINTED_LIST
    ensure_tainted(a)

    # for b, *c in [(1, 2, 3), (4, 5, 6, 7)]:
        # print(c)
        # i=0; c=[2,3]
        # i=1; c=[5,6,7]

    for b, *c in [TAINTED_LIST, TAINTED_LIST]:
        ensure_tainted(b, c)


def nested():
    l = TAINTED_LIST
    ll = [l,l]

    [[x, *xs], ys] = ll
    ensure_tainted(x, xs, ys)


# Make tests runable

extended_unpacking()
also_allowed()
nested()
