""" template renderer module, wrapping around `pystache.Renderer`

`pystache` is a python mustache engine, and mustache is a template language. More information on

https://mustache.github.io/
"""

import hashlib
import logging

import pystache

from . import paths

log = logging.getLogger(__name__)


def _md5(data):
    return hashlib.md5(data).digest()


class Renderer:
    """ Template renderer using mustache templates in the `templates` directory """

    def __init__(self, dryrun=False):
        """ Construct the renderer, which will not write anything if `dryrun` is `True` """
        self.r = pystache.Renderer(search_dirs=str(paths.lib_dir / "templates"), escape=lambda u: u)
        self.generator = paths.exe_file.relative_to(paths.swift_dir)
        self.dryrun = dryrun
        self.written = set()
        self.skipped = set()
        self.erased = set()

    @property
    def done_something(self):
        return bool(self.written or self.erased)

    @property
    def rendered(self):
        return self.written | self.skipped

    def render(self, name, output, data):
        """ Render the template called `name` in the template directory, writing to `output` using `data` as context

        If the file is unchanged, then no write is performed (and `done_something` remains unchanged)
        """
        mnemonic, _, _ = name.lower().partition(".")
        output.parent.mkdir(parents=True, exist_ok=True)
        data = self.r.render_name(name, data, generator=self.generator)
        if output.is_file():
            with open(output, "rb") as file:
                if _md5(data.encode()) == _md5(file.read()):
                    log.debug(f"skipped {output.name}")
                    self.skipped.add(output)
                    return
        if self.dryrun:
            log.error(f"would have generated {mnemonic} {output.name}")
        else:
            with open(output, "w") as out:
                out.write(data)
            log.info(f"generated {mnemonic} {output.name}")
        self.written.add(output)

    def cleanup(self, existing):
        """ Remove files in `existing` for which no `render` has been called """
        for f in existing - self.written - self.skipped:
            if f.is_file():
                if self.dryrun:
                    log.error(f"would have removed {f.name}")
                else:
                    f.unlink()
                    log.info(f"removed {f.name}")
                self.erased.add(f)
