#!/usr/bin/env python3
import pathlib

import inflection

from lib import paths, schema, generator
from lib.dbscheme import *

log = logging.getLogger(__name__)


def dbtype(typename):
    """ translate a type to a dbscheme counterpart, using `@lower_underscore` format for classes """
    if typename[0].isupper():
        return "@" + inflection.underscore(typename)
    return typename


def cls_to_dbscheme(cls: schema.Class):
    """ Yield all dbscheme entities needed to model class `cls` """
    if cls.derived:
        yield DbUnion(dbtype(cls.name), (dbtype(c) for c in cls.derived))
    # output a table specific to a class only if it is a leaf class or it has 1-to-1 properties
    # Leaf classes need a table to bind the `@` ids
    # 1-to-1 properties are added to a class specific table
    # in other cases, separate tables are used for the properties, and a class specific table is unneeded
    if not cls.derived or any(f.is_single for f in cls.properties):
        binding = not cls.derived
        keyset = DbKeySet(["id"]) if cls.derived else None
        yield DbTable(
            keyset=keyset,
            name=inflection.tableize(cls.name),
            columns=[
                        DbColumn("id", type=dbtype(cls.name), binding=binding),
                    ] + [
                        DbColumn(f.name, dbtype(f.type)) for f in cls.properties if f.is_single
                    ]
        )
    # use property-specific tables for 1-to-many and 1-to-at-most-1 properties
    for f in cls.properties:
        if f.is_optional:
            yield DbTable(
                keyset=DbKeySet(["id"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    DbColumn("id", type=dbtype(cls.name)),
                    DbColumn(f.name, dbtype(f.type)),
                ],
            )
        elif f.is_repeated:
            yield DbTable(
                keyset=DbKeySet(["id", "index"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    DbColumn("id", type=dbtype(cls.name)),
                    DbColumn("index", type="int"),
                    DbColumn(inflection.singularize(f.name), dbtype(f.type)),
                ]
            )


def get_declarations(data: schema.Schema):
    return [d for cls in data.classes.values() for d in cls_to_dbscheme(cls)]


def get_includes(data: schema.Schema, include_dir: pathlib.Path):
    includes = []
    for inc in data.includes:
        inc = include_dir / inc
        with open(inc) as inclusion:
            includes.append(DbSchemeInclude(src=inc.relative_to(paths.swift_dir), data=inclusion.read()))
    return includes


def generate(opts, renderer):
    input = opts.schema.resolve()
    out = opts.dbscheme.resolve()

    with open(input) as src:
        data = schema.load(src)

    dbscheme = DbScheme(src=input.relative_to(paths.swift_dir),
                        includes=get_includes(data, include_dir=input.parent),
                        declarations=get_declarations(data))

    renderer.render(dbscheme, out)


if __name__ == "__main__":
    generator.run(generate, tags=["schema", "dbscheme"])
