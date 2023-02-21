#!/usr/bin/env python3
""" Driver script to run all code generation """

import argparse
import logging
import os
import sys
import pathlib
import typing

if 'BUILD_WORKSPACE_DIRECTORY' not in os.environ:
    # we are not running with `bazel run`, set up module search path
    _repo_root = pathlib.Path(__file__).resolve().parents[2]
    sys.path.append(str(_repo_root))

from swift.codegen.lib import render, paths
from swift.codegen.generators import generate


def _parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Code generation suite")
    p.add_argument("--generate", type=lambda x: x.split(","), default=["dbscheme", "ql"],
                   help="specify what targets to generate as a comma separated list, choosing among dbscheme, ql, trap "
                        "and cpp")
    p.add_argument("--verbose", "-v", action="store_true", help="print more information")
    p.add_argument("--quiet", "-q", action="store_true", help="only print errors")
    p.add_argument("--root-dir", type=_abspath, default=paths.root_dir,
                   help="the directory that should be regarded as the root of the language pack codebase. Used to"
                        "compute QL imports and in some comments and as root for relative paths provided as options "
                        "(default %(default)s)")
    p.add_argument("--language", default=paths.root_dir.name,
                   help="string that should replace {language} in other provided options")
    path_arguments = [
        p.add_argument("--schema", default="schema.py",
                       help="input schema file (default %(default)s)"),
        p.add_argument("--dbscheme", default="ql/lib/{language}.dbscheme",
                       help="output file for dbscheme generation, input file for trap generation (default "
                            "%(default)s)"),
        p.add_argument("--ql-output", default="ql/lib/codeql/{language}/generated",
                       help="output directory for generated QL files (default %(default)s)"),
        p.add_argument("--ql-stub-output", default="ql/lib/codeql/{language}/elements",
                       help="output directory for QL stub/customization files (default %(default)s). Defines also the "
                            "generated qll file importing every class file"),
        p.add_argument("--ql-test-output", default="ql/test/extractor-tests/generated",
                       help="output directory for QL generated extractor test files (default %(default)s)"),
        p.add_argument("--cpp-output",
                       help="output directory for generated C++ files, required if trap or cpp is provided to "
                            "--generate"),
        p.add_argument("--generated-registry", default="ql/.generated.list",
                       help="registry file containing information about checked-in generated code"),
    ]
    p.add_argument("--ql-format", action="store_true", default=True,
                   help="use codeql to autoformat QL files (which is the default)")
    p.add_argument("--no-ql-format", action="store_false", dest="ql_format", help="do not format QL files")
    p.add_argument("--codeql-binary", default="codeql", help="command to use for QL formatting (default %(default)s)")
    p.add_argument("--force", "-f", action="store_true",
                   help="generate all files without skipping unchanged files and overwriting modified ones"),
    opts = p.parse_args()
    # absolutize all paths relative to --root-dir
    for arg in path_arguments:
        path = getattr(opts, arg.dest)
        if path is not None:
            setattr(opts, arg.dest, opts.root_dir / path.format(language=opts.language))
    return opts


def _abspath(x: str) -> typing.Optional[pathlib.Path]:
    return pathlib.Path(x).resolve() if x else None


def run():
    opts = _parse_args()
    if opts.verbose:
        log_level = logging.DEBUG
    elif opts.quiet:
        log_level = logging.ERROR
    else:
        log_level = logging.INFO
    logging.basicConfig(format="{levelname} {message}", style='{', level=log_level)
    for target in opts.generate:
        generate(target, opts, render.Renderer(opts.root_dir))


if __name__ == "__main__":
    run()
