use codeql_extractor::extractor::desugaring;

#[path = "swift/swift.rs"]
mod swift;

/// swift-syntax JSON -> `yeast::Ast` adapter for the Swift front-end.
///
/// Currently exercised by tests and the forthcoming runtime extraction path;
/// `allow(dead_code)` because this is a binary crate, so its public API isn't
/// counted as used until the binary itself calls it.
#[path = "swift/adapter.rs"]
#[allow(dead_code)]
pub mod swift_adapter;

/// Swift front-end parser: shells out to `swift-syntax-parse` and adapts its
/// JSON output via [`swift_adapter`].
///
/// Dormant for now: the runtime Swift front-end is still tree-sitter, so
/// nothing in the binary calls this yet. `allow(dead_code)` for the same
/// binary-crate reason as [`swift_adapter`]; both allows are removed once the
/// runtime switches the Swift front-end to swift-syntax.
#[path = "swift/parse.rs"]
#[allow(dead_code)]
pub mod swift_parse;

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<desugaring::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
