import pathlib
import subprocess
import sys

import pytest

from swift.codegen.generators import qlgen
from swift.codegen.lib import ql
from swift.codegen.test.utils import *


@pytest.fixture(autouse=True)
def run_mock():
    with mock.patch("subprocess.run") as ret:
        ret.return_value.returncode = 0
        yield ret


# these are lambdas so that they will use patched paths when called
def stub_path(): return paths.swift_dir / "ql/lib/stub/path"


def ql_output_path(): return paths.swift_dir / "ql/lib/other/path"


def ql_test_output_path(): return paths.swift_dir / "ql/test/path"


def import_file(): return stub_path().with_suffix(".qll")


def children_file(): return ql_output_path() / "GetImmediateParent.qll"


stub_import_prefix = "stub.path."
root_import = stub_import_prefix + "Element"
gen_import_prefix = "other.path."


@pytest.fixture
def qlgen_opts(opts):
    opts.ql_stub_output = stub_path()
    opts.ql_output = ql_output_path()
    opts.ql_test_output = ql_test_output_path()
    opts.ql_format = True
    opts.swift_dir = paths.swift_dir
    return opts


@pytest.fixture
def generate(input, qlgen_opts, renderer):
    renderer.written = []

    def func(classes):
        input.classes = {cls.name: cls for cls in classes}
        return run_generation(qlgen.generate, qlgen_opts, renderer)

    return func


@pytest.fixture
def generate_import_list(generate):
    def func(classes):
        ret = generate(classes)
        assert import_file() in ret
        return ret[import_file()]

    return func


@pytest.fixture
def generate_children_implementations(generate):
    def func(classes):
        ret = generate(classes)
        assert children_file() in ret
        return ret[children_file()]

    return func


def _filter_generated_classes(ret, output_test_files=False):
    files = {x for x in ret}
    files.remove(import_file())
    files.remove(children_file())
    stub_files = set()
    base_files = set()
    test_files = set()
    for f in files:
        try:
            stub_files.add(f.relative_to(stub_path()))
        except ValueError:
            try:
                base_files.add(f.relative_to(ql_output_path()))
            except ValueError:
                try:
                    test_files.add(f.relative_to(ql_test_output_path()))
                except ValueError:
                    assert False, f"{f} is in wrong directory"
    if output_test_files:
        return {
            str(f): ret[ql_test_output_path() / f]
            for f in test_files
        }
    base_files -= {pathlib.Path(f"{name}.qll") for name in
                   ("Raw", "Synth", "SynthConstructors", "PureSynthConstructors")}
    assert base_files <= stub_files
    return {
        str(f): (ret[stub_path() / f], ret[ql_output_path() / f])
        for f in base_files
    }


@pytest.fixture
def generate_classes(generate):
    def func(classes):
        return _filter_generated_classes(generate(classes))

    return func


@pytest.fixture
def generate_tests(generate):
    def func(classes):
        return _filter_generated_classes(generate(classes), output_test_files=True)

    return func


def test_empty(generate):
    assert generate([]) == {
        import_file(): ql.ImportList(),
        children_file(): ql.GetParentImplementation(),
        ql_output_path() / "Synth.qll": ql.Synth.Types(schema.root_class_name),
        ql_output_path() / "SynthConstructors.qll": ql.ImportList(),
        ql_output_path() / "PureSynthConstructors.qll": ql.ImportList(),
        ql_output_path() / "Raw.qll": ql.DbClasses(),
        ql_output_path() / "Raw.qll": ql.DbClasses(),
    }


def test_one_empty_class(generate_classes):
    assert generate_classes([
        schema.Class("A")
    ]) == {
        "A.qll": (ql.Stub(name="A", base_import=gen_import_prefix + "A"),
                  ql.Class(name="A", final=True)),
    }


