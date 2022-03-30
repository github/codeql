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
        return ""

    def __exit__(self, exc_type, exc, tb):
        pass

def test_with():
    ctx = Context()
    taint(ctx)
    with ctx as tainted:
        ensure_tainted(tainted) # $ tainted

class Context_taint:
    def __enter__(self):
        return TAINTED_STRING

    def __exit__(self, exc_type, exc, tb):
        pass

def test_with_taint():
    ctx = Context_taint()
    with ctx as tainted:
        ensure_tainted(tainted) # $ MISSING: tainted


class Context_arg:
    def __init__(self, arg):
        self.arg = arg

    def __enter__(self):
        return self.arg

    def __exit__(self, exc_type, exc, tb):
        pass

def test_with_arg():
    ctx = Context_arg(TAINTED_STRING)
    with ctx as tainted:
        ensure_tainted(tainted) # $ MISSING: tainted



# Make tests runable

test_with()
test_with_taint()
test_with_arg()
