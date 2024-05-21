# `tsg-python`

Run `tree-sitter-graph` queries against Python source files.

## How to build

Run `cargo build --release`. The resulting binary can be found in the `target/release` directory.

## How to invoke

`tsg-python tsg-file.tsg python-file.py`

Output is emitted on `stdout`.

If you're impatient, you can also build and run using `cargo run` followed by the arguments given
above.

## How to use

To use `tsg-python`, you must have an appropriate `.tsg` file containing the directions for how to
construct a Python AST from the output of `tree-sitter-python`.

### A quick primer on `tree-sitter-graph` syntax

A file consists of a sequence of stanzas. Each stanza consists of a query (using the [tree-sitter
query syntax](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries)) and a sequence of nodes and edges to define for each query match in the source file.
Queries will (almost always) include captures like `@foo`, which means any occurrence of `@foo` in
the corresponding stanza will refer to a particular syntax node in the bit that the query matches.

Stanzas are executed in order, and a stanza is only run when all possible matches have been
exhausted for all preceding stanzas. (Since the syntax tree that is matched against never changes,
execution never jumps back to an earlier stanza.)

Inside stanzas, scoped variables have the form `@foo.bar` where `@foo` is a capture in the
associated query, and `bar` is an identifier. This should be thought of as a variable that is
"attached" to the `tree-sitter` node that `@foo` refers to. If `@baz` is another reference to the same node as
`@foo` (perhaps even in a different stanza), then `@baz.bar` will be a reference to the _same_
scoped variable. This permits information to be linked across different stanzas.

Assigning a value to a scoped variable is done using the syntax `let @foo.bar = some-expr` (`let`
for immutable variables, `var` for mutable variables, which may be mutated using `set`). Note that
scoped variables only exist during the execution of the stack graph, and are not immediately part of
the output graph. 

To actually produce output, we must specify some `node`s or `edge`s and possibly `attr`ibutes
thereof.

To produce a node, we declare `node @foo.bar` (which is equivalent to `let @foo.bar = (node)`, the
right hand side being a function that creates a new node). In the output, nodes are simply integers.

To assign an attribute to a node, we write `attr (@foo.bar) identifier = expr`, for some suitable
choice of `identifier` and `expr`. In the output, attributes are given alongside nodes in a `key:
value` notation.

For edges and their attributes, the syntax is similar:

`edge @foo.bar -> @baz.quux`

and

`attr (@foo.bar -> @baz.quux) identifier = expr`.

Note that it is an error to declare the same node, edge, (or attribute of either of these) twice. 

### The general scheme:


For fields that point to some literal value
```tsg
<some capture involving @nd>
{
    attr (@nd.node) field_name = some_value
}
```

For fields that point directly to an AST node:

```tsg
<some capture involving @parent and @child>
{
    attr (@parent.node) field_name = @child.node
}
```

For fields that point to lists of AST nodes:

```tsg
<some capture involving @parent and @child>
{
    edge @parent.node -> @child.node
    attr (@parent.node -> @child.node) field_name = <index of @child in the resulting list>
}
```

Scoped variables of the form `@foo.node` are used to tie the AST together, and so it's important
that this is set for nodes that map directly onto `tree-sitter-python` nodes. Thus, for instance 
for binary operators, the stanza could look as follows:

```tsg
(binary_operator
    left: (_) @left
    right: (_) @right
) @bin
{
    attr (@bin.node) left = @left.node
    attr (@bin.node) right = @right.node
}
```

Note in particular the `@left.node` and `@right.node` references. In order for the above stanza to
work, these scoped variables _must_ exist and point to suitable graph `node`s. 

In practice, the setting up of all of these scoped variables (and creation of output graph nodes)
will happen at the very top of the `.tsg` file, to ensure that these scoped variables are defined
for the remainder of the file.

To ease the creation of these variables, we have the `ast-node` convenience function. For binary
operators, it would take the following form:

