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
        ts,
        ts + "foo",
        "foo" + ts,
        ts * 5,
        ts[0 : len(ts)],
        ts[:],
        ts[0:1000],
        ts[0],
        str(ts),
        bytes(tb),
        unicode(ts),
    )

    aug_assignment = "safe"
    ensure_not_tainted(aug_assignment)
    aug_assignment += TAINTED_STRING
    ensure_tainted(aug_assignment)


def str_methods():
    print("\n# str_methods")
    ts = TAINTED_STRING
    tb = TAINTED_BYTES
    ensure_tainted(
        ts.capitalize(),
        ts.center(100),
        ts.expandtabs(),

        ts.format(),
        "{}".format(ts),
        "{unsafe}".format(unsafe=ts),

        ts.join(["", ""]),
        "".join([ts]),

        ts.ljust(100),
        ts.lstrip(),
        ts.lower(),

        ts.replace("old", "new"),
        "safe".replace("safe", ts),

        ts.rjust(100),
        ts.rstrip(),
        ts.strip(),
        ts.swapcase(),
        ts.title(),
        ts.upper(),
        ts.zfill(100),

        ts.encode("utf-8"),
        ts.encode("utf-8").decode("utf-8"),

        tb.decode("utf-8"),
        tb.decode("utf-8").encode("utf-8"),

        # string methods that return a list
        ts.partition("_"),
        ts.rpartition("_"),
        ts.rsplit("_"),
        ts.split("_"),
        ts.splitlines(),
    )

    ensure_not_tainted(
        # Intuitively I think this should be safe, but better discuss it
        "safe".replace(ts, "also-safe"),

        ts.join([]),  # FP due to separator not being used with zero/one elements
        ts.join(["safe"]),  # FP due to separator not being used with zero/one elements
    )


def non_syntactic():
    print("\n# non_syntactic")
    ts = TAINTED_STRING
    meth = ts.upper
    _str = str
    ensure_tainted(
        meth(),
        _str(ts),
    )


def percent_fmt():
    print("\n# percent_fmt")
    ts = TAINTED_STRING
    tainted_fmt = ts + " %s %s"
    ensure_tainted(
        tainted_fmt % (1, 2),
        "%s foo bar" % ts,
        "%s %s %s" % (1, 2, ts),
    )


def binary_decode_encode():
    print("\n# binary_decode_encode")
    tb = TAINTED_BYTES
    import base64

    ensure_tainted(
        base64.b64encode(tb),
        base64.b64decode(base64.b64encode(tb)),

        base64.standard_b64encode(tb),
        base64.standard_b64decode(base64.standard_b64encode(tb)),

        base64.urlsafe_b64encode(tb),
        base64.urlsafe_b64decode(base64.urlsafe_b64encode(tb)),

        base64.b32encode(tb),
        base64.b32decode(base64.b32encode(tb)),

        base64.b16encode(tb),
        base64.b16decode(base64.b16encode(tb)),

        # deprecated since Python 3.1, but still works
        base64.encodestring(tb),
        base64.decodestring(base64.encodestring(tb)),
    )

    import quopri
    ensure_tainted(
        quopri.encodestring(tb),
        quopri.decodestring(quopri.encodestring(tb)),
    )


def test_os_path_join():
    import os
    import os.path as ospath_alias
    print("\n# test_os_path_join")
    ts = TAINTED_STRING
    ensure_tainted(
        os.path.join(ts, "foo", "bar"),
        os.path.join(ts),
        os.path.join("foo", "bar", ts),
        ospath_alias.join("foo", "bar", ts),
    )


# Make tests runable

str_operations()
str_methods()
non_syntactic()
percent_fmt()
binary_decode_encode()
test_os_path_join()
