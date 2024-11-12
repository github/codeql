#!/usr/bin/env python3

"""
Probe lfs files.
For each source file provided as input, this will print:
* "local", if the source file is not an LFS pointer
* the sha256 hash, a space character and a transient download link obtained via the LFS protocol otherwise
If --hash-only is provided, the transient URL will not be fetched and printed
"""
import dataclasses
import sys
import pathlib
import subprocess
import os
import shutil
import json
import typing
import urllib.request
import urllib.error
from urllib.parse import urlparse
import re
import base64
from dataclasses import dataclass
import argparse

def options():
    def resolved_path(path):
        return pathlib.Path(path).expanduser().resolve()
    p = argparse.ArgumentParser(description=__doc__)
    excl = p.add_mutually_exclusive_group(required=True)
    excl.add_argument("--hash-only", action="store_true")
    excl.add_argument("--git-lfs", type=resolved_path)
    p.add_argument("sources", type=resolved_path, nargs="+")
    opts = p.parse_args()
    source_dir = pathlib.Path(os.path.commonpath(src.parent for src in opts.sources))
    opts.source_dir = subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"], cwd=source_dir, text=True
    ).strip()
    return opts


def get_env(s: str, sep: str = "=") -> typing.Iterable[typing.Tuple[str, str]]:
    for m in re.finditer(rf"(.*?){sep}(.*)", s, re.M):
        yield m.groups()


def get_locations(objects, opts):
    ret = ["local" for _ in objects]
    indexes = [i for i, o in enumerate(objects) if o]
    if opts.hash_only:
        for i in indexes:
            ret[i] = objects[i]["oid"]
    else:
        cmd = [opts.git_lfs, "ls-urls", "--json"]
        cmd.extend(objects[i]["path"] for i in indexes)
        data = json.loads(subprocess.check_output(cmd, cwd=opts.source_dir))
        for i, f in zip(indexes, data["files"]):
            ret[i] = f'{f["oid"]} {f["url"]}'
    return ret

def get_lfs_object(path):
    with open(path, "rb") as fileobj:
        lfs_header = "version https://git-lfs.github.com/spec".encode()
        actual_header = fileobj.read(len(lfs_header))
        if lfs_header != actual_header:
            return None
        data = dict(get_env(fileobj.read().decode("ascii"), sep=" "))
        assert data["oid"].startswith("sha256:"), f"unknown oid type: {data['oid']}"
        _, _, sha256 = data["oid"].partition(":")
        return {"path": path, "oid": sha256}


def main():
    opts = options()
    objects = [get_lfs_object(src) for src in opts.sources]
    for resp in get_locations(objects, opts):
        print(resp)

if __name__ == "__main__":
    main()
