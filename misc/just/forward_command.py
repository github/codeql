#!/usr/bin/env python3
"""Forward commands to language-specific justfiles.

Called from just recipes as:
    python3 forward_command.py COMMAND [ARGS...]
"""

import os
import re
import subprocess
import sys
from pathlib import Path

JUST = os.environ.get("JUST_EXECUTABLE", "just")
ERROR = os.environ.get("JUST_ERROR", "")


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


def check_just_command(justfile, command, positional_args):
    """Check if a justfile supports the given command."""
    if not justfile.exists():
        return False
    cwd, args = get_just_context(justfile, command, [], positional_args)
    result = subprocess.run(
        [JUST, "--dry-run", *args],
        cwd=cwd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
    )
    # Avoid having the forwarder find itself
    return (
        result.returncode == 0
        and f'forward_command.py" {command} "$@"' not in result.stderr
    )


def find_justfile(command, arg):
    """Search up the directory tree for a justfile supporting the command."""
    for p in [Path(arg), *Path(arg).parents]:
        candidate = p / "justfile"
        if check_just_command(candidate, command, [arg]):
            return candidate
    return None


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
        justfile = find_justfile(cmd, arg)
        if not justfile:
            error(f"No justfile found for {cmd} on {arg}")
            return 1
        justfiles.setdefault(justfile, []).append(arg)

    invocations = []
    for justfile, pos_args in justfiles.items():
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
