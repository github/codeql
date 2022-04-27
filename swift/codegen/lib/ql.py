import pathlib
from dataclasses import dataclass, field
from typing import List, ClassVar

import inflection


@dataclass
class Param:
    param: str
    type: str = None
    first: bool = False


@dataclass
class Property:
    singular: str
    type: str
    tablename: str
    tableparams: List[Param]
    plural: str = None
    params: List[Param] = field(default_factory=list)
    first: bool = False
    local_var: str = "x"

    def __post_init__(self):
        if self.params:
            self.params[0].first = True
        while self.local_var in (p.param for p in self.params):
            self.local_var += "_"
        assert self.tableparams
        if self.type_is_class:
            self.tableparams = [x if x != "result" else self.local_var for x in self.tableparams]
        self.tableparams = [Param(x) for x in self.tableparams]
        self.tableparams[0].first = True

    @property
    def indefinite_article(self):
        if self.plural:
            return "An" if self.singular[0] in "AEIO" else "A"

    @property
    def type_is_class(self):
        return self.type[0].isupper()


@dataclass
class Class:
    template: ClassVar = 'ql_class'

    name: str
    bases: List[str] = field(default_factory=list)
    final: bool = False
    properties: List[Property] = field(default_factory=list)
    dir: pathlib.Path = pathlib.Path()
    imports: List[str] = field(default_factory=list)

    def __post_init__(self):
        self.bases = sorted(self.bases)
        if self.properties:
            self.properties[0].first = True

    @property
    def db_id(self):
        return "@" + inflection.underscore(self.name)

    @property
    def root(self):
        return not self.bases

    @property
    def path(self):
        return self.dir / self.name


@dataclass
class Stub:
    template: ClassVar = 'ql_stub'

    name: str
    base_import: str


@dataclass
class ImportList:
    template: ClassVar = 'ql_imports'

    imports: List[str] = field(default_factory=list)
