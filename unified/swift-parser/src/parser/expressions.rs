use super::{Children, F, K, Node, Span, State, SyntaxSink};

struct Effect<N: Copy> {
    kind: K,
    field: F,
    keyword: Node<N>,
    mark: Option<Node<N>>,
}

struct Operand<N: Copy> {
    node: Node<N>,
    effects: Vec<Effect<N>>,
}

impl<N: Copy> Operand<N> {
    fn plain(node: Node<N>) -> Self {
        Self {
            node,
            effects: Vec::new(),
        }
    }

    fn start(&self) -> usize {
        self.effects
            .last()
            .map_or(self.node.span.start, |effect| effect.keyword.span.start)
    }
}

#[derive(Clone, Copy)]
enum Operator<N: Copy> {
    Binary(Node<N>),
    Cast {
        node: Node<N>,
        keyword: Node<N>,
        mark: Option<Node<N>>,
        is: bool,
    },
    Ternary {
        node: Node<N>,
        question: Node<N>,
        then: Node<N>,
        colon: Node<N>,
    },
}

impl<N: Copy> Operator<N> {
    fn node(&self) -> Node<N> {
        match self {
            Self::Binary(node) => *node,
            Self::Cast { node, .. } => *node,
            Self::Ternary { node, .. } => *node,
        }
    }
}

