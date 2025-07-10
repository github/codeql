import sys
from copy import deepcopy

import pytest

from misc.codegen.lib import cpp


@pytest.mark.parametrize("keyword", cpp.cpp_keywords)
def test_field_keyword_name(keyword):
    f = cpp.Field(keyword, "int")
    assert f.field_name == keyword + "_"


def test_field_name():
    f = cpp.Field("foo", "int")
    assert f.field_name == "foo"


@pytest.mark.parametrize("type,expected", [
    ("std::string", "trapQuoted(value)"),
    ("bool", '(value ? "true" : "false")'),
    ("something_else", "value"),
])
def test_field_get_streamer(type, expected):
    f = cpp.Field("name", type)
    assert f.get_streamer()("value") == expected


@pytest.mark.parametrize("is_optional,is_repeated,is_predicate,expected", [
    (False, False, False, True),
    (True, False, False, False),
    (False, True, False, False),
    (True, True, False, False),
    (False, False, True, False),
])
def test_field_is_single(is_optional, is_repeated, is_predicate, expected):
    f = cpp.Field("name", "type", is_optional=is_optional, is_repeated=is_repeated, is_predicate=is_predicate)
    assert f.is_single is expected


@pytest.mark.parametrize("is_optional,is_repeated,expected", [
    (False, False, "bar"),
    (True, False, "std::optional<bar>"),
    (False, True, "std::vector<bar>"),
    (True, True, "std::vector<std::optional<bar>>"),
])
def test_field_modal_types(is_optional, is_repeated, expected):
    f = cpp.Field("name", "bar", is_optional=is_optional, is_repeated=is_repeated)
    assert f.type == expected


def test_trap_has_first_field_marked():
    fields = [
        cpp.Field("a", "x"),
        cpp.Field("b", "y"),
        cpp.Field("c", "z"),
    ]
    expected = deepcopy(fields)
    expected[0].first = True
    t = cpp.Trap("table_name", "name", fields)
    assert t.fields == expected


def test_tag_has_first_base_marked():
    bases = ["a", "b", "c"]
    expected = [cpp.TagBase("a", first=True), cpp.TagBase("b"), cpp.TagBase("c")]
    t = cpp.Tag("name", bases, "id")
    assert t.bases == expected


@pytest.mark.parametrize("bases,expected", [
    ([], False),
    (["a"], True),
    (["a", "b"], True)
])
def test_tag_has_bases(bases, expected):
    t = cpp.Tag("name", bases, "id")
    assert t.has_bases is expected


def test_class_has_first_base_marked():
    bases = [
        cpp.Class("a"),
        cpp.Class("b"),
        cpp.Class("c"),
    ]
    expected = [cpp.ClassBase(c) for c in bases]
    expected[0].first = True
    c = cpp.Class("foo", bases=bases)
    assert c.bases == expected


@pytest.mark.parametrize("bases,expected", [
    ([], False),
    (["a"], True),
    (["a", "b"], True)
])
def test_class_has_bases(bases, expected):
    t = cpp.Class("name", [cpp.Class(b) for b in bases])
    assert t.has_bases is expected


def test_class_single_fields():
    fields = [
        cpp.Field("a", "A"),
        cpp.Field("b", "B", is_optional=True),
        cpp.Field("c", "C"),
        cpp.Field("d", "D", is_repeated=True),
        cpp.Field("e", "E"),
    ]
    c = cpp.Class("foo", fields=fields)
    assert c.single_fields == fields[::2]


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
