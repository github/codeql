use codeql_extractor::extractor::simple;

#[path = "swift/swift.rs"]
mod swift;

pub fn all_language_specs() -> Vec<simple::LanguageSpec> {
    vec![swift::language_spec()]
}
