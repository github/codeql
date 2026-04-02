#!/usr/bin/env python3
"""Run all language tests for CI.

Called from just recipes as:
    python3 language_tests.py EXTRA_ARGS SOURCE_DIR ROOT1 [ROOT2 ...]
"""

import os
import subprocess
import sys
from pathlib import Path


def main():
    argv = sys.argv[1:]
    if len(argv) < 3:
        print(
            "Usage: language_tests.py EXTRA_ARGS SOURCE_DIR ROOT1 [ROOT2 ...]",
            file=sys.stderr,
        )
        return 1

    extra_args, source_dir, *relative_roots = argv

    semmle_code = Path(os.environ["SEMMLE_CODE"])
    roots = [
        os.path.relpath(Path(source_dir) / root, semmle_code)
        for root in relative_roots
    ]

    just = os.environ.get("JUST_EXECUTABLE", "just")
    invocation = [
        just,
        "--justfile",
        str(Path(roots[0]) / "justfile"),
        "test",
        "--all-checks",
        "--codeql=built",
        *(a for a in extra_args.split(" ") if a),
        *roots,
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
