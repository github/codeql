#!/usr/bin/env python3

import subprocess
import re
import shutil

kotlinc = shutil.which('kotlinc')
if kotlinc is None:
    raise Exception("kotlinc not found")
res = subprocess.run([kotlinc, "-version"], text=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
if res.returncode != 0:
    raise Exception(f"kotlinc -version failed: {res.stderr}")
m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z][a-zA-Z0-9]*)?) .*', res.stderr)
if m is None:
    raise Exception(f'Cannot detect version of kotlinc (got {res.stderr})')
print(m[1])
