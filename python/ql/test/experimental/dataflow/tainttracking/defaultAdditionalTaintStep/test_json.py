# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

from io import StringIO
import json

def test():
    print("\n# test")
    ts = TAINTED_STRING

    encoded = json.dumps(ts)

    ensure_tainted(
        encoded, # $ tainted
        json.dumps(ts), # $ tainted
        json.dumps(obj=ts), # $ tainted
        json.loads(encoded), # $ tainted
        json.loads(s=encoded), # $ tainted
    )

    # load/dump with file-like
    tainted_filelike = StringIO()
    json.dump(ts, tainted_filelike)

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ MISSING: tainted
        json.load(tainted_filelike), # $ MISSING: tainted
    )

    # load/dump with file-like using keyword-args
    tainted_filelike = StringIO()
    json.dump(obj=ts, fp=tainted_filelike)

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ MISSING: tainted
        json.load(fp=tainted_filelike), # $ MISSING: tainted
    )


# Make tests runable

test()
