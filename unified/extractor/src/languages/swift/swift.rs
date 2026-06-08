use codeql_extractor::extractor::simple;
use yeast::{rule, DesugaringConfig, PhaseKind};

fn translation_rules() -> Vec<yeast::Rule> {
    vec![
        // ---- Top-level ----
        // Capture all top-level statements, including unnamed tokens like `nil`.
        rule!(
            (source_file statement: _* @children)
            =>
            (top_level
                body: (block stmt: {..children})
            )
        ),
        // New grammar wraps declarations in local/global wrappers.
        rule!((global_declaration _ @inner) => {inner}),
        rule!((local_declaration _ @inner) => {inner}),
        // ---- Literals ----
        rule!((integer_literal) => (int_literal)),
        rule!((hex_literal) => (int_literal)),
        rule!((bin_literal) => (int_literal)),
        rule!((oct_literal) => (int_literal)),
        rule!((real_literal) => (float_literal)),
        rule!((boolean_literal) => (boolean_literal)),
        rule!("nil" => (keyword_literal)),
        rule!((special_literal) => (keyword_literal)),
        rule!((line_string_literal) => (string_literal)),
        rule!((multi_line_string_literal) => (string_literal)),
        rule!((raw_string_literal) => (string_literal)),
        rule!((regex_literal) => (regex_literal)),
        // ---- Names ----
        rule!((simple_identifier) @id => (name_expr identifier: (identifier #{id}))),
        // A referenceable_operator (e.g. `+` used as a value, as in `reduce(0, +)`)
        // is treated as a name reference to the operator symbol.
        rule!((referenceable_operator) @op => (name_expr identifier: (identifier #{op}))),
        // ---- Operators ----
        // All binary operators share the lhs/op/rhs shape.
        rule!((additive_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((multiplicative_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((comparison_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((equality_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((conjunction_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((disjunction_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((infix_expression lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        // Range expression `a..<b` / `a...b`
        rule!((range_expression start: @l op: @op end: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        // Open-ended ranges `a...` / `...b`
        rule!((open_end_range_expression start: @l) => (unary_expr operator: (postfix_operator "...") operand: {l})),
        rule!((open_start_range_expression end: @r) => (unary_expr operator: (prefix_operator "...") operand: {r})),
        // Custom operator declaration: `[prefix|infix|postfix] operator OP [: PrecedenceGroup]`.
        // The fixity keyword is an anonymous child of `operator_declaration`, so we
        // dispatch on it with one rule per keyword.
        rule!(
            (operator_declaration "prefix" (referenceable_operator _ @op) (simple_identifier)? @prec)
            =>
            (operator_syntax_declaration name: (identifier #{op}) fixity: (fixity "prefix") precedence: {..prec})
        ),
        rule!(
            (operator_declaration "postfix" (referenceable_operator _ @op) (simple_identifier)? @prec)
            =>
            (operator_syntax_declaration name: (identifier #{op}) fixity: (fixity "postfix") precedence: {..prec})
        ),
        rule!(
            (operator_declaration "infix" (referenceable_operator _ @op) (simple_identifier)? @prec)
            =>
            (operator_syntax_declaration
                name: (identifier #{op})
                fixity: (fixity "infix")
                precedence: {..prec})
        ),
        rule!((bitwise_operation lhs: @l op: @op rhs: @r) => (binary_expr left: {l} operator: (infix_operator #{op}) right: {r})),
        rule!((nil_coalescing_expression value: @l if_nil: @r) => (binary_expr left: {l} operator: (infix_operator "??") right: {r})),
        // Prefix unary operators
        rule!((prefix_expression operation: @op target: @operand) => (unary_expr operator: (prefix_operator #{op}) operand: {operand})),
        // Postfix unary operators
        rule!((postfix_expression operation: @op target: @operand) => (unary_expr operator: (postfix_operator #{op}) operand: {operand})),
        // Parenthesised single-value tuple is a grouping expression; pass through.
        // Multi-value tuples become tuple_expr.
        rule!((tuple_expression value: _* @v) => (tuple_expr element: {..v})),
        // New grammar uses block.statement* directly.
        rule!((block statement: _+ @stmts) => (block stmt: {..stmts})),
        rule!((block) => (block)),
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
