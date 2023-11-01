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
import typing

import inflection

from misc.codegen.lib import cpp, schema
from misc.codegen.loaders import schemaloader


def _get_type(t: str, add_or_none_except: typing.Optional[str] = None) -> str:
    if t is None:
        # this is a predicate
        return "bool"
    if t == "string":
        return "std::string"
    if t == "boolean":
        return "bool"
    if t[0].isupper():
        if add_or_none_except is not None and t != add_or_none_except:
            suffix = "OrNone"
        else:
            suffix = ""
        return f"TrapLabel<{t}{suffix}Tag>"
    return t


def _get_field(cls: schema.Class, p: schema.Property, add_or_none_except: typing.Optional[str] = None) -> cpp.Field:
    trap_name = None
    if not p.is_single:
        trap_name = inflection.camelize(f"{cls.name}_{p.name}")
        if not p.is_predicate:
            trap_name = inflection.pluralize(trap_name)
    args = dict(
        field_name=p.name + ("_" if p.name in cpp.cpp_keywords else ""),
        base_type=_get_type(p.type, add_or_none_except),
        is_optional=p.is_optional,
        is_repeated=p.is_repeated,
        is_predicate=p.is_predicate,
        is_unordered=p.is_unordered,
        trap_name=trap_name,
    )
    args.update(cpp.get_field_override(p.name))
    return cpp.Field(**args)


class Processor:
    def __init__(self, data: schema.Schema):
        self._classmap = data.classes
        if data.null:
            root_type = next(iter(data.classes))
            self._add_or_none_except = root_type
        else:
            self._add_or_none_except = None

    @functools.lru_cache(maxsize=None)
    def _get_class(self, name: str) -> cpp.Class:
        cls = self._classmap[name]
        trap_name = None
        if not cls.derived or any(p.is_single for p in cls.properties):
            trap_name = inflection.pluralize(cls.name)
        return cpp.Class(
            name=name,
            bases=[self._get_class(b) for b in cls.bases],
            fields=[
                _get_field(cls, p, self._add_or_none_except)
                for p in cls.properties if "cpp_skip" not in p.pragmas and not p.synth
            ],
            final=not cls.derived,
            trap_name=trap_name,
        )

    def get_classes(self):
        ret = {'': []}
        for k, cls in self._classmap.items():
            if not cls.synth:
                ret.setdefault(cls.group, []).append(self._get_class(cls.name))
        return ret


def generate(opts, renderer):
    assert opts.cpp_output
    processor = Processor(schemaloader.load_file(opts.schema))
    out = opts.cpp_output
    for dir, classes in processor.get_classes().items():
        renderer.render(cpp.ClassList(classes, opts.schema,
                                      include_parent=bool(dir),
                                      trap_library=opts.trap_library), out / dir / "TrapClasses")
