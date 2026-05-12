use codeql_extractor::extractor::simple;
use yeast::{rule, DesugaringConfig, PhaseKind};

/// Output AST schema. The corpus tests load this via the language spec to
/// type-check the desugared AST.
pub const OUTPUT_NODE_TYPES_YAML: &str = include_str!("../../../ast_types.yml");

fn translation_rules() -> Vec<yeast::Rule> {
    vec![
        rule!(
            (source_file (_)* @body)
            =>
            (top_level body: {..body})
        ),
        rule!(
            (additive_expression)
            =>
            (name_expr "test")
        ),
        rule!(
            _
            =>
            (unsupported_node)
        )
    ]
}

pub fn language_spec(desugared_ast_schema: &'static str) -> simple::LanguageSpec {
    let desugar = DesugaringConfig::new()
        .add_phase("translate", PhaseKind::OneShot, translation_rules())
        .with_output_node_types_yaml(desugared_ast_schema);
    simple::LanguageSpec {
        prefix: "swift",
        ts_language: tree_sitter_swift::LANGUAGE.into(),
        node_types: tree_sitter_swift::NODE_TYPES,
        file_globs: vec!["*.swift".into(), "*.swiftinterface".into()],
        desugar: Some(desugar),
    }
}
