use codeql_extractor::extractor::simple;
use yeast::{manual_rule, rule, tree, ConcreteDesugarer, DesugaringConfig, PhaseKind, Rule};

/// User context propagated from outer rules down to the inner rules that
/// emit the corresponding output declarations, so that each emitted node
/// is born with the outer information (name, type, modifiers, etc.)
/// already set — no schema-invalid intermediate state requiring
/// post-hoc mutation.
#[derive(Clone, Default)]
struct SwiftContext {
    /// Identifier node for the property name. Set by the outer
    /// `property_binding` (computed accessors / willSet-didSet) and
    /// `protocol_property_declaration` rules before translating accessor
    /// children; read by the accessor inner rules
    /// (`computed_getter`/`computed_setter`/`computed_modify`/
    /// `willset_clause`/`didset_clause`/`getter_specifier`/
    /// `setter_specifier`).
    property_name: Option<yeast::Id>,
    /// Translated type node for the property type. Set by the outer
    /// `property_binding` rule (computed accessors variant) and
    /// `protocol_property_declaration` when present; read by the
    /// accessor inner rules.
    property_type: Option<yeast::Id>,
    /// Default-value expression for the next translated `parameter`. Set
    /// by the outer `function_parameter` rule; read by the `parameter`
    /// rules.
    default_value: Option<yeast::Id>,
    /// Translated outer modifiers (e.g. visibility, attributes) to
    /// attach to each child of a flattening outer rule. Set by
    /// `protocol_property_declaration` (and, later,
    /// `property_declaration`/`enum_entry`).
    outer_modifiers: Vec<yeast::Id>,
    /// True when the current child of a flattening outer rule is not
    /// the first one — its inner rule should emit a
    /// `chained_declaration` modifier so the original grouping can be
    /// recovered downstream.
    is_chained: bool,
}

/// Build a freshly-created `chained_declaration` modifier node if
/// `ctx.is_chained`, else `None`. Used by inner declaration rules to
/// emit the chained tag for non-first children of a flattening outer
/// rule. Returns `Option<Id>` so it splices via `{..…}` to 0 or 1 ids.
fn chained_modifier(ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>) -> Option<yeast::Id> {
    if ctx.is_chained {
        Some(ctx.literal("modifier", "chained_declaration"))
    } else {
        None
    }
}

