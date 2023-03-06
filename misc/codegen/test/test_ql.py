import sys
from copy import deepcopy

from misc.codegen.lib import ql
from misc.codegen.test.utils import *


def test_property_has_first_table_param_marked():
    tableparams = ["a", "b", "c"]
    prop = ql.Property("Prop", "foo", "props", tableparams)
    assert prop.tableparams[0].first
    assert [p.param for p in prop.tableparams] == tableparams


@pytest.mark.parametrize("type,expected", [
    ("Foo", True),
    ("Bar", True),
    ("foo", False),
    ("bar", False),
    (None, False),
])
def test_property_is_a_class(type, expected):
    tableparams = ["a", "result", "b"]
    expected_tableparams = ["a", "result" if expected else "result", "b"]
    prop = ql.Property("Prop", type, tableparams=tableparams)
    assert prop.type_is_class is expected
    assert [p.param for p in prop.tableparams] == expected_tableparams


@pytest.mark.parametrize("name,expected_getter", [
    ("Argument", "getAnArgument"),
    ("Element", "getAnElement"),
    ("Integer", "getAnInteger"),
    ("Operator", "getAnOperator"),
    ("Unit", "getAUnit"),
    ("Whatever", "getAWhatever"),
])
def test_property_indefinite_article(name, expected_getter):
    prop = ql.Property(name, plural="X")
    assert prop.indefinite_getter == expected_getter


@pytest.mark.parametrize("plural,expected", [
    (None, False),
    ("", False),
    ("X", True),
])
def test_property_is_repeated(plural, expected):
    prop = ql.Property("foo", "Foo", "props", ["result"], plural=plural)
    assert prop.is_repeated is expected


@pytest.mark.parametrize("is_optional,is_predicate,plural,expected", [
    (False, False, None, True),
    (False, False, "", True),
    (False, False, "X", False),
    (True, False, None, False),
    (False, True, None, False),
])
def test_property_is_single(is_optional, is_predicate, plural, expected):
    prop = ql.Property("foo", "Foo", "props", ["result"], plural=plural,
                       is_predicate=is_predicate, is_optional=is_optional)
    assert prop.is_single is expected


def test_property_no_plural_no_indefinite_getter():
    prop = ql.Property("Prop", "Foo", "props", ["result"])
    assert prop.indefinite_getter is None


def test_property_getter():
    prop = ql.Property("Prop", "Foo")
    assert prop.getter == "getProp"


def test_property_predicate_getter():
    prop = ql.Property("prop", is_predicate=True)
    assert prop.getter == "prop"


def test_class_processes_bases():
    bases = ["B", "Ab", "C", "Aa"]
    expected = [ql.Base("B"), ql.Base("Ab", prev="B"), ql.Base("C", prev="Ab"), ql.Base("Aa", prev="C")]
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


def test_root_class():
    cls = ql.Class("Class")
    assert cls.root


def test_non_root_class():
    cls = ql.Class("Class", bases=["A"])
    assert not cls.root


@pytest.mark.parametrize("prev_child,is_child", [(None, False), ("", True), ("x", True)])
def test_is_child(prev_child, is_child):
    p = ql.Property("Foo", "int", prev_child=prev_child)
    assert p.is_child is is_child


def test_empty_class_no_children():
    cls = ql.Class("Class", properties=[])
    assert cls.has_children is False


def test_class_no_children():
    cls = ql.Class("Class", properties=[ql.Property("Foo", "int"), ql.Property("Bar", "string")])
    assert cls.has_children is False


def test_class_with_children():
    cls = ql.Class("Class", properties=[ql.Property("Foo", "int"), ql.Property("Child", "x", prev_child=""),
                                        ql.Property("Bar", "string")])
    assert cls.has_children is True


@pytest.mark.parametrize("doc,ql_internal,expected",
                         [
                             (["foo", "bar"], False, True),
                             (["foo", "bar"], True, True),
                             ([], False, False),
                             ([], True, True),
                         ])
def test_has_doc(doc, ql_internal, expected):
    cls = ql.Class("Class", doc=doc, ql_internal=ql_internal)
    assert cls.has_doc is expected


def test_property_with_description():
    prop = ql.Property("X", "int", description=["foo", "bar"])
    assert prop.has_description is True


def test_class_without_description():
    prop = ql.Property("X", "int")
    assert prop.has_description is False


def test_ipa_accessor_has_first_constructor_param_marked():
    params = ["a", "b", "c"]
    x = ql.IpaUnderlyingAccessor("foo", "bar", params)
    assert x.constructorparams[0].first
    assert [p.param for p in x.constructorparams] == params


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
