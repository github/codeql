import sys
from copy import deepcopy

from swift.codegen.lib import dbscheme
from swift.codegen.test.utils import *


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


# load tests
@pytest.fixture
def load(tmp_path):
    file = tmp_path / "test.dbscheme"

    def ret(yml):
        write(file, yml)
        return list(dbscheme.iterload(file))

    return ret


def test_load_empty(load):
    assert load("") == []


def test_load_one_empty_table(load):
    assert load("""
test_foos();
""") == [
        dbscheme.Table(name="test_foos", columns=[])
    ]


def test_load_table_with_keyset(load):
    assert load("""
#keyset[x,  y,z]
test_foos();
""") == [
        dbscheme.Table(name="test_foos", columns=[], keyset=dbscheme.KeySet(["x", "y", "z"]))
    ]


expected_columns = [
    ("int foo: int ref", dbscheme.Column(schema_name="foo", type="int", binding=False)),
    ("  int     bar :   int   ref", dbscheme.Column(schema_name="bar", type="int", binding=False)),
    ("str baz_: str ref", dbscheme.Column(schema_name="baz", type="str", binding=False)),
    ("int x: @foo ref", dbscheme.Column(schema_name="x", type="@foo", binding=False)),
    ("int y: @foo", dbscheme.Column(schema_name="y", type="@foo", binding=True)),
    ("unique int z: @foo", dbscheme.Column(schema_name="z", type="@foo", binding=True)),
]


@pytest.mark.parametrize("column,expected", expected_columns)
def test_load_table_with_column(load, column, expected):
    assert load(f"""
foos(
  {column}
);
""") == [
        dbscheme.Table(name="foos", columns=[deepcopy(expected)])
    ]


def test_load_table_with_multiple_columns(load):
    columns = ",\n".join(c for c, _ in expected_columns)
    expected = [deepcopy(e) for _, e in expected_columns]
    assert load(f"""
foos(
{columns}
);
""") == [
        dbscheme.Table(name="foos", columns=expected)
    ]


def test_load_table_with_multiple_columns_and_dir(load):
    columns = ",\n".join(c for c, _ in expected_columns)
    expected = [deepcopy(e) for _, e in expected_columns]
    assert load(f"""
foos(     //dir=foo/bar/baz
{columns}
);
""") == [
        dbscheme.Table(name="foos", columns=expected, dir=pathlib.Path("foo/bar/baz"))
    ]


def test_load_multiple_table_with_columns(load):
    tables = [f"table{i}({col});" for i, (col, _) in enumerate(expected_columns)]
    expected = [dbscheme.Table(name=f"table{i}", columns=[deepcopy(e)]) for i, (_, e) in enumerate(expected_columns)]
    assert load("\n".join(tables)) == expected


def test_union(load):
    assert load("@foo = @bar | @baz | @bla;") == [
        dbscheme.Union(lhs="@foo", rhs=["@bar", "@baz", "@bla"]),
    ]


def test_table_and_union(load):
    assert load("""
foos();
    
@foo = @bar | @baz | @bla;""") == [
        dbscheme.Table(name="foos", columns=[]),
        dbscheme.Union(lhs="@foo", rhs=["@bar", "@baz", "@bla"]),
    ]


def test_comments_ignored(load):
    assert load("""
// fake_table();
foos(/* x */unique /*y*/int/*
z
*/ id/* */: /* * */ @bar/*,
int ignored: int ref*/);
    
@foo = @bar | @baz | @bla; // | @xxx""") == [
        dbscheme.Table(name="foos", columns=[dbscheme.Column(schema_name="id", type="@bar", binding=True)]),
        dbscheme.Union(lhs="@foo", rhs=["@bar", "@baz", "@bla"]),
    ]


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
