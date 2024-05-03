#!/usr/bin/env python3
import os
import pathlib
import shutil
import sys
import subprocess

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    res = subprocess.run(["bazel", "run", ":create-extractor-pack"], cwd=pathlib.Path(__file__).parent)
    sys.exit(res.returncode)

from go._extractor_pack_install_script import main

if os.environ['REPO_NAME'] == 'codeql~':
    workspace_dir /= 'ql'

dest_dir = workspace_dir / 'go' / 'build' / 'codeql-extractor-pack'
shutil.rmtree(dest_dir, ignore_errors=True)
os.environ['DESTDIR'] = str(dest_dir)
main(sys.argv)
