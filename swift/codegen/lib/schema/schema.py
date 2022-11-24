""" schema.yml format representation """
import pathlib
import re
import types
import typing
from dataclasses import dataclass, field
from typing import List, Set, Union, Dict, Optional
from enum import Enum, auto
import functools
import importlib.util
from toposort import toposort_flatten
import inflection


class Error(Exception):

    def __str__(self):
        return self.args[0]


def _check_type(t: Optional[str], known: typing.Iterable[str]):
    if t is not None and t not in known:
        raise Error(f"Unknown type {t}")


@dataclass
class Property:
    class Kind(Enum):
        SINGLE = auto()
        REPEATED = auto()
        OPTIONAL = auto()
        REPEATED_OPTIONAL = auto()
        PREDICATE = auto()

    kind: Kind
    name: Optional[str] = None
    type: Optional[str] = None
    is_child: bool = False
    pragmas: List[str] = field(default_factory=list)
    doc: Optional[str] = None
    description: List[str] = field(default_factory=list)

    @property
    def is_single(self) -> bool:
        return self.kind == self.Kind.SINGLE

    @property
    def is_optional(self) -> bool:
        return self.kind in (self.Kind.OPTIONAL, self.Kind.REPEATED_OPTIONAL)

    @property
    def is_repeated(self) -> bool:
        return self.kind in (self.Kind.REPEATED, self.Kind.REPEATED_OPTIONAL)

    @property
    def is_predicate(self) -> bool:
        return self.kind == self.Kind.PREDICATE

    @property
    def has_class_type(self) -> bool:
        return bool(self.type) and self.type[0].isupper()

    @property
    def has_builtin_type(self) -> bool:
        return bool(self.type) and self.type[0].islower()


SingleProperty = functools.partial(Property, Property.Kind.SINGLE)
OptionalProperty = functools.partial(Property, Property.Kind.OPTIONAL)
RepeatedProperty = functools.partial(Property, Property.Kind.REPEATED)
RepeatedOptionalProperty = functools.partial(
    Property, Property.Kind.REPEATED_OPTIONAL)
PredicateProperty = functools.partial(Property, Property.Kind.PREDICATE)


@dataclass
class IpaInfo:
    from_class: Optional[str] = None
    on_arguments: Optional[Dict[str, str]] = None


@dataclass
class Class:
    name: str
    bases: List[str] = field(default_factory=list)
    derived: Set[str] = field(default_factory=set)
    properties: List[Property] = field(default_factory=list)
    group: str = ""
    pragmas: List[str] = field(default_factory=list)
    ipa: Optional[Union[IpaInfo, bool]] = None
    """^^^ filled with `True` for non-final classes with only synthesized final descendants """
    doc: List[str] = field(default_factory=list)
    default_doc_name: Optional[str] = None

    @property
    def final(self):
        return not self.derived

    def check_types(self, known: typing.Iterable[str]):
        for b in self.bases:
            _check_type(b, known)
        for d in self.derived:
            _check_type(d, known)
        for p in self.properties:
            _check_type(p.type, known)
        if self.ipa is not None:
            _check_type(self.ipa.from_class, known)
            if self.ipa.on_arguments is not None:
                for t in self.ipa.on_arguments.values():
                    _check_type(t, known)


@dataclass
class Schema:
    classes: Dict[str, Class] = field(default_factory=dict)
    includes: Set[str] = field(default_factory=set)
    null: Optional[str] = None

    @property
    def root_class(self):
        # always the first in the dictionary
        return next(iter(self.classes.values()))

    @property
    def null_class(self):
        return self.classes[self.null] if self.null else None


predicate_marker = object()

TypeRef = Union[type, str]


@functools.singledispatch
def get_type_name(arg: TypeRef) -> str:
    raise Error(f"Not a schema type or string ({arg})")


@get_type_name.register
def _(arg: type):
    return arg.__name__


@get_type_name.register
def _(arg: str):
    return arg


