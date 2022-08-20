"""
dbscheme file generation

`generate(opts, renderer)` will generate a `dbscheme` file out of a `yml` schema file.

Each final class in the schema file will get a corresponding defining DB table with the id and single properties as
columns.
Moreover:
* single properties in non-final classes will also trigger generation of a table with an id reference and all single
  properties as columns
* each optional property will trigger generation of a table with an id reference and the property value as columns
* each repeated property will trigger generation of a table with an id reference, an `int` index and the property value
  as columns
The type hierarchy will be translated to corresponding `union` declarations.
"""

import pathlib

import inflection

from swift.codegen.lib import schema
from swift.codegen.lib.dbscheme import *

log = logging.getLogger(__name__)


def dbtype(typename):
    """ translate a type to a dbscheme counterpart, using `@lower_underscore` format for classes """
    if typename[0].isupper():
        return "@" + inflection.underscore(typename)
    return typename


def cls_to_dbscheme(cls: schema.Class):
    """ Yield all dbscheme entities needed to model class `cls` """
    if cls.derived:
        yield Union(dbtype(cls.name), (dbtype(c) for c in cls.derived))
    dir = cls.dir if cls.dir != pathlib.Path() else None
    # output a table specific to a class only if it is a leaf class or it has 1-to-1 properties
    # Leaf classes need a table to bind the `@` ids
    # 1-to-1 properties are added to a class specific table
    # in other cases, separate tables are used for the properties, and a class specific table is unneeded
    if not cls.derived or any(f.is_single for f in cls.properties):
        binding = not cls.derived
        keyset = KeySet(["id"]) if cls.derived else None
        yield Table(
            keyset=keyset,
            name=inflection.tableize(cls.name),
            columns=[
                Column("id", type=dbtype(cls.name), binding=binding),
            ] + [
                Column(f.name, dbtype(f.type)) for f in cls.properties if f.is_single
            ],
            dir=dir,
        )
    # use property-specific tables for 1-to-many and 1-to-at-most-1 properties
    for f in cls.properties:
        if f.is_repeated:
            yield Table(
                keyset=KeySet(["id", "index"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    Column("id", type=dbtype(cls.name)),
                    Column("index", type="int"),
                    Column(inflection.singularize(f.name), dbtype(f.type)),
                ],
                dir=dir,
            )
        elif f.is_optional:
            yield Table(
                keyset=KeySet(["id"]),
                name=inflection.tableize(f"{cls.name}_{f.name}"),
                columns=[
                    Column("id", type=dbtype(cls.name)),
                    Column(f.name, dbtype(f.type)),
                ],
                dir=dir,
            )
        elif f.is_predicate:
            yield Table(
                keyset=KeySet(["id"]),
                name=inflection.underscore(f"{cls.name}_{f.name}"),
                columns=[
                    Column("id", type=dbtype(cls.name)),
                ],
                dir=dir,
            )


def get_declarations(data: schema.Schema):
    return [d for cls in data.classes.values() for d in cls_to_dbscheme(cls)]


def get_includes(data: schema.Schema, include_dir: pathlib.Path, swift_dir: pathlib.Path):
    includes = []
    for inc in data.includes:
        inc = include_dir / inc
        with open(inc) as inclusion:
            includes.append(SchemeInclude(src=inc.relative_to(swift_dir), data=inclusion.read()))
    return includes


def generate(opts, renderer):
    input = opts.schema
    out = opts.dbscheme

    data = schema.load(input)

    dbscheme = Scheme(src=input.relative_to(opts.swift_dir),
                      includes=get_includes(data, include_dir=input.parent, swift_dir=opts.swift_dir),
                      declarations=get_declarations(data))

    renderer.render(dbscheme, out)
