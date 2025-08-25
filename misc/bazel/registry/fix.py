#!/usr/bin/env python3

# Copyright (c) 2024 GitHub, Inc.

"""
Fix metadata in overridden registry, updating `metadata.json` to list correct versions and `source.json`
to list correct patches with sha256 hashes.
"""

import pathlib
import json
import base64
import hashlib
import re

this_dir = pathlib.Path(__file__).resolve().parent


def sha256(file):
    with open(file, 'rb') as input:
        hash = hashlib.sha256(input.read()).digest()
    hash = base64.b64encode(hash).decode()
    return f"sha256-{hash}"


def patch_file(file, f):
    try:
        data = file.read_text()
    except FileNotFoundError:
        data = None
    file.write_text(f(data))


def patch_json(file, **kwargs):
    def update(data):
        data = json.loads(data) if data else {}
        data.update(kwargs)
        return json.dumps(data, indent=4) + "\n"

    patch_file(file, update)


for entry in this_dir.joinpath("modules").iterdir():
    if not entry.is_dir():
        continue
    versions = [e for e in entry.iterdir() if e.is_dir()]

    patch_json(entry / "metadata.json", versions=[v.name for v in versions])

    for version in versions:
        patch_json(version / "source.json", patches={
            p.name: sha256(p) for p in version.joinpath("patches").iterdir()
        })
        patch_file(version / "MODULE.bazel",
                   lambda s: re.sub(r'''version\s*=\s*['"].*['"]''', f'version = "{version.name}"', s, 1))
