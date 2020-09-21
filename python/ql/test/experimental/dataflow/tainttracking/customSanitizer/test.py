import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

def emulated_authentication_check(arg):
    if not arg == "safe":
        raise Exception("user unauthenticated")


def test_custom_sanitizer():
    s = TAINTED_STRING

    try:
        emulated_authentication_check(s)
        ensure_not_tainted(s)
    except:
        pass


def emulated_is_safe(arg):
    # emulating something we won't be able to look at source code for
    return eval("False")


def test_custom_sanitizer_guard():
    s = TAINTED_STRING

    if emulated_is_safe(s):
        ensure_not_tainted(s)
        s = TAINTED_STRING
        ensure_tainted(s)
    else:
        ensure_tainted(s)


def emulated_escaping(arg):
    return arg.replace("<", "?").replace(">", "?").replace("'", "?").replace("\"", "?")


def test_escape():
    s = TAINTED_STRING

    s2 = emulated_escaping(s)
    ensure_not_tainted(s2)


# Make tests runable

test_custom_sanitizer()
test_custom_sanitizer_guard()
test_escape()
