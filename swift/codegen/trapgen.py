#!/usr/bin/env python3

import logging
import os
import re
import sys

import inflection
from toposort import toposort_flatten

sys.path.append(os.path.dirname(__file__))

from swift.codegen.lib import paths, dbscheme, generator, cpp

field_overrides = [
    (re.compile(r"locations.*::(start|end).*|.*::(index|num_.*)"), {"type": "unsigned"}),
    (re.compile(r".*::(.*)_"), lambda m: {"name": m[1]}),
]

log = logging.getLogger(__name__)


def get_field_override(table, field):
    spec = f"{table}::{field}"
    for r, o in field_overrides:
        m = r.fullmatch(spec)
        if m and callable(o):
            return o(m)
        elif m:
            return o
    return {}


def get_tag_name(s):
    assert s.startswith("@")
    return inflection.camelize(s[1:])


def get_cpp_type(schema_type):
    if schema_type.startswith("@"):
        tag = get_tag_name(schema_type)
        return f"TrapLabel<{tag}Tag>"
    if schema_type == "string":
        return "std::string"
    if schema_type == "boolean":
        return "bool"
    return schema_type


def get_field(c: dbscheme.Column, table: str):
    args = {
        "name": c.schema_name,
        "type": c.type,
    }
    args.update(get_field_override(table, c.schema_name))
    args["type"] = get_cpp_type(args["type"])
    return cpp.Field(**args)


def get_binding_column(t: dbscheme.Table):
    try:
        return next(c for c in t.columns if c.binding)
    except StopIteration:
        return None


def get_trap(t: dbscheme.Table):
    id = get_binding_column(t)
    if id:
        id = get_field(id, t.name)
    return cpp.Trap(
        table_name=t.name,
        name=inflection.camelize(t.name),
        fields=[get_field(c, t.name) for c in t.columns],
        id=id,
    )


def generate(opts, renderer):
    tag_graph = {}
    out = opts.trap_output

    traps = []
    for e in dbscheme.iterload(opts.dbscheme):
        if e.is_table:
            traps.append(get_trap(e))
        elif e.is_union:
            tag_graph.setdefault(e.lhs, set())
            for d in e.rhs:
                tag_graph.setdefault(d.type, set()).add(e.lhs)

    renderer.render(cpp.TrapList(traps), out / "TrapEntries.h")

    tags = []
    for index, tag in enumerate(toposort_flatten(tag_graph)):
        tags.append(cpp.Tag(
            name=get_tag_name(tag),
            bases=[get_tag_name(b) for b in sorted(tag_graph[tag])],
            index=index,
            id=tag,
        ))
    renderer.render(cpp.TagList(tags), out / "TrapTags.h")


tags = ("trap", "dbscheme")

if __name__ == "__main__":
    generator.run()
