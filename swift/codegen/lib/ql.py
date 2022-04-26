import pathlib
from dataclasses import dataclass, field
from typing import List, ClassVar

import inflection


@dataclass
class QlParam:
    param: str
    type: str = None
    first: bool = False


@dataclass
class QlProperty:
    singular: str
    type: str
    tablename: str
    tableparams: List[QlParam]
    plural: str = None
    params: List[QlParam] = field(default_factory=list)
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
        self.tableparams = [QlParam(x) for x in self.tableparams]
        self.tableparams[0].first = True

    @property
    def indefinite_article(self):
        if self.plural:
            return "An" if self.singular[0] in "AEIO" else "A"

    @property
    def type_is_class(self):
        return self.type[0].isupper()


@dataclass
class QlClass:
    template: ClassVar = 'ql_class'

    name: str
    bases: List[str] = field(default_factory=list)
    final: bool = False
    properties: List[QlProperty] = field(default_factory=list)
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
class QlStub:
    template: ClassVar = 'ql_stub'

    name: str
    base_import: str


@dataclass
class QlImportList:
    template: ClassVar = 'ql_imports'

    imports: List[str] = field(default_factory=list)
