#!/usr/bin/env python3
""" Driver script to run all code generation """

import argparse
import logging
import pathlib
import sys
import importlib
import types
import typing

from swift.codegen.lib import render, paths
from swift.codegen.generators import generate


def _parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Code generation suite")
    p.add_argument("--generate", type=lambda x: x.split(","), default=["dbscheme", "ql"],
                   help="specify what targets to generate as a comma separated list, choosing among dbscheme, ql, trap "
                        "and cpp")
    p.add_argument("--verbose", "-v", action="store_true", help="print more information")
    p.add_argument("--swift-dir", type=_abspath, default=paths.swift_dir,
                   help="the directory that should be regarded as the root of the swift codebase. Used to compute QL "
                        "imports and in some comments (default %(default)s)")
    p.add_argument("--schema", type=_abspath, default=paths.swift_dir / "codegen/schema.yml",
                   help="input schema file (default %(default)s)")
    p.add_argument("--dbscheme", type=_abspath, default=paths.swift_dir / "ql/lib/swift.dbscheme",
                   help="output file for dbscheme generation, input file for trap generation (default %(default)s)")
    p.add_argument("--ql-output", type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/generated",
                   help="output directory for generated QL files (default %(default)s)")
    p.add_argument("--ql-stub-output", type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/elements",
                   help="output directory for QL stub/customization files (default %(default)s). Defines also the "
                        "generated qll file importing every class file")
    p.add_argument("--ql-test-output", type=_abspath, default=paths.swift_dir / "ql/test/extractor-tests/generated",
                   help="output directory for QL generated extractor test files (default %(default)s)")
    p.add_argument("--ql-format", action="store_true", default=True,
                   help="use codeql to autoformat QL files (which is the default)")
    p.add_argument("--no-ql-format", action="store_false", dest="ql_format", help="do not format QL files")
    p.add_argument("--codeql-binary", default="codeql", help="command to use for QL formatting (default %(default)s)")
    p.add_argument("--cpp-output", type=_abspath,
                   help="output directory for generated C++ files, required if trap or cpp is provided to --generate")
    return p.parse_args()


def _abspath(x: str) -> pathlib.Path:
    return pathlib.Path(x).resolve()


def run():
    opts = _parse_args()
    log_level = logging.DEBUG if opts.verbose else logging.INFO
    logging.basicConfig(format="{levelname} {message}", style='{', level=log_level)
    exe_path = paths.exe_file.relative_to(opts.swift_dir)
    for target in opts.generate:
        generate(target, opts, render.Renderer(exe_path))


if __name__ == "__main__":
    run()
