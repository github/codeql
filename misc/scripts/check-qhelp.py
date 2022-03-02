#!/bin/env python3

"""cross platform wrapper around codeql generate query-help to check .qhelp files

This takes care of:
* providing a temporary directory to --output
* finding usages of .inc.qhelp arguments
"""

import pathlib
import subprocess
import sys
import tempfile
import xml.sax

include_cache = {}


class IncludeHandler(xml.sax.ContentHandler):
    def __init__(self, xml):
        super().__init__()
        self.__xml = xml

    def startElement(self, name, attrs):
        if name == "include":
            src = (self.__xml.parent / attrs["src"]).resolve()
            include_cache.setdefault(src, set()).add(self.__xml)


class IgnoreErrorsHandler(xml.sax.ErrorHandler):
    def error(self, exc):
        pass

    def fatalError(self, exc):
        pass

    def warning(self, exc):
        pass


def init_include_cache():
    if not include_cache:
        for qhelp in pathlib.Path().rglob("*.qhelp"):
            xml.sax.parse(qhelp, IncludeHandler(qhelp), IgnoreErrorsHandler())


def find_inc_qhelp_usages(arg):
    init_include_cache()
    return include_cache.get(arg.resolve(), ())


def transform_inputs(args):
    for arg in args:
        arg = pathlib.Path(arg)
        if arg.suffixes == ['.inc', '.qhelp']:
            for qhelp in find_inc_qhelp_usages(arg):
                yield str(qhelp)
        else:
            yield str(arg)


affected_qhelp_files = list(transform_inputs(sys.argv[1:]))
if not affected_qhelp_files:
    # can happen with changes on an unused .inc.qhelp file
    print("nothing to do!")
    sys.exit(0)

cmd = ["codeql", "generate", "query-help", "--format=markdown"]

with tempfile.TemporaryDirectory() as tmp:
    cmd += [f"--output={tmp}", "--"]
    cmd += affected_qhelp_files
    res = subprocess.run(cmd)

sys.exit(res.returncode)
