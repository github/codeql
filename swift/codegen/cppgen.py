import functools
import inflection
from typing import Dict

from toposort import toposort_flatten

from swift.codegen.lib import cpp, generator, schema


def _get_type(t: str) -> str:
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
        trap_name = inflection.pluralize(inflection.camelize(f"{cls.name}_{p.name}")) + "Trap"
    args = dict(
        name=p.name + ("_" if p.name in cpp.cpp_keywords else ""),
        type=_get_type(p.type),
        is_optional=p.is_optional,
        is_repeated=p.is_repeated,
        trap_name=trap_name,
    )
    args.update(cpp.get_field_override(p.name))
    return cpp.Field(**args)


class Processor:
    def __init__(self, data: Dict[str, schema.Class]):
        self._classmap = data

    @functools.cache
    def _get_class(self, name: str) -> cpp.Class:
        cls = self._classmap[name]
        trap_name = None
        if not cls.derived or any(p.is_single for p in cls.properties):
            trap_name = inflection.pluralize(cls.name) + "Trap"
        return cpp.Class(
            name=name,
            bases=[self._get_class(b) for b in cls.bases],
            fields=[_get_field(cls, p) for p in cls.properties],
            final=not cls.derived,
            trap_name=trap_name,
        )

    def get_classes(self):
        inheritance_graph = {k: cls.bases for k, cls in self._classmap.items()}
        return [self._get_class(cls) for cls in toposort_flatten(inheritance_graph)]


def generate(opts, renderer):
    processor = Processor({cls.name: cls for cls in schema.load(opts.schema).classes})
    out = opts.cpp_output
    renderer.render(cpp.ClassList(processor.get_classes()), out / "TrapClasses.h")


tags = ("cpp", "schema")

if __name__ == "__main__":
    generator.run()
