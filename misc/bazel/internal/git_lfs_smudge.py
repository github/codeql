#!/usr/bin/env python3

import sys
import pathlib
import subprocess
import os

sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))

for src in sources:
    with open(src, 'rb') as input:
        lfs_pointer = subprocess.run(["git", "lfs", "clean", "--", src],
                                     stdin=input, stdout=subprocess.PIPE, check=True, cwd=source_dir).stdout
    with open(src.name, 'wb') as output:
        subprocess.run(["git", "lfs", "smudge", "--", src], input=lfs_pointer, stdout=output, check=True, cwd=source_dir)
