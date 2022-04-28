#!/usr/bin/env python3

import collections
import logging
import os
import re
import sys

import inflection

sys.path.append(os.path.dirname(__file__))

from lib import paths, dbscheme, generator, cpp

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


def get_guard(path):
    path = path.relative_to(paths.swift_dir)
    return str(path.with_suffix("")).replace("/", "_").upper()


def get_topologically_ordered_tags(tags):
    degree_to_nodes = collections.defaultdict(set)
    nodes_to_degree = {}
    lookup = {}
    for name, t in tags.items():
        degree = len(t["bases"])
        degree_to_nodes[degree].add(name)
        nodes_to_degree[name] = degree
    while degree_to_nodes[0]:
        sinks = degree_to_nodes.pop(0)
        for sink in sorted(sinks):
            yield sink
            for d in tags[sink]["derived"]:
                degree = nodes_to_degree[d]
                degree_to_nodes[degree].remove(d)
                degree -= 1
                nodes_to_degree[d] = degree
                degree_to_nodes[degree].add(d)
    if any(degree_to_nodes.values()):
        raise ValueError("not a dag!")


def generate(opts, renderer):
    tag_graph = collections.defaultdict(lambda: {"bases": [], "derived": []})
    out = opts.trap_output

    traps = []
    with open(opts.dbscheme) as input:
        for e in dbscheme.iterload(input):
            if e.is_table:
                traps.append(get_trap(e))
            elif e.is_union:
                for d in e.rhs:
                    tag_graph[e.lhs]["derived"].append(d.type)
                    tag_graph[d.type]["bases"].append(e.lhs)

    renderer.render(cpp.TrapList(traps), out / "TrapEntries.h")

    tags = []
    for index, tag in enumerate(get_topologically_ordered_tags(tag_graph)):
        tags.append(cpp.Tag(
            name=get_tag_name(tag),
            bases=[get_tag_name(b) for b in sorted(tag_graph[tag]["bases"])],
            index=index,
            id=tag,
        ))
    renderer.render(cpp.TagList(tags), out / "TrapTags.h")


tags = ("trap", "dbscheme")

if __name__ == "__main__":
    generator.run()
