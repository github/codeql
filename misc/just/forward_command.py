#!/usr/bin/env python3
"""Forward commands to language-specific justfiles.

Called from just recipes as:
    python3 forward_command.py COMMAND [ARGS...]
"""

import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

JUST = os.environ.get("JUST_EXECUTABLE", "just")
ERROR = os.environ.get("JUST_ERROR", "")

# Recipes that delegate to this one do not implement a verb, they pass it on. Skipping
# them is what stops the search from settling on a forwarder, be it this one or the root
# justfile of a nested repository.
FORWARD_RECIPE = "_forward"

# Justfiles may list verbs that must be spelled out explicitly instead of being picked
# up by a verb aimed at one of their parent directories.
EXPLICIT_VERBS = "explicit_verbs"

PROBE_WORKERS = 16


def error(message):
    print(f"{ERROR}{message}", file=sys.stderr)


def get_just_context(justfile, cmd, flags, positional_args):
    """Get the (cwd, args) for invoking just with the given justfile."""
    if (
        len(positional_args) == 1
        and justfile == Path(positional_args[0]) / "justfile"
    ):
        # If there's only one positional argument and it matches the justfile
        # path, suppress arguments so e.g. `just build ql/rust` becomes
        # `just build` in the `ql/rust` directory
        return positional_args[0], [cmd, *flags]
    else:
        return None, ["--justfile", str(justfile), cmd, *flags, *positional_args]


