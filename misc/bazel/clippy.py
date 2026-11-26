#!/usr/bin/env python3
"""Lint changed root-workspace Rust projects that have Bazel targets."""

import argparse
from collections import defaultdict
import json
import os
from pathlib import Path
import subprocess
import tomllib
import xml.etree.ElementTree as ET

ROOT_INPUTS = {
    "Cargo.toml", "Cargo.lock", "rust-toolchain.toml", "clippy.toml",
    "MODULE.bazel", "MODULE.bazel.lock", ".bazelrc", ".bazelversion",
    "BUILD.bazel", ".github/workflows/bazel-clippy.yml",
}
RUST_RULES = {"rust_library", "rust_binary", "rust_proc_macro", "rust_test"}


def run(*args):
    return subprocess.check_output(args, text=True)


def package(label):
    return label[2:].split(":")[0]


def source_path(label):
    return label[2:].replace(":", "/", 1).lstrip("/")


def select_targets(graph, members, changed):
    """Use Bazel's input graph, including native/generated inputs and aliases."""
    rules = {node.attrib["name"]: node for node in graph.findall("rule")}
    candidates = {
        label for label, node in rules.items()
        if label.startswith("//")
        and package(label) in members
        and node.attrib["class"] in RUST_RULES
    }
    if any(path in ROOT_INPUTS or path.startswith("misc/bazel/") for path in changed):
        return sorted(candidates)

    reverse = defaultdict(set)
    affected = set()
    changed = set(changed)
    for node in graph.findall("source-file"):
        label = node.attrib["name"]
        if label.startswith("//") and any(
            dependency.startswith("//") and source_path(dependency) in changed
            for dependency in [label, *(load.attrib["name"] for load in node.findall("load"))]
        ):
            affected.add(label)
    for label, node in rules.items():
        if not label.startswith("//"):
            continue
        reverse[f"//{package(label)}:BUILD.bazel"].add(label)
        for dep in node.findall("rule-input"):
            dependency = dep.attrib["name"]
            reverse[dependency].add(label)
            if dependency.startswith("//") and source_path(dependency) in changed:
                affected.add(label)
        # A manifest, deleted input, or BUILD edit can disappear from query's
        # source-file graph. Invalidate its package and all reverse dependencies.
        if any(path.startswith(package(label) + "/") for path in changed):
            affected.add(label)

    while True:
        dependents = {dep for label in affected for dep in reverse[label]}
        added = dependents - affected
        if not added:
            break
        affected.update(added)
    return sorted(candidates & affected)


def lint_flags(manifest):
    """Preserve Cargo's lint-group priorities and overrides without a second policy."""
    flags = []
    for tool in ("rust", "clippy"):
        lints = manifest["workspace"]["lints"][tool]
        ordered = sorted(
            lints.items(),
            key=lambda item: (
                item[1].get("priority", 0) if isinstance(item[1], dict) else 0,
                item[0],
            ),
        )
        for name, value in ordered:
            level = value["level"] if isinstance(value, dict) else value
            prefix = "clippy::" if tool == "clippy" else ""
            flags.append(f"--@rules_rust//rust/settings:clippy_flag=--{level}={prefix}{name}")
    flags.append("--@rules_rust//rust/settings:clippy_flag=-Dwarnings")
    return flags


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", help="Compare the merge base of this revision with HEAD")
    parser.add_argument("--targets-file", type=Path, default=Path("clippy-targets.json"))
    parser.add_argument("--lint", choices=("extractor", "other"), help="Lint previously selected targets")
    args = parser.parse_args()
    manifest = tomllib.loads(Path("Cargo.toml").read_text())

    if args.lint:
        targets = json.loads(args.targets_file.read_text())
        targets = [
            target for target in targets
            if (package(target) == "rust/extractor") == (args.lint == "extractor")
        ]
        if not targets:
            print("No affected Rust targets.")
            return
        print("Linting:\n" + "\n".join(targets), flush=True)
        subprocess.run(
            ["bazel", "build", "--config=clippy", *lint_flags(manifest),
             *os.environ.get("BAZEL_CLIPPY_CACHE_FLAGS", "").split(), *targets],
            check=True,
        )
        return

    if not args.base:
        parser.error("--base is required when selecting targets")
    changed = run("git", "diff", "--name-only", "--no-renames", "-z", f"{args.base}...HEAD").split("\0")
    members = {
        member for member in manifest["workspace"]["members"]
        if (Path(member) / "BUILD.bazel").is_file()
    }
    expression = "deps(kind('rust_(library|binary|proc_macro|test) rule', set(" + " ".join(
        f"//{member}:*" for member in sorted(members)
    ) + ")))"
    graph = ET.fromstring(run(
        "bazel", "query", f"let targets = {expression} in $targets union buildfiles($targets)",
        "--output=xml", "--noimplicit_deps", "--notool_deps",
        *(flag for flag in os.environ.get("BAZEL_CLIPPY_CACHE_FLAGS", "").split()
          if flag.startswith("--repository_cache=")),
    ))
    targets = select_targets(graph, members, [path for path in changed if path])
    args.targets_file.write_text(json.dumps(targets, indent=2) + "\n")
    print("Selected targets:\n" + ("\n".join(targets) or "(none)"))
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as stream:
            stream.write(f"selected={'true' if targets else 'false'}\n")
    if summary := os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(summary, "a") as stream:
            stream.write("## Bazel Clippy targets\n\n" + "\n".join(f"- `{t}`" for t in targets) + "\n")


if __name__ == "__main__":
    main()
