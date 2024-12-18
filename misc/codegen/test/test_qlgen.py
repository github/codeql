import pathlib
import subprocess
import sys

import pytest

from misc.codegen.generators import qlgen
from misc.codegen.lib import ql
from misc.codegen.test.utils import *


@pytest.fixture(autouse=True)
def run_mock():
    with mock.patch("subprocess.run") as ret:
        ret.return_value.returncode = 0
        yield ret


# these are lambdas so that they will use patched paths when called
def stub_path(): return paths.root_dir / "ql/lib/stub/path"


def ql_output_path(): return paths.root_dir / "ql/lib/other/path"


def ql_test_output_path(): return paths.root_dir / "ql/test/path"


def generated_registry_path(): return paths.root_dir / "ql/registry.list"


def import_file(): return stub_path().with_suffix(".qll")


def children_file(): return ql_output_path() / "ParentChild.qll"


stub_import = "stub.path"
stub_import_prefix_internal = stub_import + ".internal."
stub_import_prefix = stub_import + "."
root_import = stub_import_prefix_internal + "Element"
gen_import = "other.path"
gen_import_prefix = gen_import + "."


@pytest.fixture
def qlgen_opts(opts):
    opts.ql_stub_output = stub_path()
    opts.ql_output = ql_output_path()
    opts.ql_test_output = ql_test_output_path()
    opts.generated_registry = generated_registry_path()
    opts.ql_format = True
    opts.root_dir = paths.root_dir
    opts.force = False
    return opts


