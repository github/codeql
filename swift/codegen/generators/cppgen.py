"""
C++ trap class generation

`generate(opts, renderer)` will generate `TrapClasses.h` out of a `yml` schema file.

Each class in the schema gets a corresponding `struct` in `TrapClasses.h`, where:
* inheritance is preserved
* each property will be a corresponding field in the `struct` (with repeated properties mapping to `std::vector` and
  optional ones to `std::optional`)
* final classes get a streaming operator that serializes the whole class into the corresponding trap emissions (using
  `TrapEntries.h` from `trapgen`).
"""

import functools
import pathlib
from typing import Dict

import inflection
from toposort import toposort_flatten

from swift.codegen.lib import cpp, schema


def _get_type(t: str) -> str:
    if t is None:
        # this is a predicate
        return "bool"
    if t == "string":
        return "std::string"
    if t == "boolean":
        return "bool"
    if t[0].isupper():
        return f"TrapLabel<{t}Tag>"
    return t


def _get_field(cls: schema.Class, p: schema.Property) -> cpp.Field:
    trap_name = None
    if not p.is_single:
        trap_name = inflection.camelize(f"{cls.name}_{p.name}")
        if not p.is_predicate:
            trap_name = inflection.pluralize(trap_name)
    args = dict(
        field_name=p.name + ("_" if p.name in cpp.cpp_keywords else ""),
        type=_get_type(p.type),
        is_optional=p.is_optional,
        is_repeated=p.is_repeated,
        is_predicate=p.is_predicate,
        trap_name=trap_name,
    )
    args.update(cpp.get_field_override(p.name))
    return cpp.Field(**args)


class Processor:
    def __init__(self, data: Dict[str, schema.Class]):
        self._classmap = data

    @functools.lru_cache(maxsize=None)
    def _get_class(self, name: str) -> cpp.Class:
        cls = self._classmap[name]
        trap_name = None
        if not cls.derived or any(p.is_single for p in cls.properties):
            trap_name = inflection.pluralize(cls.name)
        return cpp.Class(
            name=name,
            bases=[self._get_class(b) for b in cls.bases],
            fields=[_get_field(cls, p) for p in cls.properties if "cpp_skip" not in p.pragmas],
            final=not cls.derived,
            trap_name=trap_name,
        )

    def get_classes(self):
        grouped = {pathlib.Path(): {}}
        for k, cls in self._classmap.items():
            grouped.setdefault(cls.dir, {}).update({k: cls})
        ret = {}
        for dir, map in grouped.items():
            inheritance_graph = {k: {b for b in cls.bases if b in map} for k, cls in map.items()}
            ret[dir] = [self._get_class(cls) for cls in toposort_flatten(inheritance_graph)]
        return ret


def generate(opts, renderer):
    assert opts.cpp_output
    processor = Processor(schema.load(opts.schema).classes)
    out = opts.cpp_output
    for dir, classes in processor.get_classes().items():
        include_parent = (dir != pathlib.Path())
        renderer.render(cpp.ClassList(classes, opts.schema, include_parent), out / dir / "TrapClasses")
