import collections
import sys

from misc.codegen.generators import dbschemegen
from misc.codegen.lib import dbscheme
from misc.codegen.test.utils import *

InputExpectedPair = collections.namedtuple("InputExpectedPair", ("input", "expected"))


@pytest.fixture(params=[
    InputExpectedPair(None, None),
    InputExpectedPair("foodir", pathlib.Path("foodir")),
])
def dir_param(request):
    return request.param


@pytest.fixture
def generate(opts, input, renderer):
    def func(classes, null=None):
        input.classes = {cls.name: cls for cls in classes}
        input.null = null
        (out, data), = run_generation(dbschemegen.generate, opts, renderer).items()
        assert out is opts.dbscheme
        return data

    return func


def test_empty(generate):
    assert generate([]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[],
    )


def test_includes(input, opts, generate):
    includes = ["foo", "bar"]
    input.includes = includes
    for i in includes:
        write(opts.schema.parent / i, i + " data")

    assert generate([]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[
            dbscheme.SchemeInclude(
                src=pathlib.Path(i),
                data=i + " data",
            ) for i in includes
        ],
        declarations=[],
    )


def test_empty_final_class(generate, dir_param):
    assert generate([
        schema.Class("Object", pragmas={"group": dir_param.input}),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.SingleProperty("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.SingleProperty("foo", "Bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.OptionalProperty("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            property_cls("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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


def test_final_class_with_repeated_unordered_field(generate, dir_param):
    assert generate([
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.RepeatedUnorderedProperty("foo", "bar"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
                columns=[
                    dbscheme.Column('id', '@object'),
                    dbscheme.Column('foo', 'bar'),
                ], dir=dir_param.expected,
            ),
        ],
    )


def test_final_class_with_predicate_field(generate, dir_param):
    assert generate([
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.PredicateProperty("foo"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class("Object", pragmas={"group": dir_param.input}, properties=[
            schema.SingleProperty("one", "x"),
            schema.SingleProperty("two", "y"),
            schema.OptionalProperty("three", "z"),
            schema.RepeatedProperty("four", "u"),
            schema.RepeatedOptionalProperty("five", "v"),
            schema.PredicateProperty("six"),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
        schema.Class(name="Base", derived={"Left", "Right"}),
        schema.Class(name="Left", bases=["Base"]),
        schema.Class(name="Right", bases=["Base"]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@left", "@right"],
            ),
            dbscheme.Table(
                name="lefts",
                columns=[dbscheme.Column("id", "@left", binding=True)],
            ),
            dbscheme.Table(
                name="rights",
                columns=[dbscheme.Column("id", "@right", binding=True)],
            ),
        ],
    )


def test_class_with_derived_and_single_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            pragmas={"group": dir_param.input},
            properties=[
                schema.SingleProperty("single", "Prop"),
            ]),
        schema.Class(name="Left", bases=["Base"]),
        schema.Class(name="Right", bases=["Base"]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
            ),
            dbscheme.Table(
                name="lefts",
                columns=[dbscheme.Column("id", "@left", binding=True)],
            ),
            dbscheme.Table(
                name="rights",
                columns=[dbscheme.Column("id", "@right", binding=True)],
            ),
        ],
    )


def test_class_with_derived_and_optional_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            derived={"Left", "Right"},
            pragmas={"group": dir_param.input},
            properties=[
                schema.OptionalProperty("opt", "Prop"),
            ]),
        schema.Class(name="Left", bases=["Base"]),
        schema.Class(name="Right", bases=["Base"]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
            ),
            dbscheme.Table(
                name="lefts",
                columns=[dbscheme.Column("id", "@left", binding=True)],
            ),
            dbscheme.Table(
                name="rights",
                columns=[dbscheme.Column("id", "@right", binding=True)],
            ),
        ],
    )


def test_class_with_derived_and_repeated_property(generate, dir_param):
    assert generate([
        schema.Class(
            name="Base",
            pragmas={"group": dir_param.input},
            derived={"Left", "Right"},
            properties=[
                schema.RepeatedProperty("rep", "Prop"),
            ]),
        schema.Class(name="Left", bases=["Base"]),
        schema.Class(name="Right", bases=["Base"]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
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
            ),
            dbscheme.Table(
                name="lefts",
                columns=[dbscheme.Column("id", "@left", binding=True)],
            ),
            dbscheme.Table(
                name="rights",
                columns=[dbscheme.Column("id", "@right", binding=True)],
            ),
        ],
    )


def test_null_class(generate):
    assert generate([
        schema.Class(
            name="Base",
            derived={"W", "X", "Y", "Z", "Null"},
        ),
        schema.Class(
            name="W",
            bases=["Base"],
            properties=[
                schema.SingleProperty("w", "W"),
                schema.SingleProperty("x", "X"),
                schema.OptionalProperty("y", "Y"),
                schema.RepeatedProperty("z", "Z"),
            ]
        ),
        schema.Class(
            name="X",
            bases=["Base"],
        ),
        schema.Class(
            name="Y",
            bases=["Base"],
        ),
        schema.Class(
            name="Z",
            bases=["Base"],
        ),
        schema.Class(
            name="Null",
            bases=["Base"],
        ),
    ], null="Null") == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[
            dbscheme.Union(
                lhs="@base",
                rhs=["@null", "@w", "@x", "@y", "@z"],
            ),
            dbscheme.Table(
                name="ws",
                columns=[
                    dbscheme.Column('id', '@w', binding=True),
                    dbscheme.Column('w', '@w_or_none'),
                    dbscheme.Column('x', '@x_or_none'),
                ],
            ),
            dbscheme.Table(
                name="w_ies",
                keyset=dbscheme.KeySet(["id"]),
                columns=[
                    dbscheme.Column('id', '@w'),
                    dbscheme.Column('y', '@y_or_none'),
                ],
            ),
            dbscheme.Table(
                name="w_zs",
                keyset=dbscheme.KeySet(["id", "index"]),
                columns=[
                    dbscheme.Column('id', '@w'),
                    dbscheme.Column('index', 'int'),
                    dbscheme.Column('z', '@z_or_none'),
                ],
            ),
            dbscheme.Table(
                name="xes",
                columns=[
                    dbscheme.Column('id', '@x', binding=True),
                ],
            ),
            dbscheme.Table(
                name="ys",
                columns=[
                    dbscheme.Column('id', '@y', binding=True),
                ],
            ),
            dbscheme.Table(
                name="zs",
                columns=[
                    dbscheme.Column('id', '@z', binding=True),
                ],
            ),
            dbscheme.Table(
                name="nulls",
                columns=[
                    dbscheme.Column('id', '@null', binding=True),
                ],
            ),
            dbscheme.Union(
                lhs="@w_or_none",
                rhs=["@w", "@null"],
            ),
            dbscheme.Union(
                lhs="@x_or_none",
                rhs=["@x", "@null"],
            ),
            dbscheme.Union(
                lhs="@y_or_none",
                rhs=["@y", "@null"],
            ),
            dbscheme.Union(
                lhs="@z_or_none",
                rhs=["@z", "@null"],
            ),
        ],
    )


