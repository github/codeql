# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

class Context:
    def __enter__(self):
        return TAINTED_STRING

    def __exit__(self, exc_type, exc, tb):
        pass

def test_with():
    ctx = Context()
    taint(ctx)
    with ctx as tainted:
        ensure_tainted(tainted) # $ tainted


class Iter:
    def __iter__(self):
        return self

    def __next__(self):
        raise StopIteration

def test_for():
    iter = Iter()
    taint(iter)
    for tainted in iter:
        ensure_tainted(tainted) # $ tainted



# Make tests runable

test_with()
test_for()
