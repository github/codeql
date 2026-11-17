use codeql_extractor::extractor::desugaring;

#[path = "swift/swift.rs"]
mod swift;

/// swift-syntax JSON -> `yeast::Ast` adapter for the Swift front-end.
#[cfg(any(not(feature = "rust-parser"), test))]
#[path = "swift/adapter.rs"]
pub mod swift_adapter;

#[cfg(feature = "rust-parser")]
#[path = "swift/rust_parser.rs"]
mod swift_rust_parser;

/// Swift front-end parser selected by the extractor's Cargo features.
#[path = "swift/parse.rs"]
pub mod swift_parse;

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<desugaring::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
