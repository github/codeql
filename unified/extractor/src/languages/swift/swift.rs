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
        // ---- Variables ----
        // property_binding rules — these produce variable_declaration and/or accessor_declaration
        // nodes for individual declarators. The outer property_declaration rule splices these out
        // and attaches binding/modifiers from the parent.

        // Computed property with explicit accessors (get/set/modify) →
        // a sequence of accessor_declaration nodes, each with the property name
        // attached. Subsequent accessors will be tagged chained_declaration by
        // the outer property_declaration rule.
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                computed_value: (computed_property accessor: _+ @accessors))
            =>
            {..{
                let name_text = __yeast_ctx.ast.source_text(name.into());
                let acc_ids: Vec<usize> = accessors.iter().map(|&a| a.into()).collect();
                for &acc_id in &acc_ids {
                    let ident = __yeast_ctx.literal("identifier", &name_text);
                    __yeast_ctx.prepend_field(acc_id, "name", ident);
                }
                acc_ids
            }}
        ),
        // Computed property: shorthand getter (no explicit get/set, just statements) →
        // a single accessor_declaration with kind "get".
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                computed_value: (computed_property statement: _* @body))
            =>
            (accessor_declaration
                name: (identifier #{name})
                accessor_kind: (accessor_kind "get")
                body: (block stmt: {..body}))
        ),
        // Stored property with willSet/didSet observers (initializer optional) →
        // variable_declaration followed by one accessor_declaration per observer,
        // each carrying the property name. Subsequent items are tagged
        // chained_declaration by the outer property_declaration rule.
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                value: _? @val
                observers: (willset_didset_block willset: _? @ws didset: _? @ds))
            =>
            {..{
                let name_text = __yeast_ctx.ast.source_text(name.into());
                let val_ids: Vec<usize> = val.iter().map(|&v| v.into()).collect();
                let mut obs_ids: Vec<usize> = Vec::new();
                obs_ids.extend(ws.iter().map(|&o| { let id: usize = o.into(); id }));
                obs_ids.extend(ds.iter().map(|&o| { let id: usize = o.into(); id }));
                let ident_for_var = __yeast_ctx.literal("identifier", &name_text);
                let pat = __yeast_ctx.node("name_pattern", vec![("identifier", vec![ident_for_var])]);
                let mut var_fields: Vec<(&str, Vec<usize>)> = vec![("pattern", vec![pat])];
                if !val_ids.is_empty() {
                    var_fields.push(("value", val_ids));
                }
                let var_id = __yeast_ctx.node("variable_declaration", var_fields);
                let mut result = vec![var_id];
                for obs_id in obs_ids {
                    let ident = __yeast_ctx.literal("identifier", &name_text);
                    __yeast_ctx.prepend_field(obs_id, "name", ident);
                    result.push(obs_id);
                }
                result
            }}
        ),
        // Plain property_binding with simple identifier name → variable_declaration
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                value: _? @val)
            =>
            (variable_declaration
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {..val})
        ),
        // Property_binding with a complex pattern (tuple destructuring etc.)
        rule!(
            (property_binding
                name: @pat
                value: _? @val)
            =>
            (variable_declaration
                pattern: {pat}
                value: {..val})
        ),
        // property_declaration: splice declarators (each may translate to multiple nodes —
        // variable_declaration and/or accessor_declaration), and attach the binding modifier
        // (let/var) and any outer modifiers to each. All children after the first additionally
        // get a synthetic chained_declaration modifier so the grouping can be recovered.
        rule!(
            (property_declaration
                binding: (value_binding_pattern mutability: @binding_kind)
                declarator: _* @decls
                (modifiers)* @mods)
            =>
            {..{
                let binding_text = __yeast_ctx.ast.source_text(binding_kind.into());
                let mod_ids: Vec<usize> = mods.iter().map(|&m| m.into()).collect();
                let decl_ids: Vec<usize> = decls.iter().map(|&d| d.into()).collect();
                for (i, &decl_id) in decl_ids.iter().enumerate() {
                    if i > 0 {
                        let chained = __yeast_ctx.literal("modifier", "chained_declaration");
                        __yeast_ctx.prepend_field(decl_id, "modifier", chained);
                    }
                    for &mod_id in mod_ids.iter().rev() {
                        __yeast_ctx.prepend_field(decl_id, "modifier", mod_id);
                    }
                    let binding_mod = __yeast_ctx.literal("modifier", &binding_text);
                    __yeast_ctx.prepend_field(decl_id, "modifier", binding_mod);
                }
                decl_ids
            }}
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
