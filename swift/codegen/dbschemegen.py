#!/usr/bin/env python3

import inflection

from lib.renderer import Renderer
from lib.dbscheme import *
from lib import paths, schema, generator

log = logging.getLogger(__name__)


def dbtype(typename):
    if typename[0].isupper():
        return "@" + inflection.underscore(typename)
    return typename


def cls_to_dbscheme(cls: schema.Class):
    if cls.derived:
        yield DbUnion(dbtype(cls.name), (dbtype(c) for c in cls.derived))
    if not cls.derived or any(f.is_single() for f in cls.fields):
        binding = not cls.derived
        keyset = DbKeySet(["id"]) if cls.derived else None
        yield DbTable(
            keyset=keyset,
            name=inflection.tableize(cls.name),
            columns=[
                        DbColumn("id", type=dbtype(cls.name), binding=binding),
                    ] + [
                        DbColumn(f.name, dbtype(f.type)) for f in cls.fields if f.is_single()
                    ]
        )
    for f in cls.fields:
        if f.is_optional():
            yield DbTable(
                keyset=DbKeySet(["id"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    DbColumn("id", type=dbtype(cls.name)),
                    DbColumn(f.name, dbtype(f.type)),
                ],
            )
        elif f.is_repeated():
            yield DbTable(
                keyset=DbKeySet(["id", "index"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    DbColumn("id", type=dbtype(cls.name)),
                    DbColumn("index", type="int"),
                    DbColumn(inflection.singularize(f.name), dbtype(f.type)),
                ]
            )


def generate(opts):
    input = opts.schema.resolve()
    out = opts.dbscheme.resolve()
    renderer = Renderer(opts.check)

    with open(input) as src:
        data = schema.load(src)

    declarations = [d for cls in data.classes.values() for d in cls_to_dbscheme(cls)]

    includes = []
    for inc in data.includes:
        inc = input.parent / inc
        with open(inc) as inclusion:
            includes.append({"src": inc.relative_to(paths.swift_dir), "data": inclusion.read()})
    renderer.render("dbscheme", out, includes=includes, src=input.relative_to(paths.swift_dir),
                    declarations=declarations)
    return renderer.written


if __name__ == "__main__":
    generator.run(generate, tags=["schema", "dbscheme"])
