""" generator options, categorized by tags """

import argparse
import collections
import pathlib
from typing import Tuple

from . import paths


def _init_options():
    Option("--verbose", "-v", action="store_true")
    Option("--schema", tags=["schema"], type=pathlib.Path, default=paths.swift_dir / "codegen/schema.yml")
    Option("--dbscheme", tags=["dbscheme"], type=pathlib.Path, default=paths.swift_dir / "ql/lib/swift.dbscheme")
    Option("--ql-output", tags=["ql"], type=pathlib.Path, default=paths.swift_dir / "ql/lib/codeql/swift/generated")
    Option("--ql-stub-output", tags=["ql"], type=pathlib.Path, default=paths.swift_dir / "ql/lib/codeql/swift/elements")
    Option("--codeql-binary", tags=["ql"], default="codeql")


_options = collections.defaultdict(list)


class Option:
    def __init__(self, *args, tags=None, **kwargs):
        tags = tags or []
        self.args = args
        self.kwargs = kwargs
        if tags:
            for t in tags:
                _options[t].append(self)
        else:
            _options["*"].append(self)

    def add_to(self, parser: argparse.ArgumentParser):
        parser.add_argument(*self.args, **self.kwargs)


_init_options()


def get(tags: Tuple[str]):
    """ get options marked by `tags`

    Return all options if tags is falsy. Options tagged by wildcard '*' are always returned
    """
    if not tags:
        return (o for tagged_opts in _options.values() for o in tagged_opts)
    else:
        # use specifically tagged options + those tagged with wildcard *
        return (o for tag in ('*',) + tags for o in _options[tag])
