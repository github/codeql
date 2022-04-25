#!/usr/bin/env python3

import logging
import pathlib
import subprocess
from dataclasses import dataclass, field
from typing import List, ClassVar

import inflection

from lib import schema, paths, generator

log = logging.getLogger(__name__)


@dataclass
class QlParam:
    param: str
    type: str = None
    first: bool = False


@dataclass
class QlProperty:
    singular: str
    type: str
    tablename: str
    tableparams: List[QlParam]
    plural: str = None
    params: List[QlParam] = field(default_factory=list)
    first: bool = False
    local_var: str = "x"

    def __post_init__(self):
        if self.params:
            self.params[0].first = True
        while self.local_var in (p.param for p in self.params):
            self.local_var += "_"
        assert self.tableparams
        if self.type_is_class:
            self.tableparams = [x if x != "result" else self.local_var for x in self.tableparams]
        self.tableparams = [QlParam(x) for x in self.tableparams]
        self.tableparams[0].first = True

    @property
    def indefinite_article(self):
        if self.plural:
            return "An" if self.singular[0] in "AEIO" else "A"

    @property
    def type_is_class(self):
        return self.type[0].isupper()


@dataclass
class QlClass:
    template: ClassVar = 'ql_class'

    name: str
    bases: List[str]
    final: bool
    properties: List[QlProperty]
    dir: pathlib.Path
    imports: List[str] = field(default_factory=list)

    def __post_init__(self):
        self.bases = sorted(self.bases)
        if self.properties:
            self.properties[0].first = True

    @property
    def db_id(self):
        return "@" + inflection.underscore(self.name)

    @property
    def root(self):
        return not self.bases

    @property
    def path(self):
        return self.dir / self.name


@dataclass
class QlStub:
    template: ClassVar = 'ql_stub'

    name: str
    base_import: str


@dataclass
class QlImportList:
    template: ClassVar = 'ql_imports'

    imports: List[str] = field(default_factory=list)


def get_ql_property(cls: schema.Class, prop: schema.Property):
    if prop.is_single:
        return QlProperty(
            singular=inflection.camelize(prop.name),
            type=prop.type,
            tablename=inflection.tableize(cls.name),
            tableparams=["this"] + ["result" if p is prop else "_" for p in cls.properties if p.is_single],
        )
    elif prop.is_optional:
        return QlProperty(
            singular=inflection.camelize(prop.name),
            type=prop.type,
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "result"],
        )
    elif prop.is_repeated:
        return QlProperty(
            singular=inflection.singularize(inflection.camelize(prop.name)),
            plural=inflection.pluralize(inflection.camelize(prop.name)),
            type=prop.type,
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "index", "result"],
            params=[QlParam("index", type="int")],
        )


def get_ql_class(cls: schema.Class):
    return QlClass(
        name=cls.name,
        bases=cls.bases,
        final=not cls.derived,
        properties=[get_ql_property(cls, p) for p in cls.properties],
        dir=cls.dir,
    )


def get_import(file):
    stem = file.relative_to(paths.swift_dir / "ql/lib").with_suffix("")
    return str(stem).replace("/", ".")


def get_types_used_by(cls: QlClass):
    for b in cls.bases:
        yield b
    for p in cls.properties:
        yield p.type
        for param in p.params:
            yield param.type


def get_classes_used_by(cls: QlClass):
    return sorted(set(t for t in get_types_used_by(cls) if t[0].isupper()))


def is_generated(file):
    with open(file) as contents:
        return next(contents).startswith("// generated")


def format(codeql, files):
    format_cmd = [codeql, "query", "format", "--in-place", "--"]
    format_cmd.extend(str(f) for f in files)
    res = subprocess.run(format_cmd, check=True, stderr=subprocess.PIPE, text=True)
    for line in res.stderr.splitlines():
        log.debug(line.strip())


def generate(opts, renderer):
    input = opts.schema.resolve()
    out = opts.ql_output.resolve()
    stub_out = opts.ql_stub_output.resolve()
    existing = {q for q in out.rglob("*.qll")}
    existing |= {q for q in stub_out.rglob("*.qll") if is_generated(q)}

    with open(input) as src:
        data = schema.load(src)

    classes = [get_ql_class(cls) for cls in data.classes.values()]
    imports = {}

    for c in classes:
        imports[c.name] = get_import(stub_out / c.path)

    for c in classes:
        assert not c.final or c.bases, c.name
        qll = (out / c.path).with_suffix(".qll")
        c.imports = [imports[t] for t in get_classes_used_by(c)]
        renderer.render(c, qll)
        stub_file = (stub_out / c.path).with_suffix(".qll")
        if not stub_file.is_file() or is_generated(stub_file):
            stub = QlStub(name=c.name, base_import=get_import(qll))
            renderer.render(stub, stub_file)

    # for example path/to/syntax/generated -> path/to/syntax.qll
    include_file = stub_out.with_suffix(".qll")
    all_imports = QlImportList(v for _, v in sorted(imports.items()))
    renderer.render(all_imports, include_file)

    renderer.cleanup(existing)
    format(opts.codeql_binary, renderer.written)


if __name__ == "__main__":
    generator.run(generate, tags=["schema", "ql"])