def test_hierarchy(generate_classes):
    assert generate_classes([
        schema.Class("D", bases={"B", "C"}),
        schema.Class("C", bases={"A"}, derived={"D"}),
        schema.Class("B", bases={"A"}, derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]) == {
        "A.qll": (ql.Stub(name="A", base_import=gen_import_prefix + "A"),
                  ql.Class(name="A")),
        "B.qll": (ql.Stub(name="B", base_import=gen_import_prefix + "B"),
                  ql.Class(name="B", bases=["A"], imports=[stub_import_prefix + "A"])),
        "C.qll": (ql.Stub(name="C", base_import=gen_import_prefix + "C"),
                  ql.Class(name="C", bases=["A"], imports=[stub_import_prefix + "A"])),
        "D.qll": (ql.Stub(name="D", base_import=gen_import_prefix + "D"),
                  ql.Class(name="D", final=True, bases=["B", "C"],
                           imports=[stub_import_prefix + cls for cls in "BC"])),
    }


def test_hierarchy_imports(generate_import_list):
    assert generate_import_list([
        schema.Class("D", bases={"B", "C"}),
        schema.Class("C", bases={"A"}, derived={"D"}),
        schema.Class("B", bases={"A"}, derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]) == ql.ImportList([stub_import_prefix + cls for cls in "ABCD"])


def test_hierarchy_children(generate_children_implementations):
    assert generate_children_implementations([
        schema.Class("D", bases={"B", "C"}),
        schema.Class("C", bases={"A"}, derived={"D"}),
        schema.Class("B", bases={"A"}, derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]) == ql.GetParentImplementation(
        classes=[ql.Class(name="A"),
                 ql.Class(name="B", bases=["A"], imports=[
                     stub_import_prefix + "A"]),
                 ql.Class(name="C", bases=["A"], imports=[
                     stub_import_prefix + "A"]),
                 ql.Class(name="D", final=True, bases=["B", "C"],
                          imports=[stub_import_prefix + cls for cls in "BC"]),
                 ],
    )


def test_single_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar")]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True,
                                  properties=[
                                      ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                  tableparams=["this", "result"]),
                                  ])),
    }


def test_single_properties(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.SingleProperty("three", "z"),
        ]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True,
                                  properties=[
                                      ql.Property(singular="One", type="x", tablename="my_objects",
                                                  tableparams=["this", "result", "_", "_"]),
                                      ql.Property(singular="Two", type="y", tablename="my_objects",
                                                  tableparams=["this", "_", "result", "_"]),
                                      ql.Property(singular="Three", type="z", tablename="my_objects",
                                                  tableparams=["this", "_", "_", "result"]),
                                  ])),
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_optional_property(generate_classes, is_child):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.OptionalProperty("foo", "bar", is_child=is_child)]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True, properties=[
                             ql.Property(singular="Foo", type="bar", tablename="my_object_foos",
                                         tableparams=["this", "result"],
                                         is_optional=True, is_child=is_child),
                         ])),
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_repeated_property(generate_classes, is_child):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.RepeatedProperty("foo", "bar", is_child=is_child)]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True, properties=[
                             ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                                         tableparams=["this", "index", "result"], is_child=is_child),
                         ])),
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_repeated_optional_property(generate_classes, is_child):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.RepeatedOptionalProperty("foo", "bar", is_child=is_child)]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True, properties=[
                             ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                                         tableparams=["this", "index", "result"], is_optional=True,
                                         is_child=is_child),
                         ])),
    }


def test_predicate_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.PredicateProperty("is_foo")]),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(name="MyObject", final=True, properties=[
                             ql.Property(singular="isFoo", type="predicate", tablename="my_object_is_foo",
                                         tableparams=["this"],
                                         is_predicate=True),
                         ])),
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_single_class_property(generate_classes, is_child):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "Bar", is_child=is_child)]),
        schema.Class("Bar"),
    ]) == {
        "MyObject.qll": (ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
                         ql.Class(
            name="MyObject", final=True, imports=[stub_import_prefix + "Bar"], properties=[
                ql.Property(singular="Foo", type="Bar", tablename="my_objects",
                            tableparams=[
                                "this", "result"],
                            is_child=is_child),
            ],
        )),
        "Bar.qll": (ql.Stub(name="Bar", base_import=gen_import_prefix + "Bar"),
                    ql.Class(name="Bar", final=True)),
    }


def test_class_dir(generate_classes):
    dir = pathlib.Path("another/rel/path")
    assert generate_classes([
        schema.Class("A", derived={"B"}, dir=dir),
        schema.Class("B", bases={"A"}),
    ]) == {
        f"{dir}/A.qll": (ql.Stub(name="A", base_import=gen_import_prefix + "another.rel.path.A"),
                         ql.Class(name="A", dir=dir)),
        "B.qll": (ql.Stub(name="B", base_import=gen_import_prefix + "B"),
                  ql.Class(name="B", final=True, bases=["A"],
                           imports=[stub_import_prefix + "another.rel.path.A"])),
    }