@pytest.fixture
def generate(input, qlgen_opts, renderer, render_manager):
    render_manager.written = []

    def func(classes):
        input.classes = {cls.name: cls for cls in classes}
        return run_managed_generation(qlgen.generate, qlgen_opts, renderer, render_manager)

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
    print(files)
    files.remove(import_file())
    files.remove(children_file())
    stub_files = set()
    base_files = set()
    test_files = set()
    for f in files:
        try:
            stub_files.add(f.relative_to(stub_path()))
            print(f)
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
    stub_files = {pathlib.Path(f.parent.parent, f.stem + ".qll") if f.parent.name ==
                  "internal" and pathlib.Path(f.parent.parent, f.stem + ".qll") in base_files else f for f in stub_files}
    assert base_files <= stub_files
    return {
        str(f): (ret[stub_path() / "internal" / f] if stub_path() / "internal" / f in ret else ret[stub_path() / f],
                 ret[stub_path() / pathlib.Path(f.parent, "internal" if not f.parent.name ==
                                                "internal" else "", f.stem + "Impl.qll")],
                 ret[ql_output_path() / f])
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


def a_ql_class(**kwargs):
    return ql.Class(**kwargs, import_prefix=gen_import)


def a_ql_stub(*, name, import_prefix="", **kwargs):
    return ql.Stub(name=name, **kwargs, import_prefix=gen_import,
                   base_import=f"{gen_import_prefix}{import_prefix}{name}")


def a_ql_class_public(*, name, **kwargs):
    return ql.ClassPublic(name=name, **kwargs)


def test_one_empty_class(generate_classes):
    assert generate_classes([
        schema.Class("A")
    ]) == {
        "A.qll": (a_ql_class_public(name="A"),
                  a_ql_stub(name="A"),
                  a_ql_class(name="A", final=True, imports=[stub_import_prefix + "A"]))
    }


def test_one_empty_internal_class(generate_classes):
    assert generate_classes([
        schema.Class("A", pragmas=["ql_internal"])
    ]) == {
        "A.qll": (a_ql_class_public(name="A", internal=True),
                  a_ql_stub(name="A"),
                  a_ql_class(name="A", final=True, internal=True, imports=[stub_import_prefix_internal + "A"])),
    }


def test_hierarchy(generate_classes):
    assert generate_classes([
        schema.Class("D", bases=["B", "C"]),
        schema.Class("C", bases=["A"], derived={"D"}),
        schema.Class("B", bases=["A"], derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]) == {
        "A.qll": (a_ql_class_public(name="A"), a_ql_stub(name="A"), a_ql_class(name="A", imports=[stub_import_prefix + "A"])),
        "B.qll": (a_ql_class_public(name="B", imports=[stub_import_prefix + "A"]), a_ql_stub(name="B"), a_ql_class(name="B", bases=["A"], bases_impl=["AImpl::A"], imports=[stub_import_prefix_internal + "AImpl::Impl as AImpl"])),
        "C.qll": (a_ql_class_public(name="C", imports=[stub_import_prefix + "A"]), a_ql_stub(name="C"), a_ql_class(name="C", bases=["A"], bases_impl=["AImpl::A"], imports=[stub_import_prefix_internal + "AImpl::Impl as AImpl"])),
        "D.qll": (a_ql_class_public(name="D", imports=[stub_import_prefix + "B", stub_import_prefix + "C"]), a_ql_stub(name="D"), a_ql_class(name="D", final=True, bases=["B", "C"], bases_impl=["BImpl::B", "CImpl::C"],
                                                                                                                                             imports=[stub_import_prefix_internal + cls + "Impl::Impl as " + cls + "Impl" for cls in "BC"])),
    }


def test_hierarchy_imports(generate_import_list):
    assert generate_import_list([
        schema.Class("D", bases=["B", "C"]),
        schema.Class("C", bases=["A"], derived={"D"}),
        schema.Class("B", bases=["A"], derived={"D"}),
        schema.Class("A", derived={"B", "C"}),
    ]) == ql.ImportList([stub_import_prefix + cls for cls in "ABCD"])


def test_internal_not_in_import_list(generate_import_list):
    assert generate_import_list([
        schema.Class("D", bases=["B", "C"]),
        schema.Class("C", bases=["A"], derived={"D"}, pragmas=["ql_internal"]),
        schema.Class("B", bases=["A"], derived={"D"}),
        schema.Class("A", derived={"B", "C"}, pragmas=["ql_internal"]),
    ]) == ql.ImportList([stub_import_prefix + cls for cls in "BD"])


def test_hierarchy_children(generate_children_implementations):
    assert generate_children_implementations([
        schema.Class("A", derived={"B", "C"}, pragmas=["ql_internal"]),
        schema.Class("B", bases=["A"], derived={"D"}),
        schema.Class("C", bases=["A"], derived={"D"}, pragmas=["ql_internal"]),
        schema.Class("D", bases=["B", "C"]),
    ]) == ql.GetParentImplementation(
        classes=[a_ql_class(name="A", internal=True, imports=[stub_import_prefix_internal + "A"]),
                 a_ql_class(name="B", bases=["A"], bases_impl=["AImpl::A"], imports=[
                     stub_import_prefix_internal + "AImpl::Impl as AImpl"]),
                 a_ql_class(name="C", bases=["A"], bases_impl=["AImpl::A"], imports=[
                     stub_import_prefix_internal + "AImpl::Impl as AImpl"], internal=True),
                 a_ql_class(name="D", final=True, bases=["B", "C"], bases_impl=["BImpl::B", "CImpl::C"],
                            imports=[stub_import_prefix_internal + cls + "Impl::Impl as " + cls + "Impl" for cls in "BC"]),
                 ],
        imports=[stub_import] + [stub_import_prefix_internal + cls for cls in "AC"],
    )


def test_single_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"], doc="foo of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_internal_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar", pragmas=["ql_internal"])]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"], doc="foo of this my object",
                                                    internal=True),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_children(generate_classes):
    assert generate_classes([
        schema.Class("FakeRoot"),
        schema.Class("MyObject", properties=[
            schema.SingleProperty("a", "int"),
            schema.SingleProperty("child_1", "int", is_child=True),
            schema.RepeatedProperty("bs", "int"),
            schema.RepeatedProperty("children", "int", is_child=True),
            schema.OptionalProperty("c", "int"),
            schema.OptionalProperty("child_3", "int", is_child=True),
            schema.RepeatedOptionalProperty("d", "int"),
            schema.RepeatedOptionalProperty("child_4", "int", is_child=True),
        ]),
    ]) == {
        "FakeRoot.qll": (a_ql_class_public(name="FakeRoot"), a_ql_stub(name="FakeRoot"), a_ql_class(name="FakeRoot", final=True, imports=[stub_import_prefix + "FakeRoot"])),
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="A", type="int", tablename="my_objects",
                                                    tableparams=["this", "result", "_"],
                                                    doc="a of this my object"),
                                        ql.Property(singular="Child1", type="int", tablename="my_objects",
                                                    tableparams=["this", "_", "result"], prev_child="",
                                                    doc="child 1 of this my object"),
                                        ql.Property(singular="B", plural="Bs", type="int",
                                                    tablename="my_object_bs",
                                                    tableparams=["this", "index", "result"],
                                                    doc="b of this my object",
                                                    doc_plural="bs of this my object"),
                                        ql.Property(singular="Child", plural="Children", type="int",
                                                    tablename="my_object_children",
                                                    tableparams=["this", "index", "result"], prev_child="Child1",
                                                    doc="child of this my object",
                                                    doc_plural="children of this my object"),
                                        ql.Property(singular="C", type="int", tablename="my_object_cs",
                                                    tableparams=["this", "result"], is_optional=True,
                                                    doc="c of this my object"),
                                        ql.Property(singular="Child3", type="int",
                                                    tablename="my_object_child_3s",
                                                    tableparams=["this", "result"], is_optional=True,
                                                    prev_child="Child", doc="child 3 of this my object"),
                                        ql.Property(singular="D", plural="Ds", type="int",
                                                    tablename="my_object_ds",
                                                    tableparams=["this", "index", "result"], is_optional=True,
                                                    doc="d of this my object",
                                                    doc_plural="ds of this my object"),
                                        ql.Property(singular="Child4", plural="Child4s", type="int",
                                                    tablename="my_object_child_4s",
                                                    tableparams=["this", "index", "result"], is_optional=True,
                                                    prev_child="Child3", doc="child 4 of this my object",
                                                    doc_plural="child 4s of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_single_properties(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.SingleProperty("three", "z"),
        ]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="One", type="x", tablename="my_objects",
                                                    tableparams=["this", "result", "_", "_"],
                                                    doc="one of this my object"),
                                        ql.Property(singular="Two", type="y", tablename="my_objects",
                                                    tableparams=["this", "_", "result", "_"],
                                                    doc="two of this my object"),
                                        ql.Property(singular="Three", type="z", tablename="my_objects",
                                                    tableparams=["this", "_", "_", "result"],
                                                    doc="three of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


@pytest.mark.parametrize("is_child,prev_child", [(False, None), (True, "")])
def test_optional_property(generate_classes, is_child, prev_child):
    assert generate_classes([
        schema.Class("FakeRoot"),
        schema.Class("MyObject", properties=[
            schema.OptionalProperty("foo", "bar", is_child=is_child)]),
    ]) == {
        "FakeRoot.qll": (a_ql_class_public(name="FakeRoot"), a_ql_stub(name="FakeRoot"), a_ql_class(name="FakeRoot", final=True, imports=[stub_import_prefix + "FakeRoot"])),
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True, properties=[
                                    ql.Property(singular="Foo", type="bar", tablename="my_object_foos",
                                                tableparams=["this", "result"],
                                                is_optional=True, prev_child=prev_child, doc="foo of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


@pytest.mark.parametrize("is_child,prev_child", [(False, None), (True, "")])
def test_repeated_property(generate_classes, is_child, prev_child):
    assert generate_classes([
        schema.Class("FakeRoot"),
        schema.Class("MyObject", properties=[
            schema.RepeatedProperty("foo", "bar", is_child=is_child)]),
    ]) == {
        "FakeRoot.qll": (a_ql_class_public(name="FakeRoot"), a_ql_stub(name="FakeRoot"), a_ql_class(name="FakeRoot", final=True, imports=[stub_import_prefix + "FakeRoot"])),
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True, properties=[
                                    ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                                                tableparams=["this", "index", "result"], prev_child=prev_child,
                                                doc="foo of this my object", doc_plural="foos of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_repeated_unordered_property(generate_classes):
    assert generate_classes([
        schema.Class("FakeRoot"),
        schema.Class("MyObject", properties=[
            schema.RepeatedUnorderedProperty("foo", "bar")]),
    ]) == {
        "FakeRoot.qll": (a_ql_class_public(name="FakeRoot"), a_ql_stub(name="FakeRoot"), a_ql_class(name="FakeRoot", final=True, imports=[stub_import_prefix + "FakeRoot"])),
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True, properties=[
                                    ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                                                tableparams=["this", "result"], is_unordered=True,
                                                doc="foo of this my object", doc_plural="foos of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


@pytest.mark.parametrize("is_child,prev_child", [(False, None), (True, "")])
def test_repeated_optional_property(generate_classes, is_child, prev_child):
    assert generate_classes([
        schema.Class("FakeRoot"),
        schema.Class("MyObject", properties=[
            schema.RepeatedOptionalProperty("foo", "bar", is_child=is_child)]),
    ]) == {

        "FakeRoot.qll": (a_ql_class_public(name="FakeRoot"), a_ql_stub(name="FakeRoot"), a_ql_class(name="FakeRoot", final=True, imports=[stub_import_prefix + "FakeRoot"])),
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True, properties=[
                                    ql.Property(singular="Foo", plural="Foos", type="bar", tablename="my_object_foos",
                                                tableparams=["this", "index", "result"], is_optional=True,
                                                prev_child=prev_child, doc="foo of this my object",
                                                doc_plural="foos of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_predicate_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.PredicateProperty("is_foo")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True, properties=[
                                    ql.Property(singular="isFoo", type="predicate", tablename="my_object_is_foo",
                                                tableparams=["this"], is_predicate=True, doc="this my object is foo"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


@pytest.mark.parametrize("is_child,prev_child", [(False, None), (True, "")])
def test_single_class_property(generate_classes, is_child, prev_child):
    assert generate_classes([
        schema.Class("Bar"),
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "Bar", is_child=is_child)]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject", imports=[stub_import_prefix + "Bar"]),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(
            name="MyObject", final=True, imports=[stub_import_prefix + "Bar", stub_import_prefix + "MyObject"], properties=[
                ql.Property(singular="Foo", type="Bar", tablename="my_objects",
                            tableparams=[
                                "this", "result"],
                            prev_child=prev_child, doc="foo of this my object",
                            type_is_codegen_class=True),
            ],
        )),
        "Bar.qll": (a_ql_class_public(name="Bar"), a_ql_stub(name="Bar"), a_ql_class(name="Bar", final=True, imports=[stub_import_prefix + "Bar"])),
    }


def test_class_with_doc(generate_classes):
    doc = ["Very important class.", "Very."]
    assert generate_classes([
        schema.Class("A", doc=doc),
    ]) == {
        "A.qll": (a_ql_class_public(name="A", doc=doc), a_ql_stub(name="A", doc=doc), a_ql_class(name="A", final=True, doc=doc, imports=[stub_import_prefix + "A"])),
    }


def test_class_dir(generate_classes):
    dir = "another/rel/path"
    assert generate_classes([
        schema.Class("A", derived={"B"}, pragmas={"group": dir}),
        schema.Class("B", bases=["A"]),
    ]) == {
        f"{dir}/A.qll": (
            a_ql_class_public(name="A"), a_ql_stub(name="A", import_prefix="another.rel.path."), a_ql_class(name="A", dir=pathlib.Path(dir), imports=[stub_import_prefix + "another.rel.path.A"])),
        "B.qll": (a_ql_class_public(name="B", imports=[stub_import_prefix + "another.rel.path.A"]),
                  a_ql_stub(name="B"),
                  a_ql_class(name="B", final=True, bases=["A"], bases_impl=["AImpl::A"],
                             imports=[stub_import_prefix + "another.rel.path.internal.AImpl::Impl as AImpl"])),
    }


def test_root_element_cannot_have_children(generate_classes):
    with pytest.raises(qlgen.RootElementHasChildren):
        generate_classes([
            schema.Class('A', properties=[schema.SingleProperty("x", is_child=True)])
        ])


def test_class_dir_imports(generate_import_list):
    dir = "another/rel/path"
    assert generate_import_list([
        schema.Class("A", derived={"B"}, pragmas={"group": dir}),
        schema.Class("B", bases=["A"]),
    ]) == ql.ImportList([
        stub_import_prefix + "B",
        stub_import_prefix + "another.rel.path.A",
    ])


def test_format(opts, generate, render_manager, run_mock):
    opts.codeql_binary = "my_fake_codeql"
    run_mock.return_value.stderr = "some\nlines\n"
    render_manager.written = [
        pathlib.Path("x", "foo.ql"),
        pathlib.Path("bar.qll"),
        pathlib.Path("y", "baz.txt"),
    ]
    generate([schema.Class('A')])
    assert run_mock.mock_calls == [
        mock.call(["my_fake_codeql", "query", "format", "--in-place", "--", "x/foo.ql", "bar.qll"],
                  stderr=subprocess.PIPE, text=True),
    ]


def test_format_error(opts, generate, render_manager, run_mock):
    opts.codeql_binary = "my_fake_codeql"
    run_mock.return_value.stderr = "some\nlines\n"
    run_mock.return_value.returncode = 1
    render_manager.written = [
        pathlib.Path("x", "foo.ql"),
        pathlib.Path("bar.qll"),
        pathlib.Path("y", "baz.txt"),
    ]
    with pytest.raises(qlgen.FormatError):
        generate([schema.Class('A')])


@pytest.mark.parametrize("force", [False, True])
def test_manage_parameters(opts, generate, renderer, force):
    opts.force = force
    ql_a = opts.ql_output / "A.qll"
    ql_b = opts.ql_output / "B.qll"
    stub_a = opts.ql_stub_output / "A.qll"
    stub_b = opts.ql_stub_output / "B.qll"
    test_a = opts.ql_test_output / "A.ql"
    test_b = opts.ql_test_output / "MISSING_SOURCE.txt"
    test_c = opts.ql_test_output / "B.txt"
    write(ql_a)
    write(ql_b)
    write(stub_a)
    write(stub_b)
    write(test_a)
    write(test_b)
    write(test_c)
    generate([schema.Class('A')])
    assert renderer.mock_calls == [
        mock.call.manage(generated={ql_a, ql_b, test_a, test_b, import_file()}, stubs={stub_a, stub_b},
                         registry=opts.generated_registry, force=force)
    ]


def test_modified_stub_skipped(qlgen_opts, generate, render_manager):
    stub = qlgen_opts.ql_stub_output / "AImpl.qll"
    render_manager.is_customized_stub.side_effect = lambda f: f == stub
    assert stub not in generate([schema.Class('A')])


def test_test_missing_source(generate_tests):
    generate_tests([
        schema.Class("A"),
    ]) == {
        "A/MISSING_SOURCE.txt": ql.MissingTestInstructions(),
    }


def a_ql_class_tester(**kwargs):
    return ql.ClassTester(**kwargs, elements_module=stub_import)


def a_ql_property_tester(**kwargs):
    return ql.PropertyTester(**kwargs, elements_module=stub_import)


def test_test_source_present(opts, generate_tests):
    write(opts.ql_test_output / "A" / "test.swift")
    assert generate_tests([
        schema.Class("A"),
    ]) == {
        "A/A.ql": a_ql_class_tester(class_name="A"),
    }


def test_test_source_present_with_dir(opts, generate_tests):
    write(opts.ql_test_output / "foo" / "A" / "test.swift")
    assert generate_tests([
        schema.Class("A", pragmas={"group": "foo"}),
    ]) == {
        "foo/A/A.ql": a_ql_class_tester(class_name="A"),
    }


def test_test_total_properties(opts, generate_tests):
    write(opts.ql_test_output / "B" / "test.swift")
    assert generate_tests([
        schema.Class("A", derived={"B"}, properties=[
            schema.SingleProperty("x", "string"),
        ]),
        schema.Class("B", bases=["A"], properties=[
            schema.PredicateProperty("y", "int"),
        ]),
    ]) == {
        "B/B.ql": a_ql_class_tester(class_name="B", properties=[
            ql.PropertyForTest(getter="getX", type="string"),
            ql.PropertyForTest(getter="y"),
        ])
    }


def test_test_partial_properties(opts, generate_tests):
    write(opts.ql_test_output / "B" / "test.swift")
    assert generate_tests([
        schema.Class("A", derived={"B", "C"}, properties=[
            schema.OptionalProperty("x", "string"),
        ]),
        schema.Class("B", bases=["A"], properties=[
            schema.RepeatedProperty("y", "bool"),
            schema.RepeatedOptionalProperty("z", "int"),
            schema.RepeatedUnorderedProperty("w", "string"),
        ]),
    ]) == {
        "B/B.ql": a_ql_class_tester(class_name="B", properties=[
            ql.PropertyForTest(getter="hasX"),
            ql.PropertyForTest(getter="getNumberOfYs", type="int"),
            ql.PropertyForTest(getter="getNumberOfWs", type="int"),
        ]),
        "B/B_getX.ql": a_ql_property_tester(class_name="B",
                                            property=ql.PropertyForTest(getter="getX", is_total=False,
                                                                               type="string")),
        "B/B_getY.ql": a_ql_property_tester(class_name="B",
                                            property=ql.PropertyForTest(getter="getY", is_total=False,
                                                                               is_indexed=True,
                                                                               type="bool")),
        "B/B_getZ.ql": a_ql_property_tester(class_name="B",
                                            property=ql.PropertyForTest(getter="getZ", is_total=False,
                                                                               is_indexed=True,
                                                                               type="int")),
        "B/B_getAW.ql": a_ql_property_tester(class_name="B",
                                             property=ql.PropertyForTest(getter="getAW", is_total=False,
                                                                                type="string")),
    }


def test_test_properties_deduplicated(opts, generate_tests):
    write(opts.ql_test_output / "Final" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"A", "B"}, properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "bool"),
        ]),
        schema.Class("A", bases=["Base"], derived={"Final"}),
        schema.Class("B", bases=["Base"], derived={"Final"}),
        schema.Class("Final", bases=["A", "B"]),
    ]) == {
        "Final/Final.ql": a_ql_class_tester(class_name="Final", properties=[
            ql.PropertyForTest(getter="getX", type="string"),
            ql.PropertyForTest(getter="getNumberOfYs", type="int"),
        ]),
        "Final/Final_getY.ql": a_ql_property_tester(class_name="Final",
                                                    property=ql.PropertyForTest(getter="getY", is_total=False,
                                                                                       is_indexed=True,
                                                                                       type="bool")),
    }


def test_test_properties_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}, properties=[
            schema.SingleProperty("x", "string", pragmas=["qltest_skip", "foo"]),
            schema.RepeatedProperty("y", "int", pragmas=["bar", "qltest_skip"]),
        ]),
        schema.Class("Derived", bases=["Base"], properties=[
            schema.PredicateProperty("a", pragmas=["qltest_skip"]),
            schema.OptionalProperty(
                "b", "int", pragmas=["bar", "qltest_skip", "baz"]),
        ]),
    ]) == {
        "Derived/Derived.ql": a_ql_class_tester(class_name="Derived"),
    }


