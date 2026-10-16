use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;

mod ast;
mod lower;
mod parse;
mod rule_parse;
mod template_parse;

/// Proc macro for constructing a tree-sitter-inspired `yeast::query::QueryNode`.
///
/// # Syntax
///
/// ```text
/// (_)                          - match any named node (skips unnamed tokens)
/// _                            - match any node, named or unnamed
/// (kind)                       - match a named node of the given kind
/// ("literal")                  - match an unnamed token by its text
/// "literal"                    - shorthand for `("literal")`
/// (kind field: (pattern))      - match with named field
/// (kind field: _)              - bare `_` and bare literals work in field position too
/// (kind (pat) (pat)...)        - match unnamed children
/// (pattern) @capture           - capture the matched node
/// "literal" @capture           - capture an unnamed token
/// _ @capture                   - capture any node
/// (kind)* @capture             - capture each repeated named-node match
/// "literal"* @capture          - capture each repeated unnamed-token match
/// (kind)?                      - zero or one named node
/// ```
///
/// Named fields and bare child patterns may be intermixed in any order.
///
/// A parenthesized query whose first element is a node kind is always parsed as
/// that node pattern. Otherwise, two or more sibling patterns form a sequence.
/// A sequence may be repeated, but cannot itself be captured because it does
/// not represent one node:
///
/// ```text
/// ((identifier) @items (integer) @items)*  // valid: explicit node captures
/// ((identifier) (integer))* @items         // invalid: sequence capture
/// ("+" ",")*                               // valid: repeated token sequence
/// (_ ",")*                                 // valid: repeated wildcard/token sequence
/// ```
#[proc_macro]
pub fn query(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_query_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Build a single AST node from a template, returning its `OutputId`.
///
/// A top-level choice returns `Option<OutputId>`.
///
/// # Template syntax
///
/// ```text
/// (kind "literal")             - leaf with static content
/// (kind #{expr})               - leaf with computed content (expr.to_string())
/// {expr}                       - embed a Rust expression, dispatched via
///                                the `IntoFieldIds` trait: `OutputId` pushes a
///                                single id; iterables (`Vec<OutputId>`,
///                                `Option<OutputId>`, iterator chains) splice
///                                their elements
/// field: {expr}                - extend a named field with `{expr}`'s ids
/// location: {expr}             - override this node's source range with the
///                                span of one or more nodes; may be repeated
/// field: [(kind ...)]          - set the field only if the alternative can
///                                be constructed (see below)
/// field: [(a) (b)]             - use the first constructible alternative
/// field: [(a) if {guard} (b)]  - skip an alternative when its guard is false
/// ```
///
/// # Template choices
///
/// Brackets contain one or more ordered alternatives. For each alternative,
/// its optional `if {guard}` is evaluated first, followed by every `#{expr}`
/// dependency beneath it. An absent dependency — an `Option` that is `None` —
/// skips the alternative without constructing any of its template nodes. The
/// first alternative whose guard and dependencies succeed is constructed:
///
/// ```text
/// (break_expr label: {lbl.map(|l| tree!((identifier #{l})))})   // before
/// (break_expr label: [(identifier #{lbl})])                     // after
/// ```
///
/// Dependencies may be nested arbitrarily deeply. A nested choice handles its
/// own dependencies, so an inner absent value need not discard an outer node:
///
/// ```text
/// (parameter pattern: [
///     (name_pattern identifier: [(identifier #{name})])
/// ] type: {ty})
/// ```
///
/// Only `#{expr}` is treated as a dependency. A `{expr}` splice is unaffected,
/// since yielding no ids already leaves its field unset. Outside a choice,
/// interpolating an `Option` with `#{expr}` remains a compile error.
///
/// A choice used as a field or list item contributes zero or one node. A
/// top-level choice passed to `tree!` returns `Option<OutputId>`; ordinary
/// templates continue to return `OutputId`.
///
/// Uses the `BuildCtx` binding named `ctx` from the surrounding scope:
///
/// ```text
/// tree!((kind ...))
/// ```
#[proc_macro]
pub fn tree(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_tree_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Build a list of AST nodes from a template, returning `Vec<OutputId>`.
///
/// Like `tree!` but returns `Vec<OutputId>` and supports multiple top-level
/// elements. All syntax from `tree!` is available.
///
/// Uses the `BuildCtx` binding named `ctx` from the surrounding scope:
///
/// ```text
/// trees!((node1 ...) (node2 ...))
/// ```
#[proc_macro]
pub fn trees(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_trees_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Define a desugaring rule with query and transform in one declaration.
///
/// ```text
/// rule!(
///     (query_pattern field: (_) @name (kind)* @repeated (_)? @optional)
///     =>
///     (output_template field: {name} {repeated})
/// )
///
/// // A guard filters a successful query match. Every capture is raw in the
/// // guard because guards run before capture translation.
/// rule!(
///     (query_pattern field: _? @value)
///     where value.is_none()
///     =>
///     (output_template)
/// )
///
/// ```
///
/// Captures become Rust variables automatically:
/// - `@name` (no quantifier) → `name: OutputId`
/// - `@name` (after `*`/`+`) → `name: Vec<OutputId>`
/// - `@name` (after `?`) → `name: Option<OutputId>`
///
/// Raw `@@name` captures use the corresponding input `Id` types instead.
///
/// A guard is an optional Rust condition between the query and `=>`. It is
/// evaluated after the query matches and before any `@` captures are
/// translated. Returning false makes the driver try the next rule. All
/// captures are therefore raw in the guard; `@` versus `@@` controls only
/// whether the capture is translated for the transform. `ctx` provides
/// mutable user-context access, and `ast` provides read-only AST access.
/// Mutations to `ctx` are visible to the transform when the guard succeeds.
/// Omitting the guard is equivalent to writing `where true`.
///
/// `tree!` and `trees!` use the rule transform's `ctx` binding inside `{...}`.
#[proc_macro]
pub fn rule(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_rule_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Bundle a list of YEAST rewrite rules with input/output node-types
/// schema paths. Returns a `Vec<Rule>`; substitutable for
/// `vec![rule!(...), ...]`.
///
/// Each comma-separated item in the bracketed list may be:
///
/// 1. A **bare rule body** `(query) => (template)` — the `rule!(...)`
///    wrapper is implicit.
/// 2. An explicit `rule!(...)` invocation, possibly path-prefixed as
///    `yeast::rule!(...)`.
/// 3. Any other expression returning a `Rule` (helper-function calls,
///    conditionals).
///
/// ```ignore
/// let translation_rules: Vec<yeast::Rule> = yeast::rules! {
///     input: "tree-sitter-swift/node-types.yml",
///     output: "ast_types.yml",
///     [
///         (source_file (_)* @cs) => (top_level body: {..cs}),
///         (simple_identifier) @@id => (name_expr identifier: (identifier #{id})),
///         rule!((integer_literal) @@lit => (int_literal #{lit})),
///         helper_fn(),
///     ]
/// };
/// ```
///
/// Paths are resolved relative to the consuming crate's `CARGO_MANIFEST_DIR`
/// (the same convention `include_str!` uses for relative paths). The
/// resolved paths are also emitted as `include_str!` references so the
/// consuming crate gets invalidated when a schema YAML changes, prepping
/// the ground for compile-time type-checking against those schemas.
#[proc_macro]
pub fn rules(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_rules_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}
