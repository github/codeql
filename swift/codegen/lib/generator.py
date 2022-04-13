import argparse
import collections
import logging
import pathlib
import sys

from . import paths

options = collections.defaultdict(list)


class Option:
    def __init__(self, *args, tags=None, **kwargs):
        tags = tags or []
        self.args = args
        self.kwargs = kwargs
        if tags:
            for t in tags:
                options[t].append(self)
        else:
            options["*"].append(self)

    def add_to(self, parser: argparse.ArgumentParser):
        parser.add_argument(*self.args, **self.kwargs)


Option("--check", "-c", action="store_true")
Option("--verbose", "-v", action="store_true")
Option("--schema", tags=["schema"], type=pathlib.Path, default=paths.swift_dir / "codegen/schema.yml")
Option("--dbscheme", tags=["dbscheme"], type=pathlib.Path, default=paths.swift_dir / "ql/lib/swift.dbscheme")


def _parse(*tags):
    parser = argparse.ArgumentParser()
    if not tags:
        opts = [o for os in options.values() for o in os]
    else:
        opts = options["*"]
        for t in tags:
            opts.extend(options[t])
    for opt in opts:
        opt.add_to(parser)
    ret = parser.parse_args()
    log_level = logging.DEBUG if ret.verbose else logging.INFO
    logging.basicConfig(format="{levelname} {message}", style='{', level=log_level)
    return ret


def run(*generate, tags=()):
    opts = _parse(*tags)
    done_something = False
    for g in generate:
        if g(opts):
            done_something = True
    sys.exit(1 if opts.check and done_something else 0)