def test_test_base_class_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}, pragmas=["qltest_skip", "foo"], properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "int"),
        ]),
        schema.Class("Derived", bases=["Base"]),
    ]) == {
        "Derived/Derived.ql": a_ql_class_tester(class_name="Derived"),
    }


def test_test_final_class_skipped(opts, generate_tests):
    write(opts.ql_test_output / "Derived" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"Derived"}),
        schema.Class("Derived", bases=["Base"], pragmas=["qltest_skip", "foo"], properties=[
            schema.SingleProperty("x", "string"),
            schema.RepeatedProperty("y", "int"),
        ]),
    ]) == {}


def test_test_class_hierarchy_collapse(opts, generate_tests):
    write(opts.ql_test_output / "Base" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases=["Base"], properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases=["Base"], derived={"D3"}, properties=[schema.SingleProperty("y", "string")]),
        schema.Class("D3", bases=["D2"], properties=[schema.SingleProperty("z", "string")]),
    ]) == {
        "Base/Base.ql": a_ql_class_tester(class_name="Base", show_ql_class=True),
    }


def test_test_class_hierarchy_uncollapse(opts, generate_tests):
    for d in ("Base", "D3", "D4"):
        write(opts.ql_test_output / d / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases=["Base"], properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases=["Base"], derived={"D3", "D4"}, pragmas=["qltest_uncollapse_hierarchy", "bar"]),
        schema.Class("D3", bases=["D2"]),
        schema.Class("D4", bases=["D2"]),
    ]) == {
        "Base/Base.ql": a_ql_class_tester(class_name="Base", show_ql_class=True),
        "D3/D3.ql": a_ql_class_tester(class_name="D3"),
        "D4/D4.ql": a_ql_class_tester(class_name="D4"),
    }


