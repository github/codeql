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
        // Declarations may be wrapped in local/global wrapper nodes.
        rule!((global_declaration _ @inner) => {inner}),
        rule!((local_declaration _ @inner) => {inner}),
        // ---- Literals ----
        rule!((integer_literal) => (int_literal)),
        rule!((hex_literal) => (int_literal)),
        rule!((bin_literal) => (int_literal)),
        rule!((oct_literal) => (int_literal)),
        rule!((real_literal) => (float_literal)),
        rule!((boolean_literal) => (boolean_literal)),
        rule!("nil" => (builtin_expr)),
        rule!((special_literal) => (builtin_expr)),
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
        // Leading-dot member shorthand (e.g. `.some`, `.foo`) means member access
        // on a contextually inferred type.
        rule!((prefix_expression operation: "." target: @member) => (member_access_expr base: (inferred_type_expr) member: (identifier #{member}))),
        // Prefix unary operators
        rule!((prefix_expression operation: @op target: @operand) => (unary_expr operator: (prefix_operator #{op}) operand: {operand})),
        // Postfix unary operators
        rule!((postfix_expression operation: @op target: @operand) => (unary_expr operator: (postfix_operator #{op}) operand: {operand})),
        // Parenthesised single-value tuple is a grouping expression; pass through.
        // Multi-value tuples become tuple_expr.
        rule!((tuple_expression value: _* @v) => (tuple_expr element: {..v})),
        // Blocks contain statement* directly.
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
                name: @pattern
                type: _? @ty
                computed_value: (computed_property accessor: _+ @accessors))
            =>
            {..{
                let name_text = __yeast_ctx.ast.source_text(pattern.into());
                let ty_ids: Vec<usize> = ty.iter().map(|&t| t.into()).collect();
                let acc_ids: Vec<usize> = accessors.iter().map(|&a| a.into()).collect();
                for &acc_id in &acc_ids {
                    let ident = __yeast_ctx.literal("identifier", &name_text);
                    __yeast_ctx.prepend_field(acc_id, "name", ident);
                    for &ty_id in ty_ids.iter().rev() {
                        __yeast_ctx.prepend_field(acc_id, "type", ty_id);
                    }
                }
                acc_ids
            }}
        ),
        // Computed property: shorthand getter (no explicit get/set, just statements) →
        // a single accessor_declaration with kind "get".
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                type: _? @ty
                computed_value: (computed_property statement: _* @body))
            =>
            (accessor_declaration
                name: (identifier #{name})
                type: {..ty}
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
                type: _? @ty
                value: _? @val
                observers: (willset_didset_block willset: _? @ws didset: _? @ds))
            =>
            {..{
                let name_text = __yeast_ctx.ast.source_text(name.into());
                let val_ids: Vec<usize> = val.iter().map(|&v| v.into()).collect();
                let ty_ids: Vec<usize> = ty.iter().map(|&t| t.into()).collect();
                let mut obs_ids: Vec<usize> = Vec::new();
                obs_ids.extend(ws.iter().map(|&o| { let id: usize = o.into(); id }));
                obs_ids.extend(ds.iter().map(|&o| { let id: usize = o.into(); id }));
                let ident_for_var = __yeast_ctx.literal("identifier", &name_text);
                let pat = __yeast_ctx.node("name_pattern", vec![("identifier", vec![ident_for_var])]);
                let mut var_fields: Vec<(&str, Vec<usize>)> = vec![("pattern", vec![pat])];
                if !ty_ids.is_empty() {
                    var_fields.push(("type", ty_ids));
                }
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
        // property_binding with any pattern name (identifier or destructuring)
        rule!(
            (property_binding
                name: @pattern
                type: _? @ty
                value: _? @val)
            =>
            (variable_declaration
                pattern: {pattern}
                type: {..ty}
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
        // ---- Enums ----
        // enum_type_parameter → parameter (with optional name as pattern).
        rule!(
            (enum_type_parameter name: @name type: @ty)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty})
        ),
        rule!(
            (enum_type_parameter type: @ty)
            =>
            (parameter type: {ty})
        ),
        // enum_case_entry with associated values → class_like_declaration containing
        // a constructor whose parameters are the data parameters.
        rule!(
            (enum_case_entry
                name: @name
                data_contents: (enum_type_parameters parameter: _* @params))
            =>
            (class_like_declaration
                modifier: (modifier "enum_case")
                name: (identifier #{name})
                member: (constructor_declaration parameter: {..params} body: (block)))
        ),
        // enum_case_entry with explicit raw value → variable_declaration with that value.
        rule!(
            (enum_case_entry name: @name raw_value: @val)
            =>
            (variable_declaration
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {val})
        ),
        // enum_case_entry without associated values → variable_declaration tagged enum_case.
        rule!(
            (enum_case_entry name: @name)
            =>
            (variable_declaration
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        // enum_entry: flatten case entries; attach outer modifiers to each, and
        // chained_declaration on every entry after the first.
        rule!(
            (enum_entry case: _+ @cases (modifiers)* @mods)
            =>
            {..{
                let mod_ids: Vec<usize> = mods.iter().map(|&m| m.into()).collect();
                let case_ids: Vec<usize> = cases.iter().map(|&c| c.into()).collect();
                for (i, &case_id) in case_ids.iter().enumerate() {
                    if i > 0 {
                        let chained = __yeast_ctx.literal("modifier", "chained_declaration");
                        __yeast_ctx.prepend_field(case_id, "modifier", chained);
                    }
                    for &mod_id in mod_ids.iter().rev() {
                        __yeast_ctx.prepend_field(case_id, "modifier", mod_id);
                    }
                }
                case_ids
            }}
        ),
        // Plain assignment: `x = expr`
        rule!(
            (assignment operator: "=" target: (directly_assignable_expression expr: @target) result: @value)
            =>
            (assign_expr target: {target} value: {value})
        ),
        // Compound assignment: `x += expr` etc.
        rule!(
            (assignment operator: @op target: (directly_assignable_expression expr: @target) result: @value)
            =>
            (compound_assign_expr target: {target} operator: (infix_operator #{op}) value: {value})
        ),
        // Unwrap `type` wrapper node
        rule!((type name: @inner) => {inner}),
        // `directly_assignable_expression` is just a wrapper; unwrap it
        rule!((directly_assignable_expression expr: @inner) => {inner}),
        // Pattern with bound_identifier → name_pattern
        rule!((pattern bound_identifier: @name) => (name_pattern identifier: (identifier #{name}))),
        // Tuple pattern (destructuring)
        rule!((pattern (pattern)* @elems) => (tuple_pattern element: {..elems})),
        // ---- Functions ----
        // Function declaration
        // Function declaration (return type optional, body statements optional).
        rule!(
            (function_declaration
                name: @name
                parameter: _* @params
                return_type: _? @ret
                body: (block statement: _* @body_stmts))
            =>
            (function_declaration
                name: (identifier #{name})
                parameter: {..params}
                return_type: {..ret}
                body: (block stmt: {..body_stmts}))
        ),
        // Parameters are wrapped in function_parameter, which also carries
        // optional default values.
        rule!(
            (function_parameter parameter: @p default_value: _? @def)
            =>
            {..{
                let p_id: usize = p.into();
                for &d in def.iter().rev() {
                    __yeast_ctx.prepend_field(p_id, "default", d.into());
                }
                vec![p_id]
            }}
        ),
        // Parameter with external name and type
        rule!(
            (parameter external_name: @ext name: @name)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        rule!(
            (parameter external_name: @ext name: @name type: @ty)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty})
        ),
        // Parameter with just name and type (no external name)
        rule!(
            (parameter name: @name)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        rule!(
            (parameter name: @name type: @ty)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty})
        ),
        // Reference to a function, f(x:y:z:). This is parsed as a call with a single argument with multiple reference_specifier labels.
        // We don't want downstream QL to try to handle this as a call_expr with a weird argument, so explicitly mark it as unsupported for now.
        // In the future we probably want to translate this to a lambda expression.
        rule!(
            (call_expression suffix: (call_suffix arguments: (value_arguments argument: (value_argument reference_specifier: _+) @ref_arg)))
            =>
            (unsupported_node)
        ),
        // Call expression: function(args...)
        rule!(
            (call_expression function: @func suffix: (call_suffix arguments: (value_arguments argument: (value_argument)* @args)))
            =>
            (call_expr callee: {func} argument: {..args})
        ),
        // Value argument with label (value: _ matches both named nodes and anonymous tokens like nil)
        rule!(
            (value_argument name: (value_argument_label name: @label) value: @val)
            =>
            (argument name: (identifier #{label}) value: {val})
        ),
        // Value argument without label
        rule!(
            (value_argument value: @val)
            =>
            (argument value: {val})
        ),
        // Navigation expression → member_access_expr
        rule!(
            (navigation_expression target: @target suffix: (navigation_suffix suffix: @member))
            =>
            (member_access_expr base: {target} member: (identifier #{member}))
        ),
        // Return / break / continue, one rule per keyword.
        // The anonymous "return"/"break"/"continue" keywords are matched as
        // string literals.
        rule!((control_transfer_statement kind: "return" result: _? @val) => (return_expr value: {..val})),
        rule!((control_transfer_statement kind: "break" result: @lbl) => (break_expr label: (identifier #{lbl}))),
        rule!((control_transfer_statement kind: "break") => (break_expr)),
        rule!((control_transfer_statement kind: "continue" result: @lbl) => (continue_expr label: (identifier #{lbl}))),
        rule!((control_transfer_statement kind: "continue") => (continue_expr)),
        rule!((control_transfer_statement kind: (throw_keyword) result: @val) => (throw_expr value: {val})),
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
