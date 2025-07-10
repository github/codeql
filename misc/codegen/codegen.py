#!/usr/bin/env python3
""" Driver script to run all code generation """

import argparse
import logging
import os
import sys
import pathlib
import typing
import shlex

if 'BUILD_WORKSPACE_DIRECTORY' not in os.environ:
    # we are not running with `bazel run`, set up module search path
    _repo_root = pathlib.Path(__file__).resolve().parents[2]
    sys.path.append(str(_repo_root))

from misc.codegen.lib import render, paths
from misc.codegen.generators import generate


def _parse_args() -> argparse.Namespace:
    dirs = [pathlib.Path().resolve()]
    dirs.extend(dirs[0].parents)
    for dir in dirs:
        conf = dir / "codegen.conf"
        if conf.exists():
            break
    else:
        conf = None

    p = argparse.ArgumentParser(description="Code generation suite")
    p.add_argument("--generate", type=lambda x: x.split(","),
                   help="specify what targets to generate as a comma separated list, choosing among dbscheme, ql, "
                        "trap, cpp and rust")
    p.add_argument("--verbose", "-v", action="store_true", help="print more information")
    p.add_argument("--quiet", "-q", action="store_true", help="only print errors")
    p.add_argument("--configuration-file", "-c", type=_abspath, default=conf,
                   help="A configuration file to load options from. By default, the first codegen.conf file found by "
                        "going up directories from the current location. If present all paths provided in options are "
                        "considered relative to its directory")
    p.add_argument("--root-dir", type=_abspath,
                   help="the directory that should be regarded as the root of the language pack codebase. Used to "
                        "compute QL imports and in some comments and as root for relative paths provided as options. "
                        "If not provided it defaults to the directory of the configuration file, if any")
    path_arguments = [
        p.add_argument("--schema",
                       help="input schema file (default schema.py)"),
        p.add_argument("--dbscheme",
                       help="output file for dbscheme generation, input file for trap generation"),
        p.add_argument("--ql-output",
                       help="output directory for generated QL files"),
        p.add_argument("--ql-stub-output",
                       help="output directory for QL stub/customization files. Defines also the "
                            "generated qll file importing every class file"),
        p.add_argument("--ql-test-output",
                       help="output directory for QL generated extractor test files"),
        p.add_argument("--ql-cfg-output",
                       help="output directory for QL CFG layer (optional)."),
        p.add_argument("--cpp-output",
                       help="output directory for generated C++ files, required if trap or cpp is provided to "
                            "--generate"),
        p.add_argument("--rust-output",
                       help="output directory for generated Rust files, required if rust is provided to "
                            "--generate"),
        p.add_argument("--generated-registry",
                       help="registry file containing information about checked-in generated code. A .gitattributes"
                            "file is generated besides it to mark those files with linguist-generated=true. Must"
                            "be in a directory containing all generated code."),
    ]
    p.add_argument("--script-name",
                   help="script name to put in header comments of generated files. By default, the path of this "
                        "script relative to the root directory")
    p.add_argument("--trap-library",
                   help="path to the trap library from an include directory, required if generating C++ trap bindings"),
    p.add_argument("--ql-format", action="store_true", default=True,
                   help="use codeql to autoformat QL files (which is the default)")
    p.add_argument("--no-ql-format", action="store_false", dest="ql_format", help="do not format QL files")
    p.add_argument("--codeql-binary", default="codeql", help="command to use for QL formatting (default %(default)s)")
    p.add_argument("--force", "-f", action="store_true",
                   help="generate all files without skipping unchanged files and overwriting modified ones")
    p.add_argument("--use-current-directory", action="store_true",
                   help="do not consider paths as relative to --root-dir or the configuration directory")
    opts = p.parse_args()
    if opts.configuration_file is not None:
        with open(opts.configuration_file) as config:
            defaults = p.parse_args(shlex.split(config.read(), comments=True))
            for flag, value in opts._get_kwargs():
                if value is None:
                    setattr(opts, flag, getattr(defaults, flag))
        if opts.root_dir is None:
            opts.root_dir = opts.configuration_file.parent
    if opts.schema is None:
        opts.schema = "schema.py"
    if not opts.generate:
        p.error("Nothing to do, specify --generate")
    # absolutize all paths
    for arg in path_arguments:
        path = getattr(opts, arg.dest)
        if path is not None:
            setattr(opts, arg.dest, _abspath(path) if opts.use_current_directory else (opts.root_dir / path))
    if not opts.script_name:
        opts.script_name = paths.exe_file.relative_to(opts.root_dir)
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
        generate(target, opts, render.Renderer(opts.script_name))


if __name__ == "__main__":
    run()
