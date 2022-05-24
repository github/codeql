""" generator options, categorized by tags """

import argparse
import collections
import pathlib
from typing import Set

from swift.codegen.lib import paths


def _init_options():
    Option("--verbose", "-v", action="store_true")
    Option("--swift-dir", type=_abspath, default=paths.swift_dir)
    Option("--schema", tags=["schema"], type=_abspath, default=paths.swift_dir / "codegen/schema.yml")
    Option("--dbscheme", tags=["dbscheme"], type=_abspath, default=paths.swift_dir / "ql/lib/swift.dbscheme")
    Option("--ql-output", tags=["ql"], type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/generated")
    Option("--ql-stub-output", tags=["ql"], type=_abspath, default=paths.swift_dir / "ql/lib/codeql/swift/elements")
    Option("--ql-format", tags=["ql"], action="store_true", default=True)
    Option("--no-ql-format", tags=["ql"], action="store_false", dest="ql_format")
    Option("--codeql-binary", tags=["ql"], default="codeql")
    Option("--cpp-output", tags=["cpp"], type=_abspath, required=True)
    Option("--cpp-namespace", tags=["cpp"], default="codeql")
    Option("--trap-affix", tags=["cpp"], default="Trap")
    Option("--cpp-include-dir", tags=["cpp"], default="swift/extractor/trap")


def _abspath(x):
    return pathlib.Path(x).resolve()


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


def get(tags: Set[str]):
    """ get options marked by `tags`

    Options tagged by wildcard '*' are always returned
    """
    # use specifically tagged options + those tagged with wildcard *
    return (o for tag in ('*',) + tuple(tags) for o in _options[tag])
