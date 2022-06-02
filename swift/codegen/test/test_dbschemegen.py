import sys

from swift.codegen.generators import dbschemegen
from swift.codegen.lib import dbscheme
from swift.codegen.test.utils import *


def generate(opts, renderer):
    (out, data), = run_generation(dbschemegen.generate, opts, renderer).items()
    assert out is opts.dbscheme
    return data


def test_empty(opts, input, renderer):
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[],
    )


def test_includes(opts, input, renderer):
    includes = ["foo", "bar"]
    input.includes = includes
    for i in includes:
        write(opts.schema.parent / i, i + " data")

    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[
            dbscheme.SchemeInclude(
                src=schema_dir / i,
                data=i + " data",
            ) for i in includes
        ],
        declarations=[],
    )


def test_empty_final_class(opts, input, renderer):
    input.classes = [
        schema.Class("Object"),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ]
            )
        ],
    )


def test_final_class_with_single_scalar_field(opts, input, renderer):
    input.classes = [

        schema.Class("Object", properties=[
            schema.SingleProperty("foo", "bar"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('foo', 'bar'),
                ]
            )
        ],
    )


def test_final_class_with_single_class_field(opts, input, renderer):
    input.classes = [
        schema.Class("Object", properties=[
            schema.SingleProperty("foo", "Bar"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('foo', '@bar'),
                ]
            )
        ],
    )


def test_final_class_with_optional_field(opts, input, renderer):
    input.classes = [
        schema.Class("Object", properties=[
            schema.OptionalProperty("foo", "bar"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ]
            ),
            dbscheme.Table(
                name="object_foos",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('foo', 'bar'),
                ]
            ),
        ],
    )


@pytest.mark.parametrize("property_cls", [schema.RepeatedProperty, schema.RepeatedOptionalProperty])
def test_final_class_with_repeated_field(opts, input, renderer, property_cls):
    input.classes = [
        schema.Class("Object", properties=[
            property_cls("foo", "bar"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ]
            ),
            dbscheme.Table(
                name="object_foos",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('foo', 'bar'),
                ]
            ),
        ],
    )


def test_final_class_with_predicate_field(opts, input, renderer):
    input.classes = [
        schema.Class("Object", properties=[
            schema.PredicateProperty("foo"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                ]
            ),
            dbscheme.Table(
                name="object_foo",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                ]
            ),
        ],
    )


def test_final_class_with_more_fields(opts, input, renderer):
    input.classes = [
        schema.Class("Object", properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.OptionalProperty("three", "z"),
            schema.RepeatedProperty("four", "u"),
            schema.RepeatedOptionalProperty("five", "v"),
            schema.PredicateProperty("six"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="objects",
                columns=[
                    dbscheme.Column('id', '@object', binding=True),
                    dbscheme.Column('one', 'x'),
                    dbscheme.Column('two', 'y'),
                ]
            ),
            dbscheme.Table(
                name="object_threes",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('three', 'z'),
                ]
            ),
            dbscheme.Table(
                name="object_fours",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('four', 'u'),
                ]
            ),
            dbscheme.Table(
                name="object_fives",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('five', 'v'),
                ]
            ),
            dbscheme.Table(
                name="object_six",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@object'),
                ]
            ),
        ],
    )


def test_empty_class_with_derived(opts, input, renderer):
    input.classes = [
        schema.Class(
            name="Base",
            derived={"Left", "Right"}),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
        ],
    )


def test_class_with_derived_and_single_property(opts, input, renderer):
    input.classes = [
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            properties=[
                schema.SingleProperty("single", "Prop"),
            ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
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
                ]
            )
        ],
    )


def test_class_with_derived_and_optional_property(opts, input, renderer):
    input.classes = [
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            properties=[
                schema.OptionalProperty("opt", "Prop"),
            ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
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
                ]
            )
        ],
    )


def test_class_with_derived_and_repeated_property(opts, input, renderer):
    input.classes = [
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            properties=[
                schema.RepeatedProperty("rep", "Prop"),
            ]),
    ]
    assert generate(opts, renderer) == dbscheme.Scheme(
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
                ]
            )
        ],
    )


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