def test_class_dir_imports(generate_import_list):
    dir = pathlib.Path("another/rel/path")
    assert generate_import_list([
        schema.Class("A", derived={"B"}, dir=dir),
        schema.Class("B", bases={"A"}),
    ]) == ql.ImportList([
        stub_import_prefix + "B",
        stub_import_prefix + "another.rel.path.A",
    ])


def test_format(opts, generate, renderer, run_mock):
    opts.codeql_binary = "my_fake_codeql"
    run_mock.return_value.stderr = "some\nlines\n"
    renderer.written = [
        pathlib.Path("x", "foo.ql"),
        pathlib.Path("bar.qll"),
        pathlib.Path("y", "baz.txt"),
    ]
    generate([])
    assert run_mock.mock_calls == [
        mock.call(["my_fake_codeql", "query", "format", "--in-place", "--", "x/foo.ql", "bar.qll"],
                  stderr=subprocess.PIPE, text=True),
    ]


def test_format_error(opts, generate, renderer, run_mock):
    opts.codeql_binary = "my_fake_codeql"
    run_mock.return_value.stderr = "some\nlines\n"
    run_mock.return_value.returncode = 1
    renderer.written = [
        pathlib.Path("x", "foo.ql"),
        pathlib.Path("bar.qll"),
        pathlib.Path("y", "baz.txt"),
    ]
    with pytest.raises(qlgen.FormatError):
        generate([])


def test_empty_cleanup(generate, renderer):
    generate([])
    assert renderer.mock_calls[-1] == mock.call.cleanup(set())


def test_non_empty_cleanup(opts, generate, renderer):
    ql_a = opts.ql_output / "A.qll"
    ql_b = opts.ql_output / "B.qll"
    stub_a = opts.ql_stub_output / "A.qll"
    stub_b = opts.ql_stub_output / "B.qll"
    test_a = opts.ql_test_output / "A.ql"
    test_b = opts.ql_test_output / "MISSING_SOURCE.txt"
    test_c = opts.ql_test_output / "B.txt"
    write(ql_a)
    write(ql_b)
    write(stub_a, "// generated\nprivate import bla\n\nclass foo extends bar {\n}\n")
    write(stub_b, "bar\n")
    write(test_a)
    write(test_b)
    write(test_c)
    generate([])
    assert renderer.mock_calls[-1] == mock.call.cleanup(
        {ql_a, ql_b, stub_a, test_a, test_b})


def test_modified_stub_still_generated(qlgen_opts, renderer):
    stub = qlgen_opts.ql_stub_output / "A.qll"
    write(stub, "// generated\nprivate import bla\n\nclass foo extends bar, baz {\n}\n")
    with pytest.raises(qlgen.ModifiedStubMarkedAsGeneratedError):
        run_generation(qlgen.generate, qlgen_opts, renderer)


def test_extended_stub_still_generated(qlgen_opts, renderer):
    stub = qlgen_opts.ql_stub_output / "A.qll"
    write(stub,
          "// generated\nprivate import bla\n\nclass foo extends bar {\n}\n\nclass other {\n  other() { none() }\n}")
    with pytest.raises(qlgen.ModifiedStubMarkedAsGeneratedError):
        run_generation(qlgen.generate, qlgen_opts, renderer)


def test_test_missing_source(generate_tests):
    generate_tests([
        schema.Class("A"),
    ]) == {
        "A/MISSING_SOURCE.txt": ql.MissingTestInstructions(),
    }


def test_test_source_present(opts, generate_tests):
    write(opts.ql_test_output / "A" / "test.swift")
    assert generate_tests([
        schema.Class("A"),
    ]) == {
        "A/A.ql": ql.ClassTester(class_name="A"),
    }


def test_test_source_present_with_dir(opts, generate_tests):
    write(opts.ql_test_output / "foo" / "A" / "test.swift")
    assert generate_tests([
        schema.Class("A", dir=pathlib.Path("foo")),
    ]) == {
        "foo/A/A.ql": ql.ClassTester(class_name="A"),
    }


def test_test_total_properties(opts, generate_tests):
    write(opts.ql_test_output / "B" / "test.swift")
    assert generate_tests([
        schema.Class("A", derived={"B"}, properties=[
            schema.SingleProperty("x", "string"),
        ]),
        schema.Class("B", bases={"A"}, properties=[
            schema.PredicateProperty("y", "int"),
        ]),
    ]) == {
        "B/B.ql": ql.ClassTester(class_name="B", properties=[
            ql.PropertyForTest(
                getter="getX", is_single=True, type="string"),
            ql.PropertyForTest(
                getter="y", is_predicate=True, type="predicate"),
        ])
    }


