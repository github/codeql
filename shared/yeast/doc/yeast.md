# YEAST — YEAST Elaborates Abstract Syntax Trees

YEAST is a framework for transforming tree-sitter parse trees before they are
extracted into a CodeQL database. It sits between the tree-sitter parser and
the TRAP extractor, rewriting parts of the AST according to declarative rules.

## Motivation

Tree-sitter grammars describe the **concrete syntax** of a language — every
keyword, operator, and punctuation token appears in the parse tree. CodeQL
analyses often prefer a **simplified abstract syntax** where syntactic sugar
has been removed. YEAST bridges this gap by desugaring the tree-sitter output
into a cleaner form before extraction.

For example, Ruby's `for x in list do ... end` is syntactic sugar for
`list.each { |x| ... }`. A YEAST rule can rewrite the former into the latter
so that CodeQL queries only need to reason about the `.each` form.

## Architecture

```
Source code
    │
    ▼
┌──────────────┐
│  tree-sitter │  Parse source into a concrete syntax tree
│    parser    │
└──────┬───────┘
       │ tree_sitter::Tree
       ▼
┌──────────────┐
│    YEAST     │  Apply desugaring rules, producing a new AST
│   Runner     │
└──────┬───────┘
       │ yeast::Ast
       ▼
┌──────────────┐
│    TRAP      │  Walk the (possibly rewritten) AST and emit TRAP tuples
│  extractor   │
└──────────────┘
```

The entry point is `extract()` in the shared tree-sitter extractor. When
called with a non-empty `rules` vector, the parsed tree is run through the
YEAST `Runner` before TRAP extraction; with an empty `rules` vector the
tree is extracted unchanged.

## How desugaring works

A YEAST `Rule` has two parts:

1. A **query** that matches nodes in the AST using a tree-sitter-inspired
   pattern language.
2. A **transform** that produces replacement nodes from the match captures.

The `Runner` applies rules by walking the tree top-down. At each node, it
tries each rule in order. If a rule's query matches, the node is replaced by
the transform's output, and the rules are re-applied to the result. If no
rule matches, the node is kept and its children are processed recursively.

A rule can replace one node with zero nodes (deletion), one node (rewriting),
or multiple nodes (expansion).

