from typing import Callable as _Callable, Union as _Union
from functools import singledispatch as _singledispatch
from swift.codegen.lib import schema as _schema
import inspect as _inspect


class _ChildModifier(_schema.PropertyModifier):
    def modify(self, prop: _schema.Property):
        if prop.type is None or prop.type[0].islower():
            raise _schema.Error("Non-class properties cannot be children")
        prop.is_child = True


def include(source: str):
    # add to `includes` variable in calling context
    _inspect.currentframe().f_back.f_locals.setdefault(
        "__includes", []).append(source)


class _Pragma(_schema.PropertyModifier):
    """ A class or property pragma.
    For properties, it functions similarly to a `_PropertyModifier` with `|`, adding the pragma.
    For schema classes it acts as a python decorator with `@`.
    """

    def __init__(self, pragma):
        self.pragma = pragma

    def modify(self, prop: _schema.Property):
        prop.pragmas.append(self.pragma)

    def __call__(self, cls: type) -> type:
        """ use this pragma as a decorator on classes """
        if "pragmas" in cls.__dict__:  # not using hasattr as we don't want to land on inherited pragmas
            cls.pragmas.append(self.pragma)
        else:
            cls.pragmas = [self.pragma]
        return cls


class _Optionalizer(_schema.PropertyModifier):
    def modify(self, prop: _schema.Property):
        K = _schema.Property.Kind
        if prop.kind != K.SINGLE:
            raise _schema.Error(
                "Optional should only be applied to simple property types")
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
                "Repeated should only be applied to simple or optional property types")


class _TypeModifier:
    """ Modifies types using get item notation """

    def __init__(self, modifier: _schema.PropertyModifier):
        self.modifier = modifier

    def __getitem__(self, item):
        return item | self.modifier


class _Namespace:
    """ simple namespacing mechanism """

    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)


_ClassDecorator = _Callable[[type], type]


def _annotate(**kwargs) -> _ClassDecorator:
    def f(cls: type) -> type:
        for k, v in kwargs.items():
            setattr(cls, k, v)
        return cls

    return f


boolean = "boolean"
int = "int"
string = "string"

predicate = _schema.predicate_marker
optional = _TypeModifier(_Optionalizer())
list = _TypeModifier(_Listifier())

child = _ChildModifier()

qltest = _Namespace(
    skip=_Pragma("qltest_skip"),
    collapse_hierarchy=_Pragma("qltest_collapse_hierarchy"),
    uncollapse_hierarchy=_Pragma("qltest_uncollapse_hierarchy"),
)

cpp = _Namespace(
    skip=_Pragma("cpp_skip"),
)


def group(name: str = "") -> _ClassDecorator:
    return _annotate(group=name)


synth = _Namespace(
    from_class=lambda ref: _annotate(ipa=_schema.IpaInfo(
        from_class=_schema.get_type_name(ref))),
    on_arguments=lambda **kwargs: _annotate(
        ipa=_schema.IpaInfo(on_arguments={k: _schema.get_type_name(t) for k, t in kwargs.items()}))
)
