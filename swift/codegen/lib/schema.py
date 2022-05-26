""" schema.yml format representation """

import pathlib
import re
from dataclasses import dataclass, field
from typing import List, Set, Dict, ClassVar

import yaml

root_class_name = "Element"


@dataclass
class Property:
    is_single: ClassVar = False
    is_optional: ClassVar = False
    is_repeated: ClassVar = False
    is_predicate: ClassVar = False

    name: str
    type: str = None


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
class Class:
    name: str
    bases: Set[str] = field(default_factory=set)
    derived: Set[str] = field(default_factory=set)
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()


@dataclass
class Schema:
    classes: List[Class]
    includes: Set[str] = field(default_factory=set)


def _parse_property(name, type):
    if type.endswith("?*"):
        return RepeatedOptionalProperty(name, type[:-2])
    elif type.endswith("*"):
        return RepeatedProperty(name, type[:-1])
    elif type.endswith("?"):
        return OptionalProperty(name, type[:-1])
    elif type == "predicate":
        return PredicateProperty(name)
    else:
        return SingleProperty(name, type)


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
        assert name[0].isupper()
        cls = classes[name]
        for k, v in info.items():
            if not k.startswith("_"):
                cls.properties.append(_parse_property(k, v))
            elif k == "_extends":
                if not isinstance(v, list):
                    v = [v]
                for base in v:
                    cls.bases.add(base)
                    classes[base].derived.add(name)
            elif k == "_dir":
                cls.dir = pathlib.Path(v)
        if not cls.bases and cls.name != root_class_name:
            cls.bases.add(root_class_name)
            classes[root_class_name].derived.add(name)

    return Schema(classes=list(classes.values()), includes=set(data.get("_includes", [])))
