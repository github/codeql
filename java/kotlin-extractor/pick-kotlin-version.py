#!/usr/bin/env python3
"""
Script to get currently installed kotlinc version. If a list of available versions is provided as input,
the last version of those lower or equal to the kotlinc version is printed.
"""

import subprocess
import re
import shutil
import argparse
import sys


def version_tuple(v):
    v, _, _ = v.partition('-')
    return tuple(int(x) for x in v.split(".", 2))


p = argparse.ArgumentParser(description=__doc__, fromfile_prefix_chars='@')
p.add_argument("available_versions", nargs="*", metavar="X.Y.Z")
opts = p.parse_args()

kotlinc = shutil.which('kotlinc')
if kotlinc is None:
    raise Exception("kotlinc not found")
res = subprocess.run([kotlinc, "-version"], text=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
if res.returncode != 0:
    raise Exception(f"kotlinc -version failed: {res.stderr}")
m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z][a-zA-Z0-9]*)?) .*', res.stderr)
if m is None:
    raise Exception(f'Cannot detect version of kotlinc (got {res.stderr})')
version = m[1]
if opts.available_versions:
    vt = version_tuple(version)
    available = sorted(opts.available_versions, key=version_tuple, reverse=True)
    for v in available:
        if version_tuple(v) <= vt:
            print(v)
            sys.exit(0)
    raise Exception(f'Cannot find an available version for {version}')
print(version)
