""" schema.yml format representation """

import pathlib
import re
from dataclasses import dataclass, field
from typing import List, Set, Union, Dict, ClassVar, Optional

import yaml


class Error(Exception):

    def __str__(self):
        return self.args[0]


root_class_name = "Element"


@dataclass
class Property:
    is_single: ClassVar = False
    is_optional: ClassVar = False
    is_repeated: ClassVar = False
    is_predicate: ClassVar = False

    name: str
    type: str = None
    is_child: bool = False
    pragmas: List[str] = field(default_factory=list)


@dataclass
class SingleProperty(Property):
    is_single: ClassVar = True


@dataclass
class OptionalProperty(Property):
    is_optional: ClassVar = True


@dataclass
class RepeatedProperty(Property):
    is_repeated: ClassVar = True


@dataclass
class RepeatedOptionalProperty(Property):
    is_optional: ClassVar = True
    is_repeated: ClassVar = True


@dataclass
class PredicateProperty(Property):
    is_predicate: ClassVar = True


@dataclass
class IpaInfo:
    from_class: Optional[str] = None
    on_arguments: Optional[Dict[str, str]] = None


@dataclass
class Class:
    name: str
    bases: Set[str] = field(default_factory=set)
    derived: Set[str] = field(default_factory=set)
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()
    pragmas: List[str] = field(default_factory=list)
    ipa: Optional[IpaInfo] = None

    @property
    def final(self):
        return not self.derived


@dataclass
class Schema:
    classes: Dict[str, Class]
    includes: Set[str] = field(default_factory=set)


_StrOrList = Union[str, List[str]]


def _auto_list(data: _StrOrList) -> List[str]:
    if isinstance(data, list):
        return data
    return [data]


def _parse_property(name: str, data: Union[str, Dict[str, _StrOrList]], is_child: bool = False):
    if isinstance(data, dict):
        if "type" not in data:
            raise Error(f"property {name} has no type")
        pragmas = _auto_list(data.pop("_pragma", []))
        type = data.pop("type")
        if data:
            raise Error(f"unknown metadata {', '.join(data)} in property {name}")
    else:
        pragmas = []
        type = data
    if is_child and type[0].islower():
        raise Error(f"children must have class type, got {type} for {name}")
    if type.endswith("?*"):
        return RepeatedOptionalProperty(name, type[:-2], is_child=is_child, pragmas=pragmas)
    elif type.endswith("*"):
        return RepeatedProperty(name, type[:-1], is_child=is_child, pragmas=pragmas)
    elif type.endswith("?"):
        return OptionalProperty(name, type[:-1], is_child=is_child, pragmas=pragmas)
    elif type == "predicate":
        return PredicateProperty(name, pragmas=pragmas)
    else:
        return SingleProperty(name, type, is_child=is_child, pragmas=pragmas)


def _parse_ipa(data: Dict[str, Union[str, Dict[str, str]]]):
    return IpaInfo(from_class=data.get("from"),
                   on_arguments=data.get(True))  # 'on' is parsed as boolean True in yaml


class _DirSelector:
    """ Default output subdirectory selector for generated QL files, based on the `_directories` global field"""

    def __init__(self, dir_to_patterns):
        self.selector = [(re.compile(p), pathlib.Path(d)) for d, p in dir_to_patterns]
        self.selector.append((re.compile(""), pathlib.Path()))

    def get(self, name):
        return next(d for p, d in self.selector if p.search(name))


def load(path):
    """ Parse the schema from the file at `path` """
    with open(path) as input:
        data = yaml.load(input, Loader=yaml.SafeLoader)
    grouper = _DirSelector(data.get("_directories", {}).items())
    classes = {root_class_name: Class(root_class_name)}
    classes.update((cls, Class(cls, dir=grouper.get(cls))) for cls in data if not cls.startswith("_"))
    for name, info in data.items():
        if name.startswith("_"):
            continue
        if not name[0].isupper():
            raise Error(f"keys in the schema file must be capitalized class names or metadata, got {name}")
        cls = classes[name]
        for k, v in info.items():
            if not k.startswith("_"):
                cls.properties.append(_parse_property(k, v))
            elif k == "_extends":
                v = _auto_list(v)
                for base in v:
                    cls.bases.add(base)
                    classes[base].derived.add(name)
            elif k == "_dir":
                cls.dir = pathlib.Path(v)
            elif k == "_children":
                cls.properties.extend(_parse_property(kk, vv, is_child=True) for kk, vv in v.items())
            elif k == "_pragma":
                cls.pragmas = _auto_list(v)
            elif k == "_synth":
                cls.ipa = _parse_ipa(v)
            else:
                raise Error(f"unknown metadata {k} for class {name}")
        if not cls.bases and cls.name != root_class_name:
            cls.bases.add(root_class_name)
            classes[root_class_name].derived.add(name)

    return Schema(classes=classes, includes=set(data.get("_includes", [])))
