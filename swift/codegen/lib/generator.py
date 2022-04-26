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


def run(*generators, tags=None):
    """ run generation functions in `generators`, parsing options tagged with `tags` (all if unspecified)

    `generators` should be callables taking as input an option namespace and a `render.Renderer` instance
    """
    opts = _parse(tags)
    for g in generators:
        g(opts, render.Renderer())
