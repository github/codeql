# YAML Node Types Format

The YAML node-types format is a human-friendly alternative to tree-sitter's
`node-types.json`. It can be converted to and from JSON using the
`node_types_yaml` tool.

## Overview

A YAML node-types file has three top-level sections:

```yaml
supertypes:
  # Abstract union types

named:
  # Concrete AST nodes and leaf tokens

unnamed:
  # Punctuation and keyword tokens
```

All three sections are optional. If omitted, they default to empty.

## Supertypes

Supertypes are abstract groupings of node types (unions). Each supertype maps
to a list of its members:

```yaml
supertypes:
  _expression:
    - assignment
    - binary
    - identifier
    - call
```

This corresponds to the following JSON:

```json
{
  "type": "_expression",
  "named": true,
  "subtypes": [
    { "type": "assignment", "named": true },
    { "type": "binary", "named": true },
    { "type": "identifier", "named": true },
    { "type": "call", "named": true }
  ]
}
```

Members are resolved as named or unnamed using the
[type reference rules](#type-references) described below.

## Named nodes

Named nodes are concrete AST node types. Each entry is a node kind mapping to
its fields. A node with no fields (a leaf token like `identifier`) uses an
empty value:

```yaml
named:
  identifier:
  constant:
```

```json
{"type": "identifier", "named": true, "fields": {}},
{"type": "constant", "named": true, "fields": {}}
```

### Fields

Each field has a name, a multiplicity suffix, and a list of allowed types.

| Suffix | Meaning      | JSON `multiple` | JSON `required` |
| ------ | ------------ | --------------- | --------------- |
| (none) | exactly one  | `false`         | `true`          |
| `?`    | zero or one  | `false`         | `false`         |
| `+`    | one or more  | `true`          | `true`          |
| `*`    | zero or more | `true`          | `false`         |

Example:

```yaml
named:
  assignment:
    left: _lhs
    right: _expression
```

```json
{
  "type": "assignment",
  "named": true,
  "fields": {
    "left": {
      "multiple": false,
      "required": true,
      "types": [{ "type": "_lhs", "named": true }]
    },
    "right": {
      "multiple": false,
      "required": true,
      "types": [{ "type": "_expression", "named": true }]
    }
  }
}
```

A field with multiple allowed types uses a list:

```yaml
named:
  binary:
    left: [_expression, _simple_numeric]
    operator: ["!=", "+", "&&"]
    right: _expression
```

A singleton list can be written as a bare value (as shown with `right` above).

### Unnamed children

Unnamed children (nodes that appear as children without a field name) are
specified using the special `$children` field name, with the same suffixes:

```yaml
named:
  argument_list:
    $children*: [_expression, block_argument, splat_argument]
```

```json
{
  "type": "argument_list",
  "named": true,
  "fields": {},
  "children": {
    "multiple": true,
    "required": false,
    "types": [
      { "type": "_expression", "named": true },
      { "type": "block_argument", "named": true },
      { "type": "splat_argument", "named": true }
    ]
  }
}
```

## Unnamed tokens

Unnamed tokens are punctuation, operators, and keywords that appear in the
parse tree but don't have their own AST node type. They are listed as simple
strings:

```yaml
unnamed:
  - "="
  - "end"
  - "+"
  - "&&"
```

```json
{"type": "=", "named": false},
{"type": "end", "named": false},
{"type": "+", "named": false},
{"type": "&&", "named": false}
```

When converting to YAML, unnamed tokens are always wrapped in quotes for
visual clarity. This is purely cosmetic — YAML treats `end` and `"end"` as
the same string.

## Type references

When a type name appears in a field's type list or a supertype's member list,
it needs to be resolved as either named or unnamed. The rules are:

1. If the name only appears in `named` or `supertypes`, it is **named**.
2. If the name only appears in `unnamed`, it is **unnamed**.
3. If the name appears in both, it defaults to **named**.
4. To explicitly reference an unnamed type in the ambiguous case, use the
   map form:

```yaml
named:
  example:
    field: { unnamed: foo }
```

In practice, ambiguity is rare — names like `end`, `+`, `if` are almost
always only unnamed, while names like `identifier`, `assignment` are only
named.

## Complete example

```yaml
supertypes:
  _expression:
    - assignment
    - binary
    - identifier

named:
  assignment:
    left: _expression
    right?: _expression
  binary:
    left: [_expression, _simple_numeric]
    operator: ["!=", "+"]
    right: _expression
  argument_list:
    $children*: [_expression, block_argument]
  identifier:
  constant:

unnamed:
  - "!="
  - "+"
  - "="
  - "end"
```

## CLI usage

Convert YAML to JSON:

```
node_types_yaml input.yaml > node-types.json
```

Convert JSON to YAML:

```
node_types_yaml --from-json node-types.json > node-types.yaml
```

Both commands also accept input from stdin if no file argument is given.