```tsg
(binary_operator) @bin
{
    let @bin.node = (ast-node @bin "BinOp")
}
```
Here, the two arguments are respectively
- a `tree-sitter` node (which is used to set the location of `@bin.node`), and
- a string (which is used to set the "kind" of `@bin.node`)

In effect, the call 

```tsg
    let @bin.node = (ast-node @bin "BinOp")
```

is exactly equivalent to the more verbose

```tsg
    node @bin.node ; or equivalently `let @bin.node = (node)`
    attr (@bin.node) _location = (location @bin)
    attr (@bin.node) _kind = "BinOp"
```

As the above suggests, attributes that start with an underscore are interpreted in a special way
when reconstructing the AST. 

### Special attributes

#### The `_kind` attribute (mandatory)
Should be set to a string consisting of the name of the corresponding Python AST class. This
information will be used to build the AST, and so it is an error if this is left out.

Generally, this (and `_location`) will be set using the `ast-node` function.

#### The `_skip_to` attribute (optional)
This is used to indicate that the present graph node should _not_ be turned into an AST node, but that the
graph node contained in this attribute should be used instead. That graph node may _also_ contain a
`_skip_to` field, in which case the entire chain is followed until a node is encountered that does
not have a `_skip_to` field. (Please ensure that there are no cycles of `_skip_to` pointers.)

Example:

In `tree-sitter-python`, assignment statements are a form of `expression_statement`, and this node
type also encompasses things like expressions (e.g. `2+2`) appearing at the level of statements. In
the internal Python AST, we need to separate the assignment from such expressions. The assignment should be present as an `Assign` node, but `2+2` should be
wrapped in an `Expr` node. To solve this, we create an `Expr` for each `expression_statement`, and
then explicitly skip this node in the AST if it contains an `assignment`. This is implemented as
follows:
```tsg
(expression_statement (assignment) @inner) @outer
{
    attr (@outer.node) _skip_to = @inner.node
}
```

#### The `_location` attribute (optional)
This attribute is used to indicate the location of the corresponding AST node. As with `_kind` it
should be set using the `ast-node` function.

#### The `_location_start` and `_location_end` attributes (optional)
These attributes are used to indicate the start or end of the location of the AST node. They can be
used for nodes where `_location` has already been set, in which case they override the relevant part
of that location. For an example of this see the worked example on `if` statements below.
#### The `_start_line`, `_start_column`, `_end_line`, and `_end_column` attributes (optional)
These can be used to set the start or end position of an AST node with even greater detail than the
preceding attributes. As with the `_location_start` and `_location_end` attributes, these will
override the values of the corresponding part of the location.

In general, these attributes should be used sparingly, as they are quite verbose.

### Built-in functions
#### `(source-text` _`tree-sitter-node`_`)` (built-in)
This function returns the source text of the `tree-sitter` node it receives as an argument. 

Example:

Extracting the operator from a binary expression:
```tsg
(binary_operator
    operator: _ @op
) @bin
{
    attr (@bin.node) op = (source-text @op)
}
```

#### `(ast-node` _`tree-sitter-node`_ _`string`_`)` (`tsg-python` only)
Creates a new graph node with the given `_kind` and sets the `_location` attribute to the location
of the given `tree-sitter` node.
#### `(child-index` _`tree-sitter-node`_`)` (built-in)
Returns the index of the given `tree-sitter` node in its parent.
#### `(location` _`tree-sitter-node`_`)` (`tsg-python` only)
Returns the location of the given `tree-sitter` node as a list containing four integers
corresponding to the start row and column, followed by the end row and column.
#### `(location-start` _`tree-sitter-node`_`)` and `(location-end` _`tree-sitter-node`_`)` (`tsg-python` only)
Returns the start or end position (row followed by column) of the given `tree-sitter` node (as a list containing two integers).
#### `start-row`, `start-column`, `end-row`, and `end-column` (built-in)
(All of these take a `tree-sitter-node` as an argument.)

Returns an integer corresponding to the appropriate part of the location of the given `tree-sitter` node.

### A worked example: `if` statements

