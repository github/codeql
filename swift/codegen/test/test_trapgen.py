import sys

from swift.codegen.generators import trapgen
from swift.codegen.lib import cpp, dbscheme
from swift.codegen.test.utils import *

output_dir = pathlib.Path("path", "to", "output")


@pytest.fixture
def generate(opts, renderer, dbscheme_input):
    opts.cpp_output = output_dir

    def ret(entities):
        dbscheme_input.entities = entities
        generated = run_generation(trapgen.generate, opts, renderer)
        assert set(generated) == {output_dir /
                                  "TrapEntries.h", output_dir / "TrapTags.h"}
        return generated[output_dir / "TrapEntries.h"], generated[output_dir / "TrapTags.h"]

    return ret


@pytest.fixture
def generate_traps(opts, generate):
    def ret(entities):
        traps, _ = generate(entities)
        assert isinstance(traps, cpp.TrapList)
        return traps.traps

    return ret


@pytest.fixture
def generate_tags(opts, generate):
    def ret(entities):
        _, tags = generate(entities)
        assert isinstance(tags, cpp.TagList)
        return tags.tags

    return ret


def test_empty_traps(generate_traps):
    assert generate_traps([]) == []


def test_empty_tags(generate_tags):
    assert generate_tags([]) == []


def test_one_empty_table_rejected(generate_traps):
    with pytest.raises(AssertionError):
        generate_traps([
            dbscheme.Table(name="foos", columns=[]),
        ])


def test_one_table(generate_traps):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[dbscheme.Column("bla", "int")]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[cpp.Field("bla", "int")]),
    ]


def test_one_table(generate_traps):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[dbscheme.Column("bla", "int")]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[cpp.Field("bla", "int")]),
    ]


def test_one_table_with_id(generate_traps):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[
            dbscheme.Column("bla", "int", binding=True)]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[cpp.Field(
            "bla", "int")], id=cpp.Field("bla", "int")),
    ]


def test_one_table_with_two_binding_first_is_id(generate_traps):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[
            dbscheme.Column("x", "a", binding=True),
            dbscheme.Column("y", "b", binding=True),
        ]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[
            cpp.Field("x", "a"),
            cpp.Field("y", "b"),
        ], id=cpp.Field("x", "a")),
    ]


@pytest.mark.parametrize("column,field", [
    (dbscheme.Column("x", "string"), cpp.Field("x", "std::string")),
    (dbscheme.Column("y", "boolean"), cpp.Field("y", "bool")),
    (dbscheme.Column("z", "@db_type"), cpp.Field("z", "TrapLabel<DbTypeTag>")),
])
def test_one_table_special_types(generate_traps, column, field):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[column]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[field]),
    ]


@pytest.mark.parametrize("name", ["start_line", "start_column", "end_line", "end_column", "index", "num_whatever"])
def test_one_table_overridden_unsigned_field(generate_traps, name):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[dbscheme.Column(name, "bar")]),
    ]) == [
        cpp.Trap("foos", name="Foos", fields=[cpp.Field(name, "unsigned")]),
    ]


def test_one_table_overridden_underscore_named_field(generate_traps):
    assert generate_traps([
        dbscheme.Table(name="foos", columns=[dbscheme.Column("whatever_", "bar")]),
    ]) == [
               cpp.Trap("foos", name="Foos", fields=[cpp.Field("whatever", "bar")]),
           ]

def test_one_table_no_tags(generate_tags):
    assert generate_tags([
        dbscheme.Table(name="foos", columns=[dbscheme.Column("bla", "int")]),
    ]) == []


def test_one_union_tags(generate_tags):
    assert generate_tags([
        dbscheme.Union(lhs="@left_hand_side", rhs=["@b", "@a", "@c"]),
    ]) == [
        cpp.Tag(name="LeftHandSide", bases=[], index=0, id="@left_hand_side"),
        cpp.Tag(name="A", bases=["LeftHandSide"], index=1, id="@a"),
        cpp.Tag(name="B", bases=["LeftHandSide"], index=2, id="@b"),
        cpp.Tag(name="C", bases=["LeftHandSide"], index=3, id="@c"),
    ]


def test_multiple_union_tags(generate_tags):
    assert generate_tags([
        dbscheme.Union(lhs="@d", rhs=["@a"]),
        dbscheme.Union(lhs="@a", rhs=["@b", "@c"]),
        dbscheme.Union(lhs="@e", rhs=["@c", "@f"]),
    ]) == [
        cpp.Tag(name="D", bases=[], index=0, id="@d"),
        cpp.Tag(name="E", bases=[], index=1, id="@e"),
        cpp.Tag(name="A", bases=["D"], index=2, id="@a"),
        cpp.Tag(name="F", bases=["E"], index=3, id="@f"),
        cpp.Tag(name="B", bases=["A"], index=4, id="@b"),
        cpp.Tag(name="C", bases=["A", "E"], index=5, id="@c"),
    ]


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
