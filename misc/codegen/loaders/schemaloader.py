""" schema loader """

import inflection
import typing
import types
import pathlib
import importlib.util
from dataclasses import dataclass
from toposort import toposort_flatten

from misc.codegen.lib import schema, schemadefs


@dataclass
class _PropertyNamer(schema.PropertyModifier):
    name: str

    def modify(self, prop: schema.Property):
        prop.name = self.name.rstrip("_")


def _get_class(cls: type) -> schema.Class:
    if not isinstance(cls, type):
        raise schema.Error(f"Only class definitions allowed in schema, found {cls}")
    # we must check that going to dbscheme names and back is preserved
    # In particular this will not happen if uppercase acronyms are included in the name
    to_underscore_and_back = inflection.camelize(inflection.underscore(cls.__name__), uppercase_first_letter=True)
    if cls.__name__ != to_underscore_and_back:
        raise schema.Error(f"Class name must be upper camel-case, without capitalized acronyms, found {cls.__name__} "
                           f"instead of {to_underscore_and_back}")
    if len({b._group for b in cls.__bases__ if hasattr(b, "_group")}) > 1:
        raise schema.Error(f"Bases with mixed groups for {cls.__name__}")
    if any(getattr(b, "_null", False) for b in cls.__bases__):
        raise schema.Error(f"Null class cannot be derived")
    return schema.Class(name=cls.__name__,
                        bases=[b.__name__ for b in cls.__bases__ if b is not object],
                        derived={d.__name__ for d in cls.__subclasses__()},
                        # getattr to inherit from bases
                        group=getattr(cls, "_group", ""),
                        # in the following we don't use `getattr` to avoid inheriting
                        pragmas=cls.__dict__.get("_pragmas", []),
                        ipa=cls.__dict__.get("_ipa", None),
                        properties=[
                            a | _PropertyNamer(n)
                            for n, a in cls.__dict__.get("__annotations__", {}).items()
                        ],
                        doc=schema.split_doc(cls.__doc__),
                        default_doc_name=cls.__dict__.get("_doc_name"),
                        )


def _toposort_classes_by_group(classes: typing.Dict[str, schema.Class]) -> typing.Dict[str, schema.Class]:
    groups = {}
    ret = {}

    for name, cls in classes.items():
        groups.setdefault(cls.group, []).append(name)

    for group, grouped in sorted(groups.items()):
        inheritance = {name: classes[name].bases for name in grouped}
        for name in toposort_flatten(inheritance):
            ret[name] = classes[name]

    return ret


def _fill_ipa_information(classes: typing.Dict[str, schema.Class]):
    """ Take a dictionary where the `ipa` field is filled for all explicitly synthesized classes
    and update it so that all non-final classes that have only synthesized final descendants
    get `True` as` value for the `ipa` field
    """
    if not classes:
        return

    is_ipa: typing.Dict[str, bool] = {}

    def fill_is_ipa(name: str):
        if name not in is_ipa:
            cls = classes[name]
            for d in cls.derived:
                fill_is_ipa(d)
            if cls.ipa is not None:
                is_ipa[name] = True
            elif not cls.derived:
                is_ipa[name] = False
            else:
                is_ipa[name] = all(is_ipa[d] for d in cls.derived)

    root = next(iter(classes))
    fill_is_ipa(root)

    for name, cls in classes.items():
        if cls.ipa is None and is_ipa[name]:
            cls.ipa = True


def load(m: types.ModuleType) -> schema.Schema:
    includes = set()
    classes = {}
    known = {"int", "string", "boolean"}
    known.update(n for n in m.__dict__ if not n.startswith("__"))
    import misc.codegen.lib.schemadefs as defs
    null = None
    for name, data in m.__dict__.items():
        if hasattr(defs, name):
            continue
        if name == "__includes":
            includes = set(data)
            continue
        if name.startswith("__"):
            continue
        cls = _get_class(data)
        if classes and not cls.bases:
            raise schema.Error(
                f"Only one root class allowed, found second root {name}")
        cls.check_types(known)
        classes[name] = cls
        if getattr(data, "_null", False):
            if null is not None:
                raise schema.Error(f"Null class {null} already defined, second null class {name} not allowed")
            null = name
            cls.is_null_class = True

    _fill_ipa_information(classes)

    return schema.Schema(includes=includes, classes=_toposort_classes_by_group(classes), null=null)


def load_file(path: pathlib.Path) -> schema.Schema:
    spec = importlib.util.spec_from_file_location("schema", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return load(module)
