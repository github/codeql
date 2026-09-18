#!/usr/bin/env python3
"""Run CodeQL tests with appropriate configuration.

Called from just recipes as:
    python3 codeql_test_run.py LANGUAGE [ARG...]

Arguments are already split by `just` (see `set lists`), so each one is taken verbatim.
`--extra-check=FLAG` offers FLAG as a check to run, and `--all-checks` (or its `+`
abbreviation) turns the offered ones on. Per-language justfiles supply the offers and
the caller supplies the switch, so the two are separate options rather than one.
"""

import argparse
import os
import re
import subprocess
import sys
import shutil
from pathlib import Path

JUST = os.environ.get("JUST_EXECUTABLE", "just")
ERROR = os.environ.get("JUST_ERROR", "error: ")
CMD_BEGIN = os.environ.get("CMD_BEGIN", "")
CMD_END = os.environ.get("CMD_END", "")
SEMMLE_CODE = os.environ.get("SEMMLE_CODE")

ENV_RE = re.compile(r"(^[A-Z_][A-Z_0-9]*)=(.*)$")


def invoke(invocation, *, cwd=None, log_prefix=""):
    prefix = f"{log_prefix} " if log_prefix else ""
    print(f"{CMD_BEGIN}{prefix}{' '.join(map(str, invocation))}{CMD_END}")
    try:
        subprocess.run(invocation, check=True, cwd=cwd)
    except subprocess.CalledProcessError as e:
        return e.returncode
    return 0


def error(message):
    print(f"{ERROR}{message}", file=sys.stderr)
    raise SystemExit(1)


class _Parser(argparse.ArgumentParser):
    """An `argparse` parser that fails the way the rest of this script does.

    The default reports to `stderr` in its own format and exits 2, which would arrive
    in a `just` banner unprefixed and alongside a usage line naming this script rather
    than the recipe the caller actually typed.
    """

    def error(self, message):
        error(message)


def build_parser():
    # `+` can be an option string only because it is also a prefix character. `-h` and
    # `--help` are left unclaimed so that they reach `codeql test run`.
    parser = _Parser(add_help=False, allow_abbrev=False, prefix_chars="-+")
    parser.add_argument("language")
    parser.add_argument("--codeql", default="build" if SEMMLE_CODE else "host")
    parser.add_argument("--extra-check", action="append", dest="extra_checks")
    parser.add_argument("--all-checks", "+", action="store_true", dest="all")
    parser.set_defaults(extra_checks=[], tests=[], flags=[], env={})
    return parser


def parse_arguments():
    """Sort a command line into the kinds that are handled differently.

    `argparse` owns the options this script acts on itself. Everything else belongs to
    `codeql test run` and has to survive untouched, which is what `parse_known_args`
    hands back, and what is sorted by shape here: a test path and a `CPUS=4` are both
    positionals, told apart only by how they look.
    """
    p = build_parser()
    args, rest = p.parse_known_args()
    if args.codeql in ("build", "built") and not SEMMLE_CODE:
        p.error(
            "Using `--codeql=build` or `--codeql=built` requires working "
            "with the internal repository"
        )

    for arg in rest:
        if arg.startswith("-"):
            args.flags.append(arg)
        elif m := ENV_RE.match(arg):
            k, v = m.groups()
            args.env[k] = v
        else:
            args.tests.append(arg)
    return args


def resolve_codeql(args: argparse.Namespace) -> Path:
    suffix = ".exe" if sys.platform == "win32" else ""
    match args.codeql:
        case "built" | "build":
            return Path(
                SEMMLE_CODE,
                "target",
                "intree",
                f"codeql-{args.language}",
                "codeql" + suffix,
            )
        case "host":
            codeql = shutil.which("codeql" + suffix)
            if not codeql:
                error("CodeQL executable not found in PATH")
            return Path(codeql)
        case _:
            codeql = Path(args.codeql)
            if codeql.is_dir():
                codeql /= "codeql" + suffix
            return codeql


def main():
    args = parse_arguments()

    if args.all:
        # Apply what the language offered by parsing it alongside everything else, so an
        # offered check lands exactly where the same flag typed by hand would.
        sys.argv[1:1] = args.extra_checks
        args = parse_arguments()

    if not args.tests:
        args.tests.append(".")

    os.environ.update(args.env)

    # Resolve these only once all arguments are known, so that a `RAM_PER_THREAD=` test
    # argument can lower the default on memory-heavy suites.
    default_ram = 3000 if sys.platform == "linux" else 2048
    ram_per_thread = int(os.environ.get("RAM_PER_THREAD") or default_ram)
    cpus = int(os.environ.get("CPUS") or os.cpu_count() or 1)
    args.flags[:0] = [f"--ram={ram_per_thread * cpus}", f"-j{cpus}"]

    if args.codeql == "build":
        if ret := invoke([JUST, args.language, "build"], cwd=SEMMLE_CODE):
            return ret

    if args.codeql != "host":
        # Disable the default implicit config file, but keep an explicit one.
        # Same behavior wrt --codeql as the integration test runner.
        os.environ.setdefault("CODEQL_CONFIG_FILE", ".")

    codeql = resolve_codeql(args)

    if not codeql.exists():
        error(f"CodeQL executable not found: {codeql}")

    return invoke(
        [codeql, "test", "run", *args.flags, "--", *args.tests],
        log_prefix=" ".join(f"{k}={v}" for k, v in args.env.items()),
    )


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(128 + 2)
