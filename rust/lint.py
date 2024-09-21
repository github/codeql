#!/bin/env python3

import subprocess
import pathlib
import shutil
import sys

this_dir = pathlib.Path(__file__).resolve().parent

cargo = shutil.which("cargo")
assert cargo, "no cargo binary found on `PATH`"

fmt = subprocess.run([cargo, "fmt", "--all", "--quiet"], cwd=this_dir)
for manifest in this_dir.rglob("Cargo.toml"):
    if not manifest.is_relative_to(this_dir / "ql") and not manifest.is_relative_to(this_dir / "integration-tests"):
        clippy = subprocess.run([cargo, "clippy", "--fix", "--allow-dirty", "--allow-staged", "--quiet"],
                                cwd=manifest.parent)
sys.exit(fmt.returncode or clippy.returncode)
