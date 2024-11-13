import sys

import pytest
from misc.codegen.lib.schemadefs import optional

from misc.codegen.test.utils import *
from misc.codegen.lib import schemadefs as defs
from misc.codegen.loaders.schemaloader import load


def test_empty_schema():
    @load
    class data:
        pass

    assert data.classes == {}
    assert data.includes == set()
    assert data.null is None
    assert data.null_class is None


def test_one_empty_class():
    @load
    class data:
        class MyClass:
            pass

    assert data.classes == {
        'MyClass': schema.Class('MyClass'),
    }
    assert data.root_class is data.classes['MyClass']


def test_two_empty_classes():
    @load
    class data:
        class MyClass1:
            pass

        class MyClass2(MyClass1):
            pass

    assert data.classes == {
        'MyClass1': schema.Class('MyClass1', derived={'MyClass2'}),
        'MyClass2': schema.Class('MyClass2', bases=['MyClass1']),
    }
    assert data.root_class is data.classes['MyClass1']


def test_no_external_bases():
    class A:
        pass

    with pytest.raises(schema.Error):
        @load
        class data:
            class MyClass(A):
                pass


def test_no_multiple_roots():
    with pytest.raises(schema.Error):
        @load
        class data:
            class MyClass1:
                pass

            class MyClass2:
                pass


def test_empty_classes_diamond():
    @load
    class data:
        class A:
            pass

        class B(A):
            pass

        class C(A):
            pass

        class D(B, C):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B', 'C'}),
        'B': schema.Class('B', bases=['A'], derived={'D'}),
        'C': schema.Class('C', bases=['A'], derived={'D'}),
        'D': schema.Class('D', bases=['B', 'C']),
    }


#
def test_group():
    @load
    class data:
        @defs.group("xxx")
        class A:
            pass

    assert data.classes == {
        'A': schema.Class('A', pragmas={"group": "xxx"}),
    }


def test_group_is_inherited():
    @load
    class data:
        class A:
            pass

        class B(A):
            pass

        @defs.group('xxx')
        class C(A):
            pass

        class D(B, C):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B', 'C'}),
        'B': schema.Class('B', bases=['A'], derived={'D'}),
        'C': schema.Class('C', bases=['A'], derived={'D'}, pragmas={"group": "xxx"}),
        'D': schema.Class('D', bases=['B', 'C'], pragmas={"group": "xxx"}),
    }


def test_no_mixed_groups_in_bases():
    with pytest.raises(schema.Error):
        @load
        class data:
            class A:
                pass

            @defs.group('x')
            class B(A):
                pass

            @defs.group('y')
            class C(A):
                pass

            class D(B, C):
                pass


#


def test_lowercase_rejected():
    with pytest.raises(schema.Error):
        @load
        class data:
            class aLowerCase:
                pass


def test_properties():
    @load
    class data:
        class A:
            one: defs.string
            two: defs.optional[defs.int]
            three: defs.list[defs.boolean]
            four: defs.list[defs.optional[defs.string]]
            five: defs.predicate
            six: defs.set[defs.string]

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('one', 'string'),
            schema.OptionalProperty('two', 'int'),
            schema.RepeatedProperty('three', 'boolean'),
            schema.RepeatedOptionalProperty('four', 'string'),
            schema.PredicateProperty('five'),
            schema.RepeatedUnorderedProperty('six', 'string'),
        ]),
    }


def test_class_properties():
    class A:
        pass

    @load
    class data:
        class A:
            pass

        class B(A):
            one: A
            two: defs.optional[A]
            three: defs.list[A]
            four: defs.list[defs.optional[A]]
            five: defs.set[A]

    assert data.classes == {
        'A': schema.Class('A', derived={'B'}),
        'B': schema.Class('B', bases=['A'], properties=[
            schema.SingleProperty('one', 'A'),
            schema.OptionalProperty('two', 'A'),
            schema.RepeatedProperty('three', 'A'),
            schema.RepeatedOptionalProperty('four', 'A'),
            schema.RepeatedUnorderedProperty('five', 'A'),
        ]),
    }


