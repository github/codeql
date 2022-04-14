""" schema.yml format representation """

import pathlib
import re
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Set, Dict, ClassVar

import yaml

root_class_name = "Element"


@dataclass
class Property:
    is_single: ClassVar = False
    is_optional: ClassVar = False
    is_repeated: ClassVar = False

    name: str
    type: str


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
class Class:
    name: str
    bases: Set[str] = field(default_factory=set)
    derived: Set[str] = field(default_factory=set)
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()


@dataclass
class Schema:
    classes: Dict[str, Class]
    includes: Set[str] = field(default_factory=set)


def _parse_property(name, type):
    if type.endswith("*"):
        cls = RepeatedProperty
        type = type[:-1]
    elif type.endswith("?"):
        cls = OptionalProperty
        type = type[:-1]
    else:
        cls = SingleProperty
    return cls(name, type)


class _DirSelector:
    """ Default output subdirectory selector for generated QL files, based on the `_directories` global field"""
    def __init__(self, dir_to_patterns):
        self.selector = [(re.compile(p), pathlib.Path(d)) for d, p in dir_to_patterns]
        self.selector.append((re.compile(""), pathlib.Path()))

    def get(self, name):
        return next(d for p, d in self.selector if p.search(name))


def load(file):
    """ Parse the schema from `file` """
    data = yaml.load(file, Loader=yaml.SafeLoader)
    grouper = _DirSelector(data.get("_directories", {}).items())
    ret = Schema(classes={cls: Class(cls, dir=grouper.get(cls)) for cls in data if not cls.startswith("_")},
                 includes=set(data.get("_includes", [])))
    assert root_class_name not in ret.classes
    ret.classes[root_class_name] = Class(root_class_name)
    for name, info in data.items():
        if name.startswith("_"):
            continue
        assert name[0].isupper()
        cls = ret.classes[name]
        for k, v in info.items():
            if not k.startswith("_"):
                cls.properties.append(_parse_property(k, v))
            elif k == "_extends":
                if not isinstance(v, list):
                    v = [v]
                for base in v:
                    cls.bases.add(base)
                    ret.classes[base].derived.add(name)
            elif k == "_dir":
                cls.dir = pathlib.Path(v)
        if not cls.bases:
            cls.bases.add(root_class_name)
            ret.classes[root_class_name].derived.add(name)

    return ret
