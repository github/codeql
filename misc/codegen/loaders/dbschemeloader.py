import pathlib
import re
from misc.codegen.lib import dbscheme


class _Re:
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


def _get_column(match):
    return dbscheme.Column(
        schema_name=match["field"].rstrip("_"),
        type=match["type"],
        binding=not match["ref"],
    )


def _get_table(match):
    keyset = None
    if match["tablekeys"]:
        keyset = dbscheme.KeySet(k.strip() for k in match["tablekeys"].split(","))
    return dbscheme.Table(
        name=match["table"],
        columns=[_get_column(f) for f in _Re.field.finditer(match["tablebody"])],
        keyset=keyset,
        dir=pathlib.PurePosixPath(match["tabledir"]) if match["tabledir"] else None,
    )


def _get_union(match):
    return dbscheme.Union(
        lhs=match["union"],
        rhs=(d[0] for d in _Re.key.finditer(match["unionbody"])),
    )


def iterload(file):
    with open(file) as file:
        data = _Re.comment.sub("", file.read())
    for e in _Re.entity.finditer(data):
        if e["table"]:
            yield _get_table(e)
        elif e["union"]:
            yield _get_union(e)
