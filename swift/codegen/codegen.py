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
    p = argparse.ArgumentParser()
    p.add_argument("--generate", type=lambda x: x.split(","), default=["dbscheme", "ql"])
    p.add_argument("--verbose", "-v", action="store_true")
    p.add_argument("--swift-dir", type=_abspath, default=paths.swift_dir)
    p.add_argument("--schema", type=_abspath, default=paths.swift_dir / "codegen/schema.yml")
    p.add_argument("--dbscheme", type=_abspath, default=paths.swift_dir / "ql/lib/swift.dbscheme")
    p.add_argument("--ql-output", type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/generated")
    p.add_argument("--ql-stub-output", type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/elements")
    p.add_argument("--ql-format", action="store_true", default=True)
    p.add_argument("--no-ql-format", action="store_false", dest="ql_format")
    p.add_argument("--codeql-binary", default="codeql")
    p.add_argument("--cpp-output", type=_abspath)
    p.add_argument("--cpp-namespace", default="codeql")
    p.add_argument("--trap-affix", default="Trap")
    p.add_argument("--cpp-include-dir", default="swift/extractor/trap")
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
