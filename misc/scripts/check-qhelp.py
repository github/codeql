#!/bin/env python3

"""cross platform wrapper around codeql generate query-help to check .qhelp files

This takes care of:
* providing a temporary directory to --output
* turning .inc.qhelp arguments into their containing directory
"""

import pathlib
import tempfile
import sys
import subprocess

def transform_input(arg):
    arg = pathlib.Path(arg)
    if arg.suffixes == ['.inc', '.qhelp']:
        return str(arg.parent)
    return str(arg)

cmd = ["codeql", "generate", "query-help", "--format=markdown"]

with tempfile.TemporaryDirectory() as tmp:
    cmd += [f"--output={tmp}", "--"]
    cmd.extend(transform_input(x) for x in sys.argv[1:])
    res = subprocess.run(cmd)

sys.exit(res.returncode)
