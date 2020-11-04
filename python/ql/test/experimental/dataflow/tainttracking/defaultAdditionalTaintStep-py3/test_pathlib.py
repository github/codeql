# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import Iterable, TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *

# Actual tests

import pathlib
# pathlib was added in 3.4

def test_basic():
    print("\n# test_basic")
    ts = TAINTED_STRING

    tainted_path = pathlib.Path(ts)

    tainted_pure_path = pathlib.PurePath(ts)
    tainted_pure_posix_path = pathlib.PurePosixPath(ts)
    tainted_pure_windows_path = pathlib.PureWindowsPath(ts)

    ensure_tainted(
        tainted_path,

        tainted_pure_path,
        tainted_pure_posix_path,
        tainted_pure_windows_path,

        pathlib.Path("foo") / ts,
        ts / pathlib.Path("foo"),

        tainted_path.joinpath("foo", "bar"),
        pathlib.Path("foo").joinpath(tainted_path, "bar"),
        pathlib.Path("foo").joinpath("bar", tainted_path),

        str(tainted_path),

        # TODO: Tainted methods and attributes
        # https://docs.python.org/3.8/library/pathlib.html#methods-and-properties
    )

    if os.name == "posix":
        tainted_posix_path = pathlib.PosixPath(ts)

        ensure_tainted(
            tainted_posix_path,
        )

    if os.name == "nt":
        tainted_windows_path = pathlib.WindowsPath(ts)
        ensure_tainted(
            tainted_windows_path,
        )

# Make tests runable

test_basic()
