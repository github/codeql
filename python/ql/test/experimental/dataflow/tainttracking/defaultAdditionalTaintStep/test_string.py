# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

# Workaround for Python3 not having unicode
import sys
if sys.version_info[0] == 3:
    unicode = str


def str_operations():
    print("\n# str_operations")
    ts = TAINTED_STRING
    tb = TAINTED_BYTES

    ensure_tainted(
        ts, # $ tainted
        ts + "foo", # $ tainted
        "foo" + ts, # $ tainted
        ts * 5, # $ tainted
        ts[0 : len(ts)], # $ tainted
        ts[:], # $ tainted
        ts[0:1000], # $ tainted
        ts[0], # $ tainted
        str(ts), # $ tainted
        bytes(tb), # $ tainted
        unicode(ts), # $ tainted
    )

    aug_assignment = "safe"
    ensure_not_tainted(aug_assignment)
    aug_assignment += TAINTED_STRING
    ensure_tainted(aug_assignment) # $ tainted


def str_methods():
    print("\n# str_methods")
    ts = TAINTED_STRING
    tb = TAINTED_BYTES
    ensure_tainted(
        ts.capitalize(), # $ tainted
        ts.center(100), # $ tainted
        ts.expandtabs(), # $ tainted

        ts.format(), # $ tainted
        "{}".format(ts), # $ tainted
        "{unsafe}".format(unsafe=ts), # $ tainted

        ts.join(["", ""]), # $ tainted
        "".join([ts]), # $ tainted

        ts.ljust(100), # $ tainted
        ts.lstrip(), # $ tainted
        ts.lower(), # $ tainted

        ts.replace("old", "new"), # $ tainted
        "safe".replace("safe", ts), # $ tainted

        ts.rjust(100), # $ tainted
        ts.rstrip(), # $ tainted
        ts.strip(), # $ tainted
        ts.swapcase(), # $ tainted
        ts.title(), # $ tainted
        ts.upper(), # $ tainted
        ts.zfill(100), # $ tainted

        ts.encode("utf-8"), # $ tainted
        ts.encode("utf-8").decode("utf-8"), # $ tainted

        tb.decode("utf-8"), # $ tainted
        tb.decode("utf-8").encode("utf-8"), # $ tainted

        # string methods that return a list
        ts.partition("_"), # $ tainted
        ts.rpartition("_"), # $ tainted
        ts.rsplit("_"), # $ tainted
        ts.split("_"), # $ tainted
        ts.splitlines(), # $ tainted
    )

    ensure_not_tainted(
        # Intuitively I think this should be safe, but better discuss it
        "safe".replace(ts, "also-safe"),

        # FPs due to separator (`ts`) not ending up in result, when the list only has
        # zero/one elements
        ts.join([]), # $ SPURIOUS: tainted
        ts.join(["safe"]),  # $ SPURIOUS: tainted
    )


def non_syntactic():
    print("\n# non_syntactic")
    ts = TAINTED_STRING
    meth = ts.upper
    _str = str
    ensure_tainted(
        meth(), # $ MISSING: tainted
        _str(ts), # $ tainted
    )


def percent_fmt():
    print("\n# percent_fmt")
    ts = TAINTED_STRING
    tainted_fmt = ts + " %s %s"
    ensure_tainted(
        tainted_fmt % (1, 2), # $ tainted
        "%s foo bar" % ts, # $ tainted
        "%s %s %s" % (1, 2, ts), # $ tainted
    )


def binary_decode_encode():
    print("\n# binary_decode_encode")
    tb = TAINTED_BYTES
    import base64

    ensure_tainted(
        base64.b64encode(tb), # $ tainted
        base64.b64decode(base64.b64encode(tb)), # $ tainted

        base64.standard_b64encode(tb), # $ tainted
        base64.standard_b64decode(base64.standard_b64encode(tb)), # $ tainted

        base64.urlsafe_b64encode(tb), # $ tainted
        base64.urlsafe_b64decode(base64.urlsafe_b64encode(tb)), # $ tainted

        base64.b32encode(tb), # $ tainted
        base64.b32decode(base64.b32encode(tb)), # $ tainted

        base64.b16encode(tb), # $ tainted
        base64.b16decode(base64.b16encode(tb)), # $ tainted

        # deprecated since Python 3.1, but still works
        base64.encodestring(tb), # $ tainted
        base64.decodestring(base64.encodestring(tb)), # $ tainted
    )

    import quopri
    ensure_tainted(
        quopri.encodestring(tb), # $ MISSING: tainted
        quopri.decodestring(quopri.encodestring(tb)), # $ MISSING: tainted
    )


def test_os_path_join():
    import os
    import os.path as ospath_alias
    print("\n# test_os_path_join")
    ts = TAINTED_STRING
    ensure_tainted(
        os.path.join(ts, "foo", "bar"), # $ tainted
        os.path.join(ts), # $ tainted
        os.path.join("foo", "bar", ts), # $ tainted
        ospath_alias.join("foo", "bar", ts), # $ tainted
    )


# Make tests runable

str_operations()
str_methods()
non_syntactic()
percent_fmt()
binary_decode_encode()
test_os_path_join()
