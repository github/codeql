"""Run a command on the files matching the given patterns below the given paths.

This is a portable `find <path>... -name <pattern> -exec <command> {} +`. It exists
because `find` is an unrelated program on Windows, and because a shell command
substitution splits the file names it produces on whitespace, which mangles the many
paths in this repository that contain spaces.

The command is run once per batch of file names rather than once per file, and the
batches are sized so that no single command line runs into a length limit. Nothing is
run at all when no file matches.

Usage: run_on_files.py [option...] <pattern>[,<pattern>...] <command> [<arg>...]
                       -- [<path>...]

Options:
  --exclude <pattern>  leave out files whose path matches, repeatable
  --absolute           pass absolute file names, needed when the command runs elsewhere

The command is separated from the paths by the last `--`, so that it may contain one of
its own, as `bazel run <target> -- <flag>...` does.
"""

import os
import subprocess
import sys
from fnmatch import fnmatch
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


def files_under(paths, patterns, excludes=(), absolute=False):
    """Collect the files matching one of the patterns at or below each path.

    Patterns are matched against the file name, as bazel files are identified by name
    rather than by extension. Exclusions are matched against the whole path instead,
    which is how a directory of generated files is left alone.

    Symbolic links are not followed, which is what keeps the `bazel-*` convenience
    links out of the walk.
    """

    def wanted(path):
        return any(fnmatch(path.name, p) for p in patterns) and not any(
            fnmatch(str(path), e) for e in excludes
        )

    found = set()
    for path in map(Path, paths):
        if path.is_file():
            if wanted(path):
                found.add(path)
            continue
        for directory, _, names in os.walk(path):
            found.update(p for p in map(Path(directory).joinpath, names) if wanted(p))
    return sorted(os.path.abspath(p) if absolute else str(p) for p in found)


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


def parse_options(args):
    """Take the leading options off the argument list, returning what they asked for."""
    excludes, absolute = [], False
    while args and args[0] != "--" and args[0].startswith("--"):
        option = args.pop(0)
        if option == "--absolute":
            absolute = True
        elif option == "--exclude":
            excludes.append(args.pop(0))
        else:
            sys.exit(f"run_on_files.py: unknown option {option}")
    return excludes, absolute


def main():
    args = sys.argv[1:]
    excludes, absolute = parse_options(args)
    patterns = set(args[0].split(","))
    rest = args[1:]
    # The command may hold a `--` of its own, so the paths start after the last one.
    separator = len(rest) - 1 - rest[::-1].index("--")
    command, paths = rest[:separator], rest[separator + 1 :]

    files = files_under(paths, patterns, excludes, absolute)
    limit = batch_limit() - sum(len(arg) + 1 for arg in command)
    status = 0
    for batch in batched(files, limit):
        status = subprocess.run([*command, *batch]).returncode or status
    return status


if __name__ == "__main__":
    sys.exit(main())
