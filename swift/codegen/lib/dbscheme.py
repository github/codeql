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


class Re:
    entity = re.compile(
        "(?m)"
        r"(?:^#keyset\[(?P<tablekeys>[\w\s,]+)\][\s\n]*)?^(?P<table>\w+)\("
        r"(?:\s*//dir=(?P<tabledir>\S*))?(?P<tablebody>[^\)]*)"
        r"\);?"
        "|"
        r"^(?P<union>@\w+)\s*=\s*(?P<unionbody>@\w+(?:\s*\|\s*@\w+)*)\s*;?"
    )
    field = re.compile(r"(?m)[\w\s]*\s(?P<field>\w+)\s*:\s*(?P<type>@?\w+)(?P<ref>\s+ref)?")
    key = re.compile(r"@\w+")
    comment = re.compile(r"(?m)(?s)/\*.*?\*/|//(?!dir=)[^\n]*$")  # lookahead avoid ignoring metadata like //dir=foo


def get_column(match):
    return Column(
        schema_name=match["field"].rstrip("_"),
        type=match["type"],
        binding=not match["ref"],
    )


def get_table(match):
    keyset = None
    if match["tablekeys"]:
        keyset = KeySet(k.strip() for k in match["tablekeys"].split(","))
    return Table(
        name=match["table"],
        columns=[get_column(f) for f in Re.field.finditer(match["tablebody"])],
        keyset=keyset,
        dir=pathlib.PosixPath(match["tabledir"]) if match["tabledir"] else None,
    )


def get_union(match):
    return Union(
        lhs=match["union"],
        rhs=(d[0] for d in Re.key.finditer(match["unionbody"])),
    )


def iterload(file):
    with open(file) as file:
        data = Re.comment.sub("", file.read())
    for e in Re.entity.finditer(data):
        if e["table"]:
            yield get_table(e)
        elif e["union"]:
            yield get_union(e)
