# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import TAINTED_DICT, TAINTED_STRING, ensure_tainted


def test_frozendict():
    ensure_tainted(frozendict(TAINTED_DICT)) # $ tainted
    ensure_tainted(frozendict(TAINTED_DICT)["name"]) # $ tainted
    ensure_tainted(frozendict(name=TAINTED_STRING)["name"]) # $ tainted
    ensure_tainted(frozendict([("name", TAINTED_STRING)])["name"]) # $ tainted


if sys.version_info >= (3, 15):
    test_frozendict()