def test_string_reference_class_properties():
    @load
    class data:
        class A:
            one: "A"
            two: defs.optional["A"]
            three: defs.list["A"]
            four: defs.list[defs.optional["A"]]
            five: defs.set["A"]

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('one', 'A'),
            schema.OptionalProperty('two', 'A'),
            schema.RepeatedProperty('three', 'A'),
            schema.RepeatedOptionalProperty('four', 'A'),
            schema.RepeatedUnorderedProperty('five', 'A'),
        ]),
    }


@pytest.mark.parametrize("spec", [lambda t: t, lambda t: defs.optional[t], lambda t: defs.list[t],
                                  lambda t: defs.list[defs.optional[t]]])
def test_string_reference_dangling(spec):
    with pytest.raises(schema.Error):
        @load
        class data:
            class A:
                x: spec("B")


def test_children():
    @load
    class data:
        class A:
            one: "A" | defs.child
            two: defs.optional["A"] | defs.child
            three: defs.list["A"] | defs.child
            four: defs.list[defs.optional["A"]] | defs.child

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('one', 'A', is_child=True),
            schema.OptionalProperty('two', 'A', is_child=True),
            schema.RepeatedProperty('three', 'A', is_child=True),
            schema.RepeatedOptionalProperty('four', 'A', is_child=True),
        ]),
    }


@pytest.mark.parametrize("spec", [defs.string, defs.int, defs.boolean, defs.predicate, defs.set["A"]])
def test_builtin_predicate_and_set_children_not_allowed(spec):
    with pytest.raises(schema.Error):
        @load
        class data:
            class A:
                x: spec | defs.child


_class_pragmas = [
    (defs.qltest.collapse_hierarchy, "qltest_collapse_hierarchy"),
    (defs.qltest.uncollapse_hierarchy, "qltest_uncollapse_hierarchy"),
]

_property_pragmas = [
    (defs.qltest.skip, "qltest_skip"),
    (defs.cpp.skip, "cpp_skip"),
    (defs.ql.internal, "ql_internal"),
]

_pragmas = _class_pragmas + _property_pragmas


@pytest.mark.parametrize("pragma,expected", _property_pragmas)
def test_property_with_pragma(pragma, expected):
    @load
    class data:
        class A:
            x: defs.string | pragma

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('x', 'string', pragmas=[expected]),
        ]),
    }


def test_property_with_pragmas():
    spec = defs.string
    for pragma, _ in _property_pragmas:
        spec |= pragma

    @load
    class data:
        class A:
            x: spec

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('x', 'string', pragmas=[expected for _, expected in _property_pragmas]),
        ]),
    }


@pytest.mark.parametrize("pragma,expected", _pragmas)
def test_class_with_pragma(pragma, expected):
    @load
    class data:
        @pragma
        class A:
            pass

    assert data.classes == {
        'A': schema.Class('A', pragmas=[expected]),
    }


def test_class_with_pragmas():
    def apply_pragmas(cls):
        for p, _ in _pragmas:
            p(cls)

    @load
    class data:
        class A:
            pass

        apply_pragmas(A)

    assert data.classes == {
        'A': schema.Class('A', pragmas=[e for _, e in _pragmas]),
    }


def test_synth_from_class():
    @load
    class data:
        class A:
            pass

        @defs.synth.from_class(A)
        class B(A):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B'}, pragmas={"synth": True}),
        'B': schema.Class('B', bases=['A'], pragmas={"synth": schema.SynthInfo(from_class="A")}),
    }


def test_synth_from_class_ref():
    @load
    class data:
        @defs.synth.from_class("B")
        class A:
            pass

        class B(A):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B'}, pragmas={"synth": schema.SynthInfo(from_class="B")}),
        'B': schema.Class('B', bases=['A']),
    }


def test_synth_from_class_dangling():
    with pytest.raises(schema.Error):
        @load
        class data:
            @defs.synth.from_class("X")
            class A:
                pass


def test_synth_class_on():
    @load
    class data:
        class A:
            pass

        @defs.synth.on_arguments(a=A, i=defs.int)
        class B(A):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B'}, pragmas={"synth": True}),
        'B': schema.Class('B', bases=['A'], pragmas={"synth": schema.SynthInfo(on_arguments={'a': 'A', 'i': 'int'})}),
    }


