# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

class Foo:
    def __init__(self, arg):
        self.arg = arg
        self.other_arg = "other_arg"


def test_tainted_attr():
    # The following demonstrates how tainting an attribute affected the taintedness of
    # the object.
    #
    # Previously we would (wrongly) treat the object as tainted if we noticed a write of
    # a tainted value to any of its' attributes. This lead to FP, highlighted in
    # https://github.com/github/codeql/issues/7786

    f = Foo(TAINTED_STRING)
    ensure_not_tainted(f)
    ensure_tainted(f.arg) # $ tainted
    ensure_not_tainted(f.other_arg)


    x = Foo("x")
    ensure_not_tainted(x, x.arg, x.other_arg)

    x.arg = TAINTED_STRING
    ensure_not_tainted(x)
    ensure_tainted(x.arg) # $ tainted
    ensure_not_tainted(f.other_arg)


    b = Foo("bar")
    ensure_not_tainted(b, b.arg, b.other_arg)
