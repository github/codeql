import sys

from misc.codegen.generators import trapgen
from misc.codegen.lib import cpp, dbscheme
from misc.codegen.test.utils import *

output_dir = pathlib.Path("path", "to", "output")


@pytest.fixture
def generate_grouped(opts, renderer, dbscheme_input):
    opts.cpp_output = output_dir

    def ret(entities):
        dbscheme_input.entities = entities
        generated = run_generation(trapgen.generate, opts, renderer)
        dirs = {f.parent for f in generated}
        assert all(isinstance(f, pathlib.Path) for f in generated)
        assert all(f.name in ("TrapEntries", "TrapTags") for f in generated)
        assert set(f for f in generated if f.name == "TrapTags") == {output_dir / "TrapTags"}
        return ({
            str(d.relative_to(output_dir)): generated[d / "TrapEntries"] for d in dirs
        }, generated[output_dir / "TrapTags"])

    return ret


@pytest.fixture
def generate_grouped_traps(generate_grouped):
    def ret(entities):
        generated, _ = generate_grouped(entities)
        assert all(isinstance(g, cpp.TrapList) for g in generated.values())
        return {d: traps.traps for d, traps in generated.items()}

    return ret


@pytest.fixture
def generate_traps(generate_grouped_traps):
    def ret(entities):
        generated = generate_grouped_traps(entities)
        assert set(generated) == {"."}
        return generated["."]

    return ret


@pytest.fixture
def generate_tags(generate_grouped):
    def ret(entities):
        _, tags = generate_grouped(entities)
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


def test_tables_with_dir(generate_grouped_traps):
    assert generate_grouped_traps([
        dbscheme.Table(name="x", columns=[dbscheme.Column("i", "int")]),
        dbscheme.Table(name="y", columns=[dbscheme.Column("i", "int")], dir=pathlib.Path("foo")),
        dbscheme.Table(name="z", columns=[dbscheme.Column("i", "int")], dir=pathlib.Path("foo/bar")),
    ]) == {
        ".": [cpp.Trap("x", name="X", fields=[cpp.Field("i", "int")])],
        "foo": [cpp.Trap("y", name="Y", fields=[cpp.Field("i", "int")])],
        "foo/bar": [cpp.Trap("z", name="Z", fields=[cpp.Field("i", "int")])],
    }


def test_one_table_no_tags(generate_tags):
    assert generate_tags([
        dbscheme.Table(name="foos", columns=[dbscheme.Column("bla", "int")]),
    ]) == []


def test_one_union_tags(generate_tags):
    assert generate_tags([
        dbscheme.Union(lhs="@left_hand_side", rhs=["@b", "@a", "@c"]),
    ]) == [
        cpp.Tag(name="LeftHandSide", bases=[], id="@left_hand_side"),
        cpp.Tag(name="A", bases=["LeftHandSide"], id="@a"),
        cpp.Tag(name="B", bases=["LeftHandSide"], id="@b"),
        cpp.Tag(name="C", bases=["LeftHandSide"], id="@c"),
    ]


def test_multiple_union_tags(generate_tags):
    assert generate_tags([
        dbscheme.Union(lhs="@d", rhs=["@a"]),
        dbscheme.Union(lhs="@a", rhs=["@b", "@c"]),
        dbscheme.Union(lhs="@e", rhs=["@c", "@f"]),
    ]) == [
        cpp.Tag(name="D", bases=[], id="@d"),
        cpp.Tag(name="E", bases=[], id="@e"),
        cpp.Tag(name="A", bases=["D"], id="@a"),
        cpp.Tag(name="F", bases=["E"], id="@f"),
        cpp.Tag(name="B", bases=["A"], id="@b"),
        cpp.Tag(name="C", bases=["A", "E"], id="@c"),
    ]


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