The way the current parser handles `if` statements means we cannot do a straight mapping from the tree-sitter grammar to the AST. In particular, a block of code such as 

```python
if x: do_x
elif y: do_y
elif z: do_z
else: do_else
```

is unrolled into the following form by the current parser:

```python
if x: do_x
else:
    if y: do_y
    else:
        if z: do_z
        else: do_else
```

This means we have to synthesise nodes for the inner `if` statements.

However, this should be straightforward -- we simply have to make sure that `elif_clause`s also
produce the appropriate kind of node, and that everything is linked up correctly.

For references, here are the productions for `if_statement`, `else_clause` and `elif_clause` in
`tree-sitter-python`

```javascript
    if_statement: $ => seq(
      'if',
      field('condition', $.expression),
      ':',
      field('consequence', $._suite),
      repeat(field('alternative', $.elif_clause)),
      optional(field('alternative', $.else_clause))
    ),

    elif_clause: $ => seq(
      'elif',
      field('condition', $.expression),
      ':',
      field('consequence', $._suite)
    ),

    else_clause: $ => seq(
      'else',
      ':',
      field('body', $._suite)
    ),
```

First, we'll set up all of the relevant nodes with corresponding nodes in the AST:

```tsg

(if_statement)
@tree_sitter_node
{
    let @tree_sitter_node.node = (ast-node @tree_sitter_node "If")
}
```

This ensures that we can reference the `.node` scoped variable on the above nodes.

(We named the capture `@tree_sitter_node` above to make it more clear, but in general something like
`@if` would be more appropriate.)

In particular, since we want `elif`s to be turned into nested `if`s, it makes sense to apply the
`If` kind to `elif_clauses` as well:

```tsg
(elif_clause) @elif
{
    let @elif.node = (ast-node @elif "If")
}
```
Whenever we refer to a node, we must ensure that it has first been defined, however there is no
need to do this separately for each node. 

Next, for both `if`s and `elif`s, we want to record the `test` and the `body`. The `test` we do as follows:

```tsg
[
    (if_statement
        condition: (_) @test) @if
    (elif_clause
        condition: (_) @test) @if
]
{
    attr (@if.node) test = @test.node
}
```
For `body`, in the Python AST this is simply a list of nodes, whereas for the `tree-sitter` parse tree, it
will contain a `block` node. Because there is no Python AST equivalent for `block`, we skip over
this node when linking the `if`-statement to its body:
```tsg
[
    (if_statement
        consequence: (block (_) @stmt)) @parent
    (elif_clause
        consequence: (block (_) @stmt)) @parent    
]
{
    edge @parent.node -> @stmt.node
    attr (@parent.node -> @stmt.node) body = (child-index @stmt)
}
```
The above shows how we handle fields containing lists of items: we add an edge from the parent node
to each child node, and put an attribute on that edge. The name of the attribute will be the name of
the field, and the value will be the index of this node among the children of its `tree-sitter` parent.

Now we can begin unwinding the nesting. First of all, the first `elif` should be the `orelse` of the
initial `if_statement`:

```tsg
(if_statement 
    consequence: (_)
    . 
    (elif_clause) @elif
) @if
{
    edge @if.node -> @elif.node
    attr (@if.node -> @elif.node) orelse = 0
}
```
(The `.` acts as an anchor, forcing its two neighbours to be adjancent in the tree. So in this case,
we get the first `elif` after the body of the `if`)

Next, whenever we have two adjacent `elif`s, we want the `orelse` of the first one to be the second one:

```tsg
(
    (elif_clause) @elif1
    .
    (elif_clause) @elif2
)
{
    edge @elif1.node -> @elif2.node
    attr (@elif1.node -> @elif2.node) orelse = 0
}
```

Finally, the `else` branch of the outermost `if` should be the `orelse` of the _last_ `elif`:

```tsg
(if_statement 
    (elif_clause) @elif 
    .
    alternative: (else_clause body: (block (_) @orelse))
)
{
    edge @elif.node -> @orelse.node
    attr (@elif.node -> @orelse.node) orelse = (child-index @orelse)
}
```