fn translation_rules() -> Vec<Rule<SwiftContext>> {
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
        // TODO: Parenthesised single-value tuple is a grouping expression and should pass through.
        // Multi-value tuples become tuple_expr.
        rule!((tuple_expression value: _* @v) => (tuple_expr element: {..v})),
        // Blocks contain statement* directly.
        rule!((block statement: _+ @stmts) => (block stmt: {..stmts})),
        rule!((block) => (block)),
        // ---- Variables ----
        // property_binding rules — these produce variable_declaration and/or accessor_declaration
        // nodes for individual declarators. The outer property_declaration rule splices these out
        // and attaches binding/modifiers from the parent.

        // Computed property with explicit accessors (get/set/modify) → a
        // sequence of `accessor_declaration` nodes. The outer rule
        // publishes the property's name and type into `ctx` so that each
        // inner accessor rule
        // (`computed_getter`/`computed_setter`/`computed_modify`) builds
        // its `accessor_declaration` with `name` and `type` set from the
        // start — no schema-invalid intermediate state.
        manual_rule!(
            (property_binding
                name: @pattern
                type: _? @ty
                computed_value: (computed_property accessor: _+ @accessors))
            {
                // Translate `ty` first so the context holds an
                // output-schema node id.
                let translated_ty = ctx.translate_opt(ty)?;
                // Build the property-name identifier from the
                // (untranslated) pattern leaf.
                let name_id = tree!((identifier #{pattern}));

                ctx.property_name = Some(name_id);
                ctx.property_type = translated_ty;

                let mut result = Vec::new();
                for acc in &accessors {
                    result.extend(ctx.translate(*acc)?);
                }
                Ok(result)
            }
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
        // Stored property with willSet/didSet observers (initializer
        // optional) → a `variable_declaration` followed by one
        // `accessor_declaration` per observer, each born with the
        // property name set. Manual rule: we publish the property name
        // into `ctx` before translating the observer children so the
        // inner `willset_clause` / `didset_clause` rules construct
        // valid `accessor_declaration` nodes from the start.
        manual_rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                type: _? @ty
                value: _? @val
                observers: (willset_didset_block willset: _? @ws didset: _? @ds))
            {
                // Translate ty and val so the variable_declaration
                // below contains output-schema nodes.
                let translated_ty = ctx.translate_opt(ty)?;
                let translated_val = ctx.translate_opt(val)?;

                let var_decl = tree!(
                    (variable_declaration
                        pattern: (name_pattern identifier: (identifier #{name}))
                        type: {..translated_ty}
                        value: {..translated_val})
                );

                // Publish the property name for the observer rules.
                ctx.property_name = Some(tree!((identifier #{name})));

                let mut result = vec![var_decl];
                for obs in ws.into_iter().chain(ds) {
                    result.extend(ctx.translate(obs)?);
                }
                Ok(result)
            }
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
                let binding_text = ctx.ast.source_text(binding_kind.into());
                let mod_ids: Vec<usize> = mods.iter().map(|&m| m.into()).collect();
                let decl_ids: Vec<usize> = decls.iter().map(|&d| d.into()).collect();
                for (i, &decl_id) in decl_ids.iter().enumerate() {
                    if i > 0 {
                        let chained = ctx.literal("modifier", "chained_declaration");
                        ctx.prepend_field(decl_id, "modifier", chained);
                    }
                    for &mod_id in mod_ids.iter().rev() {
                        ctx.prepend_field(decl_id, "modifier", mod_id);
                    }
                    let binding_mod = ctx.literal("modifier", &binding_text);
                    ctx.prepend_field(decl_id, "modifier", binding_mod);
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
                        let chained = ctx.literal("modifier", "chained_declaration");
                        ctx.prepend_field(case_id, "modifier", chained);
                    }
                    for &mod_id in mod_ids.iter().rev() {
                        ctx.prepend_field(case_id, "modifier", mod_id);
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
        // Pattern with 'let' or 'var' binding: extract the inner pattern
        // TODO: Names in a pattern need to be translated to expr_equality_pattern if not under a 'var/let' but we lack a way to pass down context to do this.
        rule!(
            (pattern kind: (binding_pattern binding: _? pattern: @pattern))
            =>
            {pattern}
        ),
        // case T.foo(x,y) pattern
        rule!(
            (pattern kind: (case_pattern type: @typ name: @name arguments: (tuple_pattern item: (tuple_pattern_item)* @items)? ))
            =>
            (constructor_pattern
                constructor: (member_access_expr base: {typ} member: (identifier #{name}))
                element: {..items})
        ),
        // case .foo(x,y) pattern
        rule!(
            (pattern kind: (case_pattern dot: @dot name: @name arguments: (tuple_pattern item: (tuple_pattern_item)* @items)? ))
            =>
            (constructor_pattern
                constructor: (member_access_expr base: (inferred_type_expr #{dot}) member: (identifier #{name}))
                element: {..items})
        ),
        // Tuple pattern and its (optionally named) items
        rule!((pattern kind: (tuple_pattern item: _* @elems)) => (tuple_pattern element: {..elems})),
        rule!((tuple_pattern_item name: @key pattern: @pat) => (pattern_element key: (identifier #{key}) pattern: {pat})),
        rule!((tuple_pattern_item pattern: @pat) => (pattern_element pattern: {pat})),
        // Type casting pattern (TODO)
        rule!((pattern kind: (type_casting_pattern)) => (unsupported_node)),
        // Wildcard pattern
        rule!((pattern kind: (wildcard_pattern)) => (ignore_pattern)),
        // Expression pattern
        // We lack a way to check if 'expr' is actually an expression, but due to rule ordering
        // the 'expression' case is the only remaining possibility when this rule tries to match.
        rule!((pattern kind: @expr) => (expr_equality_pattern expr: {expr})),
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
        // optional default values. Publishes the default value into `ctx`
        // before translating the inner `parameter` so the `parameter`
        // rules can include it as a `default:` field directly.
        manual_rule!(
            (function_parameter parameter: @p default_value: _? @def)
            {
                ctx.default_value = ctx.translate_opt(def)?;
                ctx.translate(p)
            }
        ),
        // Parameter with external name and type
        rule!(
            (parameter external_name: @ext name: @name)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name}))
                default: {..ctx.default_value})
        ),
        rule!(
            (parameter external_name: @ext name: @name type: @ty)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty}
                default: {..ctx.default_value})
        ),
        // Parameter with just name and type (no external name)
        rule!(
            (parameter name: @name)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name}))
                default: {..ctx.default_value})
        ),
        rule!(
            (parameter name: @name type: @ty)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty}
                default: {..ctx.default_value})
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
        // ---- Closures ----
        // Lambda literal with optional type header (parameters + optional return type).
        // The return_type capture is optional, so this rule covers both cases.
        rule!(
            (lambda_literal
                attribute: _* @attrs
                captures: (capture_list item: _* @captures)?
                type: (lambda_function_type
                    params: (lambda_function_type_parameters parameter: _* @params)
                    return_type: _? @ret)?
                statement: _* @body)
            =>
            (function_expr
                modifier: {..attrs}
                capture_declaration: {..captures}
                parameter: {..params}
                return_type: {..ret}
                body: (block stmt: {..body}))
        ),
        // capture_list_item with ownership modifier (e.g. [weak self], [unowned x])
        rule!(
            (capture_list_item ownership: _? @ownership name: @name value: _? @val)
            =>
            (variable_declaration
                modifier: {..ownership}
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {..val})
        ),
        // Lambda parameter with type and optional external name
        rule!(
            (lambda_parameter external_name: @ext name: @name type: @ty)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty})
        ),
        rule!(
            (lambda_parameter name: @name type: @ty)
            =>
            (parameter
                pattern: (name_pattern identifier: (identifier #{name}))
                type: {ty})
        ),
        rule!(
            (lambda_parameter external_name: @ext name: @name)
            =>
            (parameter
                external_name: (identifier #{ext})
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        rule!(
            (lambda_parameter name: @name)
            =>
            (parameter pattern: (name_pattern identifier: (identifier #{name})))
        ),
        // Call expression with trailing closure (no value_arguments)
        rule!(
            (call_expression function: @func suffix: (call_suffix lambda: (lambda_literal) @closure))
            =>
            (call_expr
                callee: {func}
                argument: (argument value: {closure}))
        ),
        // ---- Control flow ----
        rule!(
            (if_statement condition: _* @cond body: @then_body else_branch: _? @else_stmts)
            =>
            (if_expr
                condition: {..cond}.reduce_left(first -> {first}, acc, elem -> (binary_expr operator: (infix_operator "&&") left: {acc} right: {elem}))
                then: {then_body}
                else: {..else_stmts})
        ),
        // Guard statement
        rule!(
            (guard_statement condition: _* @cond body: (block statement: _* @else_stmts))
            =>
            (guard_if_stmt
                condition: {..cond}.reduce_left(first -> {first}, acc, elem -> (binary_expr operator: (infix_operator "&&") left: {acc} right: {elem}))
                else: (block stmt: {..else_stmts}))
        ),
        // Ternary expression → if_expr
        rule!(
            (ternary_expression condition: @cond if_true: @then_val if_false: @else_val)
            =>
            (if_expr condition: {cond} then: {then_val} else: {else_val})
        ),
        // Switch statement
        rule!(
            (switch_statement expr: @val entry: (switch_entry)* @cases)
            =>
            (switch_expr value: {val} case: {..cases})
        ),
        // Switch entry with patterns and body
        rule!(
            (switch_entry pattern: (switch_pattern pattern: @pats)* statement: _* @body)
            =>
            (switch_case pattern: {..pats} body: (block stmt: {..body}))
        ),
        // Switch entry: default case (no patterns)
        rule!(
            (switch_entry default: (default_keyword) statement: _* @body)
            =>
            (switch_case body: (block stmt: {..body}))
        ),
        // if case let x = expr — the pattern is taken as-is (no Optional wrapping)
        rule!(
            (if_let_binding "case" (value_binding_pattern) bound_identifier: @name _ @val)
            =>
            (pattern_guard_expr
                value: {val}
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        rule!(
            (if_let_binding
                pattern: (pattern binding: (value_binding_pattern) bound_identifier: @name)
                value: @val)
            =>
            (pattern_guard_expr
                value: {val}
                pattern: (constructor_pattern
                    constructor: (member_access_expr base: (named_type_expr name: (identifier "Optional")) member: (identifier "some"))
                    element: (pattern_element pattern: (name_pattern identifier: (identifier #{name})))))
        ),
        // Shorthand if let x (Swift 5.7+) — also semantically .some(x)
        rule!(
            (if_let_binding
                pattern: (pattern binding: (value_binding_pattern) bound_identifier: @name))
            =>
            (pattern_guard_expr
                value: (name_expr identifier: (identifier #{name}))
                pattern: (constructor_pattern
                    constructor: (member_access_expr base: (named_type_expr name: (identifier "Optional")) member: (identifier "some"))
                    element: (pattern_element pattern: (name_pattern identifier: (identifier #{name})))))
        ),
        // If-condition — unwrap (pass through the inner expression/pattern)
        rule!((if_condition kind: @inner) => {inner}),
        // ---- Loops ----
        // For-in loop with optional where-clause guard.
        rule!(
            (for_statement
                item: @pat
                collection: @iter
                where: (where_clause expr: @guard)?
                body: (block statement: _* @body))
            =>
            (for_each_stmt
                pattern: {pat}
                iterable: {iter}
                guard: {..guard}
                body: (block stmt: {..body}))
        ),
        // While loop
        rule!(
            (while_statement condition: _* @cond body: (block statement: _* @body))
            =>
            (while_stmt condition: {..cond}.reduce_left(first -> {first}, acc, elem -> (binary_expr operator: (infix_operator "&&") left: {acc} right: {elem})) body: (block stmt: {..body}))
        ),
        // Repeat-while loop
        rule!(
            (repeat_while_statement condition: _* @cond body: (block statement: _* @body))
            =>
            (do_while_stmt condition: {..cond}.reduce_left(first -> {first}, acc, elem -> (binary_expr operator: (infix_operator "&&") left: {acc} right: {elem})) body: (block stmt: {..body}))
        ),
        // Labeled statement (e.g. `outer: for ...`). Strip the trailing ':' from the label token.
        rule!((labeled_statement label: (statement_label) @lbl statement: @stmt) => {..{
            let text = ctx.ast.source_text(lbl.into());
            let name = ctx.literal("identifier", &text[..text.len() - 1]);
            vec![ctx.node("labeled_stmt", vec![("label", vec![name]), ("stmt", vec![stmt.into()])])]
        }}),
        // ---- Collections ----
        // Array literal
        rule!((array_literal element: _* @elems) => (array_literal element: {..elems})),
        // Empty array literal
        rule!((array_literal) => (array_literal)),
        // Dictionary literal — zip keys and values into key_value_pairs
        rule!(
            (dictionary_literal key: _* @keys value: _* @vals)
            =>
            (map_literal element: {..{
                keys.iter().zip(vals.iter()).map(|(&k, &v)| {
                    let k_id: usize = k.into();
                    let v_id: usize = v.into();
                    ctx.node("key_value_pair", vec![
                        ("key", vec![k_id]),
                        ("value", vec![v_id]),
                    ])
                }).collect::<Vec<_>>()
            }})
        ),
        rule!((dictionary_literal element: _* @elems) => (map_literal element: {..elems})),
        rule!((dictionary_literal_item key: @k value: @v) => (key_value_pair key: {k} value: {v})),
        // ---- Optionals and errors ----
        // Optional chaining — unwrap the marker
        rule!((optional_chain_marker expr: @inner) => {inner}),
        // try/try?/try! expr → unary_expr with operator "try", "try?" or "try!"
        rule!((try_expression (try_operator) @op expr: @inner) => (unary_expr operator: (prefix_operator #{op}) operand: {inner})),
        rule!((try_expression operator: (try_operator) @op expr: @inner) => (unary_expr operator: (prefix_operator #{op}) operand: {inner})),
        // Do-catch → try_expr
        rule!(
            (do_statement body: (block statement: _* @body) catch: (catch_block)* @catches)
            =>
            (try_expr
                body: (block stmt: {..body})
                catch_clause: {..catches})
        ),
        // Catch block with bound identifier; optional where-clause guard.
        rule!(
            (catch_block
                keyword: (catch_keyword)
                error: @pattern
                where: (where_clause expr: @guard)?
                body: (block statement: _* @body))
            =>
            (catch_clause
                pattern: {pattern}
                guard: {..guard}
                body: (block stmt: {..body}))
        ),
        // Catch block without error binding
        rule!(
            (catch_block keyword: (catch_keyword) body: (block statement: _* @body))
            =>
            (catch_clause body: (block stmt: {..body}))
        ),
        // Empty catch block: catch {}
        rule!(
            (catch_block (catch_keyword))
            =>
            (catch_clause body: (block))
        ),
        // Catch block with unhandled pattern — preserve pattern; optional body.
        rule!(
            (catch_block keyword: (catch_keyword) error: @pat body: (block statement: _* @body))
            =>
            (catch_clause
                pattern: {pat}
                body: (block stmt: {..body}))
        ),
        // As expression (type cast) — as?, as!
        rule!((as_expression (as_operator) @op expr: @val type: @ty) => (type_cast_expr expr: {val} operator: (infix_operator #{op}) type: {ty})),
        // Check expression (`x is T`) → type_test_expr
        rule!((check_expression op: @op target: @val type: @ty) => (type_test_expr expr: {val} operator: (infix_operator #{op}) type: {ty})),
        // Await expression → unary_expr with operator "await"
        rule!((await_expression expr: @val) => (unary_expr operator: (prefix_operator "await") operand: {val})),
        // A multi-part identifier (for example `Foo.Bar.Baz`) is translated to
        // a member_access_expr chain with a name_expr base.
        rule!(
            (identifier part: _+ @parts)
            =>
            {parts}.reduce_left(
                first -> (name_expr identifier: (identifier #{first})),
                acc, elem -> (member_access_expr base: {acc} member: (identifier #{elem})))
        ),
        // Scoped import declaration (for example `import struct Foo.Bar`):
        // flatten the identifier parts into a member_access_expr and bind the
        // final segment as a name_pattern.
        rule!(
            (import_declaration scoped_import_kind: @kind name: (identifier part: _+ @parts) @name modifiers: (modifiers)? @mods)
            =>
            (import_declaration
                pattern: (name_pattern identifier: (identifier #{parts.last().unwrap()}))
                imported_expr: {name}
                modifier: (modifier #{kind})
                modifier: {..mods})
        ),
        // Non-scoped import declaration (for example `import Foundation`):
        // flatten the identifier parts into a member_access_expr and use a
        // bulk_importing_pattern.
        rule!(
            (import_declaration name: @name modifiers: (modifiers)? @mods)
            =>
            (import_declaration
                pattern: (bulk_importing_pattern)
                imported_expr: {name}
                modifier: {..mods})
        ),
        // ---- Types and classes ----
        // Self expression → name_expr
        rule!((self_expression) => (name_expr identifier: (identifier "self"))),
        // Super expression → super_expr
        rule!((super_expression) => (super_expr)),
        // Modifiers — unwrap to individual modifier children
        rule!((modifiers _* @mods) => {..mods}),
        rule!((attribute) @m => (modifier #{m})),
        rule!((visibility_modifier) @m => (modifier #{m})),
        rule!((function_modifier) @m => (modifier #{m})),
        rule!((member_modifier) @m => (modifier #{m})),
        rule!((mutation_modifier) @m => (modifier #{m})),
        rule!((ownership_modifier) @m => (modifier #{m})),
        rule!((property_modifier) @m => (modifier #{m})),
        rule!((parameter_modifier) @m => (modifier #{m})),
        rule!((inheritance_modifier) @m => (modifier #{m})),
        rule!((property_behavior_modifier) @m => (modifier #{m})),
        // Type annotations — unwrap
        rule!((type_annotation type: @inner) => {inner}),
        // user_type is split into simple_user_type parts.
        // Keep a conservative textual fallback to avoid dropping type information.
        rule!((user_type) @ty => (named_type_expr name: (identifier #{ty}))),
        // Tuple type → tuple_type_expr
        rule!((tuple_type element: _* @elems) => (tuple_type_expr element: {..elems})),
        rule!((tuple_type_item name: @name type: @ty) => (tuple_type_element name: (identifier #{name}) type: {ty})),
        rule!((tuple_type_item type: @ty) => (tuple_type_element type: {ty})),
        // Array type `[T]` → generic_type_expr with Array base
        rule!((array_type element: @e) => (generic_type_expr
            base: (named_type_expr name: (identifier "Array"))
            type_argument: {e})),
        // Dictionary type `[K: V]` → generic_type_expr with Dictionary base
        rule!((dictionary_type key: @k value: @v) => (generic_type_expr
            base: (named_type_expr name: (identifier "Dictionary"))
            type_argument: {k}
            type_argument: {v})),
        // Optional type `T?` → generic_type_expr with Optional base
        rule!((optional_type wrapped: @w) => (generic_type_expr
            base: (named_type_expr name: (identifier "Optional"))
            type_argument: {w})),
        // Function type `(Params) -> Ret` → function_type_expr.
        rule!((function_type parameter: _* @ps return_type: @ret) => (function_type_expr parameter: {..ps} return_type: {ret})),
        rule!((function_type_parameter name: @name type: @ty) => (parameter external_name: (identifier #{name}) type: {ty})),
        rule!((function_type_parameter type: @ty) => (parameter type: {ty})),
        // Selector expression: `#selector(inner)` -- not yet supported
        rule!(
            (selector_expression _ @inner)
            =>
            (unsupported_node)
        ),
        // Key path expressions are currently unsupported.
        rule!((key_path_expression) => (unsupported_node)),
        // Inheritance specifier → base_type
        rule!((inheritance_specifier inherits_from: @ty) => (base_type type: {ty})),
        // Class declaration with body containing members
        rule!(
            (class_declaration
                declaration_kind: @kind
                name: @name
                body: (class_body member: _* @members)
                (inheritance_specifier)* @bases
                (modifiers)* @mods)
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {..mods}
                name: (identifier #{name})
                base_type: {..bases}
                member: {..members})
        ),
        // Enum class declaration: same as a regular class but with an enum body.
        rule!(
            (class_declaration
                declaration_kind: @kind
                name: @name
                body: (enum_class_body member: _* @members)
                (inheritance_specifier)* @bases
                (modifiers)* @mods)
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {..mods}
                name: (identifier #{name})
                base_type: {..bases}
                member: {..members})
        ),
        // Class declaration with empty body
        rule!(
            (class_declaration
                declaration_kind: @kind
                name: @name
                body: _
                (inheritance_specifier)* @bases
                (modifiers)* @mods)
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {..mods}
                name: (identifier #{name})
                base_type: {..bases})
        ),
        // Protocol declaration
        rule!(
            (protocol_declaration
                name: @name
                body: (protocol_body member: _* @members)
                (inheritance_specifier)* @bases
                (modifiers)* @mods)
            =>
            (class_like_declaration
                modifier: (modifier "protocol")
                modifier: {..mods}
                name: (identifier #{name})
                base_type: {..bases}
                member: {..members})
        ),
        // Protocol function — return type and body statements both optional.
        rule!(
            (protocol_function_declaration
                name: @name
                (parameter)* @params
                return_type: _? @ret
                body: (block statement: _* @body_stmts)?
                (modifiers)* @mods)
            =>
            (function_declaration
                modifier: {..mods}
                name: (identifier #{name})
                parameter: {..params}
                return_type: {..ret}
                body: (block stmt: {..body_stmts}))
        ),
        // Init declaration → constructor_declaration. Body statements optional;
        // body itself is also optional (protocol requirement).
        rule!(
            (init_declaration
                (parameter)* @params
                body: (block statement: _* @body_stmts)?
                (modifiers)* @mods)
            =>
            (constructor_declaration
                modifier: {..mods}
                parameter: {..params}
                body: (block stmt: {..body_stmts}))
        ),
        // Deinit declaration → destructor_declaration. Body statements optional.
        rule!(
            (deinit_declaration
                body: (block statement: _* @body_stmts)
                (modifiers)* @mods)
            =>
            (destructor_declaration
                modifier: {..mods}
                body: (block stmt: {..body_stmts}))
        ),
        // Typealias declaration
        rule!(
            (typealias_declaration name: @name value: @val (modifiers)* @mods)
            =>
            (type_alias_declaration
                modifier: {..mods}
                name: (identifier #{name})
                r#type: {val})
        ),
        // Subscript declaration (not yet supported -- grammar needs to distinguish plain calls from subscript calls)
        rule!(
            (subscript_declaration (parameter)* @params (modifiers)* @mods)
            =>
            (unsupported_node)
        ),
        // Associated type declaration (with optional bound)
        rule!(
            (associatedtype_declaration name: @name inherits_from: _? @bound (modifiers)* @mods)
            =>
            (associated_type_declaration
                modifier: {..mods}
                name: (identifier #{name})
                bound: {..bound})
        ),
        // Protocol property declaration: translate each accessor
        // requirement to an `accessor_declaration` carrying the property
        // name, type, and outer modifiers. Manual rule: we publish the
        // property's name/type/modifiers into `ctx` and translate each
        // accessor with `ctx.is_chained` toggled per iteration so the
        // inner `getter_specifier`/`setter_specifier` rules emit
        // complete nodes from the start (including the
        // `chained_declaration` tag for non-first accessors).
        manual_rule!(
            (protocol_property_declaration
                name: (pattern bound_identifier: @name)
                requirements: (protocol_property_requirements accessor: _+ @accessors)
                type: _? @ty
                (modifiers)* @mods)
            {
                ctx.property_name = Some(tree!((identifier #{name})));
                ctx.property_type = ctx.translate_opt(ty)?;
                let mut modifiers = Vec::new();
                for m in mods {
                    modifiers.extend(ctx.translate(m)?);
                }
                ctx.outer_modifiers = modifiers;

                let mut result = Vec::new();
                for (i, acc) in accessors.into_iter().enumerate() {
                    ctx.is_chained = i > 0;
                    result.extend(ctx.translate(acc)?);
                }
                Ok(result)
            }
        ),
        // getter_specifier / setter_specifier → bodyless accessor_declaration
        // getter_specifier / setter_specifier → bodyless
        // accessor_declaration. Reads property name/type/modifiers from
        // `ctx` set by the outer `protocol_property_declaration` rule.
        rule!(
            (getter_specifier)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("getter_specifier outside protocol_property_declaration context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "get")
                modifier: {..ctx.outer_modifiers.clone()}
                modifier: {..chained_modifier(&mut ctx)})
        ),
        rule!(
            (setter_specifier)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("setter_specifier outside protocol_property_declaration context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "set")
                modifier: {..ctx.outer_modifiers.clone()}
                modifier: {..chained_modifier(&mut ctx)})
        ),
        // protocol_property_requirements wrapper — should be consumed by above; fallback
        rule!((protocol_property_requirements accessor: _* @accs) => {..accs}),
        // Computed getter → accessor_declaration (body optional).
        // Reads `ctx.property_name`/`ctx.property_type` set by the outer
        // property_binding manual rule.
        rule!(
            (computed_getter body: (block statement: _* @body)?)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("computed_getter outside property_binding context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "get")
                body: (block stmt: {..body}))
        ),
        // Computed setter with explicit parameter name.
        rule!(
            (computed_setter parameter: @param body: (block statement: _* @body))
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("computed_setter outside property_binding context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "set")
                parameter: (parameter pattern: (name_pattern identifier: (identifier #{param})))
                body: (block stmt: {..body}))
        ),
        // Computed setter without explicit parameter name; body optional.
        rule!(
            (computed_setter body: (block statement: _* @body)?)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("computed_setter outside property_binding context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "set")
                body: (block stmt: {..body}))
        ),
        // Computed modify → accessor_declaration
        rule!(
            (computed_modify body: (block statement: _* @body))
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("computed_modify outside property_binding context")?}
                type: {..ctx.property_type}
                accessor_kind: (accessor_kind "modify")
                body: (block stmt: {..body}))
        ),
        // willset/didset block — spread to children (only reachable as a
        // fallback; the outer property_binding manual rule normally
        // captures the willset/didset clauses directly).
        rule!((willset_didset_block _* @clauses) => {..clauses}),
        // willset clause → accessor_declaration (body optional). Reads
        // `ctx.property_name` set by the outer property_binding rule.
        rule!(
            (willset_clause body: (block statement: _* @body)?)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("willset_clause outside property_binding context")?}
                accessor_kind: (accessor_kind "willSet")
                body: (block stmt: {..body}))
        ),
        // didset clause → accessor_declaration (body optional).
        rule!(
            (didset_clause body: (block statement: _* @body)?)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("didset_clause outside property_binding context")?}
                accessor_kind: (accessor_kind "didSet")
                body: (block stmt: {..body}))
        ),
        // Preprocessor conditionals — unsupported
        rule!((diagnostic) => (unsupported_node)),
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
    let ts_language: tree_sitter::Language = tree_sitter_swift::LANGUAGE.into();
    let config = DesugaringConfig::<SwiftContext>::new()
        .add_phase("translate", PhaseKind::OneShot, translation_rules())
        .with_output_node_types_yaml(desugared_ast_schema);
    let desugarer = ConcreteDesugarer::new(ts_language.clone(), config)
        .expect("failed to build Swift desugarer");
    simple::LanguageSpec {
        prefix: "swift",
        ts_language,
        node_types: tree_sitter_swift::NODE_TYPES,
        file_globs: vec!["*.swift".into(), "*.swiftinterface".into()],
        desugar: Some(Box::new(desugarer)),
    }
}