impl<S: SyntaxSink> State<'_, S> {
    #[allow(clippy::too_many_lines)]
    pub(super) fn expression(&mut self, trailing: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingExpr);
        }
        let first = self.unary(trailing);
        let start = first.start();
        let mut values = vec![first];
        let mut ops = Vec::new();
        while !(self.exhausted || self.condition_line && self.newline())
            && (self.binary()
                || (matches!(self.text(), "->" | "async" | "throws" | "rethrows")
                    && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                        .arrow_operator())
                || self.at("as")
                || self.at("is")
                || (self.at("?") && self.spaced_before()))
        {
            let text = self.text().to_owned();
            if matches!(text.as_str(), "->" | "throws" | "rethrows" | "async") {
                let start = self.start();
                let mut c = Vec::new();
                if let Some(effects) = self.effects(K::TypeEffectSpecifiers) {
                    Self::add(&mut c, F::EffectSpecifiers, effects);
                }
                self.expect("->", &mut c, F::Arrow);
                let node = self.finish(K::ArrowExpr, start, c);
                ops.push((
                    Operator::Binary(node),
                    Some(self.operators.named("FunctionArrowPrecedence")),
                ));
                values.push(self.unary(trailing));
                continue;
            }
            if text == "?" {
                let question = self.bump();
                let then = self.expression(trailing);
                let colon = if self.at(":") {
                    self.bump()
                } else {
                    self.missing(K::Colon)
                };
                let mut c = Vec::new();
                Self::add(&mut c, F::QuestionMark, question);
                Self::add(&mut c, F::ThenExpression, then);
                Self::add(&mut c, F::Colon, colon);
                let node = self.make(
                    K::UnresolvedTernaryExpr,
                    Span {
                        start: question.span.start,
                        end: colon.span.end,
                    },
                    c,
                );
                ops.push((
                    Operator::Ternary {
                        node,
                        question,
                        then,
                        colon,
                    },
                    Some(self.operators.named("TernaryPrecedence")),
                ));
                values.push(self.unary(trailing));
                continue;
            }
            if text == "as" || text == "is" {
                let keyword = self.word();
                let mark = (self.at("?") || self.at("!")).then(|| self.bump());
                let mut c = Vec::new();
                Self::add(
                    &mut c,
                    if text == "is" {
                        F::IsKeyword
                    } else {
                        F::AsKeyword
                    },
                    keyword,
                );
                if let Some(mark) = mark {
                    Self::add(&mut c, F::QuestionOrExclamationMark, mark);
                }
                let node = self.finish(
                    if text == "is" {
                        K::UnresolvedIsExpr
                    } else {
                        K::UnresolvedAsExpr
                    },
                    keyword.span.start,
                    c,
                );
                let ty = self.type_node();
                ops.push((
                    Operator::Cast {
                        node,
                        keyword,
                        mark,
                        is: text == "is",
                    },
                    Some(self.operators.named("CastingPrecedence")),
                ));
                values.push(Operand::plain(ty));
                continue;
            }
            let start = self.start();
            let mut c = Vec::new();
            let (kind, field) = if text == "=" {
                (K::AssignmentExpr, F::Equal)
            } else {
                (K::BinaryOperatorExpr, F::Operator)
            };
            if text == "=" {
                self.take(&mut c, field);
            } else {
                let op = self.bump_as(K::BinaryOperator);
                Self::add(&mut c, field, op);
            }
            let node = self.finish(kind, start, c);
            ops.push((Operator::Binary(node), self.operators.lookup(&text)));
            values.push(self.unary(trailing));
        }
        let result = if !self.operators.can_fold(
            ops.iter()
                .map(|(op, group)| (*group, matches!(op, Operator::Cast { .. }))),
        ) {
            let mut c = Vec::new();
            let end = values.last().unwrap().node.span.end;
            for (i, operand) in values.into_iter().enumerate() {
                let value = self.materialize(operand);
                let value = if i > 0 && matches!(ops[i - 1].0, Operator::Cast { .. }) {
                    let mut children = Vec::new();
                    Self::add(&mut children, F::Type, value);
                    self.make(K::TypeExpr, value.span, children)
                } else {
                    value
                };
                Self::add(&mut c, F::Elements, value);
                if let Some((op, _)) = ops.get(i) {
                    Self::add(&mut c, F::Elements, op.node());
                }
            }
            self.make(K::SequenceExpr, Span { start, end }, c)
        } else {
            let mut values = values.into_iter();
            let mut stack = vec![values.next().unwrap()];
            let mut operators = Vec::new();
            for ((op, prec), value) in ops.into_iter().zip(values) {
                let prec = prec.unwrap();
                while operators
                    .last()
                    .is_some_and(|(op, p): &(Operator<S::Node>, usize)| {
                        matches!(op, Operator::Cast { .. })
                            || self.operators.fold_before(*p, prec) == Some(true)
                    })
                {
                    let (op, _) = operators.pop().unwrap();
                    self.fold(&mut stack, op);
                }
                operators.push((op, prec));
                stack.push(value);
            }
            while let Some((op, _)) = operators.pop() {
                self.fold(&mut stack, op);
            }
            self.materialize(stack.pop().unwrap())
        };
        self.depth -= 1;
        result
    }

    fn fold(&mut self, stack: &mut Vec<Operand<S::Node>>, op: Operator<S::Node>) {
        let right = self.materialize(stack.pop().unwrap());
        let left = stack.pop().unwrap();
        let mut c = Vec::new();
        let kind = match op {
            Operator::Binary(op) => {
                Self::add(&mut c, F::LeftOperand, left.node);
                Self::add(&mut c, F::Operator, op);
                Self::add(&mut c, F::RightOperand, right);
                K::InfixOperatorExpr
            }
            Operator::Cast {
                keyword, mark, is, ..
            } => {
                Self::add(&mut c, F::Expression, left.node);
                Self::add(
                    &mut c,
                    if is { F::IsKeyword } else { F::AsKeyword },
                    keyword,
                );
                if let Some(mark) = mark {
                    Self::add(&mut c, F::QuestionOrExclamationMark, mark);
                }
                Self::add(&mut c, F::Type, right);
                if is { K::IsExpr } else { K::AsExpr }
            }
            Operator::Ternary {
                question,
                then,
                colon,
                ..
            } => {
                Self::add(&mut c, F::Condition, left.node);
                Self::add(&mut c, F::QuestionMark, question);
                Self::add(&mut c, F::ThenExpression, then);
                Self::add(&mut c, F::Colon, colon);
                Self::add(&mut c, F::ElseExpression, right);
                K::TernaryExpr
            }
        };
        let node = self.make(
            kind,
            Span {
                start: left.node.span.start,
                end: right.span.end,
            },
            c,
        );
        stack.push(Operand {
            node,
            effects: left.effects,
        });
    }

    fn materialize(&mut self, operand: Operand<S::Node>) -> Node<S::Node> {
        let mut node = operand.node;
        // SwiftOperators hoists only effects on the left operand. Keep those
        // wrappers pending until an expression becomes a right operand or ends.
        for effect in operand.effects {
            let mut c = Vec::new();
            Self::add(&mut c, effect.field, effect.keyword);
            if let Some(mark) = effect.mark {
                Self::add(&mut c, F::QuestionOrExclamationMark, mark);
            }
            Self::add(&mut c, F::Expression, node);
            node = self.make(
                effect.kind,
                Span {
                    start: effect.keyword.span.start,
                    end: node.span.end,
                },
                c,
            );
        }
        node
    }

    pub(super) fn spaced_before(&self) -> bool {
        self.pos > 0 && self.start() > self.end()
    }
    fn binary(&self) -> bool {
        if self.pattern_context && self.at("=") {
            return false;
        }
        if self.eof() {
            return false;
        }
        if self.newline()
            && self.source[self.token().span.end..]
                .chars()
                .next()
                .is_some_and(|c| !c.is_whitespace())
            && !self.source[self.token().span.end..].starts_with("/*")
            && !self.source[self.token().span.end..].starts_with("//")
        {
            return false;
        }
        matches!(self.token().kind, K::BinaryOperator | K::Equal)
            || (self.at("!") && self.spaced_before())
    }

    fn nested_unary(&mut self, trailing: bool) -> Operand<S::Node> {
        if !self.enter() {
            return Operand::plain(self.missing(K::MissingExpr));
        }
        let node = self.unary(trailing);
        self.depth -= 1;
        node
    }

    fn unary(&mut self, trailing: bool) -> Operand<S::Node> {
        let start = self.start();
        let text = self.text();
        if matches!(text, "try" | "await")
            || (matches!(text, "consume" | "borrow" | "copy" | "unsafe")
                && self.contextual_prefix(text == "unsafe", trailing))
        {
            let (kind, field) = match text {
                "try" => (K::TryExpr, F::TryKeyword),
                "await" => (K::AwaitExpr, F::AwaitKeyword),
                "consume" => (K::ConsumeExpr, F::ConsumeKeyword),
                "borrow" => (K::BorrowExpr, F::BorrowKeyword),
                "copy" => (K::CopyExpr, F::CopyKeyword),
                _ => (K::UnsafeExpr, F::UnsafeKeyword),
            };
            let keyword = self.word();
            let mark =
                (kind == K::TryExpr && !self.spaced_before() && (self.at("?") || self.at("!")))
                    .then(|| self.bump());
            let mut operand = self.nested_unary(trailing);
            if matches!(kind, K::TryExpr | K::AwaitExpr | K::UnsafeExpr) {
                operand.effects.push(Effect {
                    kind,
                    field,
                    keyword,
                    mark,
                });
                return operand;
            }
            let value = self.materialize(operand);
            let mut c = Vec::new();
            Self::add(&mut c, field, keyword);
            Self::add(&mut c, F::Expression, value);
            return Operand::plain(self.finish(kind, start, c));
        }
        if matches!(
            self.token().kind,
            K::BinaryOperator | K::PrefixOperator | K::PostfixOperator | K::ExclamationMark
        ) && !self.at("=")
        {
            if matches!(self.nth(1), "," | ")" | "]" | "}" | ":") {
                return Operand::plain(self.reference());
            }
            let amp = self.at("&");
            let mut c = Vec::new();
            let op = if amp {
                self.bump_as(K::Ampersand)
            } else {
                self.bump_as(K::PrefixOperator)
            };
            Self::add(&mut c, if amp { F::Ampersand } else { F::Operator }, op);
            let operand = self.nested_unary(trailing);
            let value = self.materialize(operand);
            Self::add(&mut c, F::Expression, value);
            return Operand::plain(self.finish(
                if amp {
                    K::InOutExpr
                } else {
                    K::PrefixOperatorExpr
                },
                start,
                c,
            ));
        }
        let primary = self.primary(trailing);
        let node = self.postfix(primary, trailing);
        Operand::plain(node)
    }

    pub(super) fn contextual_prefix(&self, ambiguous: bool, trailing: bool) -> bool {
        let Some(next) = self.tokens.get(self.pos + 1).filter(|t| !t.newline) else {
            return false;
        };
        match next.kind {
            K::Identifier => {
                !Self::lexical_keyword(self.nth(1))
                    || matches!(
                        self.nth(1),
                        "Any"
                            | "Self"
                            | "self"
                            | "super"
                            | "init"
                            | "true"
                            | "false"
                            | "nil"
                            | "repeat"
                            | "try"
                            | "if"
                            | "switch"
                    )
            }
            K::DollarIdentifier
            | K::Wildcard
            | K::IntegerLiteral
            | K::FloatLiteral
            | K::StringQuote
            | K::MultilineStringQuote
            | K::RawStringPoundDelimiter
            | K::RegexSlash
            | K::RegexPoundDelimiter
            | K::PrefixOperator
            | K::AtSign
            | K::Backslash
            | K::Pound => true,
            K::LeftParen | K::LeftSquare | K::Period => {
                ambiguous && next.span.start > self.token().span.end
            }
            K::LeftBrace => {
                ambiguous
                    && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos + 1)
                        .trailing_closure(trailing)
            }
            _ => false,
        }
    }

    #[allow(clippy::too_many_lines)]
    fn primary(&mut self, trailing: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        if self.binding_context
            && self.binding_identifier()
            && !self.binding_pattern()
            && !matches!(self.nth(1), "." | "(" | "<")
        {
            let pattern = self.pattern();
            Self::add(&mut c, F::Pattern, pattern);
            return self.finish(K::PatternExpr, start, c);
        }
        let kind = match self.token().kind {
            K::IntegerLiteral => {
                self.take(&mut c, F::Literal);
                K::IntegerLiteralExpr
            }
            K::FloatLiteral => {
                self.take(&mut c, F::Literal);
                K::FloatLiteralExpr
            }
            K::StringQuote | K::MultilineStringQuote | K::RawStringPoundDelimiter => {
                return self.string_literal();
            }
            K::RegexPoundDelimiter | K::RegexSlash => {
                let raw = self.at_kind(K::RegexPoundDelimiter);
                if raw {
                    self.take(&mut c, F::OpeningPounds);
                }
                self.take(&mut c, F::OpeningSlash);
                self.take(&mut c, F::Regex);
                self.take(&mut c, F::ClosingSlash);
                if raw && self.at_kind(K::RegexPoundDelimiter) {
                    self.take(&mut c, F::ClosingPounds);
                }
                K::RegexLiteralExpr
            }
            K::AtSign => {
                let ty = self.type_node();
                Self::add(&mut c, F::Type, ty);
                K::TypeExpr
            }
            K::LeftParen => {
                self.take(&mut c, F::LeftParen);
                self.arguments(&mut c, F::Elements, ")");
                self.expect(")", &mut c, F::RightParen);
                K::TupleExpr
            }
            K::LeftSquare => return self.collection(),
            K::Backslash => return self.key_path(),
            K::Pound => {
                return self.macro_expansion(K::MacroExpansionExpr, start, c, trailing);
            }
            K::LeftBrace => return self.closure(),
            K::Period => {
                self.take(&mut c, F::Period);
                let name = self.reference();
                Self::add(&mut c, F::DeclName, name);
                K::MemberAccessExpr
            }
            K::Wildcard => {
                self.take(&mut c, F::Wildcard);
                K::DiscardAssignmentExpr
            }
            K::Identifier | K::DollarIdentifier => match self.text() {
                _ if self.pattern_context && self.binding_pattern() => {
                    let pattern = self.matching_pattern();
                    Self::add(&mut c, F::Pattern, pattern);
                    K::PatternExpr
                }
                "let" | "var" | "is" => {
                    let pattern = self.matching_pattern();
                    Self::add(&mut c, F::Pattern, pattern);
                    K::PatternExpr
                }
                "true" | "false" => {
                    self.kw(&mut c, F::Literal);
                    K::BooleanLiteralExpr
                }
                "nil" => {
                    self.kw(&mut c, F::NilKeyword);
                    K::NilLiteralExpr
                }
                "Any" => {
                    let ty = self.type_root();
                    Self::add(&mut c, F::Type, ty);
                    K::TypeExpr
                }
                "inout" => {
                    let ty = self.type_node();
                    Self::add(&mut c, F::Type, ty);
                    K::TypeExpr
                }
                "any"
                    if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                        .existential_type() =>
                {
                    let ty = self.type_node();
                    Self::add(&mut c, F::Type, ty);
                    K::TypeExpr
                }
                "repeat" | "each"
                    if self.at("repeat")
                        || (self.tokens.get(self.pos + 1).is_some_and(|t| {
                            !t.newline
                                && t.span.start > self.token().span.end
                                && matches!(
                                    t.kind,
                                    K::Identifier | K::DollarIdentifier | K::LeftParen
                                )
                        }) && !matches!(
                            self.nth(1),
                            "as" | "is" | "in" | "else" | "where"
                        )) =>
                {
                    let expansion = self.at("repeat");
                    self.kw(
                        &mut c,
                        if expansion {
                            F::RepeatKeyword
                        } else {
                            F::EachKeyword
                        },
                    );
                    let value = if expansion {
                        self.expression(trailing)
                    } else {
                        let operand = self.nested_unary(trailing);
                        self.materialize(operand)
                    };
                    Self::add(
                        &mut c,
                        if expansion {
                            F::RepetitionPattern
                        } else {
                            F::Pack
                        },
                        value,
                    );
                    if expansion {
                        K::PackExpansionExpr
                    } else {
                        K::PackElementExpr
                    }
                }
                "super" => {
                    self.kw(&mut c, F::SuperKeyword);
                    K::SuperExpr
                }
                "if" => return self.if_expr(),
                "switch" => return self.switch_expr(),
                _ => {
                    return self
                        .declaration_reference_with_options(false, self.attribute_arguments);
                }
            },
            _ => return self.missing(K::MissingExpr),
        };
        self.finish(kind, start, c)
    }

    pub(super) fn reference(&mut self) -> Node<S::Node> {
        self.declaration_reference(false)
    }

    pub(super) fn declaration_reference(&mut self, empty_arguments: bool) -> Node<S::Node> {
        self.declaration_reference_with_options(empty_arguments, empty_arguments)
    }

    fn declaration_reference_with_options(
        &mut self,
        empty_arguments: bool,
        special_names: bool,
    ) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        let selector = self.module_selector();
        if let Some(selector) = selector {
            Self::add(&mut c, F::ModuleSelector, selector);
        }
        if self.at("init")
            || (selector.is_none() && matches!(self.text(), "self" | "Self"))
            || (special_names && matches!(self.text(), "subscript" | "deinit"))
        {
            self.kw(&mut c, F::BaseName);
        } else if self.at("Any") || (selector.is_some() && self.at_kind(K::Identifier)) {
            let name = self.bump_as(K::Identifier);
            Self::add(&mut c, F::BaseName, name);
        } else if matches!(
            self.token().kind,
            K::BinaryOperator | K::PrefixOperator | K::PostfixOperator | K::ExclamationMark
        ) {
            let name = self.bump_as(K::BinaryOperator);
            Self::add(&mut c, F::BaseName, name);
        } else {
            self.take(&mut c, F::BaseName);
        }
        if self.at("(")
            && ((self.label(1) && self.nth(2) == ":") || (empty_arguments && self.nth(1) == ")"))
        {
            let mut end = self.pos + 1;
            while end + 1 < self.tokens.len()
                && matches!(self.tokens[end].kind, K::Identifier | K::Wildcard)
                && &self.source[self.tokens[end + 1].span.start..self.tokens[end + 1].span.end]
                    == ":"
            {
                end += 2;
            }
            if self
                .tokens
                .get(end)
                .is_some_and(|t| t.kind == K::RightParen)
            {
                let start = self.start();
                let mut names = Vec::new();
                self.take(&mut names, F::LeftParen);
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let mut name = Vec::new();
                    self.argument_label(&mut name, F::Name);
                    self.take(&mut name, F::Colon);
                    let node = self.finish(K::DeclNameArgument, start, name);
                    Self::add(&mut names, F::Arguments, node);
                }
                self.expect(")", &mut names, F::RightParen);
                let node = self.finish(K::DeclNameArguments, start, names);
                Self::add(&mut c, F::ArgumentNames, node);
            }
        }
        self.finish(K::DeclReferenceExpr, start, c)
    }

    pub(super) fn qualified_reference(&mut self) -> Node<S::Node> {
        if !super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).qualified_base() {
            return self.declaration_reference(true);
        }
        let start = self.start();
        let mut ty = self.type_root();
        while self.at(".")
            && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos + 1)
                .qualified_base()
        {
            let mut c = Vec::new();
            Self::add(&mut c, F::BaseType, ty);
            self.take(&mut c, F::Period);
            if let Some(selector) = self.module_selector() {
                Self::add(&mut c, F::ModuleSelector, selector);
            }
            self.take(&mut c, F::Name);
            if self.text().starts_with('<') {
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
            }
            ty = self.finish(K::MemberType, start, c);
        }
        let mut c = Vec::new();
        Self::add(&mut c, F::Type, ty);
        let base = self.make(K::TypeExpr, ty.span, c);
        let mut c = Vec::new();
        Self::add(&mut c, F::Base, base);
        if self.text().starts_with('.') {
            let period = self.token_prefix(1, K::Period);
            Self::add(&mut c, F::Period, period);
        } else {
            self.expect(".", &mut c, F::Period);
        }
        let name = self.declaration_reference(true);
        Self::add(&mut c, F::DeclName, name);
        self.finish(K::MemberAccessExpr, start, c)
    }

    #[allow(clippy::too_many_lines)]
    fn postfix(&mut self, mut value: Node<S::Node>, trailing: bool) -> Node<S::Node> {
        let mut has_trailing_closure = false;
        loop {
            if self.exhausted || (self.condition_line && self.newline()) {
                break;
            }
            let start = value.span.start;
            let mut c = Vec::new();
            let mut parsed_trailing_closure = false;
            let kind = if self.text().starts_with('<') && self.specialization_ahead() {
                Self::add(&mut c, F::Expression, value);
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
                K::GenericSpecializationExpr
            } else if self.at(".") {
                Self::add(&mut c, F::Base, value);
                self.take(&mut c, F::Period);
                let name = self.reference();
                Self::add(&mut c, F::DeclName, name);
                K::MemberAccessExpr
            } else if (self.at("(") || self.at("[")) && !self.newline() {
                let subscript = self.at("[");
                Self::add(&mut c, F::CalledExpression, value);
                self.take(
                    &mut c,
                    if subscript {
                        F::LeftSquare
                    } else {
                        F::LeftParen
                    },
                );
                self.arguments(&mut c, F::Arguments, if subscript { "]" } else { ")" });
                self.expect(
                    if subscript { "]" } else { ")" },
                    &mut c,
                    if subscript {
                        F::RightSquare
                    } else {
                        F::RightParen
                    },
                );
                if trailing && self.at_trailing_closure(trailing) {
                    let closure = self.closure();
                    Self::add(&mut c, F::TrailingClosure, closure);
                    self.additional_closures(&mut c);
                    parsed_trailing_closure = true;
                }
                if subscript {
                    K::SubscriptCallExpr
                } else {
                    K::FunctionCallExpr
                }
            } else if (self.text().starts_with('!') && !self.text().starts_with("!=")
                || (self.text().starts_with('?') && !self.at_kind(K::BinaryOperator))
                || (self.text().starts_with("??") && self.nth(1) == "."))
                && !self.spaced_before()
            {
                let force = self.text().starts_with('!');
                Self::add(&mut c, F::Expression, value);
                let token = self.token_prefix(
                    1,
                    if force {
                        K::ExclamationMark
                    } else {
                        K::InfixQuestionMark
                    },
                );
                Self::add(
                    &mut c,
                    if force {
                        F::ExclamationMark
                    } else {
                        F::QuestionMark
                    },
                    token,
                );
                if force {
                    K::ForceUnwrapExpr
                } else {
                    K::OptionalChainingExpr
                }
            } else if self.at_kind(K::PostfixOperator) {
                Self::add(&mut c, F::Expression, value);
                self.take(&mut c, F::Operator);
                K::PostfixOperatorExpr
            } else if !has_trailing_closure
                && !matches!(
                    value.kind,
                    K::BooleanLiteralExpr
                        | K::FloatLiteralExpr
                        | K::IntegerLiteralExpr
                        | K::NilLiteralExpr
                        | K::RegexLiteralExpr
                        | K::StringLiteralExpr
                )
                && self.at_trailing_closure(trailing)
            {
                Self::add(&mut c, F::CalledExpression, value);
                let closure = self.closure();
                Self::add(&mut c, F::TrailingClosure, closure);
                self.additional_closures(&mut c);
                parsed_trailing_closure = true;
                K::FunctionCallExpr
            } else if self.at("#if")
                && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                    .conditional_postfix()
            {
                Self::add(&mut c, F::Base, value);
                let config = self.postfix_config(trailing);
                Self::add(&mut c, F::Config, config);
                K::PostfixIfConfigExpr
            } else {
                break;
            };
            value = self.finish(kind, start, c);
            has_trailing_closure = parsed_trailing_closure;
        }
        value
    }

    fn specialization_ahead(&self) -> bool {
        super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).specialization()
    }

    fn at_trailing_closure(&self, basic: bool) -> bool {
        self.at("{")
            && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                .trailing_closure(basic)
    }

    fn postfix_config(&mut self, trailing: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut config = Vec::new();
        while !self.eof() && matches!(self.text(), "#if" | "#elseif" | "#else") {
            let start = self.start();
            let mut clause = Vec::new();
            let condition = !self.at("#else");
            self.take(&mut clause, F::PoundKeyword);
            if condition {
                let node = self.directive_condition();
                Self::add(&mut clause, F::Condition, node);
            }
            if !matches!(self.text(), "#else" | "#elseif" | "#endif") {
                let value = if self.at("#if") {
                    let start = self.start();
                    let mut nested = Vec::new();
                    let config = self.postfix_config(trailing);
                    Self::add(&mut nested, F::Config, config);
                    self.finish(K::PostfixIfConfigExpr, start, nested)
                } else {
                    self.expression(trailing)
                };
                Self::add(&mut clause, F::Elements, value);
            }
            let node = self.finish(K::IfConfigClause, start, clause);
            Self::add(&mut config, F::Clauses, node);
        }
        self.expect("#endif", &mut config, F::PoundEndif);
        self.depth -= 1;
        self.finish(K::IfConfigDecl, start, config)
    }

    fn additional_closures(&mut self, c: &mut Children<S::Node>) {
        while self.label(0)
            && !matches!(self.text(), "case" | "default")
            && self.nth(1) == ":"
            && self.nth(2) == "{"
        {
            let start = self.start();
            let mut closure = Vec::new();
            self.take(&mut closure, F::Label);
            self.take(&mut closure, F::Colon);
            let body = self.closure();
            Self::add(&mut closure, F::Closure, body);
            let node = self.finish(K::MultipleTrailingClosureElement, start, closure);
            Self::add(c, F::AdditionalTrailingClosures, node);
        }
    }

    pub(super) fn macro_expansion(
        &mut self,
        kind: K,
        start: usize,
        mut c: Children<S::Node>,
        trailing: bool,
    ) -> Node<S::Node> {
        self.take(&mut c, F::Pound);
        if let Some(selector) = self.module_selector() {
            Self::add(&mut c, F::ModuleSelector, selector);
        }
        self.take(&mut c, F::MacroName);
        if self.at("<") {
            let args = self.generic_arguments();
            Self::add(&mut c, F::GenericArgumentClause, args);
        }
        if self.at("(") {
            self.take(&mut c, F::LeftParen);
            self.arguments(&mut c, F::Arguments, ")");
            self.expect(")", &mut c, F::RightParen);
        }
        if trailing && self.at("{") {
            let closure = self.closure();
            Self::add(&mut c, F::TrailingClosure, closure);
            self.additional_closures(&mut c);
        }
        self.finish(kind, start, c)
    }

    fn argument_label(&mut self, c: &mut Children<S::Node>, field: F) {
        if matches!(
            self.text(),
            "for"
                | "in"
                | "try"
                | "throws"
                | "throw"
                | "catch"
                | "case"
                | "default"
                | "switch"
                | "if"
                | "else"
                | "while"
                | "repeat"
                | "do"
                | "defer"
                | "guard"
                | "return"
                | "break"
                | "continue"
                | "fallthrough"
                | "let"
                | "var"
                | "func"
                | "class"
                | "struct"
                | "enum"
                | "protocol"
                | "extension"
                | "import"
                | "typealias"
                | "associatedtype"
                | "init"
                | "deinit"
                | "subscript"
                | "where"
                | "as"
                | "is"
                | "inout"
                | "nil"
                | "true"
                | "false"
        ) {
            self.kw(c, field);
        } else {
            self.take(c, field);
        }
    }
    fn key_path(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::Backslash);
        if !self.text().starts_with('.') {
            let root = self.key_path_root();
            Self::add(&mut c, F::Root, root);
        }
        while !self.eof() {
            let start = self.start();
            let mut component = Vec::new();
            let period = self.at(".")
                || (self.text().starts_with('.')
                    && self.text().bytes().all(|c| matches!(c, b'.' | b'?' | b'!')));
            let optional = self.text().starts_with(['?', '!'])
                && self.text().bytes().all(|c| matches!(c, b'?' | b'!' | b'.'))
                && (!self.spaced_before() || !self.at("?"));
            let subscript = self.at("[") && !self.newline();
            if period {
                let period = self.token_prefix(1, K::Period);
                Self::add(&mut component, F::Period, period);
            } else if !(subscript || optional) {
                break;
            }
            let inner_start = self.start();
            let mut inner = Vec::new();
            let kind = if self.at("[") {
                self.take(&mut inner, F::LeftSquare);
                self.arguments(&mut inner, F::Arguments, "]");
                self.expect("]", &mut inner, F::RightSquare);
                K::KeyPathSubscriptComponent
            } else if self.text().starts_with(['?', '!']) {
                let mark = self.token_prefix(
                    1,
                    if self.text().starts_with('?') {
                        K::InfixQuestionMark
                    } else {
                        K::ExclamationMark
                    },
                );
                Self::add(&mut inner, F::QuestionOrExclamationMark, mark);
                K::KeyPathOptionalComponent
            } else {
                let name = self.reference();
                Self::add(&mut inner, F::DeclName, name);
                if self.at("<") {
                    let args = self.generic_arguments();
                    Self::add(&mut inner, F::GenericArgumentClause, args);
                }
                K::KeyPathPropertyComponent
            };
            let node = self.finish(kind, inner_start, inner);
            Self::add(&mut component, F::Component, node);
            let node = self.finish(K::KeyPathComponent, start, component);
            Self::add(&mut c, F::Components, node);
        }
        self.finish(K::KeyPathExpr, start, c)
    }

    pub(super) fn arguments(&mut self, c: &mut Children<S::Node>, field: F, closing: &str) {
        while !self.eof() && !self.at(closing) && !self.at("}") {
            let before = self.pos;
            let start = self.start();
            let mut arg = Vec::new();
            if self.label(0) && self.nth(1) == ":" {
                let label = self.bump_as(self.token().kind);
                Self::add(&mut arg, F::Label, label);
                self.take(&mut arg, F::Colon);
            }
            let expression = self.expression(true);
            Self::add(&mut arg, F::Expression, expression);
            let comma = self.eat(",", &mut arg, F::TrailingComma);
            let node = self.finish(K::LabeledExpr, start, arg);
            Self::add(c, field, node);
            if !comma || before == self.pos {
                break;
            }
        }
    }

    fn collection(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::LeftSquare);
        if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).inline_array_start()
        {
            let ty = self.inline_array_type(start, c);
            let mut c = Vec::new();
            Self::add(&mut c, F::Type, ty);
            return self.finish(K::TypeExpr, start, c);
        }
        let mut dict = self.at(":");
        if dict {
            self.take(&mut c, F::Content);
        }
        while !self.eof() && !self.at("]") {
            let before = self.pos;
            let start = self.start();
            let mut element = Vec::new();
            let value = self.expression(true);
            if self.at(":") {
                dict = true;
                Self::add(&mut element, F::Key, value);
                self.take(&mut element, F::Colon);
                let value = self.expression(true);
                Self::add(&mut element, F::Value, value);
            } else {
                Self::add(&mut element, F::Expression, value);
            }
            let comma = self.eat(",", &mut element, F::TrailingComma);
            let node = self.finish(
                if dict {
                    K::DictionaryElement
                } else {
                    K::ArrayElement
                },
                start,
                element,
            );
            Self::add(&mut c, if dict { F::Content } else { F::Elements }, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.expect("]", &mut c, F::RightSquare);
        self.finish(
            if dict {
                K::DictionaryExpr
            } else {
                K::ArrayExpr
            },
            start,
            c,
        )
    }

    fn string_literal(&mut self) -> Node<S::Node> {
        self.string_literal_as(K::StringLiteralExpr)
    }

    pub(super) fn string_literal_as(&mut self, kind: K) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        let raw = self.at_kind(K::RawStringPoundDelimiter);
        if raw {
            self.take(&mut c, F::OpeningPounds);
        }
        let quote = self.token().kind;
        self.take(&mut c, F::OpeningQuote);
        while !self.eof() && !self.at_kind(quote) {
            let before = self.pos;
            let start = self.start();
            let mut segment = Vec::new();
            let kind = if self.at_kind(K::StringSegmentToken) {
                self.take(&mut segment, F::Content);
                K::StringSegment
            } else if self.at("\\") {
                self.take(&mut segment, F::Backslash);
                if raw && self.at_kind(K::RawStringPoundDelimiter) {
                    self.take(&mut segment, F::Pounds);
                }
                self.expect("(", &mut segment, F::LeftParen);
                let previous = self.attribute_arguments;
                self.attribute_arguments = false;
                self.arguments(&mut segment, F::Expressions, ")");
                self.attribute_arguments = previous;
                self.expect(")", &mut segment, F::RightParen);
                K::ExpressionSegment
            } else {
                break;
            };
            let node = self.finish(kind, start, segment);
            Self::add(&mut c, F::Segments, node);
            if before == self.pos {
                break;
            }
        }
        if self.at_kind(quote) {
            self.take(&mut c, F::ClosingQuote);
        }
        if raw && self.at_kind(K::RawStringPoundDelimiter) {
            self.take(&mut c, F::ClosingPounds);
        }
        self.finish(kind, start, c)
    }

    #[allow(clippy::too_many_lines)]
    fn closure(&mut self) -> Node<S::Node> {
        let previous = self.attribute_arguments;
        self.attribute_arguments = false;
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::LeftBrace);
        if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).closure_signature()
        {
            let start = self.start();
            let mut sig = Vec::new();
            while self.at("@") {
                let attr = self.attribute();
                Self::add(&mut sig, F::Attributes, attr);
            }
            if self.at("[") {
                let start = self.start();
                let mut capture = Vec::new();
                self.take(&mut capture, F::LeftSquare);
                while !self.eof() && !self.at("]") {
                    let start = self.start();
                    let mut item = Vec::new();
                    if self.at("weak") || self.at("unowned") {
                        let start = self.start();
                        let mut spec = Vec::new();
                        self.kw(&mut spec, F::Specifier);
                        if self.eat("(", &mut spec, F::LeftParen) {
                            self.kw(&mut spec, F::Detail);
                            self.expect(")", &mut spec, F::RightParen);
                        }
                        let node = self.finish(K::ClosureCaptureSpecifier, start, spec);
                        Self::add(&mut item, F::Specifier, node);
                    }
                    self.take(&mut item, F::Name);
                    if self.at("=") {
                        let init = self.initializer();
                        Self::add(&mut item, F::Initializer, init);
                    }
                    let comma = self.eat(",", &mut item, F::TrailingComma);
                    let node = self.finish(K::ClosureCapture, start, item);
                    Self::add(&mut capture, F::Items, node);
                    if !comma {
                        break;
                    }
                }
                self.expect("]", &mut capture, F::RightSquare);
                let node = self.finish(K::ClosureCaptureClause, start, capture);
                Self::add(&mut sig, F::Capture, node);
            }
            if self.at("(") {
                let start = self.start();
                let mut params = Vec::new();
                self.take(&mut params, F::LeftParen);
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let mut p = Vec::new();
                    while self.at("@") {
                        let attribute = self.attribute();
                        Self::add(&mut p, F::Attributes, attribute);
                    }
                    self.parameter_modifiers(&mut p, true);
                    let name = self.bump_as(self.token().kind);
                    Self::add(&mut p, F::FirstName, name);
                    if self.label(0) || self.at_kind(K::DollarIdentifier) {
                        let name = self.bump_as(self.token().kind);
                        Self::add(&mut p, F::SecondName, name);
                    }
                    if self.eat(":", &mut p, F::Colon) {
                        let ty = self.type_node();
                        Self::add(&mut p, F::Type, ty);
                    }
                    if self.at("...") {
                        let ellipsis = self.bump_as(K::Ellipsis);
                        Self::add(&mut p, F::Ellipsis, ellipsis);
                    }
                    let comma = self.eat(",", &mut p, F::TrailingComma);
                    let node = self.finish(K::ClosureParameter, start, p);
                    Self::add(&mut params, F::Parameters, node);
                    if !comma {
                        break;
                    }
                }
                self.expect(")", &mut params, F::RightParen);
                let node = self.finish(K::ClosureParameterClause, start, params);
                Self::add(&mut sig, F::ParameterClause, node);
            } else {
                while !self.eof()
                    && !matches!(self.text(), "in" | "throws" | "->")
                    && (!self.at("async") || matches!(self.nth(1), "in" | ","))
                {
                    let start = self.start();
                    let mut p = Vec::new();
                    self.take(&mut p, F::Name);
                    let comma = self.eat(",", &mut p, F::TrailingComma);
                    let node = self.finish(K::ClosureShorthandParameter, start, p);
                    Self::add(&mut sig, F::ParameterClause, node);
                    if !comma {
                        break;
                    }
                }
            }
            if let Some(effects) = self.effects(K::TypeEffectSpecifiers) {
                Self::add(&mut sig, F::EffectSpecifiers, effects);
            }
            if self.at("->") {
                let ret = self.return_clause();
                Self::add(&mut sig, F::ReturnClause, ret);
            }
            if self.at("in") {
                self.kw(&mut sig, F::InKeyword);
            }
            let node = self.finish(K::ClosureSignature, start, sig);
            Self::add(&mut c, F::Signature, node);
        }
        self.items(&mut c, F::Statements, false, false);
        self.expect("}", &mut c, F::RightBrace);
        self.attribute_arguments = previous;
        self.finish(K::ClosureExpr, start, c)
    }
}
