""" schema format representation """
import typing
from dataclasses import dataclass, field
from typing import List, Set, Union, Dict, Optional
from enum import Enum, auto
import functools


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
        REPEATED_UNORDERED = auto()

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
        return self.kind in (self.Kind.REPEATED, self.Kind.REPEATED_OPTIONAL, self.Kind.REPEATED_UNORDERED)

    @property
    def is_unordered(self) -> bool:
        return self.kind == self.Kind.REPEATED_UNORDERED

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
RepeatedUnorderedProperty = functools.partial(Property, Property.Kind.REPEATED_UNORDERED)


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
