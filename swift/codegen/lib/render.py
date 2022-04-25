""" template renderer module, wrapping around `pystache.Renderer`

`pystache` is a python mustache engine, and mustache is a template language. More information on

https://mustache.github.io/
"""

import logging
import pathlib

import pystache

from . import paths

log = logging.getLogger(__name__)


class Renderer:
    """ Template renderer using mustache templates in the `templates` directory """

    def __init__(self):
        self.r = pystache.Renderer(search_dirs=str(paths.lib_dir / "templates"), escape=lambda u: u)
        self.generator = paths.exe_file.relative_to(paths.swift_dir)
        self.written = set()

    def render(self, data, output: pathlib.Path):
        """ Render `data` to `output`.

        `data` must have a `template` attribute denoting which template to use from the template directory.

        If the file is unchanged, then no write is performed (and `done_something` remains unchanged)
        """
        mnemonic = type(data).__name__
        output.parent.mkdir(parents=True, exist_ok=True)
        data = self.r.render_name(data.template, data, generator=self.generator)
        with open(output, "w") as out:
            out.write(data)
        log.debug(f"generated {mnemonic} {output.name}")
        self.written.add(output)

    def cleanup(self, existing):
        """ Remove files in `existing` for which no `render` has been called """
        for f in existing - self.written:
            if f.is_file():
                f.unlink()
                log.info(f"removed {f.name}")
