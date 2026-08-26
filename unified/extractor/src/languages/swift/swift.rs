use codeql_extractor::extractor::desugaring;
use yeast::{ConcreteDesugarer, DesugaringConfig, PhaseKind, Rule, rule, tree};

/// User context propagated from outer rules down to the inner rules that
/// emit the corresponding output declarations, so that each emitted node
/// is born with the outer information (name, type, modifiers, etc.)
/// already set — no schema-invalid intermediate state requiring
/// post-hoc mutation.
#[derive(Clone, Default)]
struct SwiftContext {
    /// Identifier node for the property name. Set by the accessor-bearing
    /// `variableDecl` rule before translating the accessor block; read by the
    /// inner `accessorDecl` rules to name each `accessor_declaration`.
    property_name: Option<yeast::Id>,
    /// Translated type node for the property type. Set (for computed
    /// properties) by the accessor-bearing `variableDecl` rule; read by the
    /// inner `accessorDecl` rules. Left `None` for stored properties with
    /// observers, so their `willSet`/`didSet` accessors carry no type.
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
        Some(tree!((modifier "chained_declaration")))
    } else {
        None
    }
}

/// Combine a list of boolean sub-conditions into a single expression by
/// left-folding with the infix `&&` operator. Used by control-flow
/// rules (`if`, `guard`, `while`, `repeat-while`), which carry one or
/// more comma-separated conditions that the target
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

/// Return the only pattern unchanged when there is exactly one, otherwise
/// wrap the list in an `or_pattern`.
fn make_or_pattern(
    ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>,
    items: Vec<yeast::Id>,
) -> yeast::Id {
    if items.len() == 1 {
        items[0]
    } else {
        tree!((or_pattern pattern: {items}))
    }
}

