#!/usr/bin/env python3

import subprocess
import pathlib
import shutil
import sys


def tool(name):
    ret = shutil.which(name)
    assert ret, f"no {name} binary found on `PATH`"
    return ret


this_dir = pathlib.Path(__file__).resolve().parent

cargo = tool("cargo")
bazel = tool("bazel")

runs = []


def run(tool, args, *, cwd=this_dir):
    print("+", tool, args)
    runs.append(subprocess.run([tool] + args.split(), cwd=cwd))


# make sure bazel-provided sources are put in tree for `cargo` to work with them
run(bazel, "run ast-generator:inject-sources")
run(cargo, "fmt --all --quiet")

for manifest in this_dir.rglob("Cargo.toml"):
    if not manifest.is_relative_to(this_dir / "ql") and not manifest.is_relative_to(this_dir / "integration-tests"):
        run(cargo,
            "clippy --fix --allow-dirty --allow-staged --quiet -- -D warnings",
            cwd=manifest.parent)

sys.exit(max(r.returncode for r in runs))