The above gives us the correct tree structure, but we're still missing a few bits (such as
locations). To capture location information we use the following stanza:
```tsg
[
    (if_statement 
        condition: (_) 
        ":" @colon) @if
    (elif_clause
        condition: (_)
        ":" @colon) @if
]
{
    attr (@if.node) _location_end = (location-end @colon)
}
```
Because `tree-sitter-python` disagrees with the Python AST about the location of the `If` node, we
have to adjust it. We do this by setting the `_location_end` attribute to the end of the `:` token.
(Note that the _start_ of this location was set when we called `ast-node` above. As we don't have to
change this part of the location, we simply leave it as is.)



### Synthesizing nodes
In many cases it will be sufficient to hook up AST nodes to the corresponding `tree-sitter` nodes,
but occasionally we want the tree structure to be different. One example of this would be the
`class` statement. For instance, a class declaration such as

```python
class Foo(int, object, metaclass=type):
    x = 5
```

has a `tree-sitter-python` parse tree that looks like this:

```
module [0, 0] - [2, 0]
  class_definition [0, 0] - [1, 9]
    name: identifier [0, 6] - [0, 9]
    superclasses: argument_list [0, 9] - [0, 38]
      identifier [0, 10] - [0, 13]
      identifier [0, 15] - [0, 21]
      keyword_argument [0, 23] - [0, 37]
        name: identifier [0, 23] - [0, 32]
        value: identifier [0, 33] - [0, 37]
    body: block [1, 4] - [1, 9]
      expression_statement [1, 4] - [1, 9]
        assignment [1, 4] - [1, 9]
          left: identifier [1, 4] - [1, 5]
          right: integer [1, 8] - [1, 9]
```

but the Python AST looks like _this_:

```
Module: [1, 0] - [3, 0]
  body: [
    Assign: [1, 0] - [1, 39]
      targets: [
        Name: [1, 6] - [1, 9]
          variable: Variable('Foo', None)
          ctx: Store
      ]
      value:
        ClassExpr: [1, 0] - [1, 39]
          name: 'Foo'
          bases: [
            Name: [1, 10] - [1, 13]
              variable: Variable('int', None)
              ctx: Load
            Name: [1, 15] - [1, 21]
              variable: Variable('object', None)
              ctx: Load
          ]
          keywords: [
            keyword: [1, 23] - [1, 37]
              arg: 'metaclass'
              value:
                Name: [1, 33] - [1, 37]
                  variable: Variable('type', None)
                  ctx: Load
          ]
          inner_scope:
            Class: [1, 0] - [1, 39]
              name: 'Foo'
              body: [
                Assign: [2, 4] - [2, 9]
                  targets: [
                    Name: [2, 4] - [2, 5]
                      variable: Variable('x', None)
                      ctx: Store
                  ]
                  value:
                    Num: [2, 8] - [2, 9]
                      n: 5
                      text: '5'
              ]
  ]
```

In particular, we unroll the `class` statement into an explicit assignment (which is the top node
for this statement in the AST) of a synthetic `ClassExpr`, which in turn contains a `Class` node
(which holds things like the body of the class). This requires too many nodes to simply reuse what's given to
us by `tree-sitter-python`, and so we must _synthesize_ additional nodes.

First of all, let us set up the outer node to be an `Assign` node:
```tsg
(class_definition) @class
{
    let @class.node = (ast-node @class "Assign")
}
```

Next, we can do most of the work in a single stanza:

