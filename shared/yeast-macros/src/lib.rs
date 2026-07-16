use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;

mod parse;

/// Proc macro for constructing a `QueryNode` from a tree-sitter-inspired pattern.
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
/// (pattern)* @capture          - capture each repeated match
/// (pattern)?                   - zero or one
/// ```
///
/// Named fields and bare child patterns may be intermixed in any order.
#[proc_macro]
pub fn query(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_query_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Build a single AST node from a template, returning its `Id`.
///
/// # Template syntax
///
/// ```text
/// (kind "literal")             - leaf with static content
/// (kind #{expr})               - leaf with computed content (expr.to_string())
/// (kind $fresh)                - leaf with auto-generated unique name
/// {expr}                       - embed a Rust expression, dispatched via
///                                the `IntoFieldIds` trait: `Id` pushes a
///                                single id; iterables (`Vec<Id>`,
///                                `Option<Id>`, iterator chains) splice
///                                their elements
/// field: {expr}                - extend a named field with `{expr}`'s ids
/// ```
///
/// Can be called with an explicit context or using the implicit context
/// from an enclosing `rule!`:
///
/// ```text
/// tree!(ctx, (kind ...))     // explicit BuildCtx
/// tree!((kind ...))          // implicit context from rule!
/// ```
#[proc_macro]
pub fn tree(input: TokenStream) -> TokenStream {
    let input2: TokenStream2 = input.into();
    match parse::parse_tree_top(input2) {
        Ok(output) => output.into(),
        Err(err) => err.to_compile_error().into(),
    }
}

/// Build a list of AST nodes from a template, returning `Vec<Id>`.
///
/// Like `tree!` but returns `Vec<Id>` and supports multiple top-level
/// elements. All syntax from `tree!` is available.
///
/// Can be called with an explicit context or using the implicit context
/// from an enclosing `rule!`:
///
/// ```text
/// trees!(ctx, (node1 ...) (node2 ...))   // explicit BuildCtx
/// trees!((node1 ...) (node2 ...))        // implicit context from rule!
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
/// // Shorthand: captures become fields on the output node
/// rule!((query ...) => output_kind)
/// ```
///
/// Captures become Rust variables automatically:
/// - `@name` (no quantifier) → `name: Id`
/// - `@name` (after `*`/`+`) → `name: Vec<Id>`
/// - `@name` (after `?`) → `name: Option<Id>`
///
/// `tree!` and `trees!` can be used without explicit context inside `{...}`.
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
/// 2. An explicit `rule!(...)` invocation, possibly chained as
///    `rule!(...).repeated()` or path-prefixed as `yeast::rule!(...)`.
/// 3. Any other expression returning a `Rule` (helper-function calls,
///    conditionals).
///
/// ```ignore
/// let translation_rules: Vec<yeast::Rule> = yeast::rules! {
///     input: "tree-sitter-swift/node-types.yml",
///     output: "ast_types.yml",
///     [
///         (source_file (_)* @cs) => (top_level body: {..cs}),
///         (simple_identifier) @id => (name_expr identifier: (identifier #{id})),
///         rule!((integer_literal) @lit => (int_literal #{lit})).repeated(),
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