def test_test_class_hierarchy_uncollapse_at_final(opts, generate_tests):
    for d in ("Base", "D3"):
        write(opts.ql_test_output / d / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"D1", "D2"}, pragmas=["foo", "qltest_collapse_hierarchy"]),
        schema.Class("D1", bases=["Base"], properties=[schema.SingleProperty("x", "string")]),
        schema.Class("D2", bases=["Base"], derived={"D3"}),
        schema.Class("D3", bases=["D2"], pragmas=["qltest_uncollapse_hierarchy", "bar"]),
    ]) == {
        "Base/Base.ql": a_ql_class_tester(class_name="Base", show_ql_class=True),
        "D3/D3.ql": a_ql_class_tester(class_name="D3"),
    }


def test_test_with(opts, generate_tests):
    write(opts.ql_test_output / "B" / "test.swift")
    assert generate_tests([
        schema.Class("Base", derived={"A", "B"}),
        schema.Class("A", bases=["Base"], pragmas={"qltest_test_with": "B"}),
        schema.Class("B", bases=["Base"]),
    ]) == {
        "B/A.ql": a_ql_class_tester(class_name="A"),
        "B/B.ql": a_ql_class_tester(class_name="B"),
    }


def test_property_description(generate_classes):
    description = ["Lorem", "Ipsum"]
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar", description=description),
        ]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"],
                                                    doc="foo of this my object",
                                                    description=description),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_property_doc_override(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar", doc="baz")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"], doc="baz"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_repeated_property_doc_override(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.RepeatedProperty("x", "int", doc="children of this"),
            schema.RepeatedOptionalProperty("y", "int", doc="child of this")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="X", plural="Xes", type="int",
                                                    tablename="my_object_xes",
                                                    tableparams=["this", "index", "result"],
                                                    doc="child of this", doc_plural="children of this"),
                                        ql.Property(singular="Y", plural="Ys", type="int",
                                                    tablename="my_object_ies", is_optional=True,
                                                    tableparams=["this", "index", "result"],
                                                    doc="child of this", doc_plural="children of this"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


@pytest.mark.parametrize("abbr,expected", list(qlgen.abbreviations.items()))
def test_property_doc_abbreviations(generate_classes, abbr, expected):
    expected_doc = f"foo {expected} bar of this object"
    assert generate_classes([
        schema.Class("Object", properties=[
            schema.SingleProperty(f"foo_{abbr}_bar", "baz")]),
    ]) == {
        "Object.qll": (a_ql_class_public(name="Object"),
                       a_ql_stub(name="Object"),
                       a_ql_class(name="Object", final=True,
                                  properties=[
                                      ql.Property(singular=f"Foo{abbr.capitalize()}Bar", type="baz",
                                                  tablename="objects",
                                                  tableparams=["this", "result"], doc=expected_doc),
                                  ],
                                  imports=[stub_import_prefix + "Object"])),
    }


@pytest.mark.parametrize("abbr,expected", list(qlgen.abbreviations.items()))
def test_property_doc_abbreviations_ignored_if_within_word(generate_classes, abbr, expected):
    expected_doc = f"foo {abbr}acadabra bar of this object"
    assert generate_classes([
        schema.Class("Object", properties=[
            schema.SingleProperty(f"foo_{abbr}acadabra_bar", "baz")]),
    ]) == {
        "Object.qll": (a_ql_class_public(name="Object"),
                       a_ql_stub(name="Object"),
                       a_ql_class(name="Object", final=True,
                                  properties=[
                                      ql.Property(singular=f"Foo{abbr.capitalize()}acadabraBar", type="baz",
                                                  tablename="objects",
                                                  tableparams=["this", "result"], doc=expected_doc),
                                  ],
                                  imports=[stub_import_prefix + "Object"])),
    }


def test_repeated_property_doc_override_with_format(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.RepeatedProperty("x", "int", doc="special {children} of this"),
            schema.RepeatedOptionalProperty("y", "int", doc="special {child} of this")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="X", plural="Xes", type="int",
                                                    tablename="my_object_xes",
                                                    tableparams=["this", "index", "result"],
                                                    doc="special child of this",
                                                    doc_plural="special children of this"),
                                        ql.Property(singular="Y", plural="Ys", type="int",
                                                    tablename="my_object_ies", is_optional=True,
                                                    tableparams=["this", "index", "result"],
                                                    doc="special child of this",
                                                    doc_plural="special children of this"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_repeated_property_doc_override_with_multiple_formats(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.RepeatedProperty("x", "int", doc="{cat} or {dog}"),
            schema.RepeatedOptionalProperty("y", "int", doc="{cats} or {dogs}")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="X", plural="Xes", type="int",
                                                    tablename="my_object_xes",
                                                    tableparams=["this", "index", "result"],
                                                    doc="cat or dog", doc_plural="cats or dogs"),
                                        ql.Property(singular="Y", plural="Ys", type="int",
                                                    tablename="my_object_ies", is_optional=True,
                                                    tableparams=["this", "index", "result"],
                                                    doc="cat or dog", doc_plural="cats or dogs"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_property_doc_override_with_format(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar", doc="special {baz} of this")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"], doc="special baz of this"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_property_on_class_with_default_doc_name(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar")],
            pragmas={"ql_default_doc_name": "baz"}),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    tableparams=["this", "result"], doc="foo of this baz"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_stub_on_class_with_synth_from_class(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", pragmas={"synth": schema.SynthInfo(from_class="A")},
                     properties=[schema.SingleProperty("foo", "bar")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"), a_ql_stub(name="MyObject", synth_accessors=[
            ql.SynthUnderlyingAccessor(argument="Entity", type="Raw::A", constructorparams=["result"]),
        ]),
            a_ql_class(name="MyObject", final=True, properties=[
                       ql.Property(singular="Foo", type="bar", tablename="my_objects", synth=True,
                                   tableparams=["this", "result"], doc="foo of this my object"),
                       ], imports=[stub_import_prefix + "MyObject"])),
    }


def test_stub_on_class_with_synth_on_arguments(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", pragmas={"synth": schema.SynthInfo(on_arguments={"base": "A", "index": "int", "label": "string"})},
                     properties=[schema.SingleProperty("foo", "bar")]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"), a_ql_stub(name="MyObject", synth_accessors=[
            ql.SynthUnderlyingAccessor(argument="Base", type="Raw::A", constructorparams=["result", "_", "_"]),
            ql.SynthUnderlyingAccessor(argument="Index", type="int", constructorparams=["_", "result", "_"]),
            ql.SynthUnderlyingAccessor(argument="Label", type="string", constructorparams=["_", "_", "result"]),
        ]),
            a_ql_class(name="MyObject", final=True, properties=[
                       ql.Property(singular="Foo", type="bar", tablename="my_objects", synth=True,
                                   tableparams=["this", "result"], doc="foo of this my object"),
                       ], imports=[stub_import_prefix + "MyObject"])),
    }


