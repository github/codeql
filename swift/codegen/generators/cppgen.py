import functools
from typing import Dict

import inflection
from toposort import toposort_flatten

from swift.codegen.lib import cpp, schema


def _get_type(t: str, trap_affix: str) -> str:
    if t is None:
        # this is a predicate
        return "bool"
    if t == "string":
        return "std::string"
    if t == "boolean":
        return "bool"
    if t[0].isupper():
        return f"{trap_affix}Label<{t}Tag>"
    return t


def _get_field(cls: schema.Class, p: schema.Property, trap_affix: str) -> cpp.Field:
    trap_name = None
    if not p.is_single:
        trap_name = inflection.camelize(f"{cls.name}_{p.name}")
        if not p.is_predicate:
            trap_name = inflection.pluralize(trap_name)
    args = dict(
        field_name=p.name + ("_" if p.name in cpp.cpp_keywords else ""),
        type=_get_type(p.type, trap_affix),
        is_optional=p.is_optional,
        is_repeated=p.is_repeated,
        is_predicate=p.is_predicate,
        trap_name=trap_name,
    )
    args.update(cpp.get_field_override(p.name))
    return cpp.Field(**args)


class Processor:
    def __init__(self, data: Dict[str, schema.Class], trap_affix: str):
        self._classmap = data
        self._trap_affix = trap_affix

    @functools.lru_cache(maxsize=None)
    def _get_class(self, name: str) -> cpp.Class:
        cls = self._classmap[name]
        trap_name = None
        if not cls.derived or any(p.is_single for p in cls.properties):
            trap_name = inflection.pluralize(cls.name)
        return cpp.Class(
            name=name,
            bases=[self._get_class(b) for b in cls.bases],
            fields=[_get_field(cls, p, self._trap_affix) for p in cls.properties],
            final=not cls.derived,
            trap_name=trap_name,
        )

    def get_classes(self):
        inheritance_graph = {k: cls.bases for k, cls in self._classmap.items()}
        return [self._get_class(cls) for cls in toposort_flatten(inheritance_graph)]


def generate(opts, renderer):
    assert opts.cpp_output
    processor = Processor({cls.name: cls for cls in schema.load(opts.schema).classes}, opts.trap_affix)
    out = opts.cpp_output
    renderer.render(cpp.ClassList(processor.get_classes(), opts.cpp_namespace, opts.trap_affix,
                                  opts.cpp_include_dir, opts.schema), out / f"{opts.trap_affix}Classes.h")
