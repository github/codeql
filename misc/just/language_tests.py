#!/usr/bin/env python3
"""Run a whole language test suite for CI.

Called from just recipes as:
    python3 language_tests.py ROOT [ARG...]

Arguments are already split by `just` (see `set lists`). Only the first locates a
justfile: its `test` recipe is run once, and every argument after it is handed to that
one recipe rather than visited in turn. Roots wanting different `test` recipes therefore
cannot be run together.
"""

import os
import subprocess
import sys
from pathlib import Path


def main():
    argv = sys.argv[1:]
    if not argv:
        print("Usage: language_tests.py ROOT [ARG...]", file=sys.stderr)
        return 1

    semmle_code = Path(os.environ["SEMMLE_CODE"])
    # Test roots are absolute, as justfiles build them from `source_dir()`. We run from
    # the internal checkout, so relativize them there to keep command lines readable.
    # Anything else (flags, environment assignments, relative paths) is passed verbatim.
    args = [
        os.path.relpath(arg, semmle_code) if os.path.isabs(arg) else arg for arg in argv
    ]

    just = os.environ.get("JUST_EXECUTABLE", "just")

    # Find the nearest justfile at or above the first root
    justfile_dir = Path(args[0])
    while not (semmle_code / justfile_dir / "justfile").exists():
        parent = justfile_dir.parent
        if parent == justfile_dir:
            print(f"No justfile found above {args[0]}", file=sys.stderr)
            return 1
        justfile_dir = parent

    invocation = [
        just,
        "--justfile",
        str(justfile_dir / "justfile"),
        "test",
        "--all-checks",
        "--codeql=built",
        *args,
    ]

    print(f"-> just {' '.join(invocation[1:])}")
    try:
        subprocess.run(invocation, check=True, cwd=semmle_code)
    except subprocess.CalledProcessError as e:
        return e.returncode
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(128 + 2)
