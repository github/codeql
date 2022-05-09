import sys
from copy import deepcopy

import pytest

from swift.codegen.lib import cpp


@pytest.mark.parametrize("keyword", cpp.cpp_keywords)
def test_field_keyword_cpp_name(keyword):
    f = cpp.Field(keyword, "int")
    assert f.cpp_name == keyword + "_"


def test_field_cpp_name():
    f = cpp.Field("foo", "int")
    assert f.cpp_name == "foo"


@pytest.mark.parametrize("type,expected", [
    ("std::string", "trapQuoted(value)"),
    ("bool", '(value ? "true" : "false")'),
    ("something_else", "value"),
])
def test_field_get_streamer(type, expected):
    f = cpp.Field("name", type)
    assert f.get_streamer()("value") == expected


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
    t = cpp.Tag("name", bases, 0, "id")
    assert t.bases == expected


@pytest.mark.parametrize("bases,expected", [
    ([], False),
    (["a"], True),
    (["a", "b"], True)
])
def test_tag_has_bases(bases, expected):
    t = cpp.Tag("name", bases, 0, "id")
    assert t.has_bases is expected


if __name__ == '__main__':
    sys.exit(pytest.main())