/// Translate `node` in pattern context (`ctx.in_pattern = true`).
fn translate_pattern(
    ctx: &mut yeast::build::BuildCtx<'_, SwiftContext>,
    node: yeast::Id,
) -> Result<Vec<yeast::Id>, String> {
    ctx.scoped(|ctx| {
        ctx.in_pattern = true;
        ctx.translate(node)
    })
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
        // `*LiteralExpr` kind, so one rule per literal type suffices.
        rule!((integerLiteralExpr) @@node => expr {
            let value = tree!((int_literal #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
        rule!((floatLiteralExpr) @@node => expr {
            let value = tree!((float_literal #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
        rule!((booleanLiteralExpr) @@node => expr {
            let value = tree!((boolean_literal #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
        rule!((nilLiteralExpr) @@node => expr {
            let value = tree!((builtin_expr #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
        // Plain string literals (no interpolation)
        rule!((simpleStringLiteralExpr) @@node => expr {
            let value = tree!((string_literal #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
        // String literals with interpolation
        rule!(
            (stringLiteralExpr segments: _* @segs)
            =>
            (string_interpolation_expr element: {segs})
        ),
        // Map stringSegment to a string_literal for use in string_interpolation_expr
        rule!((stringSegment content: @@content) => (string_literal #{content})),
        // In the general case, an expressionSegment results in a call to `appendInterpolation()` which
        // can take an arbitrary list of  arguments. We model it as a call to a built-in called `interpolation`.
        rule!(
            (expressionSegment expressions: _* @exprs)
            =>
            (call_expr callee: (builtin_expr "interpolation") argument: {exprs})
        ),
        rule!((regexLiteralExpr) @@node => expr {
            let value = tree!((regex_literal #{node}));
            if ctx.in_pattern { tree!((expr_equality_pattern expr: {value})) } else { value }
        }),
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
        rule!((declReferenceExpr baseName: (identifier) @name) => expr {
            let name = tree!((name_expr identifier: (identifier #{name})));
            if ctx.in_pattern {
                tree!((expr_equality_pattern expr: {name}))
            } else {
                name
            }
        }),
        // A bare name reference (`x`), and an operator used as a value (`+` in
        // `reduce(0, +)`), are both `declReferenceExpr`; its `baseName` is the
        // referenced identifier / operator symbol.
        rule!((declReferenceExpr baseName: @name) => (name_expr identifier: (identifier #{name}))),
        // A discard `_` used as an expression — e.g. the target of a discarding
        // assignment `_ = x`. swift-syntax models it as a `discardAssignmentExpr`;
        // the target AST has no expression-level discard (only `ignore_pattern`,
        // which is a pattern), so it becomes a `name_expr` over the `_` token.
        rule!((discardAssignmentExpr wildcard: @@w) => (name_expr identifier: (identifier #{w}))),
        // A generic specialization in expression position (`C<Foo>`,
        // `Array<Int>`) is represented by swift-syntax as a
        // `genericSpecializationExpr`. When used as a call target
        // (`C<Foo>()`), this should become a `call_expr` whose callee is a
        // `generic_type_expr`, so we map it directly to that shape.
        rule!(
            (genericSpecializationExpr
                expression: (declReferenceExpr baseName: @name)
                genericArgumentClause: (genericArgumentClause arguments: (genericArgument argument: @args)*))
            =>
            (generic_type_expr
                base: (named_type_expr name: (identifier #{name}))
                type_argument: {args})
        ),
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
        // In an unresolved `sequenceExpr` (below) the operator positions are not
        // only `binaryOperatorExpr`s: a plain assignment (`=`), an `as`/`is` cast
        // and the ternary `?:` can also appear unfolded. Map each to an
        // `infix_operator` (keeping its spelling) so the sequence stays a clean
        // alternation of operands and operators instead of dropping the operator
        // to an opaque `unsupported_node`. These bare nodes only occur inside an
        // unresolved sequence — folded forms are handled by the dedicated rules
        // above (assignment) and below (`ternaryExpr`).
        rule!((assignmentExpr) @op => (infix_operator #{op})),
        rule!((unresolvedAsExpr) @op => (infix_operator #{op})),
        rule!((unresolvedIsExpr) @op => (infix_operator #{op})),
        // The ternary is a three-part operator (`? thenExpr :`) that *wraps* a
        // nested expression. Splice it into `?`, the then-expression, `:` so the
        // then-expression survives as a real (traversable) operand rather than
        // being buried in an opaque token.
        rule!(
            (unresolvedTernaryExpr questionMark: @@q thenExpression: @then colon: @@c)
            =>
            expr_or_operator* {
                vec![tree!((infix_operator #{q})), then, tree!((infix_operator #{c}))]
            }
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
        // ---- Properties with accessors ----
        // A computed property with an implicit getter (`var a: T { <stmts> }`)
        // becomes a single `accessor_declaration` of kind `get`. This form is
        // self-contained (no context threading). It must precede the plain
        // `variableDecl` rules, which would otherwise match and drop the accessor
        // block.
        rule!(
            (variableDecl
                bindingSpecifier: @@spec
                bindings: (patternBinding
                    pattern: (identifierPattern identifier: @@name)
                    typeAnnotation: (typeAnnotation type: @ty)
                    accessorBlock: (accessorBlock accessors: (codeBlockItem)+ @body)))
            =>
            (accessor_declaration
                modifier: (modifier #{spec})
                name: (identifier #{name})
                type: {ty}
                accessor_kind: (accessor_kind "get")
                body: (block stmt: {body}))
        ),
        // A property with an explicit accessor block. swift-syntax makes both
        // shapes plain `accessorDecl`s, so they are told apart by the presence
        // of an initializer:
        //
        //  * With an initializer (`var x: T = e { willSet {…} didSet {…} }`) it is
        //    a *stored* property with observers: emit the backing
        //    `variable_declaration` first, then one `accessor_declaration` per
        //    observer (observers carry no type).
        //  * Without an initializer (`var v: T { get set }`, incl. protocol
        //    requirements) it is a *computed* property: no backing variable; the
        //    type is published so the get/set accessors carry it.
        //
        // In both cases the first emitted declaration is unchained and every
        // subsequent one is tagged `chained_declaration` (the `!result.is_empty()`
        // test). Must precede the plain `variableDecl` rules.
        rule!(
            (variableDecl
                bindingSpecifier: @@spec
                bindings: (patternBinding
                    pattern: (identifierPattern identifier: @@name)
                    typeAnnotation: (typeAnnotation type: @ty)
                    initializer: (initializerClause value: @@val)?
                    accessorBlock: (accessorBlock accessors: (accessorDecl)+ @@accessors)))
            =>
            member* {
                ctx.outer_modifiers = vec![tree!((modifier #{spec}))];
                ctx.property_name = Some(tree!((identifier #{name})));
                let mut result = Vec::new();
                if let Some(val) = val {
                    // Stored property with observers: the initializer is not part
                    // of the binding, so translate it in a reset scope.
                    let val = ctx.scoped(|ctx| {
                        ctx.reset();
                        ctx.translate(val)
                    })?;
                    result.push(tree!(
                        (variable_declaration
                            modifier: {ctx.outer_modifiers.clone()}
                            pattern: (name_pattern identifier: (identifier #{name}))
                            type: {ty}
                            value: {val})
                    ));
                } else {
                    // Computed property: the accessors carry the type.
                    ctx.property_type = Some(ty);
                }
                for acc in accessors.into_iter() {
                    ctx.is_chained = !result.is_empty();
                    result.extend(ctx.translate(acc)?);
                }
                result
            }
        ),
        // Each `accessorDecl` becomes an `accessor_declaration`, reading the
        // property name/type and the binding/chained modifiers from `ctx`. The
        // accessor kind comes straight from the specifier keyword
        // (`get`/`set`/`willSet`/`didSet`). The body is optional: a body-bearing
        // accessor (a computed getter/setter, or a `willSet`/`didSet` observer)
        // carries the binding modifier and a translated body, whereas a bodyless
        // one (a protocol requirement) carries neither. The property context is
        // read out *before* translating the body, which resets `ctx` so the
        // accessor's context does not leak into the body subtree.
        rule!(
            (accessorDecl accessorSpecifier: @@spec body: _? @@body)
            =>
            accessor_declaration {
                let binding = if body.is_some() {
                    ctx.outer_modifiers.clone()
                } else {
                    Vec::new()
                };
                let chained = chained_modifier(&mut ctx);
                let name = ctx
                    .property_name
                    .ok_or("accessor outside property context")?;
                let ty = ctx.property_type;
                let body = match body {
                    Some(block) => {
                        ctx.reset();
                        ctx.translate(block)?.into_iter().next()
                    }
                    None => None,
                };
                tree!(
                    (accessor_declaration
                        modifier: {binding}
                        modifier: {chained}
                        name: {name}
                        type: {ty}
                        accessor_kind: (accessor_kind #{spec})
                        body: {body})
                )
            }
        ),
        // ---- Variables ----
        // The individual bindings of a `variableDecl`. The binding modifier and
        // chained tag come from `ctx` (set by the `variableDecl` rule below). The
        // type annotation and initializer are both optional (one combined rule
        // covers `let x`, `let x = e`, `let x: T`, and `let x: T = e`); the
        // initializer value is translated in a reset scope so it is not treated
        // as a binding.
        rule!(
            (patternBinding
                pattern: @@pattern
                typeAnnotation: (typeAnnotation type: @ty)?
                initializer: (initializerClause value: @@val)?)
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                pattern: {translate_pattern(&mut ctx, pattern)?}
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
        // An enum-case payload parameter (`radius: Double`, or just `Double`).
        // The label (`firstName`) is optional.
        rule!(
            (enumCaseParameter firstName: _? @@name type: @ty)
            =>
            (parameter pattern: (name_pattern identifier: (identifier #{name}))? type: {ty})
        ),
        // An enum element with associated values (`case circle(radius: Double)`)
        // becomes a nested `class_like_declaration` whose constructor carries the
        // payload parameters; an element with a raw value (`case a = 1`) or a
        // plain element (`case north`) becomes a `variable_declaration`. All
        // carry the shared case modifiers / chained tag from `ctx` (set by the
        // `enumCaseDecl` rule below) and are tagged `enum_case`, after any
        // `chained_declaration` tag.
        rule!(
            (enumCaseElement name: @name parameterClause: (enumCaseParameterClause parameters: _* @params))
            =>
            (class_like_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                name: (identifier #{name})
                member: (constructor_declaration parameter: {params} body: (block)))
        ),
        rule!(
            (enumCaseElement name: @name rawValue: (initializerClause value: @val))
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name}))
                value: {val})
        ),
        rule!(
            (enumCaseElement name: @name)
            =>
            (variable_declaration
                modifier: {ctx.outer_modifiers.clone()}
                modifier: {chained_modifier(&mut ctx)}
                modifier: (modifier "enum_case")
                pattern: (name_pattern identifier: (identifier #{name})))
        ),
        // Enum cases. A single `case` declaration may carry modifiers
        // (e.g. `indirect`) and list several comma-separated elements; each
        // becomes its own declaration carrying those shared modifiers, and
        // non-first ones are tagged `chained_declaration`. The modifiers are
        // published into `ctx`
        // for the element rules above, which build the actual declaration.
        rule!(
            (enumCaseDecl modifiers: _* @mods elements: _* @@cases)
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
        // A tuple destructuring pattern (`let (a, b) = …`). A labelled element
        // (`let (x: a) = …`) carries its label through as the `pattern_element`
        // key; unlabelled elements have no key.
        rule!((tuplePattern elements: _* @els) => (tuple_pattern element: {els})),
        rule!(
            (tuplePatternElement label: _? @@label pattern: @p)
            =>
            (pattern_element key: (identifier #{label})? pattern: {p})
        ),
        // A type-casting pattern (`case is T`). Not yet supported, so it is
        // mapped to `unsupported_node` — an explicit reminder that this needs
        // handling in the future. (Redundant with the catch-all fallback, but
        // kept as a signpost.)
        rule!((isTypePattern) => (unsupported_node)),
        // A wildcard *binding* pattern (`let _ = x`, `for _ in xs`). swift-syntax
        // models this as a `wildcardPattern`, distinct from the `_` match form
        // handled by the context-aware `discardAssignmentExpr` rule.
        rule!((wildcardPattern) => (ignore_pattern)),
        // An expression pattern only establishes pattern context; its child
        // determines the concrete pattern shape.
        rule!((expressionPattern expression: @@e) => expr {
            translate_pattern(&mut ctx, e)?
        }),
        // ---- Functions ----
        // A function declaration (parameters/return type/body optional). The
        // parameters and return type nest under `signature`; the body is a
        // `codeBlock`. A bodyless function (a protocol requirement) still emits
        // an empty `block`.
        rule!(
            (functionDecl
                name: @name
                genericParameterClause: (genericParameterClause parameters: _* @type_params)?
                signature: (functionSignature
                    parameterClause: (functionParameterClause parameters: _* @params)
                    returnClause: (returnClause type: @ret)?)
                body: (codeBlock statements: _* @body))
            =>
            (function_declaration
                name: (identifier #{name})
                type_parameter: {type_params}
                parameter: {params}
                return_type: {ret}
                body: (block stmt: {body}))
        ),
        rule!(
            (functionDecl
                name: @name
                genericParameterClause: (genericParameterClause parameters: _* @type_params)?
                signature: (functionSignature
                    parameterClause: (functionParameterClause parameters: _* @params)
                    returnClause: (returnClause type: @ret)?))
            =>
            (function_declaration
                name: (identifier #{name})
                type_parameter: {type_params}
                parameter: {params}
                return_type: {ret}
                body: (block))
        ),
        // A function parameter. With two names (`firstName`+`secondName`) the
        // first is the external argument label and the second the internal name;
        // with one name it is just the internal name. The declared type is
        // emitted; the default value is optional.
        rule!(
            (functionParameter
                firstName: @@first
                secondName: _? @@second
                type: @ty
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
                    type: {ty}
                    default: {val}))
            }
        ),
        // Swift's `[T](...)` array-type constructor syntax is parsed as a call
        // whose callee is an `arrayExpr` containing `T`. For a generic `T`,
        // translating that callee as an array literal would place a type
        // expression in an expression-only element field. Normalize it to an
        // `Array<T>` generic type constructor instead.
        rule!(
            (functionCallExpr
                calledExpression: (arrayExpr elements: (arrayElement expression: (genericSpecializationExpr) @element))
                arguments: _* @args
                trailingClosure: @tc)
            =>
            (call_expr
                callee: (generic_type_expr
                    base: (named_type_expr name: (identifier "Array"))
                    type_argument: {element})
                argument: {args}
                argument: (argument value: {tc}))
        ),
        rule!(
            (functionCallExpr
                calledExpression: (arrayExpr elements: (arrayElement expression: (genericSpecializationExpr) @element))
                arguments: _* @args)
            =>
            (call_expr
                callee: (generic_type_expr
                    base: (named_type_expr name: (identifier "Array"))
                    type_argument: {element})
                argument: {args})
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
            (functionCallExpr calledExpression: @@rawCallee arguments: _* @args)
            =>
            expr {
                // Always translate the callee in non-pattern context.
                let callee = ctx.scoped(|ctx| {
                    ctx.in_pattern = false;
                    ctx.translate(rawCallee)
                })?;
                if ctx.in_pattern {
                    tree!((constructor_pattern constructor: {callee} element: {args}))
                } else {
                    tree!((call_expr callee: {callee} argument: {args}))
                }
            }
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
            (labeledExpr
                label: _? @@lbl
                expression: (functionCallExpr
                    calledExpression: @constructor
                    arguments: _* @elements))
            =>
            argument {
                if ctx.in_pattern {
                    tree!((pattern_element
                        key: (identifier #{lbl})?
                        pattern: (constructor_pattern
                            constructor: {constructor}
                            element: {elements})))
                } else {
                    tree!((argument
                        name: (identifier #{lbl})?
                        value: (call_expr callee: {constructor} argument: {elements})))
                }
            }
        ),
        rule!(
            (labeledExpr label: _? @@lbl expression: (patternExpr pattern: @p))
            =>
            (pattern_element key: (identifier #{lbl})? pattern: {p})
        ),
        rule!(
            (labeledExpr label: _? @@lbl expression: (discardAssignmentExpr) @@wildcard)
            =>
            (pattern_element key: (identifier #{lbl})? pattern: (ignore_pattern #{wildcard}))
        ),
        rule!(
            (labeledExpr label: _? @@lbl expression: @val)
            =>
            argument {
                if ctx.in_pattern {
                    tree!((pattern_element
                        key: (identifier #{lbl})?
                        pattern: {val}))
                } else {
                    tree!((argument name: (identifier #{lbl})? value: {val}))
                }
            }
        ),
        // Member access (`list.append`). The `declName` is itself a
        // `declReferenceExpr`; pull its `baseName` out as the member identifier.
        // A leading-dot access (`.foo`) has no explicit base — the base is an
        // `inferred_type_expr`. The base-ful form is matched first.
        // A bracketed generic array type used as a metatype or static-member
        // base (`[T].self`) is parsed as an `arrayExpr`; preserve its type
        // meaning as `Array<T>` rather than an array literal.
        rule!(
            (memberAccessExpr
                base: (arrayExpr elements: (arrayElement expression: (genericSpecializationExpr) @element))
                declName: (declReferenceExpr baseName: @member))
            =>
            (member_access_expr
                base: (generic_type_expr
                    base: (named_type_expr name: (identifier "Array"))
                    type_argument: {element})
                member: (identifier #{member}))
        ),
        rule!(
            (memberAccessExpr base: @base declName: (declReferenceExpr baseName: @member))
            =>
            (member_access_expr base: {base} member: (identifier #{member}))
        ),
        rule!(
            (memberAccessExpr period: @dot declName: (declReferenceExpr baseName: @member))
            =>
            (member_access_expr base: (inferred_type_expr #{dot}) member: (identifier #{member}))
        ),
        // Control transfer, one rule per keyword. `return` carries an optional
        // value; `break` / `continue` an optional target label; `throw` its
        // thrown expression.
        rule!((returnStmt expression: _? @val) => (return_expr value: {val})),
        rule!((breakStmt label: _? @@lbl) => (break_expr label: (identifier #{lbl})?)),
        rule!((continueStmt label: _? @@lbl) => (continue_expr label: (identifier #{lbl})?)),
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
                modifier: (modifier #{spec})?
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
        // Ternary (`c ? a : b`) desugars to an `if_expr`.
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
            (switch_case
                pattern: {make_or_pattern(&mut ctx, items)}
                body: (block stmt: {body}))
        ),
        rule!(
            (switchCase label: (switchDefaultLabel) statements: _* @body)
            =>
            (switch_case body: (block stmt: {body}))
        ),
        // A single case item unwraps to its pattern, possibly boxed in conditional_pattern
        rule!(
            (switchCaseItem pattern: @@p whereClause: (whereClause condition: @cond))
            =>
            (conditional_pattern pattern: {translate_pattern(&mut ctx, p)?} condition: {cond})
        ),
        rule!((switchCaseItem pattern: @@p) => pattern { translate_pattern(&mut ctx, p)? }),
        // A pattern-matching condition (`if case let x = e`, `if case .foo(let x)
        // = e`) becomes a `pattern_guard_expr`: the matched pattern and the
        // scrutinee value are translated recursively.
        rule!(
            (matchingPatternCondition pattern: @@pat initializer: (initializerClause value: @val))
            =>
            (pattern_guard_expr pattern: {translate_pattern(&mut ctx, pat)?} value: {val})
        ),
        // Optional binding (`if let x = foo`, or shorthand `if let x`) desugars
        // to a `pattern_guard_expr` matching `Optional.some(x)`. The initialized
        // form is matched first.
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
        // A `for`-`in` loop. The optional `where` clause becomes the `guard`.
        rule!(
            (forStmt
                pattern: @@pat
                sequence: @iter
                whereClause: (whereClause condition: @guard)?
                body: @body)
            =>
            (for_each_stmt
                pattern: {translate_pattern(&mut ctx, pat)?}
                iterable: {iter}
                guard: {guard}
                body: {body})
        ),
        // A `while` loop.
        rule!(
            (whileStmt conditions: _* @cond body: @body)
            =>
            (while_stmt
                condition: {and_chain(&mut ctx, cond)}
                body: {body})
        ),
        // A `repeat { } while c` loop desugars to a `do_while_stmt`.
        rule!(
            (repeatStmt body: @body condition: @cond)
            =>
            (do_while_stmt condition: {cond} body: {body})
        ),
        // A labeled statement (`outer: for … { }`). swift-syntax stores the
        // label and colon as separate tokens, so the label token is already the
        // bare name (no trailing `:` to strip).
        rule!(
            (labeledStmt label: @@lbl statement: @stmt)
            =>
            (labeled_stmt label: (identifier #{lbl}) stmt: {stmt})
        ),
        // ---- Collections ----
        // An array literal (`[1, 2, 3]`). Each `arrayElement` unwraps to its
        // contained expression.
        rule!(
            (arrayExpr elements: _* @els)
            =>
            (array_literal element: {els})
        ),
        rule!((arrayElement expression: @e) => expr { e }),
        // A dictionary literal (`["a": 1]`) is kept as an opaque `map_literal`
        // leaf (its source span).
        rule!((dictionaryExpr) => (map_literal)),
        // A subscript access (`xs[0]`) is modelled as a call. swift-syntax does
        // report a distinct `subscriptCallExpr`, so giving
        // subscripts their own shape needs only a `subscript_expr` node in
        // ast_types.yml and a remap here.
        rule!(
            (subscriptCallExpr calledExpression: @callee arguments: _* @args)
            =>
            (call_expr callee: {callee} argument: {args})
        ),
        // ---- Optionals and errors ----
        // Optional chaining — unwrap the marker
        rule!((optionalChainingExpr expression: @@inner) => expr {
            let inner = ctx.translate(inner)?.into_iter().next().ok_or("optional chaining expression has no child")?;
            if ctx.in_pattern {
                tree!((constructor_pattern
                    constructor: (member_access_expr
                        base: (named_type_expr name: (identifier "Optional"))
                        member: (identifier "some"))
                    element: (pattern_element pattern: {inner})))
            } else {
                inner
            }
        }),
        // try/try?/try! expr → unary_expr with operator "try", "try?" or "try!"
        rule!(
            (tryExpr questionOrExclamationMark: _? @@m expression: @e)
            =>
            expr {
                let op = format!("try{}", m.map(|m| ctx.source_text(m)).unwrap_or_default());
                tree!((unary_expr operator: (prefix_operator #{op}) operand: {e}))
            }
        ),
        // Do-catch → try_expr
        rule!(
            (doStmt body: @body catchClauses: _* @catches)
            =>
            (try_expr
                body: {body}
                catch_clause: {catches})
        ),
        rule!(
            (catchItem pattern: @@pattern whereClause: (whereClause condition: @guard))
            =>
            (conditional_pattern pattern: {translate_pattern(&mut ctx, pattern)?} condition: {guard})
        ),
        rule!(
            (catchItem pattern: @@pattern)
            =>
            pattern { translate_pattern(&mut ctx, pattern)? }
        ),
        // Catch block with one or more patterns (which have been translated by the catchItem rules)
        rule!(
            (catchClause
                catchItems: _+ @patterns
                body: @body)
            =>
            (catch_clause
                pattern: {make_or_pattern(&mut ctx, patterns)}
                body: {body})
        ),
        // Catch block without error binding
        rule!((catchClause body: @body) => (catch_clause body: {body})),
        // As expression (type cast) — as?, as!
        rule!((asExpr expression: @val questionOrExclamationMark: _? @@mark type: @ty) => type_cast_expr {
            let op = format!("as{}", mark.map(|m| ctx.source_text(m)).unwrap_or_default());
            tree!((type_cast_expr expr: {val} operator: (infix_operator #{op}) type: {ty}))
        }),
        // Check expression (`x is T`) → type_test_expr
        rule!((isExpr expression: @val type: @ty) => (type_test_expr expr: {val} operator: (infix_operator "is") type: {ty})),
        // Await expression → unary_expr with operator "await"
        rule!((awaitExpr expression: @val) => (unary_expr operator: (prefix_operator "await") operand: {val})),
        // Force-unwrap (`x!`) → postfix unary_expr, via swift-syntax's dedicated
        // `forceUnwrapExpr` node.
        rule!((forceUnwrapExpr expression: @e) => (unary_expr operator: (postfix_operator "!") operand: {e})),
        // ---- Imports ----
        // An import declaration. The dotted path (a list of
        // `importPathComponent`s) becomes a `name_expr`/`member_access_expr`
        // chain (via `member_chain`). A scoped import (`import struct Foo.Bar`)
        // has an `importKindSpecifier` and binds the last path component as a
        // `name_pattern`; a plain import (`import Foundation`) has none and uses
        // a `bulk_importing_pattern` spanning the whole declaration. Any leading
        // attributes (`@_exported`) and access modifiers (`public`) become
        // `modifier`s.
        rule!(
            (importDecl
                attributes: _* @attrs
                modifiers: _* @mods
                importKindSpecifier: _? @@kind
                path: (importPathComponent name: @@parts)*)
            =>
            import_declaration {
                let bulk_import = match kind {
                    None => Some(tree!((bulk_importing_pattern))),
                    Some(_) => None, // scoped import, no bulk import
                };
                let last = *parts.last().ok_or("import has no path")?;
                let pattern = tree!((name_pattern identifier: (identifier #{last}) sub_pattern: {bulk_import}));
                tree!((import_declaration
                    modifier: (modifier #{kind})?
                    modifier: {attrs}
                    modifier: {mods}
                    pattern: {pattern}
                    imported_expr: {member_chain(&mut ctx, parts)}))
            }
        ),
        // ---- Types and declarations ----
        // A leading attribute (`@objc`) or access/function/member/mutation/
        // ownership modifier (swift-syntax models each as a single `declModifier`)
        // becomes a `modifier`; its source text is the modifier spelling.
        rule!((attribute) @m => (modifier #{m})),
        rule!((declModifier) @m => (modifier #{m})),
        // A `super` expression.
        rule!((superExpr) => (super_expr)),
        // Type expressions. A generic type applied with explicit arguments
        // (`Set<Int>`) becomes a `generic_type_expr` whose `base` is the type
        // name and whose `type_argument`s are the (structured) arguments — the
        // same shape the sugared `?`/`[]`/`[:]` types desugar to. Matched before
        // the plain `identifierType` rule, which would otherwise drop the
        // arguments.
        rule!(
            (identifierType
                name: @@name
                genericArgumentClause: (genericArgumentClause arguments: (genericArgument argument: @args)*))
            =>
            (generic_type_expr
                base: (named_type_expr name: (identifier #{name}))
                type_argument: {args})
        ),
        // A named type (`Int`). `identifierType.name` is the type-name token.
        rule!((identifierType name: @@n) => (named_type_expr name: (identifier #{n}))),
        // A qualified type (`Outer.Inner`, `NSString.CompareOptions`). swift-syntax
        // nests these as `memberType` nodes; preserve the nesting in the
        // named_type_expr qualifier field.
        rule!(
            (memberType baseType: @base name: @@name)
            =>
            (named_type_expr qualifier: {base} name: (identifier #{name}))
        ),
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
                tree!((function_type_expr parameter: {out} return_type: {ret}))
            }
        ),
        rule!(
            (tupleTypeElement firstName: _? @@name type: @ty)
            =>
            tuple_type_element {
                if ctx.in_function_type {
                    tree!((parameter external_name: (identifier #{name})? type: {ty}))
                } else {
                    tree!((tuple_type_element name: (identifier #{name})? type: {ty}))
                }
            }
        ),
        // Selector expression: `#selector(inner)` -- not yet supported
        // (swift-syntax represents `#selector`/`#keyPath` and other macro
        // expansions uniformly as a `macroExpansionExpr`).
        rule!((macroExpansionExpr) => (unsupported_node)),
        // A nominal type's `inheritanceClause` (`: Base, Proto`) becomes a list
        // of `base_type`s, one per inherited type. Each declaration keyword
        // gets its own rule; the bodies are identical but for the keyword.
        rule!(
            (genericParameter
                attributes: _* @attrs
                specifier: _? @@spec
                name: @@name
                inheritedType: _? @bound)
            =>
            (type_parameter
                modifier: {attrs}
                modifier: (modifier #{spec})?
                name: (identifier #{name})
                bound: {bound})
        ),
        rule!(
            (genericRequirement
                requirement: (conformanceRequirement leftType: @ty rightType: @bound))
            =>
            (bound_type_constraint type: {ty} bound: {bound})
        ),
        rule!(
            (genericRequirement
                requirement: (sameTypeRequirement leftType: @left rightType: @right))
            =>
            (equality_type_constraint left: {left} right: {right})
        ),
        // Class declaration with body containing members
        rule!(
            (classDecl
                classKeyword: @kind
                modifiers: _* @mods
                name: @name
                genericParameterClause: (genericParameterClause
                    parameters: _* @params
                    genericWhereClause: (genericWhereClause requirements: _* @parameter_constraints)?)?
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bases)*)?
                genericWhereClause: (genericWhereClause requirements: _* @declaration_constraints)?
                memberBlock: (memberBlock members: _* @members))
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {mods}
                name: (identifier #{name})
                type_parameter: {params}
                type_constraint: {parameter_constraints}
                type_constraint: {declaration_constraints}
                base_type: {bases.into_iter().map(|ty| tree!((base_type type: {ty})))}
                member: {members})
        ),
        // Enum class declaration: same as a regular class but with an enum body.
        rule!(
            (enumDecl
                enumKeyword: @kind
                modifiers: _* @mods
                name: @name
                genericParameterClause: (genericParameterClause
                    parameters: _* @params
                    genericWhereClause: (genericWhereClause requirements: _* @parameter_constraints)?)?
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bases)*)?
                genericWhereClause: (genericWhereClause requirements: _* @declaration_constraints)?
                memberBlock: (memberBlock members: _* @members))
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {mods}
                name: (identifier #{name})
                type_parameter: {params}
                type_constraint: {parameter_constraints}
                type_constraint: {declaration_constraints}
                base_type: {bases.into_iter().map(|ty| tree!((base_type type: {ty})))}
                member: {members})
        ),
        // A `struct` declaration.
        rule!(
            (structDecl
                structKeyword: @kind
                modifiers: _* @mods
                name: @name
                genericParameterClause: (genericParameterClause
                    parameters: _* @params
                    genericWhereClause: (genericWhereClause requirements: _* @parameter_constraints)?)?
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bases)*)?
                genericWhereClause: (genericWhereClause requirements: _* @declaration_constraints)?
                memberBlock: (memberBlock members: _* @members))
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {mods}
                name: (identifier #{name})
                type_parameter: {params}
                type_constraint: {parameter_constraints}
                type_constraint: {declaration_constraints}
                base_type: {bases.into_iter().map(|ty| tree!((base_type type: {ty})))}
                member: {members})
        ),
        // Protocol declaration
        rule!(
            (protocolDecl
                protocolKeyword: @kind
                modifiers: _* @mods
                name: @name
                genericParameterClause: (genericParameterClause parameters: _* @params)?
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bases)*)?
                genericWhereClause: (genericWhereClause requirements: _* @declaration_constraints)?
                memberBlock: (memberBlock members: _* @members))
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {mods}
                name: (identifier #{name})
                type_parameter: {params}
                type_constraint: {declaration_constraints}
                base_type: {bases.into_iter().map(|ty| tree!((base_type type: {ty})))}
                member: {members})
        ),
        // An `extension Foo { … }` is likewise a `class_like_declaration`, named
        // by the extended type. The extended type is captured opaquely (as its
        // source text) so that qualified names (`extension String.Interpolation`,
        // a `memberType`) name the declaration just like simple ones.
        rule!(
            (extensionDecl
                extensionKeyword: @kind
                modifiers: _* @mods
                extendedType: @@name
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bases)*)?
                memberBlock: (memberBlock members: _* @members))
            =>
            (class_like_declaration
                modifier: (modifier #{kind})
                modifier: {mods}
                name: (identifier #{name})
                base_type: {bases.into_iter().map(|ty| tree!((base_type type: {ty})))}
                member: {members})
        ),
        // A member of a type declaration unwraps to the contained declaration.
        rule!((memberBlockItem decl: _* @d) => member* { d }),
        // Init declaration → constructor_declaration. Body statements optional;
        // body itself is also optional (protocol requirement). The parameters
        // nest under `signature` (as for `functionDecl`).
        rule!(
            (initializerDecl
                modifiers: _* @mods
                signature: (functionSignature
                    parameterClause: (functionParameterClause parameters: _* @params))
                body: (codeBlock statements: _* @body_stmts)?)
            =>
            (constructor_declaration
                modifier: {mods}
                parameter: {params}
                body: (block stmt: {body_stmts}))
        ),
        // Deinit declaration → destructor_declaration. Body statements optional.
        rule!(
            (deinitializerDecl
                modifiers: _* @mods
                body: (codeBlock statements: _* @body_stmts))
            =>
            (destructor_declaration
                modifier: {mods}
                body: (block stmt: {body_stmts}))
        ),
        // Typealias declaration
        rule!(
            (typeAliasDecl
                modifiers: _* @mods
                name: @@name
                genericParameterClause: (genericParameterClause parameters: _* @type_params)?
                initializer: (typeInitializerClause value: @val))
            =>
            (type_alias_declaration
                modifier: {mods}
                name: (identifier #{name})
                type_parameter: {type_params}
                r#type: {val})
        ),
        // Associated type declaration (with optional bound)
        rule!(
            (associatedTypeDecl
                modifiers: _* @mods
                name: @@name
                inheritanceClause: (inheritanceClause inheritedTypes: (inheritedType type: @bound))?)
            =>
            (associated_type_declaration
                modifier: {mods}
                name: (identifier #{name})
                bound: {bound})
        ),
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
    let config = DesugaringConfig::<SwiftContext>::new()
        .add_phase("translate", PhaseKind::OneShot, translation_rules())
        .with_output_node_types_yaml(desugared_ast_schema);
    let desugarer =
        ConcreteDesugarer::without_language(config).expect("failed to build Swift desugarer");
    desugaring::LanguageSpec {
        prefix: "swift",
        parser: Box::new(super::swift_parse::parse),
        node_types: "",
        file_globs: vec!["*.swift".into(), "*.swiftinterface".into()],
        desugarer: Box::new(desugarer),
    }
}
