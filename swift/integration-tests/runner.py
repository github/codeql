#!/bin/env python3
"""
recreation of internal `integration-tests-runner.py` to run the tests locally, with minimal
and swift-specialized functionality.

This runner requires:
* a codeql CLI binary in PATH
* `bazel run //swift:create_extractor_pack` to have been run
"""

import pathlib
import os
import sys
import subprocess
import argparse
import shutil
import platform

this_dir = pathlib.Path(__file__).parent.resolve()

def options():
    p = argparse.ArgumentParser()
    p.add_argument("--test-dir", "-d", type=pathlib.Path, action="append")
    # FIXME: the following should be the default
    p.add_argument("--check-databases", action="store_true")
    p.add_argument("--learn", action="store_true")
    p.add_argument("--threads", "-j", type=int, default=0)
    p.add_argument("--compilation-cache")
    return p.parse_args()


def execute_test(path):
    shutil.rmtree(path.parent / "db", ignore_errors=True)
    return subprocess.run([sys.executable, "-u", path.name], cwd=path.parent).returncode == 0

def skipped(test):
    return platform.system() != "Darwin" and "osx-only" in test.parts


def main(opts):
    test_dirs = opts.test_dir or [this_dir]
    tests = [t for d in test_dirs for t in d.rglob("test.py") if not skipped(t)]

    if not tests:
        print("No tests found", file=sys.stderr)
        return False

    os.environ["PYTHONPATH"] = str(this_dir)
    failed_db_creation = []
    succesful_db_creation = []
    for t in tests:
        (succesful_db_creation if execute_test(t) else failed_db_creation).append(t)

    if succesful_db_creation:
        codeql_root = this_dir.parents[1]
        cmd = [
            "codeql", "test", "run",
            f"--additional-packs={codeql_root}",
            "--keep-databases",
            "--dataset=db/db-swift",
            f"--threads={opts.threads}",
        ]
        if opts.check_databases:
            cmd.append("--check-databases")
        else:
            cmd.append("--no-check-databases")
        if opts.learn:
            cmd.append("--learn")
        if opts.compilation_cache:
            cmd.append(f'--compilation-cache="{opts.compilation_cache}"')
        cmd.extend(str(t.parent) for t in succesful_db_creation)
        ql_test_success = subprocess.run(cmd).returncode == 0

    if failed_db_creation:
        print("Database creation failed:", file=sys.stderr)
        for t in failed_db_creation:
            print(" ", t.parent, file=sys.stderr)
        return False

    return ql_test_success


if __name__ == "__main__":
    sys.exit(0 if main(options()) else 1)
