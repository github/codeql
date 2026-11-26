#!/usr/bin/env python3
"""Select root-workspace packages affected by a PR or push, and lint them with Clippy."""

import argparse
import json
import posixpath
import subprocess
import tomllib
from pathlib import Path


# Changes to any of these select every package.
GLOBAL_INPUTS = (
    "Cargo.toml",
    "Cargo.lock",
    "rust-toolchain.toml",
    "clippy.toml",
    ".clippy.toml",
    ".cargo/",
    ".github/workflows/cargo-clippy.yml",
    "misc/scripts/cargo-clippy/",
)

# Inputs read by build scripts outside their package's directory.
EXTERNAL_INPUTS = {
    "python/extractor/tsg-python/tsp/src/": "python/extractor/yeast-python",
    "misc/bazel/": "rust/ast-generator",
    "MODULE.bazel": "rust/ast-generator",
    ".bazelrc": "rust/ast-generator",
    ".bazelversion": "rust/ast-generator",
}


# Read workspace packages and map each package to its path dependents.
def workspace(root):
    manifest = tomllib.loads((root / "Cargo.toml").read_text())
    packages = {}
    for member in manifest["workspace"]["members"]:
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


# Select changed packages and their transitive dependents.
def select(root, changed):
    packages, dependents = workspace(root)
    owners = {**{member + "/": member for member in packages}, **EXTERNAL_INPUTS}
    # Longest first, so a nested member owns its files, not its containing package.
    prefixes = sorted(owners, key=len, reverse=True)
    affected = set()
    for path in changed:
        if path.startswith(GLOBAL_INPUTS):
            return sorted(package["package"]["name"] for package in packages.values())
        for prefix in prefixes:
            if path.startswith(prefix):
                affected.add(owners[prefix])
                break

    pending = list(affected)
    while pending:
        for member in dependents[pending.pop()] - affected:
            affected.add(member)
            pending.append(member)
    return sorted(packages[member]["package"]["name"] for member in affected)


# List files changed since the PR base or push's before revision.
def changed_files(root, base):
    if base in ("0" * 40, "0" * 64):
        # A newly created branch has no previous tree, so select everything.
        return ["Cargo.toml"]
    return subprocess.check_output(
        ["git", "diff", "--name-only", "--no-renames", "-z", base, "HEAD"],
        cwd=root,
    ).decode().split("\0")


# Run Clippy on the selected packages and return its exit code.
def lint(packages):
    args = ["cargo", "clippy", "--locked", "--all-targets", "--no-deps"]
    for package in packages:
        args.extend(["--package", package])
    return subprocess.run([*args, "--", "-D", "warnings"]).returncode


# Parse the command and dispatch selection or linting.
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    select_parser = commands.add_parser(
        "select", help="print the affected packages as a JSON list",
    )
    select_parser.add_argument(
        "--base", required=True,
        help="PR merge's first parent, or push event's before SHA (zero for a new branch)",
    )
    lint_parser = commands.add_parser("lint", help="run Clippy on the given packages")
    lint_parser.add_argument("packages", help="JSON list printed by the select command")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[3]
    if args.command == "select":
        print(json.dumps(select(root, changed_files(root, args.base))))
    else:
        raise SystemExit(lint(json.loads(args.packages)))

if __name__ == "__main__":
    main()
