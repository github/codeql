""" dbscheme format representation """

import logging
from dataclasses import dataclass
from typing import ClassVar, List

log = logging.getLogger(__name__)

dbscheme_keywords = {"case", "boolean", "int", "string", "type"}


@dataclass
class DbColumn:
    schema_name: str
    type: str
    binding: bool = False
    first: bool = False

    @property
    def name(self):
        if self.schema_name in dbscheme_keywords:
            return self.schema_name + "_"
        return self.schema_name

    @property
    def lhstype(self):
        if self.type[0] == "@":
            return "unique int" if self.binding else "int"
        return self.type

    @property
    def rhstype(self):
        if self.type[0] == "@" and self.binding:
            return self.type
        return self.type + " ref"


@dataclass
class DbKeySetId:
    id: str
    first: bool = False


@dataclass
class DbKeySet:
    ids: List[DbKeySetId]

    def __post_init__(self):
        assert self.ids
        self.ids = [DbKeySetId(x) for x in self.ids]
        self.ids[0].first = True


class DbDecl:
    is_table = False
    is_union = False


@dataclass
class DbTable(DbDecl):
    is_table: ClassVar = True

    name: str
    columns: List[DbColumn]
    keyset: DbKeySet = None

    def __post_init__(self):
        if self.columns:
            self.columns[0].first = True


@dataclass
class DbUnionCase:
    type: str
    first: bool = False


@dataclass
class DbUnion(DbDecl):
    is_union: ClassVar = True

    lhs: str
    rhs: List[DbUnionCase]

    def __post_init__(self):
        assert self.rhs
        self.rhs = [DbUnionCase(x) for x in self.rhs]
        self.rhs.sort(key=lambda c: c.type)
        self.rhs[0].first = True


@dataclass
class DbSchemeInclude:
    src: str
    data: str


@dataclass
class DbScheme:
    template: ClassVar = 'dbscheme'

    src: str
    includes: List[DbSchemeInclude]
    declarations: List[DbDecl]
