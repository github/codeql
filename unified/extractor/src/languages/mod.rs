use codeql_extractor::extractor::simple;

#[path = "swift/swift.rs"]
mod swift;

/// Shared YEAST output AST schema for all languages.
pub(crate) const OUTPUT_AST_SCHEMA: &str = include_str!("../../ast_types.yml");

pub fn all_language_specs() -> Vec<simple::LanguageSpec> {
    vec![swift::language_spec(OUTPUT_AST_SCHEMA)]
}
