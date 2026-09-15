#!/usr/bin/env python3
"""Run CodeQL tests with appropriate configuration.

Called from just recipes as:
    python3 codeql_test_run.py LANGUAGE [ARG...]

Arguments are already split by `just` (see `set lists`), so each one is taken verbatim.
`--all-checks=FLAG` contributes FLAG to the set of extra checks that `--all-checks` (or
its `+` abbreviation) turns on.
"""

import os
import re
import subprocess
import sys
from pathlib import Path

JUST = os.environ.get("JUST_EXECUTABLE", "just")
ERROR = os.environ.get("JUST_ERROR", "error: ")
CMD_BEGIN = os.environ.get("CMD_BEGIN", "")
CMD_END = os.environ.get("CMD_END", "")
SEMMLE_CODE = os.environ.get("SEMMLE_CODE")

ALL_CHECKS_PREFIX = "--all-checks="
ENV_RE = re.compile(r"^[A-Z_][A-Z_0-9]*=.*$")


def invoke(invocation, *, cwd=None, log_prefix=""):
    prefix = f"{log_prefix} " if log_prefix else ""
    print(f"{CMD_BEGIN}{prefix}{' '.join(invocation)}{CMD_END}")
    try:
        subprocess.run(invocation, check=True, cwd=cwd)
    except subprocess.CalledProcessError as e:
        return e.returncode
    return 0


def error(message):
    print(f"{ERROR}{message}", file=sys.stderr)


def parse_args(args, argv):
    """Sort arguments into tests, flags and environment assignments."""
    for arg in argv:
        if not arg:
            # an empty argument can come from a caller interpolating an unset variable
            continue
        if arg.startswith(ALL_CHECKS_PREFIX):
            args["all_checks"].append(arg[len(ALL_CHECKS_PREFIX) :])
        elif arg.startswith("--codeql="):
            args["codeql"] = arg.split("=", 1)[1]
        elif arg in ("+", "--all-checks"):
            args["all"] = True
        elif arg.startswith("-"):
            args["flags"].append(arg)
        elif ENV_RE.match(arg):
            args["env"].append(arg)
        else:
            args["tests"].append(arg)


def env_value(args, name, default):
    """Resolve a setting from test arguments, then the environment, then a default."""
    for assignment in reversed(args["env"]):
        key, _, value = assignment.partition("=")
        if key == name and value:
            return value
    return os.environ.get(name) or default


def main():
    argv = sys.argv[1:]
    if not argv:
        error("Usage: codeql_test_run.py LANGUAGE [ARG...]")
        return 1

    language, *rest = argv

    args = {
        "tests": [],
        "flags": [],
        "env": [],
        "all_checks": [],
        "codeql": "build" if SEMMLE_CODE else "host",
        "all": False,
    }
    parse_args(args, rest)
    if args["all"]:
        parse_args(args, args["all_checks"])

    if not SEMMLE_CODE and args["codeql"] in ("build", "built"):
        error(
            "Using `--codeql=build` or `--codeql=built` requires working "
            "with the internal repository"
        )
        return 1

    if not args["tests"]:
        args["tests"].append(".")

    # Resolve these only once all arguments are known, so that a `RAM_PER_THREAD=` test
    # argument can lower the default on memory-heavy suites.
    default_ram = 3000 if sys.platform == "linux" else 2048
    ram_per_thread = int(env_value(args, "RAM_PER_THREAD", default_ram))
    cpus = int(env_value(args, "CPUS", os.cpu_count() or 1))
    args["flags"][:0] = [f"--ram={ram_per_thread * cpus}", f"-j{cpus}"]

    if args["codeql"] == "build":
        if invoke([JUST, language, "build"], cwd=SEMMLE_CODE) != 0:
            return 1

    if args["codeql"] != "host":
        # Disable the default implicit config file, but keep an explicit one.
        # Same behavior wrt --codeql as the integration test runner.
        os.environ.setdefault("CODEQL_CONFIG_FILE", ".")

    for env_var in args["env"]:
        key, _, value = env_var.partition("=")
        if not key:
            error(f"Invalid environment variable assignment: {env_var}")
            return 1
        os.environ[key] = value

    # Resolve codeql executable
    if args["codeql"] in ("built", "build"):
        codeql = Path(SEMMLE_CODE, "target", "intree", f"codeql-{language}", "codeql")
    elif args["codeql"] == "host":
        codeql = Path("codeql")
    else:
        codeql = Path(args["codeql"])

    if codeql.is_dir():
        codeql = codeql / "codeql"

    # On Windows, prefer codeql.exe over the Unix shell wrapper
    if sys.platform == "win32" and codeql.suffix != ".exe":
        exe = codeql.with_suffix(".exe")
        if exe.exists():
            codeql = exe

    if args["codeql"] != "host" and not codeql.exists():
        error(f"CodeQL executable not found: {codeql}")
        return 1

    return invoke(
        [str(codeql), "test", "run", *args["flags"], "--", *args["tests"]],
        log_prefix=" ".join(args["env"]),
    )


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(128 + 2)
