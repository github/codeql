use codeql_extractor::extractor::desugaring;
use yeast::{ConcreteDesugarer, DesugaringConfig, PhaseKind, Rule, rule, tree};

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
    /// Translated outer modifiers to attach to each child of a flattening
    /// outer rule — e.g. the `let`/`var` binding modifier on each
    /// `patternBinding` of a `variableDecl`, or the binding modifier on each
    /// accessor of a property.
    outer_modifiers: Vec<yeast::Id>,
    /// True when the current child of a flattening outer rule is not
    /// the first one — its inner rule should emit a
    /// `chained_declaration` modifier so the original grouping can be
    /// recovered downstream.
    is_chained: bool,
    /// True while translating the parameters of a `functionType`. swift-syntax
    /// models a function type's parameters with the same `tupleTypeElement`
    /// kind as a tuple type's elements, so the shared `tupleTypeElement` rule
    /// reads this to emit a `parameter` (function-type param) rather than a
    /// `tuple_type_element` (tuple-type element). The `tupleType` /
    /// `functionType` rules each set it for their direct children, so nested
    /// types are translated in the correct context.
    in_function_type: bool,
    /// True while translating the argument list of an enum-case
    /// `constructor_pattern` (e.g. `case .foo(let x, 3)`). Read by the
    /// `labeledExpr` rules so a bare expression argument becomes an
    /// `expr_equality_pattern` (wrapped in a `pattern_element`) rather than a
    /// call `argument`.
    in_pattern: bool,
}

impl SwiftContext {
    /// Clear the context fields that must not propagate into an
    /// expression / statement / body subtree.
    ///
    /// Mirrors `Default::default()` for `SwiftContext` today, but is a
    /// named method so future context fields can opt in or out of
    /// clearing here per-field.
    ///
    /// Called before recursively translating a body / initializer
    /// slot. Most rules mutate `ctx` in place — the framework invokes
    /// each rule with a private clone of the user context, so
    /// mutations are discarded on rule exit anyway. Rules that need
    /// the outer context intact *after* the reset-and-translate (see
    /// e.g. the `property_binding` willSet/didSet rule) wrap the
    /// mutation in `ctx.scoped(...)` instead.
    fn reset(&mut self) {
        *self = SwiftContext::default();
    }
}

/// Build a freshly-created `chained_declaration` modifier node if
/// `ctx.is_chained`, else `None`. Used by inner declaration rules to
/// emit the chained tag for non-first children of a flattening outer
/// rule. Returns `Option<Id>` so it splices via `{…}` to 0 or 1 ids.
fn chained_modifier(ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>) -> Option<yeast::Id> {
    if ctx.is_chained {
        Some(ctx.literal("modifier", "chained_declaration"))
    } else {
        None
    }
}

/// Combine a list of boolean sub-conditions into a single expression by
/// left-folding with the infix `&&` operator. Used by control-flow
/// rules (`if`, `guard`, `while`, `repeat-while`) whose tree-sitter
/// nodes carry one or more comma-separated conditions that the target
/// AST represents as a single `condition:` field. Panics on an empty
/// input because every caller's grammar guarantees at least one
/// condition.
fn and_chain(
    ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>,
    conds: Vec<yeast::Id>,
) -> yeast::Id {
    conds
        .into_iter()
        .reduce(|acc, elem| {
            tree!((binary_expr operator: (infix_operator "&&") left: {acc} right: {elem}))
        })
        .expect("control-flow statement must have at least one condition")
}

