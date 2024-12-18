"""
Rust trap class generation
"""

import functools
import typing

import inflection

from misc.codegen.lib import rust, schema
from misc.codegen.loaders import schemaloader


def _get_type(t: str) -> str:
    match t:
        case None:  # None means a predicate
            return "bool"
        case "string":
            return "String"
        case "int":
            return "usize"
        case _ if t[0].isupper():
            return f"trap::Label<{t}>"
        case "boolean":
            assert False, "boolean unsupported"
        case _:
            return t


def _get_field(cls: schema.Class, p: schema.Property) -> rust.Field:
    table_name = inflection.tableize(cls.name)
    if not p.is_single:
        table_name = f"{cls.name}_{p.name}"
        if p.is_predicate:
            table_name = inflection.underscore(table_name)
        else:
            table_name = inflection.tableize(table_name)
    args = dict(
        field_name=rust.avoid_keywords(p.name),
        base_type=_get_type(p.type),
        is_optional=p.is_optional,
        is_repeated=p.is_repeated,
        is_predicate=p.is_predicate,
        is_unordered=p.is_unordered,
        table_name=table_name,
    )
    args.update(rust.get_field_override(p.name))
    return rust.Field(**args)


def _get_properties(
    cls: schema.Class, lookup: dict[str, schema.ClassBase],
) -> typing.Iterable[tuple[schema.Class, schema.Property]]:
    for b in cls.bases:
        yield from _get_properties(lookup[b], lookup)
    for p in cls.properties:
        yield cls, p


def _get_ancestors(
    cls: schema.Class, lookup: dict[str, schema.ClassBase]
) -> typing.Iterable[schema.Class]:
    for b in cls.bases:
        base = lookup[b]
        if not base.imported:
            base = typing.cast(schema.Class, base)
            yield base
            yield from _get_ancestors(base, lookup)


class Processor:
    def __init__(self, data: schema.Schema):
        self._classmap = data.classes

    def _get_class(self, name: str) -> rust.Class:
        cls = typing.cast(schema.Class, self._classmap[name])
        properties = [
            (c, p)
            for c, p in _get_properties(cls, self._classmap)
            if "rust_skip" not in p.pragmas and not p.synth
        ]
        fields = []
        detached_fields = []
        for c, p in properties:
            if "rust_detach" in p.pragmas:
                # only generate detached fields in the actual class defining them, not the derived ones
                if c is cls:
                    # TODO lift this restriction if required (requires change in dbschemegen as well)
                    assert c.derived or not p.is_single, \
                        f"property {p.name} in concrete class marked as detached but not optional"
                    detached_fields.append(_get_field(c, p))
            elif not cls.derived:
                # for non-detached ones, only generate fields in the concrete classes
                fields.append(_get_field(c, p))
        return rust.Class(
            name=name,
            fields=fields,
            detached_fields=detached_fields,
            ancestors=sorted(set(a.name for a in _get_ancestors(cls, self._classmap))),
            entry_table=inflection.tableize(cls.name) if not cls.derived else None,
        )

    def get_classes(self):
        ret = {"": []}
        for k, cls in self._classmap.items():
            if not cls.imported and not cls.synth:
                ret.setdefault(cls.group, []).append(self._get_class(cls.name))
            elif cls.imported:
                ret[""].append(rust.Class(name=cls.name))
        return ret


def generate(opts, renderer):
    assert opts.rust_output
    processor = Processor(schemaloader.load_file(opts.schema))
    out = opts.rust_output
    groups = set()
    with renderer.manage(generated=out.rglob("*.rs"),
                         stubs=(),
                         registry=out / ".generated.list",
                         force=opts.force) as renderer:
        for group, classes in processor.get_classes().items():
            group = group or "top"
            groups.add(group)
            renderer.render(
                rust.ClassList(
                    classes,
                    opts.schema,
                ),
                out / f"{group}.rs",
            )
        renderer.render(
            rust.ModuleList(
                groups,
                opts.schema,
            ),
            out / f"mod.rs",
        )
