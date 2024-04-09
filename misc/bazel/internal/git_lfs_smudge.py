#!/usr/bin/env python3

import sys
import pathlib
import subprocess
import os

sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))
source_dir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True).strip()


def is_lfs_pointer(fileobj):
    lfs_header = "version https://git-lfs.github.com/spec".encode()
    actual_header = fileobj.read(len(lfs_header))
    fileobj.seek(0)
    return lfs_header == actual_header


for src in sources:
    with open(src, 'rb') as input:
        if is_lfs_pointer(input):
            lfs_pointer = input.read()
            rel_src = src.relative_to(source_dir).as_posix()
            with open(src.name, 'wb') as output:
                subprocess.run(
                    ["git",
                     "-c", f"lfs.fetchinclude={rel_src}", "-c", "lfs.fetchexclude=",
                     "lfs", "smudge", "--", rel_src],
                    input=lfs_pointer, stdout=output, check=True, cwd=source_dir)
            continue
    pathlib.Path(src.name).symlink_to(src)
