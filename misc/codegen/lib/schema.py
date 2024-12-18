""" schema format representation """
import abc
import typing
from collections.abc import Iterable
from dataclasses import dataclass, field
from typing import List, Set, Union, Dict, Optional, FrozenSet
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
    pragmas: List[str] | Dict[str, object] = field(default_factory=dict)
    doc: Optional[str] = None
    description: List[str] = field(default_factory=list)
    synth: bool = False

    def __post_init__(self):
        if not isinstance(self.pragmas, dict):
            self.pragmas = dict.fromkeys(self.pragmas, None)

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
class SynthInfo:
    from_class: Optional[str] = None
    on_arguments: Optional[Dict[str, str]] = None


@dataclass
class ClassBase:
    imported: typing.ClassVar[bool]
    name: str


@dataclass
class ImportedClass(ClassBase):
    imported: typing.ClassVar[bool] = True

    module: str


@dataclass
class Class(ClassBase):
    imported: typing.ClassVar[bool] = False

    bases: List[str] = field(default_factory=list)
    derived: Set[str] = field(default_factory=set)
    properties: List[Property] = field(default_factory=list)
    pragmas: List[str] | Dict[str, object] = field(default_factory=dict)
    doc: List[str] = field(default_factory=list)
    cfg: bool = False

    def __post_init__(self):
        if not isinstance(self.pragmas, dict):
            self.pragmas = dict.fromkeys(self.pragmas, None)

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
        if "synth" in self.pragmas:
            synth = self.pragmas["synth"]
            _check_type(synth.from_class, known)
            if synth.on_arguments is not None:
                for t in synth.on_arguments.values():
                    _check_type(t, known)
        _check_type(self.pragmas.get("qltest_test_with"), known)

    @property
    def synth(self) -> SynthInfo | bool | None:
        return self.pragmas.get("synth")

    def mark_synth(self):
        self.pragmas.setdefault("synth", True)

    @property
    def group(self) -> str:
        return typing.cast(str, self.pragmas.get("group", ""))


@dataclass
class Schema:
    classes: Dict[str, ClassBase] = field(default_factory=dict)
    includes: List[str] = field(default_factory=list)
    null: Optional[str] = None

    @property
    def root_class(self):
        # always the first in the dictionary
        return next(iter(self.classes.values()))

    @property
    def null_class(self):
        return self.classes[self.null] if self.null else None

    def iter_properties(self, cls: str) -> Iterable[Property]:
        cls = self.classes[cls]
        for b in cls.bases:
            yield from self.iter_properties(b)
        yield from cls.properties


predicate_marker = object()

TypeRef = type | str | ImportedClass


def get_type_name(arg: TypeRef) -> str:
    match arg:
        case type():
            return arg.__name__
        case str():
            return arg
        case ImportedClass():
            return arg.name
        case _:
            raise Error(f"Not a schema type or string ({arg})")


def _make_property(arg: object) -> Property:
    match arg:
        case _ if arg is predicate_marker:
            return PredicateProperty()
        case (str() | type() | ImportedClass()) as arg:
            return SingleProperty(type=get_type_name(arg))
        case Property() as arg:
            return arg
        case _:
            raise Error(f"Illegal property specifier {arg}")


class PropertyModifier(abc.ABC):
    """ Modifier of `Property` objects.
        Being on the right of `|` it will trigger construction of a `Property` from
        the left operand.
    """

    def __ror__(self, other: object) -> Property:
        ret = _make_property(other)
        self.modify(ret)
        return ret

    def __invert__(self) -> "PropertyModifier":
        return self.negate()

    def modify(self, prop: Property):
        ...

    def negate(self) -> "PropertyModifier":
        ...


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


inheritable_pragma_prefix = "_inheritable_pragma_"