def test_test_partial_properties(opts, generate_tests):
    write(opts.ql_test_output / "B" / "test.swift")
    assert generate_tests([
        schema.Class("A", derived={"B"}, properties=[
            schema.OptionalProperty("x", "string"),
        ]),
        schema.Class("B", bases={"A"}, properties=[
            schema.RepeatedProperty("y", "int"),
        ]),
    ]) == {
        "B/B.ql": ql.ClassTester(class_name="B"),
        "B/B_getX.ql": ql.PropertyTester(class_name="B",
                                         property=ql.PropertyForTest(getter="getX", type="string")),
        "B/B_getY.ql": ql.PropertyTester(class_name="B",
                                         property=ql.PropertyForTest(getter="getY", is_repeated=True,
                                                                            type="int")),
    }


def test_test_properties_deduplicated(opts, generate_tests):
    write(opts.ql_test_output / "Final" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"A", "B"}, properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "int"),
        ]),
        schema.Class("A", bases={"Base"}, derived={"Final"}),
        schema.Class("B", bases={"Base"}, derived={"Final"}),
        schema.Class("Final", bases={"A", "B"}),
    ]) == {
        "Final/Final.ql": ql.ClassTester(class_name="Final", properties=[
            ql.PropertyForTest(
                getter="getX", is_single=True, type="string"),
        ]),
        "Final/Final_getY.ql": ql.PropertyTester(class_name="Final",
                                                 property=ql.PropertyForTest(getter="getY", is_repeated=True,
                                                                                    type="int")),
    }


def test_test_properties_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}, properties=[
            schema.SingleProperty("x", "string", pragmas=["qltest_skip", "foo"]),
            schema.RepeatedProperty("y", "int", pragmas=["bar", "qltest_skip"]),
        ]),
        schema.Class("Derived", bases={"Base"}, properties=[
            schema.PredicateProperty("a", pragmas=["qltest_skip"]),
            schema.OptionalProperty(
                "b", "int", pragmas=["bar", "qltest_skip", "baz"]),
        ]),
    ]) == {
        "Derived/Derived.ql": ql.ClassTester(class_name="Derived"),
    }


def test_test_base_class_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}, pragmas=["qltest_skip", "foo"], properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "int"),
        ]),
        schema.Class("Derived", bases={"Base"}),
    ]) == {
        "Derived/Derived.ql": ql.ClassTester(class_name="Derived"),
    }


def test_test_final_class_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}),
        schema.Class("Derived", bases={"Base"}, pragmas=["qltest_skip", "foo"], properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "int"),
        ]),
    ]) == {}


def test_test_class_hierarchy_collapse(opts, generate_tests):
    write(opts.ql_test_output / "Base" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases={"Base"}, properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases={"Base"}, derived={"D3"}, properties=[schema.SingleProperty("y", "string")]),
        schema.Class("D3", bases={"D2"}, properties=[schema.SingleProperty("z", "string")]),
    ]) == {
        "Base/Base.ql": ql.ClassTester(class_name="Base"),
    }


def test_test_class_hierarchy_uncollapse(opts, generate_tests):
    for d in ("Base", "D3", "D4"):
        write(opts.ql_test_output / d / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases={"Base"}, properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases={"Base"}, derived={"D3", "D4"}, pragmas=["qltest_uncollapse_hierarchy", "bar"]),
        schema.Class("D3", bases={"D2"}),
        schema.Class("D4", bases={"D2"}),
    ]) == {
        "Base/Base.ql": ql.ClassTester(class_name="Base"),
        "D3/D3.ql": ql.ClassTester(class_name="D3"),
        "D4/D4.ql": ql.ClassTester(class_name="D4"),
    }


def test_test_class_hierarchy_uncollapse_at_final(opts, generate_tests):
    for d in ("Base", "D3"):
        write(opts.ql_test_output / d / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases={"Base"}, properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases={"Base"}, derived={"D3"}),
        schema.Class("D3", bases={"D2"}, pragmas=["qltest_uncollapse_hierarchy", "bar"]),
    ]) == {
        "Base/Base.ql": ql.ClassTester(class_name="Base"),
        "D3/D3.ql": ql.ClassTester(class_name="D3"),
    }


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
