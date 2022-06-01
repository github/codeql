#!/usr/bin/env python3

import logging
import pathlib
import subprocess

import inflection

from swift.codegen.lib import schema, ql
from swift.codegen.generators import generator

log = logging.getLogger(__name__)


def get_ql_property(cls: schema.Class, prop: schema.Property):
    if prop.is_single:
        return ql.Property(
            singular=inflection.camelize(prop.name),
            type=prop.type,
            tablename=inflection.tableize(cls.name),
            tableparams=["this"] + ["result" if p is prop else "_" for p in cls.properties if p.is_single],
            is_child=prop.is_child,
        )
    elif prop.is_repeated:
        return ql.Property(
            singular=inflection.singularize(inflection.camelize(prop.name)),
            plural=inflection.pluralize(inflection.camelize(prop.name)),
            type=prop.type,
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "index", "result"],
            is_optional=prop.is_optional,
            is_child=prop.is_child,
        )
    elif prop.is_optional:
        return ql.Property(
            singular=inflection.camelize(prop.name),
            type=prop.type,
            tablename=inflection.tableize(f"{cls.name}_{prop.name}"),
            tableparams=["this", "result"],
            is_optional=True,
            is_child=prop.is_child,
        )
    elif prop.is_predicate:
        return ql.Property(
            singular=inflection.camelize(prop.name, uppercase_first_letter=False),
            type="predicate",
            tablename=inflection.underscore(f"{cls.name}_{prop.name}"),
            tableparams=["this"],
            is_predicate=True,
        )


def get_ql_class(cls: schema.Class):
    return ql.Class(
        name=cls.name,
        bases=cls.bases,
        final=not cls.derived,
        properties=[get_ql_property(cls, p) for p in cls.properties],
        dir=cls.dir,
    )


def get_import(file: pathlib.Path, swift_dir: pathlib.Path):
    stem = file.relative_to(swift_dir / "ql/lib").with_suffix("")
    return str(stem).replace("/", ".")


def get_types_used_by(cls: ql.Class):
    for b in cls.bases:
        yield b
    for p in cls.properties:
        yield p.type


def get_classes_used_by(cls: ql.Class):
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
    input = opts.schema
    out = opts.ql_output
    stub_out = opts.ql_stub_output
    existing = {q for q in out.rglob("*.qll")}
    existing |= {q for q in stub_out.rglob("*.qll") if is_generated(q)}

    data = schema.load(input)

    classes = [get_ql_class(cls) for cls in data.classes]
    classes.sort(key=lambda cls: cls.name)
    imports = {}

    for c in classes:
        imports[c.name] = get_import(stub_out / c.path, opts.swift_dir)

    for c in classes:
        qll = (out / c.path).with_suffix(".qll")
        c.imports = [imports[t] for t in get_classes_used_by(c)]
        renderer.render(c, qll)
        stub_file = (stub_out / c.path).with_suffix(".qll")
        if not stub_file.is_file() or is_generated(stub_file):
            stub = ql.Stub(name=c.name, base_import=get_import(qll, opts.swift_dir))
            renderer.render(stub, stub_file)

    # for example path/to/elements -> path/to/elements.qll
    include_file = stub_out.with_suffix(".qll")
    all_imports = ql.ImportList(list(sorted(imports.values())))
    renderer.render(all_imports, include_file)

    renderer.render(ql.GetParentImplementation(classes), out / 'GetImmediateParent.qll')

    renderer.cleanup(existing)
    if opts.ql_format:
        format(opts.codeql_binary, renderer.written)


tags = ("schema", "ql")

if __name__ == "__main__":
    generator.run()
