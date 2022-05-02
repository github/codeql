""" generator script scaffolding """

import argparse
import logging
import sys

from . import options, render


def _parse(tags):
    parser = argparse.ArgumentParser()
    for opt in options.get(tags):
        opt.add_to(parser)
    ret = parser.parse_args()
    log_level = logging.DEBUG if ret.verbose else logging.INFO
    logging.basicConfig(format="{levelname} {message}", style='{', level=log_level)
    return ret


def run(*modules):
    """ run generation functions in specified in `modules`, or in current module by default
    """
    if modules:
        opts = _parse({t for m in modules for t in m.tags})
        for m in modules:
            m.generate(opts, render.Renderer())
    else:
        run(sys.modules["__main__"])