def test_synth_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", properties=[
            schema.SingleProperty("foo", "bar", synth=True)]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"),
                         a_ql_stub(name="MyObject"),
                         a_ql_class(name="MyObject", final=True,
                                    properties=[
                                        ql.Property(singular="Foo", type="bar", tablename="my_objects",
                                                    synth=True,
                                                    tableparams=["this", "result"], doc="foo of this my object"),
                                    ],
                                    imports=[stub_import_prefix + "MyObject"])),
    }


def test_hideable_class(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", pragmas=["ql_hideable"]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"), a_ql_stub(name="MyObject"), a_ql_class(name="MyObject", final=True, hideable=True, imports=[stub_import_prefix + "MyObject"])),
    }


def test_hideable_property(generate_classes):
    assert generate_classes([
        schema.Class("MyObject", pragmas=["ql_hideable"]),
        schema.Class("Other", properties=[
            schema.SingleProperty("x", "MyObject"),
        ]),
    ]) == {
        "MyObject.qll": (a_ql_class_public(name="MyObject"), a_ql_stub(name="MyObject"), a_ql_class(name="MyObject", final=True, hideable=True, imports=[stub_import_prefix + "MyObject"])),
        "Other.qll": (a_ql_class_public(name="Other", imports=[stub_import_prefix + "MyObject"]),
                      a_ql_stub(name="Other"),
                      a_ql_class(name="Other", imports=[stub_import_prefix + "MyObject", stub_import_prefix + "Other"],
                                 final=True, properties=[
                                 ql.Property(singular="X", type="MyObject", tablename="others",
                                             type_is_hideable=True,
                                             type_is_codegen_class=True,
                                             tableparams=["this", "result"], doc="x of this other"),
                                 ])),
    }


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
