# without this, `eval("print(42)")` becomes invalid syntax in Python 2, since print is a
# statement
from __future__ import print_function
import sys

if sys.version_info[0] == 3:
    import builtins
if sys.version_info[0] == 2:
    import __builtin__ as builtins


def foo(*args, **kwargs):
    raise Exception("no eval")


builtins.eval = foo

# This function call might be marked as a code execution, but it actually isn't.
eval("print(42)")  # $ SPURIOUS: getCode="print(42)"
