""" generator script scaffolding """

import argparse
import logging
import sys
from typing import Set

from swift.codegen.lib import render, paths
from swift.codegen.generators import options


def _parse(tags: Set[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    for opt in options.get(tags):
        opt.add_to(parser)
    return parser.parse_args()


def run(*modules, **kwargs):
    """ run generation functions in specified in `modules`, or in current module by default
    """
    if modules:
        if kwargs:
            opts = argparse.Namespace(**kwargs)
        else:
            opts = _parse({t for m in modules for t in m.tags})
        log_level = logging.DEBUG if opts.verbose else logging.INFO
        logging.basicConfig(format="{levelname} {message}", style='{', level=log_level)
        exe_path = paths.exe_file.relative_to(opts.swift_dir)
        for m in modules:
            m.generate(opts, render.Renderer(exe_path))
    else:
        run(sys.modules["__main__"], **kwargs)
