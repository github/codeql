#!/usr/bin/env python3
"""Forward a common verb to the justfiles that implement it.

Verbs like `test`, `build` and `format` are spelled the same everywhere, but what they
mean is defined per language, next to the code they act on. This finds the justfiles
implementing a verb for each of its arguments and runs every one of them, so that
`just test rust` or `just format .` work without a central list of who implements what.

Justfiles are looked for in both directions from an argument:

- above it, where a recipe is passed the argument itself, as that says what to act on
- below it, where a recipe is passed its own directory, as there the argument only said
  where to look

Every distinct recipe found this way runs. Recipes are compared by value, so one reached
through `import` is recognised as the same job and runs once, while a cross-cutting
recipe higher up composes with the more specific ones below instead of hiding them.

Two things keep the search useful: recipes delegating back here are skipped, so it never
settles on a forwarder, and a directory can set `explicit_verbs` to stay out of reach of
a verb aimed at one of its parents. See README.md for the whole picture.

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

# A justfile that forwards a verb has already spent the plain name on the forwarder, so
# it names its own implementation of that verb `_root_<verb>`. This is how a repository
# root gets to answer a verb for itself while still dispatching it everywhere else.
ROOT_PREFIX = "_root_"

# Justfiles may list verbs that must be spelled out explicitly instead of being picked
# up by a verb aimed at one of their parent directories.
EXPLICIT_VERBS = "explicit_verbs"

PROBE_WORKERS = 16


def error(message):
    # Anything already reported on stdout belongs before this, and the two streams are
    # buffered differently when they are not both a terminal.
    sys.stdout.flush()
    print(f"{ERROR}{message}", file=sys.stderr)


def get_just_context(justfile, recipe, flags, positional_args):
    """Get the (cwd, args) for invoking just with the given justfile."""
    if (
        len(positional_args) == 1
        and justfile == Path(positional_args[0]) / "justfile"
    ):
        # If there's only one positional argument and it matches the justfile
        # path, suppress arguments so e.g. `just build ql/rust` becomes
        # `just build` in the `ql/rust` directory
        return positional_args[0], [recipe, *flags]
    else:
        return None, ["--justfile", str(justfile), recipe, *flags, *positional_args]


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


def implements(dump, command, argc):
    """Return the recipe a justfile runs for a command, if it has a usable one."""
    recipes = dump["recipes"]
    recipe = recipes.get(dump["aliases"].get(command, command))
    if recipe is None or recipe["private"]:
        return None
    if any(
        dependency["recipe"] == FORWARD_RECIPE for dependency in recipe["dependencies"]
    ):
        # Here the plain name is the forwarder's own, so it says nothing about what this
        # directory does. A justfile that both forwards and answers the command itself
        # spells its own answer `_root_<command>`, the one name the two can share.
        recipe = recipes.get(f"{ROOT_PREFIX}{command}")
        if recipe is None:
            return None
    return recipe if accepts(recipe, argc) else None


def opts_out(dump, command):
    """Whether a justfile asks to be named rather than found by a command."""
    return command in list_value(dump["assignments"], EXPLICIT_VERBS)


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


def invocation_path(path, *, like):
    """Spell an absolute path like the user spelled the argument."""
    if Path(like).is_absolute():
        return path
    return Path(os.path.relpath(path, Path.cwd()))


def find_justfiles_above(command, arg):
    """Search up the directory tree for justfiles implementing the command.

    All of them are collected rather than just the nearest, because a recipe higher up
    is often doing a different job from one further down rather than a broader version
    of it. Returns (justfile, recipe) pairs, nearest first.
    """
    directory = Path(arg).resolve()
    candidates = [
        invocation_path(p / "justfile", like=arg)
        for p in [directory, *directory.parents]
        if (p / "justfile").exists()
    ]
    found = []
    seen = []
    for justfile, dump in dump_all(candidates):
        # A justfile sitting exactly on the argument is called without it, as the
        # argument would only repeat where it already is.
        argc = 0 if justfile.parent.resolve() == directory else 1
        recipe = implements(dump, command, argc)
        # These justfiles are nested, so a recipe that was seen already is one this
        # one merely imported, and the nearest spelling of it has been taken.
        #
        # Two repositories that each define a root recipe are not that case: the text
        # can match while the workspace, the tool it runs and the paths it excludes all
        # differ, so they have to stay apart. Nothing here says so. They are told apart
        # only by the doc comment one of them happens to carry, which means dropping
        # `doc` from this comparison silently discards an invocation unless a real
        # discriminator arrives in the same change.
        if recipe is not None and recipe not in seen:
            seen.append(recipe)
            found.append((justfile, recipe))
    return found


def find_justfiles_below(command, directory, covered=()):
    """Search down a directory for justfiles implementing the command.

    A justfile is skipped when the recipe it would run is one an enclosing directory
    already contributes, which is what `import` makes happen: the recipe is the same
    job, so running it once is enough. `covered` holds the recipes already found above
    the directory.

    Returns the justfiles to run and, separately, the ones that implement the command
    but ask to be named rather than found.
    """
    # The justfile at `directory` is covered by the search above it.
    candidates = sorted(find_justfiles(directory) - {Path(directory) / "justfile"})
    matches = []
    opted_out = []
    for justfile, dump in dump_all(candidates):
        recipe = implements(dump, command, 0)
        if recipe is None:
            continue
        if opts_out(dump, command):
            opted_out.append(justfile)
        else:
            matches.append((justfile, recipe))
    contributed = {Path(directory): list(covered)}
    found = []
    # Shallowest first, so that an enclosing justfile is always decided before the ones
    # it may account for.
    for justfile, recipe in sorted(matches, key=lambda match: len(match[0].parts)):
        if any(recipe in contributed.get(p, []) for p in justfile.parent.parents):
            continue
        contributed.setdefault(justfile.parent, []).append(recipe)
        found.append((justfile, recipe))
    return sorted(found, key=lambda match: match[0]), sorted(opted_out)


def resolve(command, arg):
    """Find the justfiles implementing a command for an argument.

    Returns a list of (justfile, argument, recipe) triples, from both above and below
    the argument. One found above gets the argument itself, as that selects what to act
    on. One found below gets its own directory instead, as there the argument only said
    where to look. Justfiles below that asked to be named are returned separately.
    """
    above = find_justfiles_above(command, arg)
    resolved = [(justfile, arg, recipe["name"]) for justfile, recipe in above]
    opted_out = []
    if os.path.isdir(arg):
        below, opted_out = find_justfiles_below(
            command, arg, [recipe for _, recipe in above]
        )
        resolved += [
            (justfile, str(justfile.parent), recipe["name"])
            for justfile, recipe in below
        ]
    return resolved, opted_out


def report_opted_out(command, justfiles, *, ran):
    """Name the justfiles a command passed over because they ask to be named.

    Worth saying even when other recipes did run, as otherwise a command that looks
    like it covered a whole directory quietly left parts of it alone. That case is
    informational and goes to stdout with the rest of the account of what ran: the
    command did what was asked of it. Only matching nothing at all is an error.
    """
    if not justfiles:
        return
    directories = sorted(str(jf.parent) for jf in set(justfiles))
    # One per line: there can be dozens, and a single wrapped line is unreadable.
    listed = "\n".join(f"  {directory}" for directory in directories)
    message = f"not run, as {command} must name these explicitly:\n{listed}"
    if ran:
        print(message)
    else:
        error(message)


def invoke_just(cwd, args):
    """Run just with the given arguments."""
    # This process' stdout is block-buffered off a terminal, while the child writes to the
    # same descriptor at once: without this the account lands after what it describes.
    sys.stdout.flush()
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
    opted_out = []
    for arg in positional_args or ["."]:
        resolved, skipped = resolve(cmd, arg)
        opted_out += skipped
        if not resolved:
            error(f"No justfile found for {cmd} on {arg}")
            report_opted_out(cmd, skipped, ran=False)
            return 1
        for justfile, justfile_arg, recipe in resolved:
            justfiles.setdefault(justfile, (recipe, []))[1].append(justfile_arg)

    invocations = []
    for justfile, (recipe, pos_args) in justfiles.items():
        # An argument standing for the whole directory subsumes any more specific one
        # that ended up on the same justfile.
        whole_directory = str(justfile.parent)
        if whole_directory in pos_args:
            pos_args = [whole_directory]
        cwd, just_args = get_just_context(justfile, recipe, flags, pos_args)
        prefix = f"cd {cwd}; " if cwd else ""
        print(f"-> {prefix}just {' '.join(just_args)}")
        invocations.append((cwd, just_args))

    report_opted_out(cmd, opted_out, ran=True)

    for cwd, just_args in invocations:
        if invoke_just(cwd, just_args) != 0:
            # Say which one, as a verb can fan out over a great many directories.
            where = f" in {cwd}" if cwd else ""
            error(f"{cmd} failed{where}: just {' '.join(just_args)}")
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
