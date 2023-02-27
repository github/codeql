import sys
from copy import deepcopy

from misc.codegen.lib import dbscheme
from misc.codegen.test.utils import *


def test_dbcolumn_name():
    assert dbscheme.Column("foo", "some_type").name == "foo"


@pytest.mark.parametrize("keyword", dbscheme.dbscheme_keywords)
def test_dbcolumn_keyword_name(keyword):
    assert dbscheme.Column(keyword, "some_type").name == keyword + "_"


@pytest.mark.parametrize("type,binding,lhstype,rhstype", [
    ("builtin_type", False, "builtin_type", "builtin_type ref"),
    ("builtin_type", True, "builtin_type", "builtin_type ref"),
    ("@at_type", False, "int", "@at_type ref"),
    ("@at_type", True, "unique int", "@at_type"),
])
def test_dbcolumn_types(type, binding, lhstype, rhstype):
    col = dbscheme.Column("foo", type, binding)
    assert col.lhstype == lhstype
    assert col.rhstype == rhstype


def test_keyset_has_first_id_marked():
    ids = ["a", "b", "c"]
    ks = dbscheme.KeySet(ids)
    assert ks.ids[0].first
    assert [id.id for id in ks.ids] == ids


def test_table_has_first_column_marked():
    columns = [dbscheme.Column("a", "x"), dbscheme.Column("b", "y", binding=True), dbscheme.Column("c", "z")]
    expected = deepcopy(columns)
    table = dbscheme.Table("foo", columns)
    expected[0].first = True
    assert table.columns == expected


def test_union_has_first_case_marked():
    rhs = ["a", "b", "c"]
    u = dbscheme.Union(lhs="x", rhs=rhs)
    assert u.rhs[0].first
    assert [c.type for c in u.rhs] == rhs


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
