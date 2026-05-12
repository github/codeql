use codeql_extractor::extractor::simple;
use yeast::{rule, DesugaringConfig, PhaseKind};

fn desugaring_rules() -> Vec<yeast::Rule> {
    vec![
        rule!(
            (additive_expression)
            =>
            (simple_identifier "blah")
        ),
        rule!(
            _
            =>
            (simple_identifier "not supported")
        )
    ]
}

pub fn language_spec() -> simple::LanguageSpec {
    let desugar = DesugaringConfig::new().add_phase("desugar", PhaseKind::OneShot, desugaring_rules());
    simple::LanguageSpec {
        prefix: "swift",
        ts_language: tree_sitter_swift::LANGUAGE.into(),
        node_types: tree_sitter_swift::NODE_TYPES,
        file_globs: vec!["*.swift".into(), "*.swiftinterface".into()],
        desugar: Some(desugar),
    }
}
