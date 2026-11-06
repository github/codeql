"""Run a command on the files matching the given patterns below the given paths.

This is a portable `find <path>... -name <pattern> -exec <command> {} +`. It exists
because `find` is an unrelated program on Windows, and because a shell command
substitution splits the file names it produces on whitespace, which mangles the many
paths in this repository that contain spaces.

The command is run once per batch of file names rather than once per file, and the
batches are sized so that no single command line runs into a length limit. Nothing is
run at all when no file matches, and nothing is announced either, so silence means that
nothing here matched rather than that nothing was there: a path that does not exist is
refused instead, naming one being an assertion that it does.
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

    A single argument is capped far lower than the whole line, at 128KB on Linux, and a
    command that hands its arguments on through a shell arrives as one of them. Batches
    are kept below that too, as the resulting failure is reported by whatever did the
    handing on rather than by anything naming this file.
    """
    if sys.platform == "win32":
        return 30000
    single_argument = 100000
    try:
        arg_max = os.sysconf("SC_ARG_MAX")
    except (ValueError, OSError):
        return 30000
    environment = sum(len(name) + len(value) + 2 for name, value in os.environ.items())
    return max(4096, min(arg_max - environment - 4096, single_argument))


def files_under(paths, patterns, excludes=(), absolute=False, within=None):
    """Collect the files matching one of the patterns at or below each path.

    Patterns are matched against the file name, as bazel files are identified by name
    rather than by extension. Exclusions are matched against the whole path instead,
    which is how a directory of generated files is left alone. Both the path the walk
    built and its resolved form are tried, as the walk only ever extends the path it
    was given: walking `cpp` from inside a directory builds nothing naming that
    directory, so an exclusion naming it could never match. An exclusion that has to
    hold however the path was reached is therefore anchored absolutely, and resolving
    is what makes that spelling hold for a path reached through a symbolic link too.

    A `within` directory bounds the result to the files below it, for a command that
    answers for one project and may be handed a path reaching outside it.

    Symbolic links are not followed, which is what keeps the `bazel-*` convenience
    links out of the walk.

    Returns the file names, and the given paths that yielded one. The two differ
    whenever a path is excluded or simply holds nothing matching, and telling them
    apart is what lets the banner name the paths being acted on rather than the paths
    that were asked about.
    """
    boundary = Path(within).resolve() if within else None

    def wanted(path):
        # The name decides most files and costs nothing, so it is asked first: resolving
        # is a system call, and is only owed for a file that could still be collected.
        if not any(fnmatch(path.name, p) for p in patterns):
            return False
        if boundary is None and not excludes:
            return True
        resolved = path.resolve()
        if boundary is not None and not resolved.is_relative_to(boundary):
            return False
        # A relative pattern is anchored at the start, so it cannot match the resolved
        # spelling: trying both only ever gives a pattern the reach it was written with.
        spellings = (str(path), str(resolved))
        return not any(
            fnmatch(spelling, e) for e in excludes for spelling in spellings
        )

    def collect(path):
        if path.is_file():
            return {path} if wanted(path) else set()
        return {
            file
            for directory, _, names in os.walk(path)
            for file in map(Path(directory).joinpath, names)
            if wanted(file)
        }

    # Kept per path rather than in one set, as which path a file came from is not a
    # question the collected names can be asked afterwards without resolving each of
    # them again. A file reached by two paths still only appears once below.
    contributed = {}
    for given in paths:
        collected = collect(Path(given))
        if collected:
            # Keyed by the spelling that was given rather than a normalised one, as
            # this goes back to whoever wrote it and is theirs to recognise.
            contributed[str(given)] = collected
    files = sorted(
        os.path.abspath(file) if absolute else str(file)
        for file in set().union(*contributed.values())
    )
    return files, list(contributed)


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


def comma_separated(value):
    """Split an option value listing several patterns.

    Patterns tend to come in groups, and a justfile passes them as one variable, so they
    are spelled as one argument here rather than repeated. Repeating the option works
    too, which is what lets a list be extended rather than restated.
    """
    return value.split(",")


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
        action="extend",
        default=[],
        type=comma_separated,
        metavar="<pattern>[,<pattern>...]",
        help="leave out files whose path matches, repeatable",
    )
    parser.add_argument(
        "--absolute",
        action="store_true",
        help="pass absolute file names, needed when the command runs elsewhere",
    )
    parser.add_argument(
        "--chdir",
        metavar="<directory>",
        help="run the command from here, for one that must be run from a project root",
    )
    parser.add_argument(
        "--within",
        metavar="<directory>",
        help="leave out files outside this directory, for a command answering for one "
        "project that may be handed a path reaching beyond it",
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
        type=comma_separated,
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
    missing = [path for path in args.paths if not os.path.exists(path)]
    if missing:
        parser.error("no such path: " + ", ".join(missing))
    return args


def run(command, drops, chdir=None):
    """Run the command, hiding the lines of its output that were asked to be hidden.

    Told nothing to hide, the command keeps this process' own output streams, so that
    it can do as it likes with them. Otherwise its diagnostics are read a line at a
    time and passed on as they arrive, which is what keeps a long run's progress
    visible. Only what was named is hidden, so an unforeseen message still gets out.

    Note that these tools report on their progress over standard error rather than
    standard output, which is left alone here.
    """
    if not drops:
        return subprocess.run(command, cwd=chdir).returncode
    hidden = re.compile("|".join(drops))
    process = subprocess.Popen(
        command, cwd=chdir, stderr=subprocess.PIPE, text=True, bufsize=1
    )
    for line in process.stderr:
        if not hidden.search(line):
            sys.stderr.write(line)
            sys.stderr.flush()
    return process.wait()


def banner(command, paths):
    """Announce a command over the paths it turned out to have something to do in.

    Only the paths that yielded a file are named: one whose files were all excluded is
    not being acted on, and naming it claims work that is not about to happen. The file
    names are left out, there being thousands of them and the paths being what was
    asked for.

    So this is a report rather than something to paste, the collecting being the whole
    point. `just -n` prints what really runs.

    `CMD_BEGIN` and `CMD_END` are the rules the justfiles put around a command; with
    neither set this is a plain line.
    """
    begin = os.environ.get("CMD_BEGIN", "")
    end = os.environ.get("CMD_END", "")
    return f"{begin}-> {' '.join(command)} -- {' '.join(paths)}{end}"


def main():
    args = parse_args()
    files, contributing = files_under(
        args.paths, args.patterns, args.exclude, args.absolute, args.within
    )
    if files:
        # Neither half of this is known where the caller would have to say it: whether
        # anything is going to run at all, and which of the paths it named hold any of
        # it.
        print(banner(args.command, contributing), file=sys.stderr, flush=True)
    limit = batch_limit() - sum(len(argument) + 1 for argument in args.command)
    status = 0
    for batch in batched(files, limit):
        status = run([*args.command, *batch], args.drop, args.chdir) or status
    return status


if __name__ == "__main__":
    sys.exit(main())
