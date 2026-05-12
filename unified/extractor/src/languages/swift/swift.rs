use codeql_extractor::extractor::simple;
use yeast::{rule, DesugaringConfig, PhaseKind};

fn translation_rules() -> Vec<yeast::Rule> {
    vec![
        rule!(
            (source_file (_)* @children)
            =>
            (top_level
                body: {..children}
            )
        ),
        rule!(
            (additive_expression
                lhs: (_) @left
                op: _ @operator
                rhs: (_) @right)
            =>
            (binary_expr
                left: {left}
                operator: (operator #{operator})
                right: {right})
        ),
        rule!(
            (multiplicative_expression
                lhs: (_) @left
                op: _ @operator
                rhs: (_) @right)
            =>
            (binary_expr
                left: {left}
                operator: (operator #{operator})
                right: {right})
        ),
        rule!(
            (simple_identifier)
            =>
            name_expr
        ),
        rule!(
            (_)
            =>
            (unsupported_node)
        ),
        rule!(
            _ @node
            =>
            {node}
        ),
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