def test_synth_class_on_ref():
    class A:
        pass

    @load
    class data:
        @defs.synth.on_arguments(b="B", i=defs.int)
        class A:
            pass

        class B(A):
            pass

    assert data.classes == {
        'A': schema.Class('A', derived={'B'}, pragmas={"synth": schema.SynthInfo(on_arguments={'b': 'B', 'i': 'int'})}),
        'B': schema.Class('B', bases=['A']),
    }


def test_synth_class_on_dangling():
    with pytest.raises(schema.Error):
        @load
        class data:
            @defs.synth.on_arguments(s=defs.string, a="A", i=defs.int)
            class B:
                pass


def test_synth_class_hierarchy():
    @load
    class data:
        class Root:
            pass

        class Base(Root):
            pass

        class Intermediate(Base):
            pass

        @defs.synth.on_arguments(a=Base, i=defs.int)
        class A(Intermediate):
            pass

        @defs.synth.from_class(Base)
        class B(Base):
            pass

        class C(Root):
            pass

    assert data.classes == {
        'Root': schema.Class('Root', derived={'Base', 'C'}),
        'Base': schema.Class('Base', bases=['Root'], derived={'Intermediate', 'B'}, pragmas={"synth": True}),
        'Intermediate': schema.Class('Intermediate', bases=['Base'], derived={'A'}, pragmas={"synth": True}),
        'A': schema.Class('A', bases=['Intermediate'], pragmas={"synth": schema.SynthInfo(on_arguments={'a': 'Base', 'i': 'int'})}),
        'B': schema.Class('B', bases=['Base'], pragmas={"synth": schema.SynthInfo(from_class='Base')}),
        'C': schema.Class('C', bases=['Root']),
    }


def test_synthesized_property():
    @load
    class data:
        class A:
            x: defs.int | defs.synth

    assert data.classes["A"].properties == [
        schema.SingleProperty("x", "int", synth=True)
    ]


def test_class_docstring():
    @load
    class data:
        class A:
            """Very important class."""

    assert data.classes == {
        'A': schema.Class('A', doc=["Very important class."])
    }


def test_property_docstring():
    @load
    class data:
        class A:
            x: int | defs.desc("very important property.")

    assert data.classes == {
        'A': schema.Class('A', properties=[schema.SingleProperty('x', 'int', description=["very important property."])])
    }


def test_class_docstring_newline():
    @load
    class data:
        class A:
            """Very important
            class."""

    assert data.classes == {
        'A': schema.Class('A', doc=["Very important", "class."])
    }


def test_property_docstring_newline():
    @load
    class data:
        class A:
            x: int | defs.desc("""very important 
            property.""")

    assert data.classes == {
        'A': schema.Class('A',
                          properties=[schema.SingleProperty('x', 'int', description=["very important", "property."])])
    }


def test_class_docstring_stripped():
    @load
    class data:
        class A:
            """

            Very important class.

            """

    assert data.classes == {
        'A': schema.Class('A', doc=["Very important class."])
    }


def test_property_docstring_stripped():
    @load
    class data:
        class A:
            x: int | defs.desc("""
            
            very important property.
            
            """)

    assert data.classes == {
        'A': schema.Class('A', properties=[schema.SingleProperty('x', 'int', description=["very important property."])])
    }


def test_class_docstring_split():
    @load
    class data:
        class A:
            """Very important class.

            As said, very important."""

    assert data.classes == {
        'A': schema.Class('A', doc=["Very important class.", "", "As said, very important."])
    }


def test_property_docstring_split():
    @load
    class data:
        class A:
            x: int | defs.desc("""very important property.
            
            Very very important.""")

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('x', 'int', description=["very important property.", "", "Very very important."])])
    }


def test_class_docstring_indent():
    @load
    class data:
        class A:
            """
            Very important class.
              As said, very important.
            """

    assert data.classes == {
        'A': schema.Class('A', doc=["Very important class.", "  As said, very important."])
    }


def test_property_docstring_indent():
    @load
    class data:
        class A:
            x: int | defs.desc("""
            very important property.
              Very very important.
            """)

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('x', 'int', description=["very important property.", "  Very very important."])])
    }


