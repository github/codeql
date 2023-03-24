#!/usr/bin/env python3

import sys
import subprocess
import pathlib
import os

autobuilder = pathlib.Path(sys.argv[1]).absolute()
test_dir = pathlib.Path(sys.argv[2])

expected = test_dir / 'commands.expected'
actual = pathlib.Path('commands.actual')

with open(actual, 'wb') as out:
    ret = subprocess.run([str(autobuilder), '-dry-run', '.'], capture_output=True, check=True, cwd=test_dir)
    for line in ret.stdout.splitlines():
        out.write(line.rstrip())
        out.write(b'\n')

subprocess.run(['diff', '-u', expected, actual], check=True)

print("SUCCESS!")
