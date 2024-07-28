#!/usr/bin/env python3

import sys
import subprocess
import pathlib
import os

autobuilder = pathlib.Path(sys.argv[1]).absolute()
test_dir = pathlib.Path(sys.argv[2])

expected = test_dir / 'commands.expected'
actual = pathlib.Path('commands.actual')

os.environ["CODEQL_EXTRACTOR_SWIFT_LOG_LEVELS"] = "text:no_logs,diagnostics:no_logs,console:info"

with open(actual, 'w') as out:
    ret = subprocess.run([str(autobuilder), '-dry-run', '.'], stdout=subprocess.PIPE,
                         check=True, cwd=test_dir, text=True)
    for line in ret.stdout.splitlines():
        out.write(line.rstrip())
        out.write('\n')

subprocess.run(['diff', '-u', expected, actual], check=True)

print("SUCCESS!")
