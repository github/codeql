# without this, `eval("print(42)")` becomes invalid syntax in Python 2, since print is a
# statement
from __future__ import print_function

import sys

if sys.version_info[0] == 3:
    import builtins
if sys.version_info[0] == 2:
    import __builtin__ as builtins

exec("print(42)")  # $getCode="print(42)"
eval("print(42)")  # $getCode="print(42)"

builtins.eval("print(42)")  # $getCode="print(42)"

cmd = compile("print(42)", "<filename>", "exec")
exec(cmd)  # $getCode=cmd

cmd = builtins.compile("print(42)", "<filename>", "exec")
exec(cmd)  # $getCode=cmd

# ------------------------------------------------------------------------------
# taint related


def test_additional_taint():
    src = TAINTED_STRING

    cmd1 = compile(src, "<filename>", "exec")
    cmd2 = compile(source=src, filename="<filename>", mode="exec")
    cmd3 = builtins.compile(src, "<filename>", "exec")

    ensure_tainted(
        src, # $ tainted
        cmd1, # $ tainted
        cmd2, # $ tainted
        cmd3, # $ tainted
    )
