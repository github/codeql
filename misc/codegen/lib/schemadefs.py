from typing import (
    Callable as _Callable,
    Dict as _Dict,
    Iterable as _Iterable,
    ClassVar as _ClassVar,
)
from misc.codegen.lib import schema as _schema
import inspect as _inspect
from dataclasses import dataclass as _dataclass

_set = set


@_dataclass
class _ChildModifier(_schema.PropertyModifier):
    child: bool = True

    def modify(self, prop: _schema.Property):
        if prop.type is None or prop.type[0].islower():
            raise _schema.Error("Non-class properties cannot be children")
        if prop.is_unordered:
            raise _schema.Error("Set properties cannot be children")
        prop.is_child = self.child

    def negate(self) -> _schema.PropertyModifier:
        return _ChildModifier(False)


class _DocModifierMetaclass(type(_schema.PropertyModifier)):
    # make ~doc same as doc(None)
    def __invert__(self) -> _schema.PropertyModifier:
        return _DocModifier(None)


@_dataclass
class _DocModifier(_schema.PropertyModifier, metaclass=_DocModifierMetaclass):
    doc: str | None

    def modify(self, prop: _schema.Property):
        if self.doc and ("\n" in self.doc or self.doc[-1] == "."):
            raise _schema.Error("No newlines or trailing dots are allowed in doc, did you intend to use desc?")
        prop.doc = self.doc

    def negate(self) -> _schema.PropertyModifier:
        return _DocModifier(None)


class _DescModifierMetaclass(type(_schema.PropertyModifier)):
    # make ~desc same as desc(None)
    def __invert__(self) -> _schema.PropertyModifier:
        return _DescModifier(None)


@_dataclass
class _DescModifier(_schema.PropertyModifier, metaclass=_DescModifierMetaclass):
    description: str | None

    def modify(self, prop: _schema.Property):
        prop.description = _schema.split_doc(self.description)

    def negate(self) -> _schema.PropertyModifier:
        return _DescModifier(None)


def include(source: str):
    # add to `includes` variable in calling context
    _inspect.currentframe().f_back.f_locals.setdefault("includes", []).append(source)


imported = _schema.ImportedClass


@_dataclass
class _Namespace:
    """ simple namespacing mechanism """
    _name: str

    def add(self, pragma: "_PragmaBase", key: str | None = None):
        self.__dict__[pragma.pragma] = pragma
        pragma.pragma = key or f"{self._name}_{pragma.pragma}"


@_dataclass
class _SynthModifier(_schema.PropertyModifier, _Namespace):
    synth: bool = True

    def modify(self, prop: _schema.Property):
        prop.synth = self.synth

    def negate(self) -> _schema.PropertyModifier:
        return _SynthModifier(self._name, False)


qltest = _Namespace("qltest")
ql = _Namespace("ql")
cpp = _Namespace("cpp")
rust = _Namespace("rust")
synth = _SynthModifier("synth")


@_dataclass
class _PragmaBase:
    pragma: str


@_dataclass
class _ClassPragma(_PragmaBase):
    """ A class pragma.
    For schema classes it acts as a python decorator with `@`.
    """
    inherited: bool = False
    value: object = None

    def __call__(self, cls: type) -> type:
        """ use this pragma as a decorator on classes """
        if self.inherited:
            setattr(cls, f"{_schema.inheritable_pragma_prefix}{self.pragma}", self.value)
        else:
            # not using hasattr as we don't want to land on inherited pragmas
            if "_pragmas" not in cls.__dict__:
                cls._pragmas = {}
            self._apply(cls._pragmas)
        return cls

    def _apply(self, pragmas: _Dict[str, object]) -> None:
        pragmas[self.pragma] = self.value


@_dataclass
class _Pragma(_ClassPragma, _schema.PropertyModifier):
    """ A class or property pragma.
    For properties, it functions similarly to a `_PropertyModifier` with `|`, adding the pragma.
    For schema classes it acts as a python decorator with `@`.
    """
    remove: bool = False

    def modify(self, prop: _schema.Property):
        self._apply(prop.pragmas)

    def negate(self) -> _schema.PropertyModifier:
        return _Pragma(self.pragma, remove=True)

    def _apply(self, pragmas: _Dict[str, object]) -> None:
        if self.remove:
            pragmas.pop(self.pragma, None)
        else:
            super()._apply(pragmas)


@_dataclass
class _ParametrizedClassPragma(_PragmaBase):
    """ A class parametrized pragma.
    Needs to be applied to a parameter to give a class pragma.
    """
    _pragma_class: _ClassVar[type] = _ClassPragma

    inherited: bool = False
    factory: _Callable[..., object] = None

    def __post_init__(self):
        self.__signature__ = _inspect.signature(self.factory).replace(return_annotation=self._pragma_class)

    def __call__(self, *args, **kwargs) -> _pragma_class:
        return self._pragma_class(self.pragma, self.inherited, value=self.factory(*args, **kwargs))


@_dataclass
class _ParametrizedPragma(_ParametrizedClassPragma):
    """ A class or property parametrized pragma.
    Needs to be applied to a parameter to give a pragma.
    """
    _pragma_class: _ClassVar[type] = _Pragma

    def __invert__(self) -> _Pragma:
        return _Pragma(self.pragma, remove=True)


