#!/usr/bin/env python3

import sys
import pathlib
import subprocess
import os

sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))

def is_lfs_pointer(fileobj):
    lfs_header = "version https://git-lfs.github.com/spec".encode()
    actual_header = fileobj.read(len(lfs_header))
    fileobj.seek(0)
    return lfs_header == actual_header

for src in sources:
    with open(src, 'rb') as input:
        if is_lfs_pointer(input):
            with open(src.name, 'wb') as output:
                subprocess.run(["git", "lfs", "smudge", "--", src], stdin=input, stdout=output, check=True, cwd=source_dir)
            continue
    pathlib.Path(src.name).symlink_to(src)
