use codeql_extractor::extractor::simple;
use yeast::{build::BuildCtx, rule, DesugaringConfig, PhaseKind};

/// Names of output AST kinds that belong to the `expr` supertype. Kept in
/// sync with `ast_types.yml`. `unsupported_node` is intentionally omitted
/// because it is also a member of the `stmt` supertype.
const EXPR_KINDS: &[&str] = &[
    "name_expr",
    "int_literal",
    "string_literal",
    "binary_expr",
    "unary_expr",
    "call_expr",
    "member_access_expr",
    "lambda_expr",
];

/// If `id` is an `expr`, wrap it in `expr_stmt` so it can sit in a `stmt`
/// position; otherwise return it unchanged.
fn wrap_expr_in_stmt(ctx: &mut BuildCtx, id: usize) -> usize {
    let kind = ctx.ast.get_node(id).map(|n| n.kind()).unwrap_or("");
    if EXPR_KINDS.contains(&kind) {
        yeast::tree!(ctx, (expr_stmt expr: {id}))
    } else {
        id
    }
}

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
        ),        // ---- Lambdas / closures ----
        // Map a `lambda_literal` whose body is a single statement to
        // `lambda_expr`. Multi-statement bodies fall through to
        // `unsupported_node` because `lambda_expr.body` is single-valued
        // in the current `ast_types.yml`. Parameters from explicit-typed
        // closures (`{ (x: Int) -> Int in ... }`) are not yet captured.
        rule!(
            (lambda_literal
                (statements (_) @body))
            =>
            (lambda_expr
                body: {body})
        ),
        // ---- Block / statement wrapping ----
        // A `(statements ...)` node corresponds to a brace-delimited block.
        // Each child is mapped through translation; bare expression results
        // get wrapped in `expr_stmt` so they fit the `body*: stmt` field.
        rule!(
            (statements (_)* @stmts)
            =>
            (block_stmt body: {..stmts.iter().copied().map(|n|
                wrap_expr_in_stmt(&mut __yeast_ctx, n.into())
            ).collect::<Vec<usize>>()})
        ),
        // ---- Calls and member access ----
        // Member access, e.g. `obj.member`. The Swift parser wraps the
        // member name as `(navigation_suffix suffix: (simple_identifier))`.
        rule!(
            (navigation_expression
                target: (_) @target
                suffix: (navigation_suffix
                    suffix: (simple_identifier) @member))
            =>
            (member_access_expr
                target: {target}
                member: (identifier #{member}))
        ),
        // Function / method call. The callee is the first child of
        // `call_expression`; the second is a `call_suffix` whose
        // `value_arguments` (if present) hold the parenthesized args. A
        // trailing closure (`call_suffix` with a `lambda_literal` child)
        // is appended as a final argument.
        rule!(
            (call_expression
                (_) @callee
                (call_suffix
                    (value_arguments
                        (value_argument value: (_) @args)*)?
                    (lambda_literal)? @trailing))
            =>
            (call_expr
                function: {callee}
                argument: {..args.iter().copied().map(Into::into)
                    .chain(trailing.map(Into::into)).collect::<Vec<usize>>()})
        ),
        // ---- Guard statement ----
        // `guard let x = e else { ... }` — currently only handles the
        // let-binding form. The Swift parser models the `let` keyword as a
        // `value_binding_pattern` child of `condition`, followed by an
        // unnamed `=` and the source expression.
        rule!(
            (guard_statement
                bound_identifier: (simple_identifier) @id
                condition: (value_binding_pattern)
                condition: (_) @value
                (else)
                (statements) @else_branch)
            =>
            (guard_if_stmt
                condition: (let_pattern_condition
                    pattern: (var_pattern identifier: (identifier #{id}))
                    value: {value})
                else: {else_branch})
        ),
        // ---- If statement ----
        // if-let binding (with optional else branch). The Swift parser puts
        // the bound name in `bound_identifier`, the `let` keyword as a
        // `value_binding_pattern` child of `condition`, and the source
        // expression as a separate child of `condition`.
        rule!(
            (if_statement
                bound_identifier: (simple_identifier) @id
                condition: (value_binding_pattern)
                condition: (_) @value
                (statements) @then
                (else)
                (_) @else_branch)
            =>
            (if_stmt
                condition: (let_pattern_condition
                    pattern: (var_pattern identifier: (identifier #{id}))
                    value: {value})
                then: {then}
                else: {else_branch})
        ),
        rule!(
            (if_statement
                bound_identifier: (simple_identifier) @id
                condition: (value_binding_pattern)
                condition: (_) @value
                (statements) @then)
            =>
            (if_stmt
                condition: (let_pattern_condition
                    pattern: (var_pattern identifier: (identifier #{id}))
                    value: {value})
                then: {then})
        ),
        // With explicit else branch (block or chained if).
        rule!(
            (if_statement
                condition: (_) @cond
                (statements) @then
                (else)
                (_) @else_branch)
            =>
            (if_stmt
                condition: (expr_condition expr: {cond})
                then: {then}
                else: {else_branch})
        ),
        // Without else branch.
        rule!(
            (if_statement
                condition: (_) @cond
                (statements) @then)
            =>
            (if_stmt
                condition: (expr_condition expr: {cond})
                then: {then})
        ),        // ---- Patterns ----
        // The Swift parser uses a `pattern` node with a `bound_identifier`
        // field for simple bindings such as `let x = ...`.
        rule!(
            (pattern bound_identifier: (simple_identifier) @id)
            =>
            (var_pattern
                identifier: (identifier #{id}))
        ),
        // Inside tuple patterns, the inner `pattern` node holds a bare
        // `simple_identifier` (with no `bound_identifier` field).
        rule!(
            (pattern (simple_identifier) @id)
            =>
            (var_pattern
                identifier: (identifier #{id}))
        ),
        // Tuple destructuring pattern, e.g. `let (a, b) = pair`. The parser
        // emits a `pattern` node whose unnamed children are themselves
        // `pattern` nodes.
        rule!(
            (pattern (pattern)+ @parts)
            =>
            (tuple_pattern element: {..parts})
        ),
        // ---- Variable declarations ----
        // Handles single (`let x = e`), multiple (`let x = 1, y = 2`),
        // and uninitialized (`var x: T`) bindings.
        rule!(
            (property_declaration
                name: (_)* @pats
                value: (_)* @vals)
            =>
            (variable_declaration_stmt
                variable_declarator: {..pats.iter().enumerate().map(|(i, &pat)| {
                    match vals.get(i).copied() {
                        Some(val) => yeast::tree!(
                            (variable_declarator
                                pattern: {pat}
                                value: {val})),
                        None => yeast::tree!(
                            (variable_declarator
                                pattern: {pat})),
                    }
                })})
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
