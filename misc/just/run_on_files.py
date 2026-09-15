"""Run a command on the files matching the given patterns below the given paths.

This is a portable `find <path>... -name <pattern> -exec <command> {} +`. It exists
because `find` is an unrelated program on Windows, and because a shell command
substitution splits the file names it produces on whitespace, which mangles the many
paths in this repository that contain spaces.

The command is run once per batch of file names rather than once per file, and the
batches are sized so that no single command line runs into a length limit. Nothing is
run at all when no file matches.
"""

import argparse
import os
import re
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


def parse_args():
    """Work out what to run, on which files, and what to hide of what it says."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        usage="%(prog)s [option...] <pattern>[,<pattern>...] "
        "<command> [<arg>...] -- [<path>...]",
    )
    parser.add_argument(
        "--exclude",
        action="append",
        default=[],
        metavar="<pattern>",
        help="leave out files whose path matches, repeatable",
    )
    parser.add_argument(
        "--absolute",
        action="store_true",
        help="pass absolute file names, needed when the command runs elsewhere",
    )
    parser.add_argument(
        "--drop",
        action="append",
        default=[],
        metavar="<regex>",
        help="hide matching lines of the command's output, repeatable",
    )
    parser.add_argument(
        "patterns",
        metavar="<pattern>[,<pattern>...]",
        type=lambda patterns: set(patterns.split(",")),
        help="what to match file names against",
    )
    parser.add_argument(
        "rest",
        nargs=argparse.REMAINDER,
        metavar="<command> [<arg>...] -- [<path>...]",
        help="the command, then the paths to search, separated by the last `--` so "
        "that the command may contain one of its own",
    )
    args = parser.parse_args()
    if "--" not in args.rest:
        parser.error("the paths must be separated from the command by `--`")
    separator = len(args.rest) - 1 - args.rest[::-1].index("--")
    args.command, args.paths = args.rest[:separator], args.rest[separator + 1 :]
    if not args.command:
        parser.error("no command given")
    return args


def run(command, drops):
    """Run the command, hiding the lines of its output that were asked to be hidden.

    Told nothing to hide, the command keeps this process' own output streams, so that
    it can do as it likes with them. Otherwise its diagnostics are read a line at a
    time and passed on as they arrive, which is what keeps a long run's progress
    visible. Only what was named is hidden, so an unforeseen message still gets out.

    Note that these tools report on their progress over standard error rather than
    standard output, which is left alone here.
    """
    if not drops:
        return subprocess.run(command).returncode
    hidden = re.compile("|".join(drops))
    process = subprocess.Popen(command, stderr=subprocess.PIPE, text=True, bufsize=1)
    for line in process.stderr:
        if not hidden.search(line):
            sys.stderr.write(line)
            sys.stderr.flush()
    return process.wait()


def main():
    args = parse_args()
    files = files_under(args.paths, args.patterns, args.exclude, args.absolute)
    limit = batch_limit() - sum(len(argument) + 1 for argument in args.command)
    status = 0
    for batch in batched(files, limit):
        status = run([*args.command, *batch], args.drop) or status
    return status


if __name__ == "__main__":
    sys.exit(main())