def test_property_doc_override():
    @load
    class data:
        class A:
            x: int | defs.doc("y")

    assert data.classes == {
        'A': schema.Class('A', properties=[
            schema.SingleProperty('x', 'int', doc="y")]),
    }


def test_property_doc_override_no_newlines():
    with pytest.raises(schema.Error):
        @load
        class data:
            class A:
                x: int | defs.doc("no multiple\nlines")


def test_property_doc_override_no_trailing_dot():
    with pytest.raises(schema.Error):
        @load
        class data:
            class A:
                x: int | defs.doc("no dots please.")


def test_class_default_doc_name():
    @load
    class data:
        @defs.ql.default_doc_name("b")
        class A:
            pass

    assert data.classes == {
        'A': schema.Class('A', pragmas={"ql_default_doc_name": "b"}),
    }


def test_null_class():
    @load
    class data:
        class Root:
            pass

        @defs.use_for_null
        class Null(Root):
            pass

    assert data.classes == {
        'Root': schema.Class('Root', derived={'Null'}),
        'Null': schema.Class('Null', bases=['Root']),
    }
    assert data.null == 'Null'
    assert data.null_class is data.classes[data.null]


def test_null_class_cannot_be_derived():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            @defs.use_for_null
            class Null(Root):
                pass

            class Impossible(Null):
                pass


def test_null_class_cannot_be_defined_multiple_times():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            @defs.use_for_null
            class Null1(Root):
                pass

            @defs.use_for_null
            class Null2(Root):
                pass


def test_uppercase_acronyms_are_rejected():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            class ROTFLNode(Root):
                pass


def test_hideable():
    @load
    class data:
        class Root:
            pass

        @defs.ql.hideable
        class A(Root):
            pass

        class IndirectlyHideable(Root):
            pass

        class B(A, IndirectlyHideable):
            pass

        class NonHideable(Root):
            pass

    assert data.classes == {
        "Root": schema.Class("Root", derived={"A", "IndirectlyHideable", "NonHideable"}, pragmas=["ql_hideable"]),
        "A": schema.Class("A", bases=["Root"], derived={"B"}, pragmas=["ql_hideable"]),
        "IndirectlyHideable": schema.Class("IndirectlyHideable", bases=["Root"], derived={"B"}, pragmas=["ql_hideable"]),
        "B": schema.Class("B", bases=["A", "IndirectlyHideable"], pragmas=["ql_hideable"]),
        "NonHideable": schema.Class("NonHideable", bases=["Root"]),
    }


def test_test_with():
    @load
    class data:
        class Root:
            pass

        class A(Root):
            pass

        @defs.qltest.test_with(A)
        class B(Root):
            pass

        @defs.qltest.test_with("D")
        class C(Root):
            pass

        class D(Root):
            pass

        class E(B):
            pass

    assert data.classes == {
        "Root": schema.Class("Root", derived=set("ABCD")),
        "A": schema.Class("A", bases=["Root"]),
        "B": schema.Class("B", bases=["Root"], pragmas={"qltest_test_with": "A"}, derived={'E'}),
        "C": schema.Class("C", bases=["Root"], pragmas={"qltest_test_with": "D"}),
        "D": schema.Class("D", bases=["Root"]),
        "E": schema.Class("E", bases=["B"], pragmas={"qltest_test_with": "A"}),
    }


def test_annotate_docstring():
    @load
    class data:
        class Root:
            """ old docstring """

        class A(Root):
            """ A docstring """

        @defs.annotate(Root)
        class _:
            """
            new
            docstring
            """

        @defs.annotate(A)
        class _:
            pass

    assert data.classes == {
        "Root": schema.Class("Root", doc=["new", "docstring"], derived={"A"}),
        "A": schema.Class("A", bases=["Root"], doc=["A docstring"]),
    }


def test_annotate_decorations():
    @load
    class data:
        @defs.qltest.skip
        class Root:
            pass

        @defs.annotate(Root)
        @defs.qltest.collapse_hierarchy
        @defs.ql.hideable
        @defs.cpp.skip
        class _:
            pass

    assert data.classes == {
        "Root": schema.Class("Root", pragmas=["qltest_skip", "cpp_skip", "ql_hideable", "qltest_collapse_hierarchy"]),
    }


