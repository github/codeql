import subprocess
import sys

from swift.codegen.generators import qlgen
from swift.codegen.lib import ql
from swift.codegen.test.utils import *


@pytest.fixture(autouse=True)
def run_mock():
    with mock.patch("subprocess.run") as ret:
        yield ret


# these are lambdas so that they will use patched paths when called
stub_path = lambda: paths.swift_dir / "ql/lib/stub/path"
ql_output_path = lambda: paths.swift_dir / "ql/lib/other/path"
import_file = lambda: stub_path().with_suffix(".qll")
stub_import_prefix = "stub.path."
gen_import_prefix = "other.path."


def generate(opts, renderer, written=None):
    opts.ql_stub_output = stub_path()
    opts.ql_output = ql_output_path()
    opts.ql_format = True
    renderer.written = written or []
    return run_generation(qlgen.generate, opts, renderer)


def test_empty(opts, input, renderer):
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList()
    }


def test_one_empty_class(opts, input, renderer):
    input.classes = [
        schema.Class("A")
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "A"]),
        stub_path() / "A.qll": ql.Stub(name="A", base_import=gen_import_prefix + "A"),
        ql_output_path() / "A.qll": ql.Class(name="A", final=True),
    }


def test_hierarchy(opts, input, renderer):
    input.classes = [
        schema.Class("D", bases={"B", "C"}),
        schema.Class("C", bases={"A"}, derived={"D"}),
        schema.Class("B", bases={"A"}, derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + cls for cls in "ABCD"]),
        stub_path() / "A.qll": ql.Stub(name="A", base_import=gen_import_prefix + "A"),
        stub_path() / "B.qll": ql.Stub(name="B", base_import=gen_import_prefix + "B"),
        stub_path() / "C.qll": ql.Stub(name="C", base_import=gen_import_prefix + "C"),
        stub_path() / "D.qll": ql.Stub(name="D", base_import=gen_import_prefix + "D"),
        ql_output_path() / "A.qll": ql.Class(name="A"),
        ql_output_path() / "B.qll": ql.Class(name="B", bases=["A"], imports=[stub_import_prefix + "A"]),
        ql_output_path() / "C.qll": ql.Class(name="C", bases=["A"], imports=[stub_import_prefix + "A"]),
        ql_output_path() / "D.qll": ql.Class(name="D", final=True, bases=["B", "C"],
                                             imports=[stub_import_prefix + cls for cls in "BC"]),

    }


def test_single_property(opts, input, renderer):
    input.classes = [
        schema.Class("MyObject", properties=[schema.SingleProperty("foo", "bar")]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="Foo", type="bar", tablename="my_objects", tableparams=["this", "result"]),
        ])
    }


def test_single_properties(opts, input, renderer):
    input.classes = [
        schema.Class("MyObject", properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.SingleProperty("three", "z"),
        ]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="One", type="x", tablename="my_objects", tableparams=["this", "result", "_", "_"]),
            ql.Property(singular="Two", type="y", tablename="my_objects", tableparams=["this", "_", "result", "_"]),
            ql.Property(singular="Three", type="z", tablename="my_objects", tableparams=["this", "_", "_", "result"]),
        ])
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_optional_property(opts, input, renderer, is_child):
    input.classes = [
        schema.Class("MyObject", properties=[schema.OptionalProperty("foo", "bar", is_child=is_child)]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="Foo", type="bar", tablename="my_object_foos", tableparams=["this", "result"],
                        is_optional=True, is_child=is_child),
        ])
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_repeated_property(opts, input, renderer, is_child):
    input.classes = [
        schema.Class("MyObject", properties=[schema.RepeatedProperty("foo", "bar", is_child=is_child)]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                        tableparams=["this", "index", "result"], is_child=is_child),
        ])
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_repeated_optional_property(opts, input, renderer, is_child):
    input.classes = [
        schema.Class("MyObject", properties=[schema.RepeatedOptionalProperty("foo", "bar", is_child=is_child)]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                        tableparams=["this", "index", "result"], is_optional=True, is_child=is_child),
        ])
    }


