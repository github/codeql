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
        // ---- Binary expressions ----
        // Swift's parser produces a different node kind for each operator
        // family, but the field shape (`lhs` / `op` / `rhs`) is uniform, so
        // each maps onto `binary_expr`.
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
            (comparison_expression
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
            (equality_expression
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
            (conjunction_expression
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
            (disjunction_expression
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
            (nil_coalescing_expression
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
            (range_expression
                start: (_) @left
                op: _ @operator
                end: (_) @right)
            =>
            (binary_expr
                left: {left}
                operator: (operator #{operator})
                right: {right})
        ),
        // ---- Unary expressions ----
        rule!(
            (prefix_expression
                operation: _ @operator
                target: (_) @operand)
            =>
            (unary_expr
                operand: {operand}
                operator: (operator #{operator}))
        ),
        // ---- Identifiers / name expressions ----
        rule!(
            (simple_identifier) @name
            =>
            (name_expr
                identifier: (identifier #{name}))
        ),
        // ---- Literals ----
        rule!(
            (integer_literal) @lit
            =>
            (int_literal #{lit})
        ),
        // String literals: render the *raw* source text, including the
        // surrounding quotes. Interpolations (e.g. `"hi \(x)"`) are not
        // yet broken out into structured pieces \u2014 they show up as part
        // of the literal's source text.
        rule!(
            (line_string_literal) @lit
            =>
            (string_literal #{lit})
        ),
        // ---- Patterns ----
        // The Swift parser uses a `pattern` node with a `bound_identifier`
        // field for simple bindings such as `let x = ...`.
        rule!(
            (pattern bound_identifier: (simple_identifier) @id)
            =>
            (var_pattern
                identifier: (identifier #{id}))
        ),
        // ---- Variable declarations ----
        // `let x = e` / `var x = e` (with initializer).
        rule!(
            (property_declaration
                name: (_) @pat
                value: (_) @value)
            =>
            (variable_declaration_stmt
                variable_declarator: (variable_declarator
                    pattern: {pat}
                    value: {value}))
        ),
        // `var x: T` (no initializer).
        rule!(
            (property_declaration
                name: (_) @pat)
            =>
            (variable_declaration_stmt
                variable_declarator: (variable_declarator
                    pattern: {pat}))
        ),
        // ---- Fallbacks ----
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