def test_annotate_fields():
    @load
    class data:
        class Root:
            x: defs.int
            y: defs.optional["Root"] | defs.child

        @defs.annotate(Root)
        class _:
            x: defs._ | defs.doc("foo")
            y: defs._ | defs.ql.internal
            z: defs.string

    assert data.classes == {
        "Root": schema.Class("Root", properties=[
            schema.SingleProperty("x", "int", doc="foo"),
            schema.OptionalProperty("y", "Root", pragmas=["ql_internal"], is_child=True),
            schema.SingleProperty("z", "string"),
        ]),
    }


def test_annotate_fields_negations():
    @load
    class data:
        class Root:
            x: defs.int | defs.ql.internal | defs.qltest.skip
            y: defs.optional["Root"] | defs.child | defs.desc("foo\nbar\n")
            z: defs.string | defs.synth | defs.doc("foo")

        @defs.annotate(Root)
        class _:
            x: defs._ | ~defs.ql.internal
            y: defs._ | ~defs.child | ~defs.ql.internal | ~defs.desc
            z: defs._ | ~defs.synth | ~defs.doc

    assert data.classes == {
        "Root": schema.Class("Root", properties=[
            schema.SingleProperty("x", "int", pragmas=["qltest_skip"]),
            schema.OptionalProperty("y", "Root"),
            schema.SingleProperty("z", "string"),
        ]),
    }


def test_annotate_non_existing_field():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            @defs.annotate(Root)
            class _:
                x: defs._ | defs.doc("foo")


def test_annotate_not_underscore():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            @defs.annotate(Root)
            class Something:
                """
                new
                docstring
                """


def test_annotate_replace_bases():
    @load
    class data:
        class Root:
            pass

        class A(Root):
            pass

        class B(Root):
            pass

        class C(B):
            pass

        class Derived(A, B):
            pass

        @defs.annotate(Derived, replace_bases={B: C})
        class _:
            pass
    assert data.classes == {
        "Root": schema.Class("Root", derived={"A", "B"}),
        "A": schema.Class("A", bases=["Root"], derived={"Derived"}),
        "B": schema.Class("B", bases=["Root"], derived={"C"}),
        "C": schema.Class("C", bases=["B"], derived={"Derived"}),
        "Derived": schema.Class("Derived", bases=["A", "C"]),
    }


def test_annotate_add_bases():
    @load
    class data:
        class Root:
            pass

        class A(Root):
            pass

        class B(Root):
            pass

        class C(Root):
            pass

        class Derived(A):
            pass

        @defs.annotate(Derived, add_bases=(B, C))
        class _:
            pass
    assert data.classes == {
        "Root": schema.Class("Root", derived={"A", "B", "C"}),
        "A": schema.Class("A", bases=["Root"], derived={"Derived"}),
        "B": schema.Class("B", bases=["Root"], derived={"Derived"}),
        "C": schema.Class("C", bases=["Root"], derived={"Derived"}),
        "Derived": schema.Class("Derived", bases=["A", "B", "C"]),
    }


def test_annotate_drop_field():
    @load
    class data:
        class Root:
            x: defs.int
            y: defs.string
            z: defs.boolean

        @defs.annotate(Root)
        class _:
            y: defs.drop

    assert data.classes == {
        "Root": schema.Class("Root", properties=[
            schema.SingleProperty("x", "int"),
            schema.SingleProperty("z", "boolean"),
        ]),
    }


def test_test_with_unknown_string():
    with pytest.raises(schema.Error):
        @load
        class data:
            class Root:
                pass

            @defs.qltest.test_with("B")
            class A(Root):
                pass


def test_test_with_unknown_class():
    with pytest.raises(schema.Error):
        class B:
            pass

        @load
        class data:
            class Root:
                pass

            @defs.qltest.test_with(B)
            class A(Root):
                pass


def test_test_with_double():
    with pytest.raises(schema.Error):
        class B:
            pass

        @load
        class data:
            class Root:
                pass

            class A(Root):
                pass

            @defs.qltest.test_with("C")
            class B(Root):
                pass

            @defs.qltest.test_with(A)
            class C(Root):
                pass


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
