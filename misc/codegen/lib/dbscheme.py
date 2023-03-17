""" dbscheme format representation """

import logging
import pathlib
import re
from dataclasses import dataclass
from typing import ClassVar, List

log = logging.getLogger(__name__)

dbscheme_keywords = {"case", "boolean", "int", "string", "type"}


@dataclass
class Column:
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
class KeySetId:
    id: str
    first: bool = False


@dataclass
class KeySet:
    ids: List[KeySetId]

    def __post_init__(self):
        assert self.ids
        self.ids = [KeySetId(x) for x in self.ids]
        self.ids[0].first = True


class Decl:
    is_table = False
    is_union = False


@dataclass
class Table(Decl):
    is_table: ClassVar = True

    name: str
    columns: List[Column]
    keyset: KeySet = None
    dir: pathlib.Path = None

    def __post_init__(self):
        if self.columns:
            self.columns[0].first = True


@dataclass
class UnionCase:
    type: str
    first: bool = False


@dataclass
class Union(Decl):
    is_union: ClassVar = True

    lhs: str
    rhs: List[UnionCase]

    def __post_init__(self):
        assert self.rhs
        self.rhs = [UnionCase(x) for x in self.rhs]
        self.rhs.sort(key=lambda c: c.type)
        self.rhs[0].first = True


@dataclass
class SchemeInclude:
    src: str
    data: str


@dataclass
class Scheme:
    template: ClassVar = 'dbscheme'

    src: str
    includes: List[SchemeInclude]
    declarations: List[Decl]