@functools.singledispatch
def _make_property(arg: object) -> Property:
    if arg is predicate_marker:
        return PredicateProperty()
    raise Error(f"Illegal property specifier {arg}")


@_make_property.register(str)
@_make_property.register(type)
def _(arg: TypeRef):
    return SingleProperty(type=get_type_name(arg))


@_make_property.register
def _(arg: Property):
    return arg


class PropertyModifier:
    """ Modifier of `Property` objects.
        Being on the right of `|` it will trigger construction of a `Property` from
        the left operand.
    """

    def __ror__(self, other: object) -> Property:
        ret = _make_property(other)
        self.modify(ret)
        return ret

    def modify(self, prop: Property):
        raise NotImplementedError


def split_doc(doc):
    # implementation inspired from https://peps.python.org/pep-0257/
    if not doc:
        return []
    lines = doc.splitlines()
    # Determine minimum indentation (first line doesn't count):
    strippedlines = (line.lstrip() for line in lines[1:])
    indents = [len(line) - len(stripped) for line, stripped in zip(lines[1:], strippedlines) if stripped]
    # Remove indentation (first line is special):
    trimmed = [lines[0].strip()]
    if indents:
        indent = min(indents)
        trimmed.extend(line[indent:].rstrip() for line in lines[1:])
    # Strip off trailing and leading blank lines:
    while trimmed and not trimmed[-1]:
        trimmed.pop()
    while trimmed and not trimmed[0]:
        trimmed.pop(0)
    return trimmed


@dataclass
class _PropertyNamer(PropertyModifier):
    name: str

    def modify(self, prop: Property):
        prop.name = self.name.rstrip("_")


def _get_class(cls: type) -> Class:
    if not isinstance(cls, type):
        raise Error(f"Only class definitions allowed in schema, found {cls}")
    # we must check that going to dbscheme names and back is preserved
    # In particular this will not happen if uppercase acronyms are included in the name
    to_underscore_and_back = inflection.camelize(inflection.underscore(cls.__name__), uppercase_first_letter=True)
    if cls.__name__ != to_underscore_and_back:
        raise Error(f"Class name must be upper camel-case, without capitalized acronyms, found {cls.__name__} "
                    f"instead of {to_underscore_and_back}")
    if len({b._group for b in cls.__bases__ if hasattr(b, "_group")}) > 1:
        raise Error(f"Bases with mixed groups for {cls.__name__}")
    if any(getattr(b, "_null", False) for b in cls.__bases__):
        raise Error(f"Null class cannot be derived")
    return Class(name=cls.__name__,
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
                 doc=split_doc(cls.__doc__),
                 default_doc_name=cls.__dict__.get("_doc_name"),
                 )


def _toposort_classes_by_group(classes: typing.Dict[str, Class]) -> typing.Dict[str, Class]:
    groups = {}
    ret = {}

    for name, cls in classes.items():
        groups.setdefault(cls.group, []).append(name)

    for group, grouped in sorted(groups.items()):
        inheritance = {name: classes[name].bases for name in grouped}
        for name in toposort_flatten(inheritance):
            ret[name] = classes[name]

    return ret


def _fill_ipa_information(classes: typing.Dict[str, Class]):
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


def load(m: types.ModuleType) -> Schema:
    includes = set()
    classes = {}
    known = {"int", "string", "boolean"}
    known.update(n for n in m.__dict__ if not n.startswith("__"))
    import swift.codegen.lib.schema.defs as defs
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
            raise Error(
                f"Only one root class allowed, found second root {name}")
        cls.check_types(known)
        classes[name] = cls
        if getattr(data, "_null", False):
            if null is not None:
                raise Error(f"Null class {null} already defined, second null class {name} not allowed")
            null = name
            cls.is_null_class = True

    _fill_ipa_information(classes)

    return Schema(includes=includes, classes=_toposort_classes_by_group(classes), null=null)


def load_file(path: pathlib.Path) -> Schema:
    spec = importlib.util.spec_from_file_location("schema", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return load(module)
