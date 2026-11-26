#!/usr/bin/env python3
"""Select root-workspace packages affected by a pull request, without building Rust."""

import argparse
import json
import posixpath
import subprocess
import tomllib
from pathlib import Path


GLOBAL_INPUTS = {
    "Cargo.toml",
    "Cargo.lock",
    "rust-toolchain.toml",
    "clippy.toml",
    ".clippy.toml",
    ".github/workflows/cargo-clippy.yml",
}

# Inputs read by build scripts outside their package's directory.
EXTERNAL_INPUTS = {
    "python/extractor/tsg-python/tsp/src/": "python/extractor/yeast-python",
}


def workspace(root):
    manifest = tomllib.loads((root / "Cargo.toml").read_text())
    packages = {}
    for member in manifest["workspace"]["members"]:
        # Fail explicitly if the workspace starts using globbed members.
        if any(c in member for c in "*?["):
            raise ValueError(f"Unsupported workspace member pattern: {member}")
        packages[member] = tomllib.loads((root / member / "Cargo.toml").read_text())

    dependents = {member: set() for member in packages}
    for member, package in packages.items():
        tables = [package, *package.get("target", {}).values()]
        for table in tables:
            for kind in ("dependencies", "dev-dependencies", "build-dependencies"):
                for alias, dependency in table.get(kind, {}).items():
                    if not isinstance(dependency, dict):
                        continue
                    relative_to = member
                    if dependency.get("workspace"):
                        dependency = manifest["workspace"]["dependencies"][alias]
                        relative_to = ""
                    if isinstance(dependency, dict) and "path" in dependency:
                        path = posixpath.normpath(
                            posixpath.join(relative_to, dependency["path"])
                        )
                        if path in dependents:
                            dependents[path].add(member)
                        else:
                            raise ValueError(f"Path dependency outside workspace: {path}")
    return packages, dependents


def select(root, changed):
    packages, dependents = workspace(root)
    affected = set()
    members = sorted(packages, key=len, reverse=True)
    for path in changed:
        if (
            path in GLOBAL_INPUTS
            or path.startswith(".cargo/")
            or path.startswith("misc/scripts/cargo-clippy/")
        ):
            return sorted(package["package"]["name"] for package in packages.values())
        for prefix, member in EXTERNAL_INPUTS.items():
            if path.startswith(prefix):
                affected.add(member)
        # A nested member owns its files, not its containing package.
        for member in members:
            if path.startswith(member + "/"):
                affected.add(member)
                break

    pending = list(affected)
    while pending:
        for member in dependents[pending.pop()] - affected:
            affected.add(member)
            pending.append(member)
    return sorted(packages[member]["package"]["name"] for member in affected)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", required=True, help="Base parent of the PR merge commit")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[3]
    changed = subprocess.check_output(
        ["git", "diff", "--name-only", "--no-renames", "-z", args.base, "HEAD"],
        cwd=root,
    ).decode().split("\0")
    print(json.dumps(select(root, changed), separators=(",", ":")))


if __name__ == "__main__":
    main()
