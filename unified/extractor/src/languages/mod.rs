use codeql_extractor::extractor::simple;

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

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<simple::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
