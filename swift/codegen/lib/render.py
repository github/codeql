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

    def __init__(self, generator):
        self._r = pystache.Renderer(search_dirs=str(paths.templates_dir), escape=lambda u: u)
        self.written = set()
        self._generator = generator

    def render(self, data, output: pathlib.Path):
        """ Render `data` to `output`.

        `data` must have a `template` attribute denoting which template to use from the template directory.

        Optionally, `data` can also have an `extensions` attribute denoting list of file extensions: they will all be
        appended to the template name with an underscore and be generated in turn.
        """
        mnemonic = type(data).__name__
        output.parent.mkdir(parents=True, exist_ok=True)
        extensions = getattr(data, "extensions", [None])
        for ext in extensions:
            output_filename = output
            template = data.template
            if ext:
                output_filename = output_filename.with_suffix(f".{ext}")
                template += f"_{ext}"
            contents = self._r.render_name(template, data, generator=self._generator)
            with open(output_filename, "w") as out:
                out.write(contents)
            log.debug(f"{mnemonic}: generated {output.name}")
            self.written.add(output_filename)

    def cleanup(self, existing):
        """ Remove files in `existing` for which no `render` has been called """
        for f in existing - self.written:
            f.unlink(missing_ok=True)
            log.info(f"removed {f.name}")
