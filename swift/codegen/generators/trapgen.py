"""
C++ trap entry generation

`generate(opts, renderer)` will generate `TrapTags.h` (for types of labels) and `TrapEntries.h` (for trap emission) out
of a dbscheme file.

Each table in the `dbscheme` gets a corresponding `struct` defined in `TrapEntries.h` with a field for each column and
an appropriate streaming operator for the trap emission.

Unions in the `dbscheme` are used to populate a hierarchy of tags (empty structs) in `TrapTags.h` that is used to
enforce a type system on trap labels (see `TrapLabel.h`).
"""

import logging

import inflection
from toposort import toposort_flatten

from swift.codegen.lib import dbscheme, cpp

log = logging.getLogger(__name__)


def get_tag_name(s):
    assert s.startswith("@")
    return inflection.camelize(s[1:])


def get_cpp_type(schema_type: str):
    if schema_type.startswith("@"):
        tag = get_tag_name(schema_type)
        return f"TrapLabel<{tag}Tag>"
    if schema_type == "string":
        return "std::string"
    if schema_type == "boolean":
        return "bool"
    return schema_type


def get_field(c: dbscheme.Column):
    args = {
        "field_name": c.schema_name,
        "type": c.type,
    }
    args.update(cpp.get_field_override(c.schema_name))
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
        id = get_field(id)
    return cpp.Trap(
        table_name=t.name,
        name=inflection.camelize(t.name),
        fields=[get_field(c) for c in t.columns],
        id=id,
    )


def generate(opts, renderer):
    assert opts.cpp_output
    tag_graph = {}
    out = opts.cpp_output

    traps = []
    for e in dbscheme.iterload(opts.dbscheme):
        if e.is_table:
            traps.append(get_trap(e))
        elif e.is_union:
            tag_graph.setdefault(e.lhs, set())
            for d in e.rhs:
                tag_graph.setdefault(d.type, set()).add(e.lhs)

    renderer.render(cpp.TrapList(traps, opts.dbscheme),
                    out / f"TrapEntries.h")

    tags = []
    for index, tag in enumerate(toposort_flatten(tag_graph)):
        tags.append(cpp.Tag(
            name=get_tag_name(tag),
            bases=[get_tag_name(b) for b in sorted(tag_graph[tag])],
            index=index,
            id=tag,
        ))
    renderer.render(cpp.TagList(tags, opts.dbscheme), out / f"TrapTags.h")
