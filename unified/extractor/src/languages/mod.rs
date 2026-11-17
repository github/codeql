use codeql_extractor::extractor::desugaring;

#[path = "swift/swift.rs"]
mod swift;

/// Native Swift front-end parser.
#[path = "swift/parse.rs"]
pub mod swift_parse;

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<desugaring::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
