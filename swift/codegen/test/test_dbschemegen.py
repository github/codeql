import pathlib
import sys

from swift.codegen import dbschemegen
from swift.codegen.lib import dbscheme, paths
from swift.codegen.test.utils import *

def generate(opts, renderer):
    (out, data), = run_generation(dbschemegen.generate, opts, renderer).items()
    assert out is opts.dbscheme
    return data


def test_empty(opts, input, renderer):
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[],
    )


def test_includes(opts, input, renderer):
    includes = ["foo", "bar"]
    input.includes = includes
    for i in includes:
        write(opts.schema.parent / i, i + " data")

    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[
            dbscheme.DbSchemeInclude(
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
                    dbscheme.DbColumn('foo', 'bar'),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
                    dbscheme.DbColumn('foo', '@bar'),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
                ]
            ),
            dbscheme.DbTable(
                name="object_foos",
                keyset=dbscheme.DbKeySet(["id"]),
                columns=[
                    dbscheme.DbColumn('id', '@object'),
                    dbscheme.DbColumn('foo', 'bar'),
                ]
            ),
        ],
    )


def test_final_class_with_repeated_field(opts, input, renderer):
    input.classes = [
        schema.Class("Object", properties=[
            schema.RepeatedProperty("foo", "bar"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
                ]
            ),
            dbscheme.DbTable(
                name="object_foos",
                keyset=dbscheme.DbKeySet(["id", "index"]),
                columns=[
                    dbscheme.DbColumn('id', '@object'),
                    dbscheme.DbColumn('index', 'int'),
                    dbscheme.DbColumn('foo', 'bar'),
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
            schema.RepeatedProperty("four", "w"),
        ]),
    ]
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbTable(
                name="objects",
                columns=[
                    dbscheme.DbColumn('id', '@object', binding=True),
                    dbscheme.DbColumn('one', 'x'),
                    dbscheme.DbColumn('two', 'y'),
                ]
            ),
            dbscheme.DbTable(
                name="object_threes",
                keyset=dbscheme.DbKeySet(["id"]),
                columns=[
                    dbscheme.DbColumn('id', '@object'),
                    dbscheme.DbColumn('three', 'z'),
                ]
            ),
            dbscheme.DbTable(
                name="object_fours",
                keyset=dbscheme.DbKeySet(["id", "index"]),
                columns=[
                    dbscheme.DbColumn('id', '@object'),
                    dbscheme.DbColumn('index', 'int'),
                    dbscheme.DbColumn('four', 'w'),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbUnion(
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbUnion(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.DbTable(
                name="bases",
                keyset=dbscheme.DbKeySet(["id"]),
                columns=[
                    dbscheme.DbColumn('id', '@base'),
                    dbscheme.DbColumn('single', '@prop'),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbUnion(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.DbTable(
                name="base_opts",
                keyset=dbscheme.DbKeySet(["id"]),
                columns=[
                    dbscheme.DbColumn('id', '@base'),
                    dbscheme.DbColumn('opt', '@prop'),
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
    assert generate(opts, renderer) == dbscheme.DbScheme(
        src=schema_file,
        includes=[],
        declarations=[
            dbscheme.DbUnion(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.DbTable(
                name="base_reps",
                keyset=dbscheme.DbKeySet(["id", "index"]),
                columns=[
                    dbscheme.DbColumn('id', '@base'),
                    dbscheme.DbColumn('index', 'int'),
                    dbscheme.DbColumn('rep', '@prop'),
                ]
            )
        ],
    )


def test_dbcolumn_name():
    assert dbscheme.DbColumn("foo", "some_type").name == "foo"


@pytest.mark.parametrize("keyword", dbscheme.dbscheme_keywords)
def test_dbcolumn_keyword_name(keyword):
    assert dbscheme.DbColumn(keyword, "some_type").name == keyword + "_"


@pytest.mark.parametrize("type,binding,lhstype,rhstype", [
    ("builtin_type", False, "builtin_type", "builtin_type ref"),
    ("builtin_type", True, "builtin_type", "builtin_type ref"),
    ("@at_type", False, "int", "@at_type ref"),
    ("@at_type", True, "unique int", "@at_type"),
])
def test_dbcolumn_types(type, binding, lhstype, rhstype):
    col = dbscheme.DbColumn("foo", type, binding)
    assert col.lhstype == lhstype
    assert col.rhstype == rhstype


if __name__ == '__main__':
    sys.exit(pytest.main())
