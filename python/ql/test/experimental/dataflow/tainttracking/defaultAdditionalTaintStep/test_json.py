# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

from io import StringIO

# Workaround for Python3 not having unicode
import sys
if sys.version_info[0] == 3:
    unicode = str

def test():
    print("\n# test")
    ts = TAINTED_STRING
    import json

    ensure_tainted(
        json.dumps(ts), # $ tainted
        json.loads(json.dumps(ts)), # $ tainted
    )

    # For Python2, need to convert to unicode for StringIO to work
    tainted_filelike = StringIO(unicode(json.dumps(ts)))

    ensure_tainted(
        tainted_filelike, # $ MISSING: tainted
        json.load(tainted_filelike), # $ MISSING: tainted
    )

def non_syntacical():
    print("\n# non_syntacical")
    ts = TAINTED_STRING

    # a less syntactical approach
    from json import load, loads, dumps

    dumps_alias = dumps

    ensure_tainted(
        dumps(ts), # $ tainted
        dumps_alias(ts), # $ tainted
        loads(dumps(ts)), # $ tainted
    )

    # For Python2, need to convert to unicode for StringIO to work
    tainted_filelike = StringIO(unicode(dumps(ts)))

    ensure_tainted(
        tainted_filelike, # $ MISSING: tainted
        load(tainted_filelike), # $ MISSING: tainted
    )

# Make tests runable

test()
non_syntacical()