def test_predicate_property(opts, input, renderer):
    input.classes = [
        schema.Class("MyObject", properties=[schema.PredicateProperty("is_foo")]),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + "MyObject"]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        ql_output_path() / "MyObject.qll": ql.Class(name="MyObject", final=True, properties=[
            ql.Property(singular="isFoo", type="predicate", tablename="my_object_is_foo", tableparams=["this"],
                        is_predicate=True),
        ])
    }


@pytest.mark.parametrize("is_child", [False, True])
def test_single_class_property(opts, input, renderer, is_child):
    input.classes = [
        schema.Class("MyObject", properties=[schema.SingleProperty("foo", "Bar", is_child=is_child)]),
        schema.Class("Bar"),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([stub_import_prefix + cls for cls in ("Bar", "MyObject")]),
        stub_path() / "MyObject.qll": ql.Stub(name="MyObject", base_import=gen_import_prefix + "MyObject"),
        stub_path() / "Bar.qll": ql.Stub(name="Bar", base_import=gen_import_prefix + "Bar"),
        ql_output_path() / "MyObject.qll": ql.Class(
            name="MyObject", final=True, imports=[stub_import_prefix + "Bar"], properties=[
                ql.Property(singular="Foo", type="Bar", tablename="my_objects", tableparams=["this", "result"],
                            is_child=is_child),
            ],
        ),
        ql_output_path() / "Bar.qll": ql.Class(name="Bar", final=True)
    }


def test_class_dir(opts, input, renderer):
    dir = pathlib.Path("another/rel/path")
    input.classes = [
        schema.Class("A", derived={"B"}, dir=dir),
        schema.Class("B", bases={"A"}),
    ]
    assert generate(opts, renderer) == {
        import_file(): ql.ImportList([
            stub_import_prefix + "another.rel.path.A",
            stub_import_prefix + "B",
        ]),
        stub_path() / dir / "A.qll": ql.Stub(name="A", base_import=gen_import_prefix + "another.rel.path.A"),
        stub_path() / "B.qll": ql.Stub(name="B", base_import=gen_import_prefix + "B"),
        ql_output_path() / dir / "A.qll": ql.Class(name="A", dir=dir),
        ql_output_path() / "B.qll": ql.Class(name="B", final=True, bases=["A"],
                                             imports=[stub_import_prefix + "another.rel.path.A"])
    }


def test_format(opts, input, renderer, run_mock):
    opts.codeql_binary = "my_fake_codeql"
    run_mock.return_value.stderr = "some\nlines\n"
    generate(opts, renderer, written=["foo", "bar"])
    assert run_mock.mock_calls == [
        mock.call(["my_fake_codeql", "query", "format", "--in-place", "--", "foo", "bar"],
                  check=True, stderr=subprocess.PIPE, text=True),
    ]


def test_empty_cleanup(opts, input, renderer):
    generate(opts, renderer)
    assert renderer.mock_calls[-1] == mock.call.cleanup(set())


def test_empty_cleanup(opts, input, renderer, tmp_path):
    opts.ql_output = tmp_path / "gen"
    opts.ql_stub_output = tmp_path / "stub"
    renderer.written = []
    ql_a = opts.ql_output / "A.qll"
    ql_b = opts.ql_output / "B.qll"
    stub_a = opts.ql_stub_output / "A.qll"
    stub_b = opts.ql_stub_output / "B.qll"
    write(ql_a)
    write(ql_b)
    write(stub_a, "// generated\nfoo\n")
    write(stub_b, "bar\n")
    run_generation(qlgen.generate, opts, renderer)
    assert renderer.mock_calls[-1] == mock.call.cleanup({ql_a, ql_b, stub_a})


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
