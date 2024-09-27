import sys

from misc.codegen.generators import cppgen
from misc.codegen.lib import cpp
from misc.codegen.test.utils import *

output_dir = pathlib.Path("path", "to", "output")


@pytest.fixture
def generate_grouped(opts, renderer, input):
    opts.cpp_output = output_dir

    def ret(classes):
        input.classes = {cls.name: cls for cls in classes}
        generated = run_generation(cppgen.generate, opts, renderer)
        for f, g in generated.items():
            assert isinstance(g, cpp.ClassList), f
            assert g.include_parent is (f.parent != output_dir)
            assert f.name == "TrapClasses", f
        return {str(f.parent.relative_to(output_dir)): g.classes for f, g in generated.items()}

    return ret


@pytest.fixture
def generate(generate_grouped):
    def ret(classes):
        generated = generate_grouped(classes)
        assert set(generated) == {"."}
        return generated["."]

    return ret


def test_empty(generate):
    assert generate([]) == []


def test_empty_class(generate):
    assert generate([
        schema.Class(name="MyClass"),
    ]) == [
        cpp.Class(name="MyClass", final=True, trap_name="MyClasses")
    ]


def test_two_class_hierarchy(generate):
    base = cpp.Class(name="A")
    assert generate([
        schema.Class(name="A", derived={"B"}),
        schema.Class(name="B", bases=["A"]),
    ]) == [
        base,
        cpp.Class(name="B", bases=[base], final=True, trap_name="Bs"),
    ]


@pytest.mark.parametrize("type,expected", [
    ("a", "a"),
    ("string", "std::string"),
    ("boolean", "bool"),
    ("MyClass", "TrapLabel<MyClassTag>"),
])
@pytest.mark.parametrize("property_cls,optional,repeated,unordered,trap_name", [
    (schema.SingleProperty, False, False, False, None),
    (schema.OptionalProperty, True, False, False, "MyClassProps"),
    (schema.RepeatedProperty, False, True, False, "MyClassProps"),
    (schema.RepeatedOptionalProperty, True, True, False, "MyClassProps"),
    (schema.RepeatedUnorderedProperty, False, True, True, "MyClassProps"),
])
def test_class_with_field(generate, type, expected, property_cls, optional, repeated, unordered, trap_name):
    assert generate([
        schema.Class(name="MyClass", properties=[property_cls("prop", type)]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[cpp.Field("prop", expected, is_optional=optional,
                                    is_repeated=repeated, is_unordered=unordered, trap_name=trap_name)],
                  trap_name="MyClasses",
                  final=True)
    ]


def test_class_field_with_null(generate, input):
    input.null = "Null"
    a = cpp.Class(name="A")
    assert generate([
        schema.Class(name="A", derived={"B"}),
        schema.Class(name="B", bases=["A"], properties=[
            schema.SingleProperty("x", "A"),
            schema.SingleProperty("y", "B"),
        ])
    ]) == [
        a,
        cpp.Class(name="B", bases=[a], final=True, trap_name="Bs",
                  fields=[
            cpp.Field("x", "TrapLabel<ATag>"),
            cpp.Field("y", "TrapLabel<BOrNoneTag>"),
        ]),
    ]


def test_class_with_predicate(generate):
    assert generate([
        schema.Class(name="MyClass", properties=[
            schema.PredicateProperty("prop")]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[
                      cpp.Field("prop", "bool", trap_name="MyClassProp", is_predicate=True)],
                  trap_name="MyClasses",
                  final=True)
    ]


@pytest.mark.parametrize("name",
                         ["start_line", "start_column", "end_line", "end_column", "index", "num_whatever", "width"])
def test_class_with_overridden_unsigned_field(generate, name):
    assert generate([
        schema.Class(name="MyClass", properties=[
            schema.SingleProperty(name, "bar")]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[cpp.Field(name, "unsigned")],
                  trap_name="MyClasses",
                  final=True)
    ]


def test_class_with_overridden_underscore_field(generate):
    assert generate([
        schema.Class(name="MyClass", properties=[
            schema.SingleProperty("something_", "bar")]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[cpp.Field("something", "bar")],
                  trap_name="MyClasses",
                  final=True)
    ]


@pytest.mark.parametrize("name", cpp.cpp_keywords)
def test_class_with_keyword_field(generate, name):
    assert generate([
        schema.Class(name="MyClass", properties=[
            schema.SingleProperty(name, "bar")]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[cpp.Field(name + "_", "bar")],
                  trap_name="MyClasses",
                  final=True)
    ]


def test_classes_with_dirs(generate_grouped):
    cbase = cpp.Class(name="CBase")
    assert generate_grouped([
        schema.Class(name="A"),
        schema.Class(name="B", pragmas={"group": "foo"}),
        schema.Class(name="CBase", derived={"C"}, pragmas={"group": "bar"}),
        schema.Class(name="C", bases=["CBase"], pragmas={"group": "bar"}),
        schema.Class(name="D", pragmas={"group": "foo/bar/baz"}),
    ]) == {
        ".": [cpp.Class(name="A", trap_name="As", final=True)],
        "foo": [cpp.Class(name="B", trap_name="Bs", final=True)],
        "bar": [cbase, cpp.Class(name="C", bases=[cbase], trap_name="Cs", final=True)],
        "foo/bar/baz": [cpp.Class(name="D", trap_name="Ds", final=True)],
    }


def test_cpp_skip_pragma(generate):
    assert generate([
        schema.Class(name="A", properties=[
            schema.SingleProperty("x", "foo"),
            schema.SingleProperty("y", "bar", pragmas=["x", "cpp_skip", "y"]),
        ])
    ]) == [
        cpp.Class(name="A", final=True, trap_name="As", fields=[
            cpp.Field("x", "foo"),
        ]),
    ]


def test_synth_classes_ignored(generate):
    assert generate([
        schema.Class(
            name="W",
            pragmas={"synth": schema.SynthInfo()},
        ),
        schema.Class(
            name="X",
            pragmas={"synth": schema.SynthInfo(from_class="A")},
        ),
        schema.Class(
            name="Y",
            pragmas={"synth": schema.SynthInfo(on_arguments={"a": "A", "b": "int"})},
        ),
        schema.Class(
            name="Z",
        ),
    ]) == [
        cpp.Class(name="Z", final=True, trap_name="Zs"),
    ]


def test_synth_properties_ignored(generate):
    assert generate([
        schema.Class(
            name="X",
            properties=[
                schema.SingleProperty("x", "a"),
                schema.SingleProperty("y", "b", synth=True),
                schema.SingleProperty("z", "c"),
                schema.OptionalProperty("foo", "bar", synth=True),
                schema.RepeatedProperty("baz", "bazz", synth=True),
                schema.RepeatedOptionalProperty("bazzz", "bazzzz", synth=True),
                schema.RepeatedUnorderedProperty("bazzzzz", "bazzzzzz", synth=True),
            ],
        ),
    ]) == [
        cpp.Class(name="X", final=True, trap_name="Xes", fields=[
            cpp.Field("x", "a"),
            cpp.Field("z", "c"),
        ]),
    ]


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
