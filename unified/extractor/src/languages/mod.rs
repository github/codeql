use codeql_extractor::extractor::desugaring;

#[path = "swift/swift.rs"]
mod swift;

/// swift-syntax JSON -> `yeast::Ast` adapter for the Swift front-end.
#[path = "swift/adapter.rs"]
pub mod swift_adapter;

/// Swift front-end parser: shells out to `swift-syntax-parse` and adapts its
/// JSON output via [`swift_adapter`]. This is the live Swift front-end used by
/// [`all_language_specs`].
#[path = "swift/parse.rs"]
pub mod swift_parse;

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<desugaring::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