```tsg
(class_definition 
    name: (identifier) @name
    ":" @colon
) @class
{

    ; To make it clearer that the outer node is an assignment, we create an alias for it.
    let @class.assign = @class.node

    ; Synthesized nodes: the left-hand side of the assignment, the class_expr node, and the class
    ; node.

    let @class.assign_lhs = (ast-node @name "Name")
    let @class.class_expr = (ast-node @class "ClassExpr")
    let @class.inner_scope = (ast-node @class "Class")

    edge @class.assign -> @class.assign_lhs
    attr (@class.assign -> @class.assign_lhs) targets = 0
    attr (@class.assign) value = @class.class_expr
    attr (@class.assign) _location_end = (location-end @colon)

    let class_name = (source-text @name)

    ; The left-hand side of the assignment, a `Name`.
    attr (@class.assign_lhs) variable = class_name
    attr (@class.assign_lhs) ctx = "store"

    ; The right hand side of the assignment, a `ClassExpr`.
    attr (@class.class_expr) name = class_name
    attr (@class.class_expr) inner_scope = @class.inner_scope
    ; `bases` will be set elsewhere
    ; `keywords` will be set elsewhere
    attr (@class.class_expr) _location_end = (location-end @colon)

    ; The inner scope of the class_expr, a `Class`.
    attr (@class.inner_scope) name = class_name
    ; body will be set in a separate stanza.
    attr (@class.inner_scope) _location_end = (location-end @colon)

}
```

Let's go over these lines bit by bit. First, we create an alias for the outermost node (which will
become an assignment node) in order to make it clearer that it's an assignment. Next, we create
_new_ nodes for the inner synthesized nodes. Note that we can't assign these to `@class.node` as
that already points to the node that will become the assignment node. Instead, we create new scoped
variables (with suitable names), and assign them nodes (with appropriate kinds and locations using
`ast-node`).
```tsg
    ; To make it clearer that the outer node is an assignment, we create an alias for it.
    let @class.assign = @class.node

    ; Synthesized nodes: the left-hand side of the assignment, the class_expr node, and the class
    ; node.

    let @class.assign_lhs = (ast-node @name "Name")
    let @class.class_expr = (ast-node @class "ClassExpr")
    let @class.inner_scope = (ast-node @class "Class")
```

Next, we set up the outer assignment:
```tsg
    edge @class.assign -> @class.assign_lhs
    attr (@class.assign -> @class.assign_lhs) targets = 0
    attr (@class.assign) value = @class.class_expr
    attr (@class.assign) _location_end = (location-end @colon)
```

The remaining nodes all contain a field that refers to the name of the class, so put this in a local
variable for convenience:
```tsg
    let class_name = (source-text @name)
```
We set up the left hand side of the assignment:
```tsg
    ; The left-hand side of the assignment, a `Name`.
    attr (@class.assign_lhs) variable = class_name
    attr (@class.assign_lhs) ctx = "store"
```
The `ClassExpr`:
```tsg
    ; The right hand side of the assignment, a `ClassExpr`.
    attr (@class.class_expr) name = class_name
    attr (@class.class_expr) inner_scope = @class.inner_scope
    ; `bases` will be set elsewhere
    ; `keywords` will be set elsewhere
    attr (@class.class_expr) _location_end = (location-end @colon)
```

The `Class`:
```tsg
    ; The inner scope of the class_expr, a `Class`.
    attr (@class.inner_scope) name = class_name
    ; body will be set elsewhere
    attr (@class.inner_scope) _location_end = (location-end @colon)

```

The remaining stanzas take care of setting up the fields that contain lists of nodes, and these
follow the same scheme as before.
```tsg
; Class.body
(class_definition
    body: (block (_) @stmt)
) @class
{
    edge @class.inner_scope -> @stmt.node
    attr (@class.inner_scope -> @stmt.node) body = (child-index @stmt)
}

; Class.bases
(class_definition
    superclasses: (argument_list (identifier) @arg)
) @class
{
    edge @class.class_expr -> @arg.node
    attr (@class.class_expr -> @arg.node) bases = (child-index @arg)
    attr (@arg.node) ctx = "load"
}

; Class.keywords
(class_definition
    superclasses: (argument_list (keyword_argument) @arg)
) @class
{
    edge @class.class_expr -> @arg.node
    attr (@class.class_expr -> @arg.node) keywords = (child-index @arg)
}
```
