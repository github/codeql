from typing import Callable as _Callable, Dict as _Dict
from misc.codegen.lib import schema as _schema
import inspect as _inspect
from dataclasses import dataclass as _dataclass

from misc.codegen.lib.schema import Property


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


class _Namespace:
    """ simple namespacing mechanism """

    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)


@_dataclass
class _SynthModifier(_schema.PropertyModifier, _Namespace):
    synth: bool = True

    def modify(self, prop: _schema.Property):
        prop.synth = self.synth

    def negate(self) -> "PropertyModifier":
        return _SynthModifier(False)


qltest = _Namespace()
ql = _Namespace()
cpp = _Namespace()
rust = _Namespace()
synth = _SynthModifier()


@_dataclass
class _Pragma(_schema.PropertyModifier):
    """ A class or property pragma.
    For properties, it functions similarly to a `_PropertyModifier` with `|`, adding the pragma.
    For schema classes it acts as a python decorator with `@`.
    """
    pragma: str
    value: object = None
    remove: bool = False

    def __post_init__(self):
        namespace, _, name = self.pragma.partition('_')
        setattr(globals()[namespace], name, self)

    def modify(self, prop: _schema.Property):
        self._apply(prop.pragmas)

    def negate(self) -> "PropertyModifier":
        return _Pragma(self.pragma, remove=True)

    def __call__(self, cls: type) -> type:
        """ use this pragma as a decorator on classes """
        # not using hasattr as we don't want to land on inherited pragmas
        if "_pragmas" not in cls.__dict__:
            cls._pragmas = {}
        self._apply(cls._pragmas)
        return cls

    def _apply(self, pragmas: _Dict[str, object]) -> None:
        if self.remove:
            pragmas.pop(self.pragma, None)
        else:
            pragmas[self.pragma] = self.value


@_dataclass
class _ParametrizedPragma:
    """ A class or property parametrized pragma.
    Needs to be applied to a parameter to give a pragma.
    """
    pragma: str
    function: _Callable[[...], object] = None

    def __call__(self, *args, **kwargs) -> _Pragma:
        return _Pragma(self.pragma, value=self.function(*args, **kwargs))

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


def _annotate(**kwargs) -> _ClassDecorator:
    def f(cls: type) -> type:
        for k, v in kwargs.items():
            setattr(cls, f"_{k}", v)
        return cls

    return f


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

use_for_null = _annotate(null=True)

_Pragma("qltest_skip")
_Pragma("qltest_collapse_hierarchy")
_Pragma("qltest_uncollapse_hierarchy")
qltest.test_with = lambda cls: _annotate(test_with=cls)

ql.default_doc_name = lambda doc: _annotate(doc_name=doc)
ql.hideable = _annotate(hideable=True)
_Pragma("ql_internal")

_Pragma("cpp_skip")

_Pragma("rust_skip_doc_test")

rust.doc_test_signature = lambda signature: _annotate(rust_doc_test_function=signature)


def group(name: str = "") -> _ClassDecorator:
    return _annotate(group=name)


synth.from_class = lambda ref: _annotate(synth=_schema.SynthInfo(
    from_class=_schema.get_type_name(ref)))
synth.on_arguments = lambda **kwargs: _annotate(
    synth=_schema.SynthInfo(on_arguments={k: _schema.get_type_name(t) for k, t in kwargs.items()}))


class _PropertyModifierList(_schema.PropertyModifier):
    def __init__(self):
        self._mods = []

    def __or__(self, other: _schema.PropertyModifier):
        self._mods.append(other)
        return self

    def modify(self, prop: Property):
        for m in self._mods:
            m.modify(prop)


class _PropertyAnnotation:
    def __or__(self, other: _schema.PropertyModifier):
        return _PropertyModifierList() | other


_ = _PropertyAnnotation()


def annotate(annotated_cls: type) -> _Callable[[type], _PropertyAnnotation]:
    """
    Add or modify schema annotations after a class has been defined
    For the moment, only docstring annotation is supported. In the future, any kind of
    modification will be allowed.

    The name of the class used for annotation must be `_`
    """
    def decorator(cls: type) -> _PropertyAnnotation:
        if cls.__name__ != "_":
            raise _schema.Error("Annotation classes must be named _")
        if cls.__doc__ is not None:
            annotated_cls.__doc__ = cls.__doc__
        old_pragmas = getattr(annotated_cls, "_pragmas", None)
        new_pragmas = getattr(cls, "_pragmas", {})
        if old_pragmas:
            old_pragmas.update(new_pragmas)
        else:
            annotated_cls._pragmas = new_pragmas
        for a, v in cls.__dict__.items():
            # transfer annotations
            if a.startswith("_") and not a.startswith("__") and a != "_pragmas":
                setattr(annotated_cls, a, v)
        for p, a in cls.__annotations__.items():
            if p in annotated_cls.__annotations__:
                annotated_cls.__annotations__[p] |= a
            elif isinstance(a, (_PropertyAnnotation, _PropertyModifierList)):
                raise _schema.Error(f"annotated property {p} not present in annotated class "
                                    f"{annotated_cls.__name__}")
            else:
                annotated_cls.__annotations__[p] = a
        return _
    return decorator
