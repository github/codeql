import hashlib
import logging

import pystache

from . import paths

log = logging.getLogger(__name__)


def md5(data):
    return hashlib.md5(data).digest()


class Renderer:
    def __init__(self, check=False):
        self.r = pystache.Renderer(search_dirs=str(paths.lib_dir / "templates"), escape=lambda u: u)
        self.generator = paths.exe_file.relative_to(paths.swift_dir)
        self.check = check
        self.written = set()
        self.skipped = set()
        self.erased = set()

    @property
    def done_something(self):
        return bool(self.written or self.erased)

    @property
    def rendered(self):
        return self.written | self.skipped

    def render(self, name, output, **data):
        mnemonic, _, _ = name.lower().partition(".")
        output.parent.mkdir(parents=True, exist_ok=True)
        data["generator"] = self.generator
        data = self.r.render_name(name, data)
        if output.is_file():
            with open(output, "rb") as file:
                if md5(data.encode()) == md5(file.read()):
                    log.debug(f"skipped {output.name}")
                    self.skipped.add(output)
                    return
        if self.check:
            log.error(f"would have generated {mnemonic} {output.name}")
        else:
            with open(output, "w") as out:
                out.write(data)
            log.info(f"generated {mnemonic} {output.name}")
        self.written.add(output)

    def cleanup(self, existing):
        for f in existing - self.written - self.skipped:
            if f.is_file():
                if self.check:
                    log.error(f"would have removed {f.name}")
                else:
                    f.unlink()
                    log.info(f"removed {f.name}")
                self.erased.add(f)