def test_synth_classes_ignored(generate):
    assert generate([
        schema.Class(name="A", pragmas={"synth": schema.SynthInfo()}),
        schema.Class(name="B", pragmas={"synth": schema.SynthInfo(from_class="A")}),
        schema.Class(name="C", pragmas={"synth": schema.SynthInfo(on_arguments={"x": "A"})}),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[],
    )


def test_synth_derived_classes_ignored(generate):
    assert generate([
        schema.Class(name="A", derived={"B", "C"}),
        schema.Class(name="B", bases=["A"], pragmas={"synth": schema.SynthInfo()}),
        schema.Class(name="C", bases=["A"]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[
            dbscheme.Union("@a", ["@c"]),
            dbscheme.Table(
                name="cs",
                columns=[
                    dbscheme.Column("id", "@c", binding=True),
                ],
            )
        ],
    )


def test_synth_properties_ignored(generate):
    assert generate([
        schema.Class(name="A", properties=[
            schema.SingleProperty("x", "a"),
            schema.SingleProperty("y", "b", synth=True),
            schema.SingleProperty("z", "c"),
            schema.OptionalProperty("foo", "bar", synth=True),
            schema.RepeatedProperty("baz", "bazz", synth=True),
            schema.RepeatedOptionalProperty("bazzz", "bazzzz", synth=True),
            schema.RepeatedUnorderedProperty("bazzzzz", "bazzzzzz", synth=True),
        ]),
    ]) == dbscheme.Scheme(
        src=schema_file.name,
        includes=[],
        declarations=[
            dbscheme.Table(
                name="as",
                columns=[
                    dbscheme.Column("id", "@a", binding=True),
                    dbscheme.Column("x", "a"),
                    dbscheme.Column("z", "c"),
                ],
            )
        ],
    )


if __name__ == '__main__':
    sys.exit(pytest.main([__file__] + sys.argv[1:]))