class _Optionalizer(_schema.PropertyModifier):
    def modify(self, prop: _schema.Property):
        K = _schema.Property.Kind
        if prop.kind != K.SINGLE:
            raise _schema.Error(
                "optional should only be applied to simple property types")
        prop.kind = K.OPTIONAL


class _Listifier(_schema.PropertyModifier):
    def modify(self, prop: _schema.Property):
        K = _schema.Property.Kind
        if prop.kind == K.SINGLE:
            prop.kind = K.REPEATED
        elif prop.kind == K.OPTIONAL:
            prop.kind = K.REPEATED_OPTIONAL
        else:
            raise _schema.Error(
                "list should only be applied to simple or optional property types")


class _Setifier(_schema.PropertyModifier):
    def modify(self, prop: _schema.Property):
        K = _schema.Property.Kind
        if prop.kind != K.SINGLE:
            raise _schema.Error("set should only be applied to simple property types")
        prop.kind = K.REPEATED_UNORDERED


class _TypeModifier:
    """ Modifies types using get item notation """

    def __init__(self, modifier: _schema.PropertyModifier):
        self.modifier = modifier

    def __getitem__(self, item):
        return item | self.modifier


_ClassDecorator = _Callable[[type], type]


boolean = "boolean"
int = "int"
string = "string"

predicate = _schema.predicate_marker
optional = _TypeModifier(_Optionalizer())
list = _TypeModifier(_Listifier())
set = _TypeModifier(_Setifier())

child = _ChildModifier()
doc = _DocModifier
desc = _DescModifier

use_for_null = _ClassPragma("null")

qltest.add(_Pragma("skip"))
qltest.add(_ClassPragma("collapse_hierarchy"))
qltest.add(_ClassPragma("uncollapse_hierarchy"))
qltest.add(_ParametrizedClassPragma("test_with", inherited=True, factory=_schema.get_type_name))

ql.add(_ParametrizedClassPragma("default_doc_name", factory=lambda doc: doc))
ql.add(_ClassPragma("hideable", inherited=True))
ql.add(_Pragma("internal"))
ql.add(_ParametrizedPragma("name", factory=lambda name: name))

cpp.add(_Pragma("skip"))

rust.add(_Pragma("detach"))
rust.add(_Pragma("skip_doc_test"))

rust.add(_ParametrizedClassPragma("doc_test_signature", factory=lambda signature: signature))

group = _ParametrizedClassPragma("group", inherited=True, factory=lambda group: group)


synth.add(_ParametrizedClassPragma("from_class", factory=lambda ref: _schema.SynthInfo(
    from_class=_schema.get_type_name(ref))), key="synth")
synth.add(_ParametrizedClassPragma("on_arguments", factory=lambda **kwargs:
                                   _schema.SynthInfo(on_arguments={k: _schema.get_type_name(t) for k, t in kwargs.items()})), key="synth")


@_dataclass(frozen=True)
class _PropertyModifierList(_schema.PropertyModifier):
    _mods: tuple[_schema.PropertyModifier, ...]

    def __or__(self, other: _schema.PropertyModifier):
        return _PropertyModifierList(self._mods + (other,))

    def modify(self, prop: _schema.Property):
        for m in self._mods:
            m.modify(prop)


_ = _PropertyModifierList(())

drop = object()


def annotate(annotated_cls: type, add_bases: _Iterable[type] | None = None, replace_bases: _Dict[type, type] | None = None, cfg: bool = False) -> _Callable[[type], _PropertyModifierList]:
    """
    Add or modify schema annotations after a class has been defined previously.

    The name of the class used for annotation must be `_`.

    `replace_bases` can be used to replace bases on the annotated class.
    """
    def decorator(cls: type) -> _PropertyModifierList:
        if cls.__name__ != "_":
            raise _schema.Error("Annotation classes must be named _")
        if cls.__doc__ is not None:
            annotated_cls.__doc__ = cls.__doc__
        for p, v in cls.__dict__.get("_pragmas", {}).items():
            _ClassPragma(p, value=v)(annotated_cls)
        if replace_bases:
            annotated_cls.__bases__ = tuple(replace_bases.get(b, b) for b in annotated_cls.__bases__)
        if add_bases:
            annotated_cls.__bases__ += tuple(add_bases)
        annotated_cls.__cfg__ = cfg
        for a in dir(cls):
            if a.startswith(_schema.inheritable_pragma_prefix):
                setattr(annotated_cls, a, getattr(cls, a))
        for p, a in cls.__annotations__.items():
            if a is drop:
                del annotated_cls.__annotations__[p]
            elif p in annotated_cls.__annotations__:
                annotated_cls.__annotations__[p] |= a
            elif isinstance(a, (_PropertyModifierList, _PropertyModifierList)):
                raise _schema.Error(f"annotated property {p} not present in annotated class "
                                    f"{annotated_cls.__name__}")
            else:
                annotated_cls.__annotations__[p] = a
        return _
    return decorator
