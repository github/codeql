# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *

# Actual tests

def test_access():
    tainted_list = TAINTED_LIST

    ensure_tainted(
        tainted_list.copy(),
    )


def list_clear():
    tainted_string = TAINTED_STRING
    tainted_list = [tainted_string]

    ensure_tainted(tainted_list)

    tainted_list.clear()
    ensure_not_tainted(tainted_list)

# Make tests runable

test_access()
list_clear()
