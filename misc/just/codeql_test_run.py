#!/usr/bin/env python3
"""Run CodeQL tests with appropriate configuration.

Called from just recipes as:
    python3 codeql_test_run.py LANGUAGE BASE_FLAGS ALL_CHECKS_FLAGS EXTRA_ARGS
"""

import os
import re
import shlex
import subprocess
import sys
from pathlib import Path

JUST = os.environ.get("JUST_EXECUTABLE", "just")
ERROR = os.environ.get("JUST_ERROR", "error: ")
CMD_BEGIN = os.environ.get("CMD_BEGIN", "")
CMD_END = os.environ.get("CMD_END", "")
SEMMLE_CODE = os.environ.get("SEMMLE_CODE")


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


ENV_RE = re.compile(r"^[A-Z_][A-Z_0-9]*=.*$")


def parse_args(args, argv_str):
    """Parse a space-separated argument string into categorized arguments."""
    for arg in shlex.split(argv_str):
        if arg.startswith("--codeql="):
            args["codeql"] = arg.split("=", 1)[1]
        elif arg in ("+", "--all-checks"):
            args["all"] = True
        elif arg.startswith("-"):
            args["flags"].append(arg)
        elif ENV_RE.match(arg):
            args["env"].append(arg)
        elif arg:
            args["tests"].append(arg)


def main():
    argv = sys.argv[1:]
    if len(argv) < 4:
        error(
            "Usage: codeql_test_run.py LANGUAGE BASE_FLAGS ALL_CHECKS_FLAGS EXTRA_ARGS"
        )
        return 1

    language, base_args, all_args, extra_args = argv[0], argv[1], argv[2], argv[3]
    ram_per_thread = 3000 if sys.platform == "linux" else 2048
    cpus = os.cpu_count() or 1

    args = {
        "tests": [],
        "flags": [f"--ram={ram_per_thread * cpus}", f"-j{cpus}"],
        "env": [],
        "codeql": "build" if SEMMLE_CODE else "host",
        "all": False,
    }
    parse_args(args, base_args)
    parse_args(args, extra_args)
    if args["all"]:
        parse_args(args, all_args)

    if not SEMMLE_CODE and args["codeql"] in ("build", "built"):
        error(
            "Using `--codeql=build` or `--codeql=built` requires working "
            "with the internal repository"
        )
        return 1

    if not args["tests"]:
        args["tests"].append(".")

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
        if not codeql.exists():
            error(f"CodeQL executable not found: {codeql}")
            return 1
    elif args["codeql"] == "host":
        codeql = Path("codeql")
    else:
        codeql = Path(args["codeql"])
        if not codeql.exists():
            error(f"CodeQL executable not found: {codeql}")
            return 1

    if codeql.is_dir():
        codeql = codeql / "codeql"
        if sys.platform == "win32":
            codeql = codeql.with_suffix(".exe")
        if not codeql.exists():
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