By default a rule fires **at most once on a given node**: after firing, the
engine will not re-try that same rule on the result root. Other rules may
still fire on the result, and the rule may still fire on different nodes
(including the result's children). To opt into iterative behaviour — when a
rule's output is intentionally re-matched by the same rule — call
`.repeated()` on the constructed `Rule`:

```rust
let r = yeast::rule!((foo ...) => (foo ...)).repeated();
```

Without `.repeated()`, a rule whose output happens to match its own query
simply fires once and stops. With `.repeated()`, the rule is allowed to
re-match indefinitely; the runner still enforces a global rewrite-depth
limit (currently 100) as a safety net against accidental cycles.

## Query language

Queries use a syntax inspired by
[tree-sitter queries](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/index.html),
written inside the `yeast::query!()` proc macro.

### Node patterns

```rust
// Match any named node
(_)

// Match a node of a specific kind
(assignment)

// Match an unnamed token by its text
("end")
```

### Fields

```rust
// Match a node with specific fields
(assignment
    left: (identifier) @lhs
    right: (_) @rhs
)
```

Fields are matched by name. Unmentioned fields are ignored — the pattern
`(assignment left: (_) @x)` matches any `assignment` node regardless of
what's in `right`.

### Captures

Captures bind matched nodes to names for use in the transform. A capture
`@name` always follows the pattern it captures:

```rust
(identifier) @name          // capture an identifier node
(_) @value                  // capture any named node
(identifier)* @items        // capture each repeated match
("=") @op                   // capture an unnamed token by its text
"=" @op                     // shorthand for the line above
_ @anything                 // capture any node, named or unnamed
```

### Named vs unnamed children

The two wildcard forms `(_)` and bare `_` differ:

- `(_)` matches only **named** nodes. When used as a positional pattern,
  unnamed children (keywords, operators, punctuation) are skipped over.
- Bare `_` matches **any** node, named or unnamed, taking whatever is next
  in the child list.

Bare child patterns are matched **forward-scan**: each pattern advances
through the iterator until it finds a child that matches, skipping
non-matching children along the way. So `(foo ("baz"))` against a `foo`
whose children are `[bar, baz]` succeeds — the matcher scans past `bar`
and matches `baz`. The iterator advances as it goes, so subsequent
patterns can never match children that appear earlier in source order
than already-matched ones.

For named-only patterns (`(_)`, `(some_kind ...)`), the scan additionally
skips past unnamed tokens without trying to match them, since they can
never match anyway.

Anchors (`.`) for forcing immediate adjacency, like in tree-sitter
queries, are not supported.

```rust
(for
    pattern: (_) @pat             // named field, captures any named node
    value: (in (_) @val)          // "in" wrapper is a named node here
    body: (do (_)* @body)         // "do" and "end" tokens skipped by (_)
)
```

### Repetitions

```rust
(_)*                   // zero or more
(_)+                   // one or more
(_)?                   // zero or one
(identifier)* @names   // capture each repeated match
```

## Template language

Templates construct new AST nodes using the `tree!` and `trees!` macros.
All children in a template must be in named fields — output AST nodes are
always fully fielded.

When used inside a `rule!` macro, the context is implicit — no explicit
`BuildCtx` argument is needed. When used standalone, they take a `BuildCtx`
as the first argument:

```rust
// Inside rule! — implicit context, captures are Rust variables
yeast::rule!(
    (assignment left: (_) @left right: (_) @right)
    =>
    (assignment left: {right} right: {left})
);

// Standalone — explicit context
let fresh = yeast::tree_builder::FreshScope::new();
let mut ctx = BuildCtx::new(ast, &captures, &fresh);
let id = yeast::tree!(ctx,
    (assignment
        left: {ctx.capture("lhs")}
        right: {ctx.capture("rhs")}
    )
);
```

### `tree!` — build a single node

`tree!(...)` returns a single node `Id`:

```rust
yeast::tree!(ctx,
    (assignment
        left: {ctx.capture("lhs")}
        right: {ctx.capture("rhs")}
    )
)
```

### `trees!` — build multiple nodes

`trees!(...)` returns `Vec<Id>`:

```rust
yeast::trees!(ctx,
    (assignment left: {tmp} right: {right})
    {..body}
)
```

### Literal nodes

`(kind "text")` creates a leaf node with fixed text content:

```rust
(identifier "each")          // an identifier node whose text is "each"
```

### Computed literals

`(kind #{expr})` creates a leaf node whose content is `expr.to_string()`:

```rust
(integer #{i})               // an integer node with the value of i
(identifier #{name})         // an identifier from a Rust variable
```

### Fresh identifiers

`(kind $name)` creates a leaf node with an auto-generated unique name. All
occurrences of the same `$name` within one `BuildCtx` share the same value:

```rust
(block
    parameters: (block_parameters
        (identifier $tmp)         // generates e.g. "$tmp-0"
    )
    body: (block_body
        (assignment
            left: {pat}
            right: (identifier $tmp)   // same "$tmp-0" value
        )
    )
)
```

### Embedded Rust expressions

`{expr}` embeds a Rust expression that returns a single node `Id`:

```rust
(assignment
    left: {some_node_id}       // insert a pre-built node
    right: {rhs}               // insert a captured value (inside rule!)
)
```

The contents of `{…}` are treated as a Rust block, so multi-statement
expressions (with `let` bindings) work too:

```rust
(assignment
    left: {tmp}
    right: {
        let lit = ctx.literal("integer", "0");
        tree!((binary_expr op: (operator "+") left: {tmp} right: {lit}))
    })
```

`{..expr}` splices a `Vec<Id>` (or any iterable of `Id`); the contents
are likewise a Rust block, so the splice can be the result of arbitrary
computation:

```rust
yeast::trees!(ctx,
    (assignment left: {tmp} right: {right})
    {..extra_nodes}                        // splice a Vec<Id>
)
```

Inside `rule!`, captures are Rust variables, so `{name}` inserts a
single capture (`Id`) and `{..name}` splices a repeated capture
(`Vec<Id>`).

### Raw captures (`@@name`)

The default `@name` capture marker is *auto-translated*: in OneShot
phases the macro recursively translates the captured node before
binding it, so `{name}` in the output template splices a node that
already conforms to the output schema.

For rules that need the raw (input-schema) capture — typically to read
its source text or to translate it explicitly with mutable context
state between calls — use `@@name` instead. The body sees the original
input-schema `Id`:

```rust
yeast::rule!(
    (assignment left: (_) @@raw_lhs right: (_) @rhs)
    =>
    {
        // raw_lhs is untranslated: read its original source text.
        let text = ctx.ast.source_text(raw_lhs.into());
        // rhs is already translated by the auto-translate prefix.
        tree!((call
            method: (identifier #{text.as_str()})
            receiver: {rhs}))
    }
);
```

Mix `@` and `@@` freely in the same rule. In a Repeating phase both
markers are equivalent (auto-translation is a no-op for repeating
rules).

## Complete example: for-loop desugaring

This rule rewrites Ruby's `for pat in val do body end` into
`val.each { |tmp| pat = tmp; body }`:

```rust
let for_rule = yeast::rule!(
    (for
        pattern: (_) @pat
        value: (in (_) @val)
        body: (do (_)* @body)
    )
    =>
    (call
        receiver: {val}
        method: (identifier "each")
        block: (block
            parameters: (block_parameters
                (identifier $tmp)
            )
            body: (block_body
                (assignment
                    left: {pat}
                    right: (identifier $tmp)
                )
                {..body}
            )
        )
    )
);
```

Captures from the query (`@pat`, `@val`, `@body`) become Rust variables
automatically: single captures bind as `Id`, repeated captures (after
`*` or `+`) as `Vec<Id>`, and optional captures (after `?`) as
`Option<Id>`.

## The `rule!` macro

`rule!` combines a query and a transform into a single declaration:

```rust
// Full template form
yeast::rule!(
    (query_pattern field: (_) @capture)
    =>
    (output_template field: {capture})
)

// Shorthand form — captures become fields on the output node
yeast::rule!(
    (query_pattern field: (_) @capture)
    => output_kind
)
```

The shorthand `=> kind` form auto-generates the template, mapping each
capture name to a field of the same name on the output node.

## Integration with the extractor

A YEAST desugaring pass is configured with a [`DesugaringConfig`], which
carries one or more named [`Phase`]s of rules and an optional output
node-types schema (in YAML format). Each phase is a complete traversal
that runs to completion before the next phase starts; only the current
phase's rules are considered during that traversal. Attach the config to
a language spec
to enable rewriting:

```rust
let desugar = yeast::DesugaringConfig::new()
    .add_phase("cleanup", yeast::PhaseKind::Repeating, cleanup_rules())
    .add_phase("translate", yeast::PhaseKind::OneShot, translate_rules())
    .with_output_node_types_yaml(include_str!("output-node-types.yml"));

let lang = simple::LanguageSpec {
    prefix: "ruby",
    ts_language: tree_sitter_ruby::LANGUAGE.into(),
    node_types: tree_sitter_ruby::NODE_TYPES,
    desugar: Some(desugar),
    file_globs: vec!["*.rb".into()],
};
```

A single-phase config is just `.add_phase(...)` called once. Phase names
appear in error messages so you can tell which phase failed.

There are two kinds of phases:
- **Repeating**:
    Each node is re-processed until none of the rules in the phase matches.
    When a node no longer matches any rules, its children are recursively processed. In practice this is used to desugar or simplify an AST, while staying mostly within the same schema.
- **One-shot**:
    Each node is processed by the first matching rule, and the engine panics if no rule matches.
    Rules are then recursively applied to every captured node.
    In practice this is used when translating from one AST schema to another, where an exhaustive match is required.

The same YAML node-types is used for both the runtime yeast `Schema` (so
rules can refer to output-only kinds and fields) and TRAP validation (it
is converted to JSON internally).

For the dbscheme/QL code generator, set `Language::desugar` to a
`DesugaringConfig` carrying the same YAML; the generator converts it to
JSON for downstream code generation. The `phases` field of the config is
unused at code-generation time.
