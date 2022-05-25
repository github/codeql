#!/usr/bin/env python3

import logging

import inflection
from toposort import toposort_flatten

from swift.codegen.lib import dbscheme, cpp
from swift.codegen.generators import generator

log = logging.getLogger(__name__)


def get_tag_name(s):
    assert s.startswith("@")
    return inflection.camelize(s[1:])


def get_cpp_type(schema_type: str, trap_affix: str):
    if schema_type.startswith("@"):
        tag = get_tag_name(schema_type)
        return f"{trap_affix}Label<{tag}Tag>"
    if schema_type == "string":
        return "std::string"
    if schema_type == "boolean":
        return "bool"
    return schema_type


def get_field(c: dbscheme.Column, trap_affix: str):
    args = {
        "field_name": c.schema_name,
        "type": c.type,
    }
    args.update(cpp.get_field_override(c.schema_name))
    args["type"] = get_cpp_type(args["type"], trap_affix)
    return cpp.Field(**args)


def get_binding_column(t: dbscheme.Table):
    try:
        return next(c for c in t.columns if c.binding)
    except StopIteration:
        return None


def get_trap(t: dbscheme.Table, trap_affix: str):
    id = get_binding_column(t)
    if id:
        id = get_field(id, trap_affix)
    return cpp.Trap(
        table_name=t.name,
        name=inflection.camelize(t.name),
        fields=[get_field(c, trap_affix) for c in t.columns],
        id=id,
    )


def generate(opts, renderer):
    tag_graph = {}
    out = opts.cpp_output

    traps = []
    for e in dbscheme.iterload(opts.dbscheme):
        if e.is_table:
            traps.append(get_trap(e, opts.trap_affix))
        elif e.is_union:
            tag_graph.setdefault(e.lhs, set())
            for d in e.rhs:
                tag_graph.setdefault(d.type, set()).add(e.lhs)

    renderer.render(cpp.TrapList(traps, opts.cpp_namespace, opts.trap_affix, opts.cpp_include_dir, opts.dbscheme),
                    out / f"{opts.trap_affix}Entries.h")

    tags = []
    for index, tag in enumerate(toposort_flatten(tag_graph)):
        tags.append(cpp.Tag(
            name=get_tag_name(tag),
            bases=[get_tag_name(b) for b in sorted(tag_graph[tag])],
            index=index,
            id=tag,
        ))
    renderer.render(cpp.TagList(tags, opts.cpp_namespace, opts.dbscheme), out / f"{opts.trap_affix}Tags.h")


tags = ("cpp", "dbscheme")

if __name__ == "__main__":
    generator.run()
