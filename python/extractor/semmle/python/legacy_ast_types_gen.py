"""Generate the yeast output schema for the legacy Python extractor AST."""

import argparse
from pathlib import Path

import yaml

from semmle.python import ast, master
from semmle.python.AstMeta import ClassNode, ListNode, PrimitiveNode, UnionNode


OUTPUT_PATH = Path(__file__).resolve().parents[2] / "yeast-python" / "legacy_ast_types.yml"

LITERAL_KINDS = (
    "string_literal",
    "bytes_literal",
    "integer_literal",
    "boolean_literal",
    "number_literal",
    "variable_literal",
    "python_string_literal",
    "none_literal",
)

PRIMITIVE_LITERAL_KINDS = {
    "str": "string_literal",
    "bytes": "bytes_literal",
    "int": "integer_literal",
    "bool": "boolean_literal",
    "number": "number_literal",
    "variable": "variable_literal",
}


class _RepeatedType:
    def __init__(self, item_type):
        self.item_type = item_type


# These fields are populated after parsing or exist only in the extraction schema.
EXCLUDED_MASTER_FIELDS = {
    "Module": {"name", "hash", "kind"},
    # master.py declares both `class` and `class_name`, but the runtime AST only has `class_name`,
    # which is the field populated by both parsers. Since AST extraction walks runtime fields,
    # the legacy `class` slot in the generated database schema is not populated.
    "MatchClassPattern": {"class"},
    "TemplateStringPart": {"parenthesised"},
}

# These fields exist on the runtime AST but are intentionally absent from the extraction schema.
ADDITIONAL_FIELD_TYPES = {
    ("comprehension", "is_async"): "boolean_literal",
    ("DictComp", "key"): "expr",
    ("DictComp", "value"): "expr",
    ("DictComp", "generators"): _RepeatedType("comprehension"),
    ("GeneratorExp", "elt"): "expr",
    ("GeneratorExp", "generators"): _RepeatedType("comprehension"),
    ("SetComp", "elt"): "expr",
    ("SetComp", "generators"): _RepeatedType("comprehension"),
    ("StringPart", "prefix"): "string_literal",
    ("StringPart", "s"): "python_string_literal",
    ("TemplateStringPart", "s"): "python_string_literal",
}

# These fields have a parser representation that differs from their database primitive type.
FIELD_TYPE_OVERRIDES = {
    ("Bytes", "prefix"): "string_literal",
    ("Bytes", "s"): "python_string_literal",
    ("Num", "text"): "string_literal",
    ("Str", "s"): "python_string_literal",
}

# The lists are aligned with parameter lists, so missing entries are explicit None values.
FIELDS_WITH_NONE_ELEMENTS = {
    ("arguments", "annotations"),
    ("arguments", "defaults"),
    ("arguments", "kw_annotations"),
    ("arguments", "kw_defaults"),
}

MANUAL_RUNTIME_FIELDS = {
    "Module": ("body",),
}


def _runtime_field_order(cls):
    if cls.__name__ in MANUAL_RUNTIME_FIELDS:
        return MANUAL_RUNTIME_FIELDS[cls.__name__]

    fields = []
    seen = set()
    for base in cls.__mro__:
        slots = base.__dict__.get("__slots__", ())
        if isinstance(slots, str):
            slots = (slots,)
        for field in slots:
            if field not in ast.AstBase.__slots__ and field not in seen:
                fields.append(field)
                seen.add(field)
    return tuple(fields)


def _runtime_fields(cls):
    return set(_runtime_field_order(cls))


def _class_nodes(nodes):
    return {
        node.__name__: node
        for node in nodes.values()
        if isinstance(node, ClassNode)
    }


def _validate_runtime_field_overrides(class_nodes):
    runtime_classes = {
        name: cls
        for name, cls in ast.__dict__.items()
        if isinstance(cls, type) and cls is not ast.AstBase and ast.AstBase in cls.__mro__
    }
    if set(runtime_classes) != set(class_nodes):
        missing_from_master = sorted(set(runtime_classes) - set(class_nodes))
        missing_from_runtime = sorted(set(class_nodes) - set(runtime_classes))
        raise ValueError(
            "Runtime and master AST classes differ: "
            "runtime-only={}, master-only={}".format(
                missing_from_master, missing_from_runtime
            )
        )

    configured_additions = {}
    for (kind, field), _field_type in ADDITIONAL_FIELD_TYPES.items():
        configured_additions.setdefault(kind, set()).add(field)

    for kind, cls in runtime_classes.items():
        master_fields = {
            field
            for field, field_type, _description, _artificial, _parser_type
            in class_nodes[kind].fields
            if field_type is not master.location
        }
        runtime_fields = _runtime_fields(cls)
        expected_runtime_only = configured_additions.get(kind, set())
        expected_master_only = EXCLUDED_MASTER_FIELDS.get(kind, set())
        runtime_only = runtime_fields - master_fields
        master_only = master_fields - runtime_fields
        if runtime_only != expected_runtime_only or master_only != expected_master_only:
            raise ValueError(
                "{} field metadata differs: runtime-only={} (expected {}), "
                "master-only={} (expected {})".format(
                    kind,
                    sorted(runtime_only),
                    sorted(expected_runtime_only),
                    sorted(master_only),
                    sorted(expected_master_only),
                )
            )


