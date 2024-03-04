""" template renderer module, wrapping around `pystache.Renderer`

`pystache` is a python mustache engine, and mustache is a template language. More information on

https://mustache.github.io/
"""

import logging
import pathlib
import typing
import hashlib
from dataclasses import dataclass

import pystache

from . import paths

log = logging.getLogger(__name__)


class Error(Exception):
    pass


class Renderer:
    """ Template renderer using mustache templates in the `templates` directory """

    def __init__(self, generator: pathlib.Path):
        self._r = pystache.Renderer(search_dirs=str(paths.templates_dir), escape=lambda u: u)
        self._generator = generator

    def render(self, data: object, output: typing.Optional[pathlib.Path], template: typing.Optional[str] = None):
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
            template_to_use = template or data.template
            if ext:
                output_filename = output_filename.with_suffix(f".{ext}")
                template_to_use += f"_{ext}"
            contents = self.render_str(data, template_to_use)
            self._do_write(mnemonic, contents, output_filename)

    def render_str(self, data: object, template: typing.Optional[str] = None):
        template = template or data.template
        return self._r.render_name(template, data, generator=self._generator)

    def _do_write(self, mnemonic: str, contents: str, output: pathlib.Path):
        with open(output, "w") as out:
            out.write(contents)
        log.debug(f"{mnemonic}: generated {output.name}")

    def manage(self, generated: typing.Iterable[pathlib.Path], stubs: typing.Iterable[pathlib.Path],
               registry: pathlib.Path, force: bool = False) -> "RenderManager":
        return RenderManager(self._generator, generated, stubs, registry, force)


class RenderManager(Renderer):
    """ A context manager allowing to manage checked in generated files and their cleanup, able
    to skip unneeded writes.

    This is done by using and updating a checked in list of generated files that assigns two
    hashes to each file:
    * one is the hash of the mustache rendered contents, that can be used to quickly check whether a
      write is needed
    * the other is the hash of the actual file after code generation has finished. This will be
      different from the above because of post-processing like QL formatting. This hash is used
      to detect invalid modification of generated files"""
    written: typing.Set[pathlib.Path]

    @dataclass
    class Hashes:
        """
        pre contains the hash of a file as rendered, post is the hash after
        postprocessing (for example QL formatting)
        """
        pre: str
        post: typing.Optional[str] = None

    def __init__(self, generator: pathlib.Path, generated: typing.Iterable[pathlib.Path],
                 stubs: typing.Iterable[pathlib.Path],
                 registry: pathlib.Path, force: bool = False):
        super().__init__(generator)
        self._registry_path = registry
        self._force = force
        self._hashes = {}
        self.written = set()
        self._existing = set()
        self._skipped = set()

        self._load_registry()
        self._process_generated(generated)
        self._process_stubs(stubs)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_val is None:
            for f in self._existing - self._skipped - self.written:
                f.unlink(missing_ok=True)
                log.info(f"removed {f.name}")
            for f in self.written:
                self._hashes[self._get_path(f)].post = self._hash_file(f)
        else:
            # if an error was encountered, drop already written files from the registry
            # so that they get the chance to be regenerated again during the next run
            for f in self.written:
                self._hashes.pop(self._get_path(f), None)
        # clean up the registry from files that do not exist any more
        for f in list(self._hashes):
            if not (self._registry_path.parent / f).exists():
                self._hashes.pop(f)
        self._dump_registry()

    def _get_path(self, file: pathlib.Path):
        return file.relative_to(self._registry_path.parent)

    def _do_write(self, mnemonic: str, contents: str, output: pathlib.Path):
        hash = self._hash_string(contents)
        rel_output = self._get_path(output)
        if rel_output in self._hashes and self._hashes[rel_output].pre == hash:
            self._skipped.add(output)
            log.debug(f"{mnemonic}: skipped {output.name}")
        else:
            self.written.add(output)
            super()._do_write(mnemonic, contents, output)
            self._hashes[rel_output] = self.Hashes(pre=hash)

    def _process_generated(self, generated: typing.Iterable[pathlib.Path]):
        for f in generated:
            self._existing.add(f)
            rel_path = self._get_path(f)
            if self._force:
                pass
            elif rel_path not in self._hashes:
                log.warning(f"{rel_path} marked as generated but absent from the registry")
            elif self._hashes[rel_path].post != self._hash_file(f):
                raise Error(f"{rel_path} is generated but was modified, please revert the file "
                            "or pass --force to overwrite")

    def _process_stubs(self, stubs: typing.Iterable[pathlib.Path]):
        for f in stubs:
            rel_path = self._get_path(f)
            if self.is_customized_stub(f):
                self._hashes.pop(rel_path, None)
                continue
            self._existing.add(f)
            if self._force:
                pass
            elif rel_path not in self._hashes:
                log.warning(f"{rel_path} marked as stub but absent from the registry")
            elif self._hashes[rel_path].post != self._hash_file(f):
                raise Error(f"{rel_path} is a stub marked as generated, but it was modified, "
                            "please remove the `// generated` header, revert the file or pass --force to overwrite it")

    @staticmethod
    def is_customized_stub(file: pathlib.Path) -> bool:
        if not file.is_file():
            return False
        with open(file) as contents:
            for line in contents:
                return not line.startswith("// generated")
        # no lines
        return True

    @staticmethod
    def _hash_file(filename: pathlib.Path) -> str:
        with open(filename) as inp:
            return RenderManager._hash_string(inp.read())

    @staticmethod
    def _hash_string(data: str) -> str:
        h = hashlib.sha256()
        h.update(data.encode())
        return h.hexdigest()

    def _load_registry(self):
        if self._force:
            return
        try:
            with open(self._registry_path) as reg:
                for line in reg:
                    if line.strip():
                        filename, prehash, posthash = line.split()
                        self._hashes[pathlib.Path(filename)] = self.Hashes(prehash, posthash)
        except FileNotFoundError:
            pass

    def _dump_registry(self):
        self._registry_path.parent.mkdir(parents=True, exist_ok=True)
        with open(self._registry_path, 'w') as out, open(self._registry_path.parent / ".gitattributes", "w") as attrs:
            print(f"/{self._registry_path.name}", "linguist-generated", file=attrs)
            print("/.gitattributes", "linguist-generated", file=attrs)
            for f, hashes in sorted(self._hashes.items()):
                print(f, hashes.pre, hashes.post, file=out)
                print(f"/{f}", "linguist-generated", file=attrs)
