import sys

from swift.codegen.generators import cppgen
from swift.codegen.lib import cpp
from swift.codegen.test.utils import *

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
        schema.Class(name="B", bases={"A"}),
    ]) == [
        base,
        cpp.Class(name="B", bases=[base], final=True, trap_name="Bs"),
    ]


def test_complex_hierarchy_topologically_ordered(generate):
    a = cpp.Class(name="A")
    b = cpp.Class(name="B")
    c = cpp.Class(name="C", bases=[a])
    d = cpp.Class(name="D", bases=[a])
    e = cpp.Class(name="E", bases=[b, c, d], final=True, trap_name="Es")
    f = cpp.Class(name="F", bases=[c], final=True, trap_name="Fs")
    assert generate([
        schema.Class(name="F", bases={"C"}),
        schema.Class(name="B", derived={"E"}),
        schema.Class(name="D", bases={"A"}, derived={"E"}),
        schema.Class(name="C", bases={"A"}, derived={"E", "F"}),
        schema.Class(name="E", bases={"B", "C", "D"}),
        schema.Class(name="A", derived={"C", "D"}),
    ]) == [a, b, c, d, e, f]


@pytest.mark.parametrize("type,expected", [
    ("a", "a"),
    ("string", "std::string"),
    ("boolean", "bool"),
    ("MyClass", "TrapLabel<MyClassTag>"),
])
@pytest.mark.parametrize("property_cls,optional,repeated,trap_name", [
    (schema.SingleProperty, False, False, None),
    (schema.OptionalProperty, True, False, "MyClassProps"),
    (schema.RepeatedProperty, False, True, "MyClassProps"),
    (schema.RepeatedOptionalProperty, True, True, "MyClassProps"),
])
def test_class_with_field(generate, type, expected, property_cls, optional, repeated, trap_name):
    assert generate([
        schema.Class(name="MyClass", properties=[property_cls("prop", type)]),
    ]) == [
        cpp.Class(name="MyClass",
                  fields=[cpp.Field("prop", expected, is_optional=optional,
                                    is_repeated=repeated, trap_name=trap_name)],
                  trap_name="MyClasses",
                  final=True)
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
        schema.Class(name="B", dir=pathlib.Path("foo")),
        schema.Class(name="C", bases={"CBase"}, dir=pathlib.Path("bar")),
        schema.Class(name="CBase", derived={"C"}, dir=pathlib.Path("bar")),
        schema.Class(name="D", dir=pathlib.Path("foo/bar/baz")),
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


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
