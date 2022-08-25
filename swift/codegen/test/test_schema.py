import sys

import pytest

from swift.codegen.test.utils import *

root_name = schema.root_class_name


@pytest.fixture
def load(tmp_path):
    file = tmp_path / "schema.yml"

    def ret(yml):
        write(file, yml)
        return schema.load(file)

    return ret


def test_empty_schema(load):
    ret = load("{}")
    assert ret.classes == {root_name: schema.Class(root_name)}
    assert ret.includes == set()


def test_one_empty_class(load):
    ret = load("""
MyClass: {}
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'MyClass'}),
        'MyClass': schema.Class('MyClass', bases={root_name}),
    }


def test_two_empty_classes(load):
    ret = load("""
MyClass1: {}
MyClass2: {}
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'MyClass1', 'MyClass2'}),
        'MyClass1': schema.Class('MyClass1', bases={root_name}),
        'MyClass2': schema.Class('MyClass2', bases={root_name}),
    }


def test_two_empty_chained_classes(load):
    ret = load("""
MyClass1: {}
MyClass2:
    _extends: MyClass1
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'MyClass1'}),
        'MyClass1': schema.Class('MyClass1', bases={root_name}, derived={'MyClass2'}),
        'MyClass2': schema.Class('MyClass2', bases={'MyClass1'}),
    }


def test_empty_classes_diamond(load):
    ret = load("""
A: {}
B: {}
C:
    _extends: 
        - A
        - B
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A', 'B'}),
        'A': schema.Class('A', bases={root_name}, derived={'C'}),
        'B': schema.Class('B', bases={root_name}, derived={'C'}),
        'C': schema.Class('C', bases={'A', 'B'}),
    }


def test_dir(load):
    ret = load("""
A:
    _dir: other/dir
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, dir=pathlib.Path("other/dir")),
    }


def test_directory_filter(load):
    ret = load("""
_directories:
    first/dir: '[xy]'
    second/dir: foo$
    third/dir: bar$
Afoo: {}
Bbar: {}
Abar: {}
Bfoo: {}
Ax: {}
Ay: {}
A: {}
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'Afoo', 'Bbar', 'Abar', 'Bfoo', 'Ax', 'Ay', 'A'}),
        'Afoo': schema.Class('Afoo', bases={root_name}, dir=pathlib.Path("second/dir")),
        'Bbar': schema.Class('Bbar', bases={root_name}, dir=pathlib.Path("third/dir")),
        'Abar': schema.Class('Abar', bases={root_name}, dir=pathlib.Path("third/dir")),
        'Bfoo': schema.Class('Bfoo', bases={root_name}, dir=pathlib.Path("second/dir")),
        'Ax': schema.Class('Ax', bases={root_name}, dir=pathlib.Path("first/dir")),
        'Ay': schema.Class('Ay', bases={root_name}, dir=pathlib.Path("first/dir")),
        'A': schema.Class('A', bases={root_name}, dir=pathlib.Path()),
    }


def test_directory_filter_override(load):
    ret = load("""
_directories:
    one/dir: ^A$
A:
    _dir: other/dir
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, dir=pathlib.Path("other/dir")),
    }


def test_lowercase_rejected(load):
    with pytest.raises(schema.Error):
        load("aLowercase: {}")


def test_digit_rejected(load):
    with pytest.raises(schema.Error):
        load("1digit: {}")


def test_properties(load):
    ret = load("""
A:
     one: string
     two: int?
     three: bool*
     four: x?*
     five: predicate
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.SingleProperty('one', 'string'),
            schema.OptionalProperty('two', 'int'),
            schema.RepeatedProperty('three', 'bool'),
            schema.RepeatedOptionalProperty('four', 'x'),
            schema.PredicateProperty('five'),
        ]),
    }


def test_element_properties(load):
    ret = load("""
Element:
    x: string
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, properties=[
            schema.SingleProperty('x', 'string'),
        ]),
    }


def test_children(load):
    ret = load("""
A:
    a: string
    b: B*
    _children:
        c: C
        d: D*
        e: E?
        f: F?*
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.SingleProperty('a', 'string'),
            schema.RepeatedProperty('b', 'B'),
            schema.SingleProperty('c', 'C', is_child=True),
            schema.RepeatedProperty('d', 'D', is_child=True),
            schema.OptionalProperty('e', 'E', is_child=True),
            schema.RepeatedOptionalProperty('f', 'F', is_child=True),
        ]),
    }


@pytest.mark.parametrize("type", ["string", "int", "boolean", "predicate"])
def test_builtin_and_predicate_children_not_allowed(load, type):
    with pytest.raises(schema.Error):
        load(f"""
A:
    _children:
        x: {type}
""")


def test_property_with_explicit_type(load):
    ret = load("""
A:
    x: 
      type: string*
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.RepeatedProperty('x', 'string'),
        ]),
    }


def test_property_with_explicit_type_and_pragmas(load):
    ret = load("""
A:
    x: 
      type: string*
      _pragma: [foo, bar]
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.RepeatedProperty('x', 'string', pragmas=["foo", "bar"]),
        ]),
    }


def test_property_with_explicit_type_and_one_pragma(load):
    ret = load("""
A:
    x: 
      type: string*
      _pragma: foo
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.RepeatedProperty('x', 'string', pragmas=["foo"]),
        ]),
    }


def test_property_with_explicit_type_and_unknown_metadata(load):
    with pytest.raises(schema.Error):
        load("""
A:
    x: 
      type: string*
      _what_is_this: [foo, bar]
""")


def test_property_with_dict_without_explicit_type(load):
    with pytest.raises(schema.Error):
        load("""
A:
    x: 
      typo: string*
""")


def test_class_with_pragmas(load):
    ret = load("""
A:
    x: string*
    _pragma: [foo, bar]
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.RepeatedProperty('x', 'string'),
        ], pragmas=["foo", "bar"]),
    }


def test_class_with_one_pragma(load):
    ret = load("""
A:
    x: string*
    _pragma: foo
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'A'}),
        'A': schema.Class('A', bases={root_name}, properties=[
            schema.RepeatedProperty('x', 'string'),
        ], pragmas=["foo"]),
    }


def test_class_with_unknown_metadata(load):
    with pytest.raises(schema.Error):
        load("""
A:
    x: string*
    _foobar: yeah
""")


def test_ipa_class_from(load):
    ret = load("""
MyClass:
    _synth:
        from: A
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'MyClass'}),
        'MyClass': schema.Class('MyClass', bases={root_name}, ipa=schema.IpaInfo(from_class="A")),
    }


def test_ipa_class_on(load):
    ret = load("""
MyClass:
    _synth:
        on: 
            x: A
            y: int
""")
    assert ret.classes == {
        root_name: schema.Class(root_name, derived={'MyClass'}),
        'MyClass': schema.Class('MyClass', bases={root_name}, ipa=schema.IpaInfo(on_arguments={"x": "A", "y": "int"})),
    }


# TODO rejection tests and implementation for malformed `_synth` clauses


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
