import pathlib
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Set, Dict
import re

import yaml


class Cardinality(Enum):
    ONE = auto()
    OPTIONAL = auto()
    MANY = auto()


@dataclass
class Field:
    name: str
    type: str
    cardinality: Cardinality = Cardinality.ONE

    def is_single(self):
        return self.cardinality == Cardinality.ONE

    def is_optional(self):
        return self.cardinality == Cardinality.OPTIONAL

    def is_repeated(self):
        return self.cardinality == Cardinality.MANY


@dataclass
class Class:
    name: str
    bases: Set[str] = field(default_factory=set)
    derived: Set[str] = field(default_factory=set)
    fields: List[Field] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()


@dataclass
class Schema:
    classes: Dict[str, Class]
    includes: Set[str] = field(default_factory=set)


def _parse_field(name, type):
    if type.endswith("*"):
        cardinality = Cardinality.MANY
        type = type[:-1]
    elif type.endswith("?"):
        cardinality = Cardinality.OPTIONAL
        type = type[:-1]
    else:
        cardinality = Cardinality.ONE
    return Field(name, type, cardinality)


root_class_name = "Element"


class DirSelector:
    def __init__(self, dir_to_patterns):
        self.selector = [(re.compile(p), pathlib.Path(d)) for d, p in dir_to_patterns]
        self.selector.append((re.compile(""), pathlib.Path()))

    def get(self, name):
        return next(d for p, d in self.selector if p.search(name))


def load(file):
    data = yaml.load(file, Loader=yaml.SafeLoader)
    grouper = DirSelector(data.get("_directories", {}).items())
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
                cls.fields.append(_parse_field(k, v))
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
