"""Run a command on the files with the given extensions below the given paths.

This is a portable `find <path>... -name '*.<ext>' -exec <command> {} +`. It exists
because `find` is an unrelated program on Windows, and because a shell command
substitution splits the file names it produces on whitespace, which mangles the many
paths in this repository that contain spaces.

The command is run once per batch of file names rather than once per file, and the
batches are sized so that no single command line runs into a length limit. Nothing is
run at all when no file matches.

Usage: run_on_files.py <ext>[,<ext>...] <command> [<arg>...] -- [<path>...]
"""

import os
import subprocess
import sys
from pathlib import Path

def batch_limit():
    """How many characters of file names to put on one command line.

    Windows caps a whole command line at 32767 characters. Elsewhere the cap is
    `ARG_MAX`, which the environment is counted against as well, so that is taken off
    along with some slack. This is worth doing rather than assuming the tightest of the
    two: `ARG_MAX` is 2MB on Linux, which turns the couple of thousand QL files of a
    language into a single invocation rather than several.
    """
    if sys.platform == "win32":
        return 30000
    try:
        arg_max = os.sysconf("SC_ARG_MAX")
    except (ValueError, OSError):
        return 30000
    environment = sum(len(name) + len(value) + 2 for name, value in os.environ.items())
    return max(4096, arg_max - environment - 4096)


def files_under(paths, extensions):
    """Collect the files with one of the extensions at or below each path.

    Symbolic links are not followed, which is what keeps the `bazel-*` convenience
    links out of the walk.
    """
    found = set()
    for path in map(Path, paths):
        if path.is_file():
            if path.suffix in extensions:
                found.add(path)
            continue
        for directory, _, names in os.walk(path):
            found.update(
                Path(directory) / name
                for name in names
                if Path(name).suffix in extensions
            )
    return sorted(str(path) for path in found)


def batched(files, limit):
    """Split file names into groups that each fit on one command line."""
    batch, length = [], 0
    for file in files:
        if batch and length + len(file) + 1 > limit:
            yield batch
            batch, length = [], 0
        batch.append(file)
        length += len(file) + 1
    if batch:
        yield batch


def main():
    extensions = set(sys.argv[1].split(","))
    rest = sys.argv[2:]
    separator = rest.index("--")
    command, paths = rest[:separator], rest[separator + 1 :]

    files = files_under(paths, extensions)
    limit = batch_limit() - sum(len(arg) + 1 for arg in command)
    status = 0
    for batch in batched(files, limit):
        status = subprocess.run([*command, *batch]).returncode or status
    return status


if __name__ == "__main__":
    sys.exit(main())