def _type_name(field_type):
    if isinstance(field_type, PrimitiveNode):
        if field_type is master.location:
            return None
        try:
            return PRIMITIVE_LITERAL_KINDS[field_type.__name__]
        except KeyError:
            raise ValueError(
                "No literal kind configured for primitive '{}'".format(
                    field_type.__name__
                )
            )
    if isinstance(field_type, (ClassNode, UnionNode)):
        return field_type.__name__
    if isinstance(field_type, str):
        return field_type
    raise TypeError("Unsupported field type {!r}".format(field_type))


def _field_schema(kind, field, field_type):
    multiple = isinstance(field_type, (ListNode, _RepeatedType))
    item_type = field_type.item_type if multiple else field_type
    type_names = [_type_name(item_type)]
    if (kind, field) in FIELDS_WITH_NONE_ELEMENTS:
        type_names.append("none_literal")
    value = type_names[0] if len(type_names) == 1 else type_names
    suffix = "*" if multiple else "?"
    return field + suffix, value


def _fields_for_class(node):
    field_types = {}
    excluded = EXCLUDED_MASTER_FIELDS.get(node.__name__, set())
    for field, field_type, _description, _artificial, _parser_type in node.fields:
        if field in excluded or field_type is master.location:
            continue
        field_types[field] = FIELD_TYPE_OVERRIDES.get(
            (node.__name__, field), field_type
        )

    for (kind, field), field_type in ADDITIONAL_FIELD_TYPES.items():
        if kind == node.__name__:
            field_types[field] = field_type

    fields = {}
    runtime_class = getattr(ast, node.__name__)
    for field in _runtime_field_order(runtime_class):
        field_type = field_types[field]
        name, value = _field_schema(node.__name__, field, field_type)
        fields[name] = value
    return fields


def build_schema():
    nodes = master.all_nodes()
    class_nodes = _class_nodes(nodes)
    _validate_runtime_field_overrides(class_nodes)

    supertypes = {}
    for node in sorted(class_nodes.values(), key=lambda n: n._index):
        if node.subclasses:
            subtypes = [
                subtype.__name__
                for subtype in sorted(node.subclasses, key=lambda n: n._index)
            ]
            fields = _fields_for_class(node)
            supertypes[node.__name__] = (
                {"subtypes": subtypes, "fields": fields}
                if fields
                else subtypes
            )

    referenced_unions = set()
    for node in class_nodes.values():
        for _field, field_type, _description, _artificial, _parser_type in node.fields:
            item_type = field_type.item_type if isinstance(field_type, ListNode) else field_type
            if isinstance(item_type, UnionNode):
                referenced_unions.add(item_type)
    for union in sorted(referenced_unions, key=lambda n: n.__name__):
        supertypes[union.__name__] = [
            member.__name__ for member in sorted(union.types, key=lambda n: n._index)
        ]

    supertypes["literal"] = list(LITERAL_KINDS)

    named = {}
    for node in sorted(class_nodes.values(), key=lambda n: n._index):
        if not node.subclasses:
            named[node.__name__] = _fields_for_class(node)
    for kind in LITERAL_KINDS:
        named[kind] = None

    schema = {
        "supertypes": supertypes,
        "named": named,
    }
    _validate_type_references(schema)
    return schema


def _validate_type_references(schema):
    known_types = set(schema["supertypes"]) | set(schema["named"])
    for supertype, declaration in schema["supertypes"].items():
        members = (
            declaration["subtypes"]
            if isinstance(declaration, dict)
            else declaration
        )
        unknown = set(members) - known_types
        if unknown:
            raise ValueError(
                "Supertype '{}' refers to unknown types {}".format(
                    supertype, sorted(unknown)
                )
            )
        if isinstance(declaration, dict):
            _validate_field_type_references(
                supertype, declaration["fields"], known_types
            )
    for kind, fields in schema["named"].items():
        _validate_field_type_references(kind, fields, known_types)


def _validate_field_type_references(kind, fields, known_types):
    for field, field_types in (fields or {}).items():
        if isinstance(field_types, str):
            field_types = [field_types]
        unknown = set(field_types) - known_types
        if unknown:
            raise ValueError(
                "{}.{} refers to unknown types {}".format(
                    kind, field, sorted(unknown)
                )
            )


class _IndentedSafeDumper(yaml.SafeDumper):
    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)


def _represent_none(dumper, _value):
    return dumper.represent_scalar("tag:yaml.org,2002:null", "")


_IndentedSafeDumper.add_representer(type(None), _represent_none)


def render_schema():
    header = (
        "# Generated by `python3 -m semmle.python.legacy_ast_types_gen`.\n"
        "# Do not edit this file directly; update master.py, ast.py, or the generator instead.\n\n"
        "# Primitive values are represented by typed leaf nodes whose content is a string.\n"
        "# Singular fields are optional and list fields allow zero or more children because\n"
        "# master.py does not record field requiredness.\n\n"
    )
    return header + yaml.dump(
        build_schema(),
        Dumper=_IndentedSafeDumper,
        sort_keys=False,
        allow_unicode=True,
        width=100,
    )


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Generate the yeast schema for the legacy Python AST"
    )
    parser.add_argument(
        "output",
        nargs="?",
        type=Path,
        default=OUTPUT_PATH,
        help="output path (default: %(default)s)",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail if the output file is not up to date",
    )
    args = parser.parse_args(argv)

    generated = render_schema()
    if args.check:
        if not args.output.exists() or args.output.read_text(encoding="utf-8") != generated:
            parser.error("{} is not up to date".format(args.output))
        return

    args.output.write_text(generated, encoding="utf-8")


if __name__ == "__main__":
    main()
