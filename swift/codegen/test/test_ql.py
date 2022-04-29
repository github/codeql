import sys
from copy import deepcopy

from swift.codegen.lib import ql
from swift.codegen.test.utils import *


def test_property_has_first_param_marked():
    params = [ql.Param("a", "x"), ql.Param("b", "y"), ql.Param("c", "z")]
    expected = deepcopy(params)
    expected[0].first = True
    prop = ql.Property("Prop", "foo", "props", ["this"], params=params)
    assert prop.params == expected


def test_property_has_first_table_param_marked():
    tableparams = ["a", "b", "c"]
    prop = ql.Property("Prop", "foo", "props", tableparams)
    assert prop.tableparams[0].first
    assert [p.param for p in prop.tableparams] == tableparams
    assert all(p.type is None for p in prop.tableparams)


@pytest.mark.parametrize("params,expected_local_var", [
    (["a", "b", "c"], "x"),
    (["a", "x", "c"], "x_"),
    (["a", "x", "x_", "c"], "x__"),
    (["a", "x", "x_", "x__"], "x___"),
])
def test_property_local_var_avoids_params_collision(params, expected_local_var):
    prop = ql.Property("Prop", "foo", "props", ["this"], params=[ql.Param(p) for p in params])
    assert prop.local_var == expected_local_var


def test_property_not_a_class():
    tableparams = ["x", "result", "y"]
    prop = ql.Property("Prop", "foo", "props", tableparams)
    assert not prop.type_is_class
    assert [p.param for p in prop.tableparams] == tableparams


def test_property_is_a_class():
    tableparams = ["x", "result", "y"]
    prop = ql.Property("Prop", "Foo", "props", tableparams)
    assert prop.type_is_class
    assert [p.param for p in prop.tableparams] == ["x", prop.local_var, "y"]


@pytest.mark.parametrize("name,expected_article", [
    ("Argument", "An"),
    ("Element", "An"),
    ("Integer", "An"),
    ("Operator", "An"),
    ("Unit", "A"),
    ("Whatever", "A"),
])
def test_property_indefinite_article(name, expected_article):
    prop = ql.Property(name, "Foo", "props", ["x"], plural="X")
    assert prop.indefinite_article == expected_article


def test_property_no_plural_no_indefinite_article():
    prop = ql.Property("Prop", "Foo", "props", ["x"])
    assert prop.indefinite_article is None


def test_class_sorts_bases():
    bases = ["B", "Ab", "C", "Aa"]
    expected = ["Aa", "Ab", "B", "C"]
    cls = ql.Class("Foo", bases=bases)
    assert cls.bases == expected


def test_class_has_first_property_marked():
    props = [
        ql.Property(f"Prop{x}", f"Foo{x}", f"props{x}", [f"{x}"]) for x in range(4)
    ]
    expected = deepcopy(props)
    expected[0].first = True
    cls = ql.Class("Class", properties=props)
    assert cls.properties == expected


def test_class_db_id():
    cls = ql.Class("ThisIsMyClass")
    assert cls.db_id == "@this_is_my_class"


def test_root_class():
    cls = ql.Class("Class")
    assert cls.root


def test_non_root_class():
    cls = ql.Class("Class", bases=["A"])
    assert not cls.root


if __name__ == '__main__':
    sys.exit(pytest.main())
