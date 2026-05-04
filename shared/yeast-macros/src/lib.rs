use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;

mod parse;

/// Proc macro for constructing a `QueryNode` from a tree-sitter-inspired pattern.
///
/// # Syntax
///
/// ```text
/// (_)                          - match any named node (skips unnamed tokens)
/// (kind)                       - match a named node of the given kind
/// ("literal")                  - match an unnamed token by its text
/// (kind field: (pattern))      - match with named field
/// (kind (pat) (pat)...)        - match unnamed children (after all fields)
/// (pattern) @capture           - capture the matched node
/// (pattern)* @capture          - capture each repeated match
/// (pattern)?                   - zero or one
/// ```
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
/// {expr}                       - embed a Rust expression returning Id
/// {..expr}                     - splice an iterable of Id (in child/field position)
/// field: {..expr}              - splice into a named field
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
///     (output_template field: {name} {..repeated})
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
