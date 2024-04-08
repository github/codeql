#!/usr/bin/env python3

import sys
import pathlib
import subprocess
import os

sources = [pathlib.Path(arg).resolve() for arg in sys.argv[1:]]
source_dir = pathlib.Path(os.path.commonpath(src.parent for src in sources))
source_dir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True).strip()


def is_lfs_pointer(file):
    lfs_header = "version https://git-lfs.github.com/spec".encode()
    with open(file, 'rb') as fileobj:
        return fileobj.read(len(lfs_header)) == lfs_header


for src in sources:
    if is_lfs_pointer(src):
        relative_src = src.relative_to(source_dir)
        subprocess.run(["git", "lfs", "fetch", f"--include={relative_src}"], stdout=subprocess.DEVNULL, check=True,
                       cwd=source_dir)
        subprocess.run(["git", "lfs", "checkout", relative_src], check=True, cwd=source_dir)
    pathlib.Path(src.name).symlink_to(src)