/// Translate a multi-part identifier (for example `Foo.Bar.Baz`) into a
/// `member_access_expr` chain rooted at a `name_expr` over the first
/// part. Panics on an empty input because the grammar's `_+` quantifier
/// guarantees at least one part.
fn member_chain(
    ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>,
    parts: Vec<yeast::Id>,
) -> yeast::Id {
    let mut iter = parts.into_iter();
    let first = iter
        .next()
        .expect("identifier with `part:` must have at least one part");
    let init = tree!((name_expr identifier: (identifier #{first})));
    iter.fold(
        init,
        |acc, elem| tree!((member_access_expr base: {acc} member: (identifier #{elem}))),
    )
}

/// Compound-assignment operator spellings (`+=`, `<<=`, ...). Used to tell a
/// compound assignment from an ordinary binary application, both of which
/// arrive as a `binaryOperator`-based `infixOperatorExpr`.
const COMPOUND_ASSIGN_OPS: &[&str] = &[
    "+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "|=", "^=", "&+=", "&-=", "&*=",
];

fn translation_rules() -> Vec<Rule<SwiftContext>> {
    vec![
        // ---- Top-level ----
        // These rules translate the swift-syntax AST (camelCase kind names),
        // produced by the sibling `adapter` module from the `swift-syntax-parse`
        // binary's JSON. Anything unmatched falls through to the
        // `unsupported_node` fallback at the end.
        //
        // `sourceFile` holds its top-level statements in an (elided)
        // `statements` collection; each element is a `codeBlockItem` wrapping
        // the real node.
        rule!(
            (sourceFile statements: _* @items)
            =>
            (top_level body: (block stmt: {items}))
        ),
        // `codeBlockItem` wraps a top-level statement. It is a simple unwrapper,
        // but a single wrapped `variableDecl` can translate to *several*
        // declarations (`let x = 1, y = 2`), so the wrapped node is captured with
        // `_*` and the result annotated `stmt*` to splice all of them.
        rule!((codeBlockItem item: _* @item) => stmt* { item }),
        // ---- Literals ----
        // swift-syntax does not distinguish the lexical integer/string forms
        // (hex/binary/octal, single- vs multi-line, raw): each is a single
        // `*LiteralExpr` kind, so the tree-sitter variants collapse to one rule.
        rule!((integerLiteralExpr) => (int_literal)),
        rule!((floatLiteralExpr) => (float_literal)),
        rule!((booleanLiteralExpr) => (boolean_literal)),
        rule!((nilLiteralExpr) => (builtin_expr)),
        rule!((stringLiteralExpr) => (string_literal)),
        rule!((regexLiteralExpr) => (regex_literal)),
        // ---- Names ----
        // A function reference spelled with argument labels (`f(x:y:z:)`) is a
        // `declReferenceExpr` carrying `argumentNames`. Mark it unsupported for
        // now (rather than let the bare-name rule below treat it as a plain
        // reference), so downstream QL isn't handed a malformed reference. In
        // the future this should become a lambda expression. Matched before the
        // bare-name rule.
        rule!(
            (declReferenceExpr argumentNames: (declNameArguments))
            =>
            (unsupported_node)
        ),
        // A bare name reference (`x`), and an operator used as a value (`+` in
        // `reduce(0, +)`), are both `declReferenceExpr`; its `baseName` is the
        // referenced identifier / operator symbol.
        rule!((declReferenceExpr baseName: @name) => (name_expr identifier: (identifier #{name}))),
        // A discard `_` used as an expression — e.g. the target of a discarding
        // assignment `_ = x`. swift-syntax models it as a `discardAssignmentExpr`;
        // the tree-sitter path treated the bare `_` as a name, so map it to a
        // `name_expr` too.
        rule!((discardAssignmentExpr wildcard: @@w) => (name_expr identifier: (identifier #{w}))),
        // ---- Operators ----
        // The parser front-end folds operator chains into nested
        // `infixOperatorExpr`s by precedence (see swift-syntax-rs), so
        // `1 + 2 * 3` arrives here already structured.
        //
        // A `binaryOperatorExpr` wraps the operator token; unwrap it to the
        // operator leaf. Used by `infixOperatorExpr` (folded) and `sequenceExpr`
        // (unresolved).
        rule!((binaryOperatorExpr operator: @op) => (infix_operator #{op})),
        // Compound assignment (`x += y`) vs. an ordinary binary application
        // (`a + b`): both are `binaryOperator`-based `infixOperatorExpr`s,
        // distinguishable only by the operator's spelling. The query engine
        // can't match on token text, so a small Rust block reads the spelling
        // and routes to `compound_assign_expr` or `binary_expr`. The operator
        // is captured raw (`@@op`) to read its spelling.
        rule!(
            (infixOperatorExpr leftOperand: @l operator: (binaryOperatorExpr) @@op rightOperand: @r)
            =>
            expr {
                if COMPOUND_ASSIGN_OPS.contains(&ctx.source_text(op).as_str()) {
                    tree!((compound_assign_expr target: {l} operator: (infix_operator #{op}) value: {r}))
                } else {
                    tree!((binary_expr left: {l} operator: (infix_operator #{op}) right: {r}))
                }
            }
        ),
        // Plain assignment (`x = y`). In a folded chain the `=` is an
        // `assignmentExpr` node (distinct from other operators), matched by kind.
        rule!(
            (infixOperatorExpr leftOperand: @l operator: (assignmentExpr) rightOperand: @r)
            =>
            (assign_expr target: {l} value: {r})
        ),
        // Escape hatch: an operator chain the front-end could not resolve
        // (because it uses an operator of unknown precedence, e.g. imported from
        // another module) stays a flat `sequenceExpr`. Preserve it as an
        // `unresolved_operator_sequence` whose elements alternate operands and
        // infix operators, rather than guessing a structure.
        rule!((sequenceExpr elements: _* @els) => (unresolved_operator_sequence element: {els})),
        // Prefix unary operators (`!a`, `-x`).
        rule!((prefixOperatorExpr operator: @op expression: @operand) => (unary_expr operator: (prefix_operator #{op}) operand: {operand})),
        // A `tupleExpr` is a tuple literal (`(a, b)`) or a parenthesised
        // expression (`(x)`). For now it is kept as an opaque `tuple_expr` leaf
        // (its source text); its elements are not descended into.
        //
        // TODO: a parenthesised single-element `tupleExpr` is really a grouping
        // expression and should be elided (unwrapped to its inner expression)
        // rather than modelled as a tuple.
        rule!((tupleExpr) => (tuple_expr)),
        // A code block contains its statements directly.
        rule!((codeBlock statements: _* @stmts) => (block stmt: {stmts})),
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
        //
        // Toggles `ctx.is_chained` per accessor iteration: the first
        // accessor inherits the outer rule's chained state (i.e. whether
        // this whole property_binding is itself a non-first declarator
        // of a containing property_declaration); subsequent accessors
        // always emit `chained_declaration`.
        rule!(
            (property_binding
                name: @pattern
                type: _? @ty
                computed_value: (computed_property accessor: _+ @@accessors))
            =>
            accessor_declaration* {
                ctx.property_name = Some(tree!((identifier #{pattern})));
                ctx.property_type = ty;

                let mut result = Vec::new();
                for (i, acc) in accessors.into_iter().enumerate() {
                    if i > 0 {
                        ctx.is_chained = true;
                    }
                    result.extend(ctx.translate(acc)?);
                }
                result
            }
        ),
        // Computed property: shorthand getter (no explicit get/set, just
        // statements) → a single accessor_declaration with kind "get".
        // Reads outer modifiers / chained tag from `ctx` (set by the
        // outer `property_declaration` rule).
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                type: _? @ty
                computed_value: (computed_property statement: _* @@body))
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: (identifier #{name})
                type: {ty}
                accessor_kind: (accessor_kind "get")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // Stored property with willSet/didSet observers (initializer
        // optional) → a `variable_declaration` followed by one
        // `accessor_declaration` per observer, each born with the
        // property name set. Manual rule: we publish the property name
        // into `ctx` before translating the observer children so the
        // inner `willset_clause` / `didset_clause` rules construct
        // valid `accessor_declaration` nodes from the start.
        //
        // The `variable_declaration` itself inherits the outer rule's
        // chained state; observers always get `chained_declaration`
        // because they're subsequent outputs of this flattening rule.
        rule!(
            (property_binding
                name: (pattern bound_identifier: @name)
                type: _? @ty
                value: _? @@val
                observers: (willset_didset_block willset: _? @@ws didset: _? @@ds))
            =>
            member* {
                // The initializer value must not inherit the binding
                // context (it may contain patterns, e.g. a switch
                // expression), so translate it inside a `ctx.scoped`
                // block — the block receives a temporary `ctx` whose
                // `user_ctx` is a clone; mutations to it are discarded
                // when the block returns, so the outer `ctx` is intact
                // for the observer loop below. The observers keep the
                // outer context: each willSet/didSet accessor emits
                // the binding modifier and, in turn, resets the
                // context for its own body.
                let val = ctx.scoped(|ctx| {
                    ctx.reset();
                    ctx.translate(val)
                })?;

                let var_decl = tree!(
                    (variable_declaration
                        modifier: {ctx.outer_modifiers.clone()}
                        modifier: {chained_modifier(&mut ctx)}
                        pattern: (name_pattern identifier: (identifier #{name}))
                        type: {ty}
                        value: {val})
                );

                // Publish the property name for the observer rules.
                ctx.property_name = Some(tree!((identifier #{name})));
                // Observers are subsequent outputs of this flattening
                // rule, so they always get `chained_declaration`.
                ctx.is_chained = true;

                let mut result = vec![var_decl];
                for obs in ws.into_iter().chain(ds) {
                    result.extend(ctx.translate(obs)?);
                }
                result
            }
        ),
        // The individual bindings of a `variableDecl`. The binding modifier and
        // chained tag come from `ctx` (set by the `variableDecl` rule below). The
        // type annotation and initializer are both optional (one combined rule
        // covers `let x`, `let x = e`, `let x: T`, and `let x: T = e`); the
        // initializer value is translated in a reset scope so it is not treated
        // as a binding.
        rule!(
            (patternBinding
                pattern: @pattern
                typeAnnotation: (typeAnnotation type: @ty)?
                initializer: (initializerClause value: @@val)?)
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                pattern: {pattern}
                type: {ty}
                value: {ctx.reset(); ctx.translate(val)?})
        ),
        // A `let`/`var` declaration binds one or more comma-separated patterns
        // (`let x = 1, y = 2`). The `bindingSpecifier` (`let`/`var`) is published
        // as the binding modifier, followed by any attributes and modifiers
        // (`@objc`, `public`, `static`, …); each `patternBinding` becomes its own
        // `variable_declaration`, with non-first ones tagged `chained_declaration`.
        // Accessor/observer forms are handled by the earlier rules.
        rule!(
            (variableDecl
                attributes: _* @attrs
                modifiers: _* @mods
                bindingSpecifier: @@spec
                bindings: _* @@bindings)
            =>
            stmt* {
                let binding = tree!((modifier #{spec}));
                // The binding (`let`/`var`) leads, then attributes then modifiers
                // in source order (Swift writes attributes before modifiers).
                ctx.outer_modifiers = std::iter::once(binding).chain(attrs).chain(mods).collect();
                let mut result = Vec::new();
                for (i, b) in bindings.into_iter().enumerate() {
                    ctx.is_chained = i > 0;
                    result.extend(ctx.translate(b)?);
                }
                result
            }
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
        // enum_case_entry with associated values → class_like_declaration
        // containing a constructor whose parameters are the data
        // parameters. Reads outer modifiers / chained tag from `ctx`
        // (set by the outer `enum_entry` rule).
        rule!(
            (enum_case_entry
                name: @name
                data_contents: (enum_type_parameters parameter: _* @params))
            =>
            (class_like_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                name: (identifier #{name})
                member: (constructor_declaration parameter: {params} body: (block)))
        ),
        // enum_case_entry with explicit raw value → variable_declaration with that value.
        rule!(
            (enum_case_entry name: @name raw_value: @val)
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {val})
        ),
        // enum_case_entry without associated values → variable_declaration tagged enum_case.
        rule!(
            (enum_case_entry name: @name)
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        // enum_entry: flatten case entries; publish outer modifiers
        // into `ctx` and translate each case with `ctx.is_chained`
        // toggled per iteration so the inner `enum_case_entry` rules
        // emit complete `modifier:` lists from the start.
        rule!(
            (enum_entry case: _+ @@cases (modifiers)* @mods)
            =>
            member* {
                ctx.outer_modifiers = mods;

                let mut result = Vec::new();
                for (i, case) in cases.into_iter().enumerate() {
                    ctx.is_chained = i > 0;
                    result.extend(ctx.translate(case)?);
                }
                result
            }
        ),
        // Unwrap `type` wrapper node
        rule!((type name: @inner) => type_expr { inner }),
        // `identifierPattern` wraps a single identifier token.
        rule!(
            (identifierPattern identifier: @name)
            =>
            (name_pattern identifier: (identifier #{name}))
        ),
        // A `let`/`var` value-binding pattern (`let x`) inside a case or `if case`
        // introduces a new binding; it unwraps to its inner pattern (a
        // `name_pattern`).
        rule!((valueBindingPattern pattern: @p) => pattern { p }),
        // An enum-case pattern with associated values (`case .foo(let x)`,
        // `case Color.foo(let x)`) is an expression pattern wrapping a call of a
        // member access. It becomes a `constructor_pattern`; its arguments are
        // translated as pattern elements (see the `labeledExpr` rules, gated by
        // `ctx.in_pattern`). Matched before the generic `expressionPattern` rule.
        // The base is optional: a leading-dot form (`.foo`) has none, so the
        // constructor's base is an `inferred_type_expr`.
        rule!(
            (expressionPattern expression: (functionCallExpr
                calledExpression: (memberAccessExpr base: _? @base period: @dot declName: (declReferenceExpr baseName: @name))
                arguments: _* @@args))
            =>
            constructor_pattern {
                ctx.in_pattern = true;
                let elements = ctx.translate(args)?;
                let base = base.unwrap_or_else(|| tree!((inferred_type_expr #{dot})));
                tree!((constructor_pattern
                    constructor: (member_access_expr
                        base: {base}
                        member: (identifier #{name}))
                    element: {elements}))
            }
        ),
        // A tuple destructuring pattern (`let (a, b) = …`). A labelled element
        // (`let (x: a) = …`) carries its label through as the `pattern_element`
        // key; unlabelled elements have no key.
        rule!((tuplePattern elements: _* @els) => (tuple_pattern element: {els})),
        rule!(
            (tuplePatternElement label: _? @label pattern: @p)
            =>
            (pattern_element key: {label.map(|l| tree!((identifier #{l})))} pattern: {p})
        ),
        // A type-casting pattern (`case is T`). Not yet supported, so it is
        // mapped to `unsupported_node` — an explicit reminder that this needs
        // handling in the future. (Redundant with the catch-all fallback, but
        // kept as a signpost.)
        rule!((isTypePattern) => (unsupported_node)),
        // A standalone wildcard pattern (`case _:`, `if case _`): swift-syntax
        // models the bare `_` as an `expressionPattern` wrapping a
        // `discardAssignmentExpr`. Matched before the generic `expressionPattern`
        // rule so `_` becomes an `ignore_pattern` rather than an equality match.
        // (Wildcards *inside* an enum-case argument list are handled by the
        // `labeledExpr`/`discardAssignmentExpr` rules.)
        rule!((expressionPattern expression: (discardAssignmentExpr)) => (ignore_pattern)),
        // A wildcard *binding* pattern (`let _ = x`, `for _ in xs`). swift-syntax
        // models this as a `wildcardPattern` — distinct from the `_` *match*
        // pattern above, which is an `expressionPattern` over a
        // `discardAssignmentExpr`.
        rule!((wildcardPattern) => (ignore_pattern)),
        // A tuple pattern in a match position (`case (let a, 3):`) is parsed by
        // swift-syntax as an `expressionPattern` wrapping a `tupleExpr` — unlike a
        // binding tuple (`let (a, b)`), which is a real `tuplePattern`. Recognise
        // it as a `tuple_pattern`; its `labeledExpr` elements translate to
        // `pattern_element`s under `ctx.in_pattern` (a binding element becomes a
        // `name_pattern`, any other expression an `expr_equality_pattern`).
        rule!(
            (expressionPattern expression: (tupleExpr elements: _* @@els))
            =>
            tuple_pattern {
                ctx.in_pattern = true;
                let elements = ctx.translate(els)?;
                tree!((tuple_pattern element: {elements}))
            }
        ),
        // A bare expression pattern (`case 1:`, `case someConstant:`) matches by
        // equality.
        rule!((expressionPattern expression: @e) => (expr_equality_pattern expr: {e})),
        // ---- Functions ----
        // A function declaration (parameters/return type/body optional). The
        // parameters and return type nest under `signature`; the body is a
        // `codeBlock`. A bodyless function (a protocol requirement) still emits
        // an empty `block`, matching the tree-sitter path.
        rule!(
            (functionDecl
                name: @name
                signature: (functionSignature
                    parameterClause: (functionParameterClause parameters: _* @params)
                    returnClause: (returnClause type: @ret)?)
                body: (codeBlock statements: _* @body))
            =>
            (function_declaration
                name: (identifier #{name})
                parameter: {params}
                return_type: {ret}
                body: (block stmt: {body}))
        ),
        rule!(
            (functionDecl
                name: @name
                signature: (functionSignature
                    parameterClause: (functionParameterClause parameters: _* @params)
                    returnClause: (returnClause type: @ret)?))
            =>
            (function_declaration
                name: (identifier #{name})
                parameter: {params}
                return_type: {ret}
                body: (block))
        ),
        // A function parameter. With two names (`firstName`+`secondName`) the
        // first is the external argument label and the second the internal name;
        // with one name it is just the internal name. The default value is
        // optional.
        //
        // PARITY: the declared type is intentionally dropped. In the tree-sitter
        // path the untyped-parameter rule was ordered before the typed one and
        // shadowed it (first match wins), so the baseline emits no parameter
        // type; emitting one here would diverge from it.
        rule!(
            (functionParameter
                firstName: @@first
                secondName: _? @@second
                defaultValue: (initializerClause value: @val)?)
            =>
            parameter {
                let (external, name) = match second {
                    Some(second) => (Some(tree!((identifier #{first}))), second),
                    None => (None, first),
                };
                tree!((parameter
                    external_name: {external}
                    pattern: (name_pattern identifier: (identifier #{name}))
                    default: {val}))
            }
        ),
        // A function/method call (`foo(1, 2)`). `calledExpression` is the callee
        // and `arguments` is an (elided) list of `labeledExpr`, each translated
        // to an `argument` below. A trailing closure (`xs.map { … }`) becomes a
        // final unlabelled argument; that variant is matched first.
        rule!(
            (functionCallExpr calledExpression: @callee arguments: _* @args trailingClosure: @tc)
            =>
            (call_expr callee: {callee} argument: {args} argument: (argument value: {tc}))
        ),
        rule!(
            (functionCallExpr calledExpression: @callee arguments: _* @args)
            =>
            (call_expr callee: {callee} argument: {args})
        ),
        // A call argument or an enum-case pattern argument. When translating an
        // enum-case `constructor_pattern`'s arguments (`ctx.in_pattern`), a
        // `patternExpr` argument (`let x`) becomes a bound `name_pattern`, a
        // wildcard (`_`) becomes an `ignore_pattern`, and any other expression
        // becomes an `expr_equality_pattern`; each is wrapped in a
        // `pattern_element` carrying the optional argument label as its `key`.
        // Otherwise the argument keeps its label as the `name` and its value.
        // The pattern-only shapes (`patternExpr`, `discardAssignmentExpr`) are
        // matched first; they never occur as ordinary call arguments.
        rule!(
            (labeledExpr label: _? @lbl expression: (patternExpr pattern: @p))
            =>
            (pattern_element key: {lbl.map(|l| tree!((identifier #{l})))} pattern: {p})
        ),
        rule!(
            (labeledExpr label: _? @lbl expression: (discardAssignmentExpr) @@wildcard)
            =>
            (pattern_element key: {lbl.map(|l| tree!((identifier #{l})))} pattern: (ignore_pattern #{wildcard}))
        ),
        rule!(
            (labeledExpr label: _? @lbl expression: @val)
            =>
            argument {
                let key = lbl.map(|l| tree!((identifier #{l})));
                if ctx.in_pattern {
                    tree!((pattern_element
                        key: {key}
                        pattern: (expr_equality_pattern expr: {val})))
                } else {
                    tree!((argument name: {key} value: {val}))
                }
            }
        ),
        // Member access (`list.append`). The `declName` is itself a
        // `declReferenceExpr`; pull its `baseName` out as the member identifier.
        // A leading-dot access (`.foo`) has no explicit base — the base is an
        // `inferred_type_expr`. The base-ful form is matched first.
        rule!(
            (memberAccessExpr base: @base declName: (declReferenceExpr baseName: @member))
            =>
            (member_access_expr base: {base} member: (identifier #{member}))
        ),
        rule!(
            (memberAccessExpr declName: (declReferenceExpr baseName: @member))
            =>
            (member_access_expr base: (inferred_type_expr) member: (identifier #{member}))
        ),
        // Control transfer, one rule per keyword. `return` carries an optional
        // value; `break` / `continue` an optional target label; `throw` its
        // thrown expression.
        rule!((returnStmt expression: _? @val) => (return_expr value: {val})),
        rule!((breakStmt label: _? @@lbl) => (break_expr label: {lbl.map(|l| tree!((identifier #{l})))})),
        rule!((continueStmt label: _? @@lbl) => (continue_expr label: {lbl.map(|l| tree!((identifier #{l})))})),
        rule!((throwStmt expression: @val) => (throw_expr value: {val})),
        // ---- Closures ----
        // A closure (`{ (x: Int) -> Int in … }`) becomes a `function_expr`. The
        // whole signature is optional, as are its capture list, parameter
        // clause, and return clause, so one rule covers everything from a bare
        // `{ … }` to `{ [weak self] (x) -> T in … }`. Shorthand `$0` closures
        // have no signature and their `$0` references are ordinary name
        // expressions.
        rule!(
            (closureExpr
                signature: (closureSignature
                    attributes: _* @attrs
                    capture: (closureCaptureClause items: _* @captures)?
                    parameterClause: _* @params
                    returnClause: (returnClause type: @ret)?)?
                statements: _* @body)
            =>
            (function_expr
                modifier: {attrs}
                capture_declaration: {captures}
                parameter: {params}
                return_type: {ret}
                body: (block stmt: {body}))
        ),
        // A closure capture (`[weak self]`, `[x]`, `[y = expr]`). The optional
        // ownership specifier (`weak`/`unowned`) becomes a modifier; the
        // captured name becomes the bound `name_pattern`; an explicit capture
        // initializer (`[y = expr]`) becomes the bound value.
        rule!(
            (closureCapture
                specifier: (closureCaptureSpecifier specifier: @@spec)?
                name: @@name
                initializer: (initializerClause value: @val)?)
            =>
            (variable_declaration
                modifier: {spec.map(|s| tree!((modifier #{s})))}
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {val})
        ),
        // A closure parameter clause (`(x: Int, y)`) unwraps to its parameters.
        rule!((closureParameterClause parameters: _* @params) => parameter* { params }),
        // A closure parameter (`x: Int`, or just `x`). Unlike a function
        // parameter it has no external label; the type is optional.
        rule!(
            (closureParameter firstName: @name type: _? @ty)
            =>
            (parameter pattern: (name_pattern identifier: (identifier #{name})) type: {ty})
        ),
        // A shorthand closure parameter (`x` in `{ x, y in … }`): a bare name
        // with no parentheses and no type.
        rule!(
            (closureShorthandParameter name: @name)
            =>
            (parameter pattern: (name_pattern identifier: (identifier #{name})))
        ),
        // ---- Control flow ----
        // An `if`/`else` expression. Conditions are joined via `and_chain`; the
        // then-body and optional else-body (another block, or an `ifExpr` for an
        // else-if chain) are translated recursively.
        rule!(
            (ifExpr conditions: _* @cond body: @then_body elseBody: _? @else_stmts)
            =>
            (if_expr
                condition: {and_chain(&mut ctx, cond)}
                then: {then_body}
                else: {else_stmts})
        ),
        // A `guard … else { }` statement. The `body` is the else block.
        rule!(
            (guardStmt conditions: _* @cond body: @else_stmts)
            =>
            (guard_if_stmt
                condition: {and_chain(&mut ctx, cond)}
                else: {else_stmts})
        ),
        // Ternary (`c ? a : b`) desugars to an `if_expr`, as in the tree-sitter
        // path.
        rule!(
            (ternaryExpr condition: @cond thenExpression: @then_val elseExpression: @else_val)
            =>
            (if_expr condition: {cond} then: {then_val} else: {else_val})
        ),
        // A `switch` statement. Each `switchCase` becomes a `switch_case` with a
        // pattern (or an `or_pattern` for comma-separated `case a, b:`) and a
        // body; a `default:` case has a body but no pattern. The case items and
        // body are auto-translated; the Rust block only picks the pattern shape
        // by arity (the query engine can't branch on list length).
        rule!(
            (switchExpr subject: @val cases: _* @cases)
            =>
            (switch_expr value: {val} case: {cases})
        ),
        rule!(
            (switchCase label: (switchCaseLabel caseItems: _* @items) statements: _* @body)
            =>
            switch_case {
                let pattern = if items.len() == 1 {
                    items[0]
                } else {
                    tree!((or_pattern pattern: {items}))
                };
                tree!((switch_case pattern: {pattern} body: (block stmt: {body})))
            }
        ),
        rule!(
            (switchCase label: (switchDefaultLabel) statements: _* @body)
            =>
            (switch_case body: (block stmt: {body}))
        ),
        // A single case item unwraps to its pattern (used as an `or_pattern`
        // element).
        rule!((switchCaseItem pattern: @p) => pattern { p }),
        // A pattern-matching condition (`if case let x = e`, `if case .foo(let x)
        // = e`) becomes a `pattern_guard_expr`: the matched pattern and the
        // scrutinee value are translated recursively.
        rule!(
            (matchingPatternCondition pattern: @pat initializer: (initializerClause value: @val))
            =>
            (pattern_guard_expr pattern: {pat} value: {val})
        ),
        // Optional binding (`if let x = foo`, or shorthand `if let x`) desugars
        // to a `pattern_guard_expr` matching `Optional.some(x)`, exactly as the
        // tree-sitter path does. The initialized form is matched first.
        rule!(
            (optionalBindingCondition
                pattern: (identifierPattern identifier: @name)
                initializer: (initializerClause value: @val))
            =>
            (pattern_guard_expr
                value: {val}
                pattern: (constructor_pattern
                    constructor: (member_access_expr base: (named_type_expr name: (identifier "Optional")) member: (identifier "some"))
                    element: (pattern_element pattern: (name_pattern identifier: (identifier #{name})))))
        ),
        rule!(
            (optionalBindingCondition pattern: (identifierPattern identifier: @name))
            =>
            (pattern_guard_expr
                value: (name_expr identifier: (identifier #{name}))
                pattern: (constructor_pattern
                    constructor: (member_access_expr base: (named_type_expr name: (identifier "Optional")) member: (identifier "some"))
                    element: (pattern_element pattern: (name_pattern identifier: (identifier #{name})))))
        ),
        // A single condition in an `if`/`while`/`guard` condition list unwraps to
        // its inner expression; `and_chain` joins multiple with `&&`.
        rule!((conditionElement condition: @c) => expr { c }),
        // `if`/`switch`/`do` are expressions in Swift; when used as a statement
        // swift-syntax wraps them in an `expressionStmt`. Unwrap to the inner
        // expression (a plain expression statement, e.g. a call, is not wrapped).
        rule!((expressionStmt expression: @e) => expr { e }),
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
                guard: {guard}
                body: (block stmt: {body}))
        ),
        // While loop
        rule!(
            (while_statement condition: _* @cond body: (block statement: _* @body))
            =>
            (while_stmt
                condition: {and_chain(&mut ctx, cond)}
                body: (block stmt: {body}))
        ),
        // Repeat-while loop
        rule!(
            (repeat_while_statement condition: _* @cond body: (block statement: _* @body))
            =>
            (do_while_stmt
                condition: {and_chain(&mut ctx, cond)}
                body: (block stmt: {body}))
        ),
        // Labeled statement (e.g. `outer: for ...`). Strip the trailing ':' from the label token.
        rule!((labeled_statement label: (statement_label) @lbl statement: @stmt) => labeled_stmt {
            let text = ctx.ast.source_text(lbl);
            let name = &text[..text.len() - 1];
            tree!((labeled_stmt label: (identifier #{name}) stmt: {stmt}))
        }),
        // ---- Collections ----
        // Array literal
        rule!((array_literal element: _* @elems) => (array_literal element: {elems})),
        // Empty array literal
        rule!((array_literal) => (array_literal)),
        // Dictionary literal — zip keys and values into key_value_pairs
        rule!(
            (dictionary_literal key: _* @keys value: _* @vals)
            =>
            (map_literal element: {keys.into_iter().zip(vals).map(|(k, v)|
                tree!((key_value_pair key: {k} value: {v}))
            )})
        ),
        rule!((dictionary_literal element: _* @elems) => (map_literal element: {elems})),
        rule!((dictionary_literal_item key: @k value: @v) => (key_value_pair key: {k} value: {v})),
        // ---- Optionals and errors ----
        // Optional chaining — unwrap the marker
        rule!((optional_chain_marker expr: @inner) => expr { inner }),
        // try/try?/try! expr → unary_expr with operator "try", "try?" or "try!"
        rule!((try_expression (try_operator) @op expr: @inner) => (unary_expr operator: (prefix_operator #{op}) operand: {inner})),
        rule!((try_expression operator: (try_operator) @op expr: @inner) => (unary_expr operator: (prefix_operator #{op}) operand: {inner})),
        // Do-catch → try_expr
        rule!(
            (do_statement body: (block statement: _* @body) catch: (catch_block)* @catches)
            =>
            (try_expr
                body: (block stmt: {body})
                catch_clause: {catches})
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
                guard: {guard}
                body: (block stmt: {body}))
        ),
        // Catch block without error binding
        rule!(
            (catch_block keyword: (catch_keyword) body: (block statement: _* @body))
            =>
            (catch_clause body: (block stmt: {body}))
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
                body: (block stmt: {body}))
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
            expr { member_chain(&mut ctx, parts) }
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
                modifier: {mods})
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
                modifier: {mods})
        ),
        // ---- Types and classes ----
        // Self expression → name_expr
        rule!((self_expression) => (name_expr identifier: (identifier "self"))),
        // Super expression → super_expr
        rule!((super_expression) => (super_expr)),
        // Modifiers — unwrap to individual modifier children
        rule!((modifiers _* @mods) => modifier* { mods }),
        rule!((attribute) @m => (modifier #{m})),
        // swift-syntax models every access/function/member/mutation/ownership
        // modifier as a single `declModifier`; its source text is the modifier.
        rule!((declModifier) @m => (modifier #{m})),
        rule!((visibility_modifier) @m => (modifier #{m})),
        rule!((function_modifier) @m => (modifier #{m})),
        rule!((member_modifier) @m => (modifier #{m})),
        rule!((mutation_modifier) @m => (modifier #{m})),
        rule!((ownership_modifier) @m => (modifier #{m})),
        rule!((property_modifier) @m => (modifier #{m})),
        rule!((parameter_modifier) @m => (modifier #{m})),
        rule!((inheritance_modifier) @m => (modifier #{m})),
        rule!((property_behavior_modifier) @m => (modifier #{m})),
        // Type expressions. A generic type applied with explicit arguments
        // (`Set<Int>`) is represented opaquely, using the whole source text as
        // the name (PARITY(tree-sitter): the generic arguments are not
        // structured `type_argument`s). Matched before the plain `identifierType`
        // rule, which would otherwise drop the arguments.
        rule!(
            (identifierType genericArgumentClause: (genericArgumentClause)) @@ty
            =>
            (named_type_expr name: (identifier #{ty}))
        ),
        // A named type (`Int`). `identifierType.name` is the type-name token.
        rule!((identifierType name: @@n) => (named_type_expr name: (identifier #{n}))),
        // A qualified type (`Outer.Inner`, `NSString.CompareOptions`). swift-syntax
        // nests these as `memberType` nodes; like the old tree-sitter `user_type`
        // rule, we keep the whole dotted path as the opaque `named_type_expr` name.
        rule!((memberType) @ty => (named_type_expr name: (identifier #{ty}))),
        // Sugared types desugar to `generic_type_expr`: `T?` -> Optional<T>,
        // `[T]` -> Array<T>, `[K: V]` -> Dictionary<K, V>.
        rule!(
            (optionalType wrappedType: @w)
            =>
            (generic_type_expr base: (named_type_expr name: (identifier "Optional")) type_argument: {w})
        ),
        rule!(
            (arrayType element: @e)
            =>
            (generic_type_expr base: (named_type_expr name: (identifier "Array")) type_argument: {e})
        ),
        rule!(
            (dictionaryType key: @k value: @v)
            =>
            (generic_type_expr base: (named_type_expr name: (identifier "Dictionary")) type_argument: {k} type_argument: {v})
        ),
        // A tuple type (`(Int, String)`) or function type (`(Int) -> Bool`).
        // Both hold their contents as `tupleTypeElement`s, but a tuple element
        // maps to `tuple_type_element` while a function parameter maps to
        // `parameter`. Each container sets `ctx.in_function_type` for its direct
        // children (and translates them explicitly, so a nested type is
        // translated in the right context) and the shared `tupleTypeElement`
        // rule below reads it. An element's label (`firstName`) is optional.
        rule!(
            (tupleType elements: _* @@elems)
            =>
            tuple_type_expr {
                ctx.in_function_type = false;
                let mut out = Vec::new();
                for e in elems {
                    out.extend(ctx.translate(e)?);
                }
                tree!((tuple_type_expr element: {out}))
            }
        ),
        rule!(
            (functionType parameters: _* @@params returnClause: (returnClause type: @ret))
            =>
            function_type_expr {
                ctx.in_function_type = true;
                let mut out = Vec::new();
                for p in params {
                    out.extend(ctx.translate(p)?);
                }
                ctx.in_function_type = false;
                tree!((function_type_expr parameter: {out} return_type: {ret}))
            }
        ),
        rule!(
            (tupleTypeElement firstName: _? @@name type: @ty)
            =>
            tuple_type_element {
                let name = name.map(|n| tree!((identifier #{n})));
                if ctx.in_function_type {
                    tree!((parameter external_name: {name} type: {ty}))
                } else {
                    tree!((tuple_type_element name: {name} type: {ty}))
                }
            }
        ),
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
                modifier: {mods}
                name: (identifier #{name})
                base_type: {bases}
                member: {members})
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
                modifier: {mods}
                name: (identifier #{name})
                base_type: {bases}
                member: {members})
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
                modifier: {mods}
                name: (identifier #{name})
                base_type: {bases})
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
                modifier: {mods}
                name: (identifier #{name})
                base_type: {bases}
                member: {members})
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
                modifier: {mods}
                name: (identifier #{name})
                parameter: {params}
                return_type: {ret}
                body: (block stmt: {body_stmts}))
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
                modifier: {mods}
                parameter: {params}
                body: (block stmt: {body_stmts}))
        ),
        // Deinit declaration → destructor_declaration. Body statements optional.
        rule!(
            (deinit_declaration
                body: (block statement: _* @body_stmts)
                (modifiers)* @mods)
            =>
            (destructor_declaration
                modifier: {mods}
                body: (block stmt: {body_stmts}))
        ),
        // Typealias declaration
        rule!(
            (typealias_declaration name: @name value: @val (modifiers)* @mods)
            =>
            (type_alias_declaration
                modifier: {mods}
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
                modifier: {mods}
                name: (identifier #{name})
                bound: {bound})
        ),
        // Protocol property declaration: translate each accessor
        // requirement to an `accessor_declaration` carrying the property
        // name, type, and outer modifiers. Manual rule: we publish the
        // property's name/type/modifiers into `ctx` and translate each
        // accessor with `ctx.is_chained` toggled per iteration so the
        // inner `getter_specifier`/`setter_specifier` rules emit
        // complete nodes from the start (including the
        // `chained_declaration` tag for non-first accessors).
        rule!(
            (protocol_property_declaration
                name: (pattern bound_identifier: @name)
                requirements: (protocol_property_requirements accessor: _+ @@accessors)
                type: _? @ty
                (modifiers)* @mods)
            =>
            accessor_declaration* {
                ctx.property_name = Some(tree!((identifier #{name})));
                ctx.property_type = ty;
                ctx.outer_modifiers = mods;

                let mut result = Vec::new();
                for (i, acc) in accessors.into_iter().enumerate() {
                    ctx.is_chained = i > 0;
                    result.extend(ctx.translate(acc)?);
                }
                result
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
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "get")
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)})
        ),
        rule!(
            (setter_specifier)
            =>
            (accessor_declaration
                name: {ctx.property_name.ok_or("setter_specifier outside protocol_property_declaration context")?}
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "set")
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)})
        ),
        // protocol_property_requirements wrapper — should be consumed by above; fallback
        rule!((protocol_property_requirements accessor: _* @accs) => accessor_declaration* { accs }),
        // Computed getter → accessor_declaration (body optional).
        // Reads property name/type from the outer property_binding rule
        // and binding/outer modifiers + chained tag from the outer
        // property_declaration rule.
        rule!(
            (computed_getter body: (block statement: _* @@body)?)
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("computed_getter outside property_binding context")?}
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "get")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // Computed setter with explicit parameter name.
        rule!(
            (computed_setter parameter: @param body: (block statement: _* @@body))
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("computed_setter outside property_binding context")?}
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "set")
                parameter: (parameter pattern: (name_pattern identifier: (identifier #{param})))
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // Computed setter without explicit parameter name; body optional.
        rule!(
            (computed_setter body: (block statement: _* @@body)?)
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("computed_setter outside property_binding context")?}
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "set")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // Computed modify → accessor_declaration
        rule!(
            (computed_modify body: (block statement: _* @@body))
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("computed_modify outside property_binding context")?}
                type: {ctx.property_type}
                accessor_kind: (accessor_kind "modify")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // willset/didset block — spread to children (only reachable as a
        // fallback; the outer property_binding manual rule normally
        // captures the willset/didset clauses directly).
        rule!((willset_didset_block _* @clauses) => accessor_declaration* { clauses }),
        // willset clause → accessor_declaration (body optional). Reads
        // `ctx.property_name` set by the outer property_binding rule and
        // binding/outer modifiers + chained tag from the outer
        // property_declaration rule.
        rule!(
            (willset_clause body: (block statement: _* @@body)?)
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("willset_clause outside property_binding context")?}
                accessor_kind: (accessor_kind "willSet")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // didset clause → accessor_declaration (body optional).
        rule!(
            (didset_clause body: (block statement: _* @@body)?)
            =>
            (accessor_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                name: {ctx.property_name.ok_or("didset_clause outside property_binding context")?}
                accessor_kind: (accessor_kind "didSet")
                body: (block stmt: {ctx.reset(); ctx.translate(body)?}))
        ),
        // Preprocessor conditionals — unsupported
        rule!((diagnostic) => (unsupported_node)),
        // ---- Fallbacks ----
        // Bare `_` (rather than `(_)`) so this matches both named nodes
        // and unnamed tokens. Any unnamed token that escapes the
        // input-schema-specific rules (e.g. captured operators in
        // `additive_expression op: @op`) has its auto-translated value
        // replaced with an `unsupported_node` whose source range is
        // inherited from the original token, so `#{op}` still reads the
        // original text.
        rule!(
            _
            =>
            (unsupported_node)
        ),
    ]
}

pub fn language_spec(desugared_ast_schema: &'static str) -> desugaring::LanguageSpec {
    let ts_language: tree_sitter::Language = tree_sitter_swift::LANGUAGE.into();
    let config = DesugaringConfig::<SwiftContext>::new()
        .add_phase("translate", PhaseKind::OneShot, translation_rules())
        .with_output_node_types_yaml(desugared_ast_schema);
    let desugarer = ConcreteDesugarer::new(ts_language.clone(), config)
        .expect("failed to build Swift desugarer");
    desugaring::LanguageSpec {
        prefix: "swift",
        parser: Box::new(codeql_extractor::extractor::tree_sitter_parser(ts_language)),
        node_types: tree_sitter_swift::NODE_TYPES,
        file_globs: vec!["*.swift".into(), "*.swiftinterface".into()],
        desugarer: Box::new(desugarer),
    }
}