def dump_justfile(justfile):
    """Parse a justfile with `just`, returning its JSON dump or an error message."""
    result = subprocess.run(
        [JUST, "--dump", "--dump-format", "json", "--justfile", str(justfile)],
        stdin=subprocess.DEVNULL,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return None, result.stderr.strip()
    return json.loads(result.stdout), None


def list_value(assignments, name):
    """Read a list literal assignment from a justfile dump."""
    value = assignments.get(name, {}).get("value")
    # A literal list is dumped as ["list", element...]. Anything else is an expression
    # that cannot be evaluated without running just, and counts as absent.
    if isinstance(value, list) and value[:1] == ["list"]:
        return value[1:]
    return []


def accepts(recipe, argc):
    """Check whether a recipe can be called with a given number of arguments."""
    parameters = recipe["parameters"]
    variadic = parameters and parameters[-1]["kind"] in ("star", "plus")
    required = sum(
        1
        for parameter in parameters
        if parameter["default"] is None and parameter["kind"] != "star"
    )
    return required <= argc and (variadic or argc <= len(parameters))


def implements(dump, command, argc, *, implicitly):
    """Return the recipe a justfile runs for a command, if it has a usable one."""
    recipe = dump["recipes"].get(dump["aliases"].get(command, command))
    if recipe is None or recipe["private"] or not accepts(recipe, argc):
        return None
    if any(
        dependency["recipe"] == FORWARD_RECIPE for dependency in recipe["dependencies"]
    ):
        return None
    if implicitly and command in list_value(dump["assignments"], EXPLICIT_VERBS):
        return None
    return recipe


def dump_all(justfiles):
    """Parse justfiles in parallel, reporting the ones that cannot be read."""
    with ThreadPoolExecutor(PROBE_WORKERS) as executor:
        dumps = list(executor.map(dump_justfile, justfiles))
    parsed = []
    for justfile, (dump, failure) in zip(justfiles, dumps):
        if dump is None:
            error(f"could not read {justfile}:\n{failure}")
        else:
            parsed.append((justfile, dump))
    return parsed


def git(directory, *args):
    """Run a git command in a directory, returning its output lines."""
    result = subprocess.run(
        ["git", "-C", directory, *args],
        stdin=subprocess.DEVNULL,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        error(f"`git {' '.join(args)}` failed in {directory}:\n{result.stderr.strip()}")
        return []
    return result.stdout.splitlines()


def submodules(directory):
    """List the initialised submodules under a directory."""
    toplevel = git(directory, "rev-parse", "--show-toplevel")
    if not toplevel or not (Path(toplevel[0]) / ".gitmodules").exists():
        return []
    paths = [
        Path(toplevel[0]) / line.split(" ", 1)[1]
        for line in git(
            toplevel[0], "config", "--file", ".gitmodules", "--get-regexp", r"\.path$"
        )
    ]
    within = Path(directory).resolve()
    return [
        Path(directory) / os.path.relpath(path, within)
        for path in paths
        # An uninitialised submodule is an empty directory, with nothing to run.
        if path.is_relative_to(within) and (path / ".git").exists()
    ]


def find_justfiles(directory):
    """List every justfile under a directory.

    Submodules are listed separately, as `git ls-files` can either recurse into them or
    report untracked files, but not both, and a justfile that has just been written is
    worth finding.
    """
    justfiles = set()
    for repository in [directory, *submodules(directory)]:
        justfiles.update(
            Path(repository) / line
            for line in git(
                repository,
                "ls-files",
                "--cached",
                "--others",
                "--exclude-standard",
                "--",
                "justfile",
                "*/justfile",
            )
        )
    return justfiles


def find_justfiles_above(command, arg):
    """Search up the directory tree for justfiles implementing the command.

    All of them are collected rather than just the nearest, because a recipe higher up
    is often doing a different job from one further down rather than a broader version
    of it. Returns (justfile, recipe) pairs, nearest first.
    """
    candidates = [
        p / "justfile"
        for p in [Path(arg), *Path(arg).parents]
        if (p / "justfile").exists()
    ]
    found = []
    seen = []
    for justfile, dump in dump_all(candidates):
        # A justfile sitting exactly on the argument is called without it, as the
        # argument would only repeat where it already is.
        argc = 0 if justfile.parent == Path(arg) else 1
        recipe = implements(dump, command, argc, implicitly=False)
        # These justfiles are nested, so a recipe that was seen already is one this
        # one merely imported, and the nearest spelling of it has been taken.
        if recipe is not None and recipe not in seen:
            seen.append(recipe)
            found.append((justfile, recipe))
    return found


def find_justfiles_below(command, directory, covered=(), *, implicitly=True):
    """Search down a directory for justfiles implementing the command.

    A justfile is skipped when the recipe it would run is one an enclosing directory
    already contributes, which is what `import` makes happen: the recipe is the same
    job, so running it once is enough. `covered` holds the recipes already found above
    the directory.
    """
    # The justfile at `directory` is covered by the search above it.
    candidates = sorted(find_justfiles(directory) - {Path(directory) / "justfile"})
    matches = [
        (justfile, recipe)
        for justfile, dump in dump_all(candidates)
        if (recipe := implements(dump, command, 0, implicitly=implicitly))
    ]
    contributed = {Path(directory): list(covered)}
    found = []
    # Shallowest first, so that an enclosing justfile is always decided before the ones
    # it may account for.
    for justfile, recipe in sorted(matches, key=lambda match: len(match[0].parts)):
        if any(recipe in contributed.get(p, []) for p in justfile.parent.parents):
            continue
        contributed.setdefault(justfile.parent, []).append(recipe)
        found.append(justfile)
    return sorted(found)


def resolve(command, arg):
    """Find the justfiles implementing a command for an argument.

    Returns a list of (justfile, argument) pairs, from both above and below the
    argument. One found above gets the argument itself, as that selects what to act on.
    One found below gets its own directory instead, as there the argument only said
    where to look.
    """
    above = find_justfiles_above(command, arg)
    resolved = [(justfile, arg) for justfile, _ in above]
    if os.path.isdir(arg):
        below = find_justfiles_below(command, arg, [recipe for _, recipe in above])
        resolved += [(justfile, str(justfile.parent)) for justfile in below]
    return resolved


def report_missing(command, arg):
    """Explain a command going nowhere, naming what opted out of being found."""
    error(f"No justfile found for {command} on {arg}")
    if not os.path.isdir(arg):
        return
    skipped = find_justfiles_below(command, arg, implicitly=False)
    if skipped:
        directories = " ".join(sorted(str(jf.parent) for jf in skipped))
        error(f"these ask to be named explicitly: {directories}")


def invoke_just(cwd, args):
    """Run just with the given arguments."""
    try:
        subprocess.run([JUST, *args], check=True, cwd=cwd)
    except subprocess.CalledProcessError as e:
        return e.returncode
    return 0


def forward(cmd, args):
    """Forward a command to language-specific justfiles."""
    is_non_positional = re.compile(r"^(-.*|\+|[A-Z_][A-Z_0-9]*=.*)$")
    flags = [arg for arg in args if is_non_positional.match(arg)]
    positional_args = [arg for arg in args if not is_non_positional.match(arg)]

    justfiles = {}
    for arg in positional_args or ["."]:
        resolved = resolve(cmd, arg)
        if not resolved:
            report_missing(cmd, arg)
            return 1
        for justfile, justfile_arg in resolved:
            justfiles.setdefault(justfile, []).append(justfile_arg)

    invocations = []
    for justfile, pos_args in justfiles.items():
        # An argument standing for the whole directory subsumes any more specific one
        # that ended up on the same justfile.
        whole_directory = str(justfile.parent)
        if whole_directory in pos_args:
            pos_args = [whole_directory]
        cwd, just_args = get_just_context(justfile, cmd, flags, pos_args)
        prefix = f"cd {cwd}; " if cwd else ""
        print(f"-> {prefix}just {' '.join(just_args)}")
        invocations.append((cwd, just_args))

    for cwd, just_args in invocations:
        if invoke_just(cwd, just_args) != 0:
            return 1
    return 0


def main():
    argv = sys.argv[1:]
    if not argv:
        error("No command provided")
        return 1
    return forward(argv[0], argv[1:])


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(128 + 2)
