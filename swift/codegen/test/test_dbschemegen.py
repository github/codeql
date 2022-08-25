import collections
import pathlib
import sys

import pytest

from swift.codegen.generators import dbschemegen
from swift.codegen.lib import dbscheme
from swift.codegen.test.utils import *

InputExpectedPair = collections.namedtuple("InputExpectedPair", ("input", "expected"))


@pytest.fixture(params=[
    InputExpectedPair(pathlib.Path(), None),
    InputExpectedPair(pathlib.Path("foodir"), pathlib.Path("foodir")),
])
def dir_param(request):
    return request.param


@pytest.fixture
def generate(opts, input, renderer):
    def func(classes):
        input.classes = {cls.name: cls for cls in classes}
        (out, data), = run_generation(dbschemegen.generate, opts, renderer).items()
        assert out is opts.dbscheme
        return data

    return func


def test_empty(generate):
    assert generate([]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[],
    )


def test_includes(input, opts, generate):
    includes = ["foo", "bar"]
    input.includes = includes
    for i in includes:
        write(opts.schema.parent / i, i + " data")

    assert generate([]) == dbscheme.Scheme(
        src=schema_file,
        includes=[
            dbscheme.SchemeInclude(
                src=schema_dir / i,
                data=i + " data",
            ) for i in includes
        ],
        declarations=[],
    )


def test_empty_final_class(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ],
                dir=dir_param.expected,
            )
        ],
    )


def test_final_class_with_single_scalar_field(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            schema.SingleProperty("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('foo', 'bar'),
                ], dir=dir_param.expected,
            )
        ],
    )


def test_final_class_with_single_class_field(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            schema.SingleProperty("foo", "Bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('foo', '@bar'),
                ], dir=dir_param.expected,
            )
        ],
    )


def test_final_class_with_optional_field(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            schema.OptionalProperty("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_foos",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('foo', 'bar'),
                ], dir=dir_param.expected,
            ),
        ],
    )


@pytest.mark.parametrize("property_cls", [schema.RepeatedProperty, schema.RepeatedOptionalProperty])
def test_final_class_with_repeated_field(generate, property_cls, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            property_cls("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_foos",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('foo', 'bar'),
                ], dir=dir_param.expected,
            ),
        ],
    )


def test_final_class_with_predicate_field(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            schema.PredicateProperty("foo"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_foo",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                ], dir=dir_param.expected,
            ),
        ],
    )


def test_final_class_with_more_fields(generate, dir_param):
    assert generate([
        schema.Class("Object", dir=dir_param.input, properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.OptionalProperty("three", "z"),
            schema.RepeatedProperty("four", "u"),
            schema.RepeatedOptionalProperty("five", "v"),
            schema.PredicateProperty("six"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('one', 'x'),
                    dbscheme.Column('two', 'y'),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_threes",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('three', 'z'),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_fours",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('four', 'u'),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_fives",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('five', 'v'),
                ], dir=dir_param.expected,
            ),
            dbscheme.Table(
                name="object_six",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                ], dir=dir_param.expected,
            ),
        ],
    )


def test_empty_class_with_derived(generate):
    assert generate([
        schema.Class(
            name="Base", derived={"Left", "Right"}),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
        ],
    )


def test_class_with_derived_and_single_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            dir=dir_param.input,
            properties=[
                schema.SingleProperty("single", "Prop"),
            ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.Table(
                name="bases",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@base'),
                    dbscheme.Column('single', '@prop'),
                ],
                dir=dir_param.expected,
            )
        ],
    )


def test_class_with_derived_and_optional_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            dir=dir_param.input,
            properties=[
                schema.OptionalProperty("opt", "Prop"),
            ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.Table(
                name="base_opts",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@base'),
                    dbscheme.Column('opt', '@prop'),
                ],
                dir=dir_param.expected,
            )
        ],
    )


def test_class_with_derived_and_repeated_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            dir=dir_param.input,
            derived={"Left", "Right"},
            properties=[
                schema.RepeatedProperty("rep", "Prop"),
            ]),
    ]) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.Table(
                name="base_reps",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@base'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('rep', '@prop'),
                ],
                dir=dir_param.expected,
            )
        ],
    )


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
