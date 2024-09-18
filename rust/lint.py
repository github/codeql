#!/bin/env python3

import subprocess
import pathlib
import shutil
import sys

extractor_dir = pathlib.Path(__file__).resolve().parent / "extractor"

cargo = shutil.which("cargo")
assert cargo, "no cargo binary found on `PATH`"

fmt = subprocess.run([cargo, "fmt", "--quiet"], cwd=extractor_dir)
clippy = subprocess.run([cargo, "clippy", "--fix", "--allow-dirty", "--allow-staged", "--quiet"],
                        cwd=extractor_dir)
sys.exit(fmt.returncode or clippy.returncode)
