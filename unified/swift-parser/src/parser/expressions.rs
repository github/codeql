use super::{Children, F, K, Node, Span, State, SyntaxSink};

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
        let mut values = vec![first];
        let mut ops = Vec::new();
        while !self.exhausted
            && (self.binary()
                || self.at("as")
                || self.at("is")
                || (self.at("?") && self.spaced_before()))
        {
            let text = self.text().to_owned();
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
                values.push(ty);
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
        let result = if !self.operators.can_fold(ops.iter().map(|(_, group)| *group)) {
            let mut c = Vec::new();
            for (i, value) in values.iter().copied().enumerate() {
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
            self.make(
                K::SequenceExpr,
                Span {
                    start: first.span.start,
                    end: values.last().unwrap().span.end,
                },
                c,
            )
        } else {
            let mut stack = vec![values[0]];
            let mut operators = Vec::new();
            for (index, (op, prec)) in ops.into_iter().enumerate() {
                let prec = prec.unwrap();
                while operators
                    .last()
                    .is_some_and(|(_, p): &(Operator<S::Node>, usize)| {
                        self.operators.fold_before(*p, prec) == Some(true)
                    })
                {
                    let (op, _) = operators.pop().unwrap();
                    self.fold(&mut stack, op);
                }
                operators.push((op, prec));
                stack.push(values[index + 1]);
            }
            while let Some((op, _)) = operators.pop() {
                self.fold(&mut stack, op);
            }
            stack[0]
        };
        self.depth -= 1;
        result
    }

    fn fold(&mut self, stack: &mut Vec<Node<S::Node>>, op: Operator<S::Node>) {
        let right = stack.pop().unwrap();
        let left = stack.pop().unwrap();
        let mut c = Vec::new();
        let kind = match op {
            Operator::Binary(op) => {
                Self::add(&mut c, F::LeftOperand, left);
                Self::add(&mut c, F::Operator, op);
                Self::add(&mut c, F::RightOperand, right);
                K::InfixOperatorExpr
            }
            Operator::Cast {
                keyword, mark, is, ..
            } => {
                Self::add(&mut c, F::Expression, left);
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
                Self::add(&mut c, F::Condition, left);
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
                start: left.span.start,
                end: right.span.end,
            },
            c,
        );
        stack.push(node);
    }

    fn spaced_before(&self) -> bool {
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
        {
            return false;
        }
        matches!(self.token().kind, K::BinaryOperator | K::Equal)
            || (self.at("!") && self.spaced_before())
    }

    fn unary(&mut self, trailing: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingExpr);
        }
        let node = self.unary_inner(trailing);
        self.depth -= 1;
        node
    }

    fn unary_inner(&mut self, trailing: bool) -> Node<S::Node> {
        let start = self.start();
        let text = self.text();
        if matches!(text, "try" | "await" | "unsafe")
            || (matches!(text, "consume" | "borrow" | "copy")
                && self.tokens.get(self.pos + 1).is_some_and(|t| {
                    !t.newline
                        && t.span.start > self.token().span.end
                        && matches!(t.kind, K::Identifier | K::DollarIdentifier | K::LeftParen)
                }))
        {
            let (kind, field) = match text {
                "try" => (K::TryExpr, F::TryKeyword),
                "await" => (K::AwaitExpr, F::AwaitKeyword),
                "consume" => (K::ConsumeExpr, F::ConsumeKeyword),
                "borrow" => (K::BorrowExpr, F::BorrowKeyword),
                "copy" => (K::CopyExpr, F::CopyKeyword),
                _ => (K::UnsafeExpr, F::UnsafeKeyword),
            };
            let mut c = Vec::new();
            self.kw(&mut c, field);
            if kind == K::TryExpr && (self.at("?") || self.at("!")) {
                self.take(&mut c, F::QuestionOrExclamationMark);
            }
            let value = if matches!(kind, K::TryExpr | K::AwaitExpr | K::UnsafeExpr) {
                self.expression(trailing)
            } else {
                self.unary(trailing)
            };
            Self::add(&mut c, F::Expression, value);
            return self.finish(kind, start, c);
        }
        if matches!(self.token().kind, K::BinaryOperator | K::ExclamationMark) && !self.at("=") {
            let amp = self.at("&");
            let mut c = Vec::new();
            let op = if amp {
                self.bump_as(K::Ampersand)
            } else {
                self.bump_as(K::PrefixOperator)
            };
            Self::add(&mut c, if amp { F::Ampersand } else { F::Operator }, op);
            let value = self.unary(trailing);
            Self::add(&mut c, F::Expression, value);
            return self.finish(
                if amp {
                    K::InOutExpr
                } else {
                    K::PrefixOperatorExpr
                },
                start,
                c,
            );
        }
        let primary = self.primary(trailing);
        self.postfix(primary, trailing)
    }

    fn primary(&mut self, trailing: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        if self.binding_context
            && self.at_kind(K::Identifier)
            && !matches!(self.text(), "let" | "var" | "true" | "false" | "nil")
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
            K::LeftParen => {
                self.take(&mut c, F::LeftParen);
                self.arguments(&mut c, F::Elements, ")");
                self.expect(")", &mut c, F::RightParen);
                K::TupleExpr
            }
            K::LeftSquare => return self.collection(),
            K::Pound => {
                self.take(&mut c, F::Pound);
                self.take(&mut c, F::MacroName);
                if self.at("(") {
                    self.take(&mut c, F::LeftParen);
                    self.arguments(&mut c, F::Arguments, ")");
                    self.expect(")", &mut c, F::RightParen);
                }
                K::MacroExpansionExpr
            }
            K::LeftBrace if trailing => return self.closure(),
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
                "let" | "var" => {
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
                "super" => {
                    self.kw(&mut c, F::SuperKeyword);
                    K::SuperExpr
                }
                "if" => return self.if_expr(),
                "switch" => return self.switch_expr(),
                _ => return self.reference(),
            },
            _ => return self.missing(K::MissingExpr),
        };
        self.finish(kind, start, c)
    }

    pub(super) fn reference(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        if matches!(self.text(), "self" | "Self" | "init") {
            self.kw(&mut c, F::BaseName);
        } else {
            self.take(&mut c, F::BaseName);
        }
        if self.at("(") && self.nth(2) == ":" {
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
                    self.take(&mut name, F::Name);
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

    fn postfix(&mut self, mut value: Node<S::Node>, trailing: bool) -> Node<S::Node> {
        loop {
            if self.exhausted {
                break;
            }
            let start = value.span.start;
            let mut c = Vec::new();
            let kind = if self.at("<") && self.specialization_ahead() {
                Self::add(&mut c, F::Expression, value);
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
                K::GenericSpecializationExpr
            } else if self.at(".") && (!self.newline() || !self.tokens[self.pos + 1].newline) {
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
                if trailing && self.at("{") {
                    let closure = self.closure();
                    Self::add(&mut c, F::TrailingClosure, closure);
                }
                if subscript {
                    K::SubscriptCallExpr
                } else {
                    K::FunctionCallExpr
                }
            } else if (self.text().starts_with('!') && !self.text().starts_with("!=")
                || self.at("?"))
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
            } else if self.at("{")
                && trailing
                && !self.newline()
                && !matches!(
                    self.nth(1),
                    "didSet" | "willSet" | "get" | "set" | "_read" | "_modify"
                )
            {
                Self::add(&mut c, F::CalledExpression, value);
                let closure = self.closure();
                Self::add(&mut c, F::TrailingClosure, closure);
                K::FunctionCallExpr
            } else {
                break;
            };
            value = self.finish(kind, start, c);
        }
        value
    }

    fn specialization_ahead(&self) -> bool {
        !self.spaced_before()
            && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).specialization()
    }

    pub(super) fn arguments(&mut self, c: &mut Children<S::Node>, field: F, closing: &str) {
        while !self.eof() && !self.at(closing) && !self.at("}") {
            let before = self.pos;
            let start = self.start();
            let mut arg = Vec::new();
            if self.label(0) && self.nth(1) == ":" {
                self.take(&mut arg, F::Label);
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
        if self.at_kind(K::RawStringPoundDelimiter) {
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
                if self.at_kind(K::RawStringPoundDelimiter) {
                    self.take(&mut segment, F::Pounds);
                }
                self.expect("(", &mut segment, F::LeftParen);
                self.arguments(&mut segment, F::Expressions, ")");
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
        if self.at_kind(K::RawStringPoundDelimiter) {
            self.take(&mut c, F::ClosingPounds);
        }
        self.finish(kind, start, c)
    }

    #[allow(clippy::too_many_lines)]
    fn closure(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::LeftBrace);
        if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos).closure_signature()
        {
            let start = self.start();
            let mut sig = Vec::new();
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
                    self.take(&mut p, F::FirstName);
                    if !self.at(":") && !self.at(",") && !self.at(")") {
                        self.take(&mut p, F::SecondName);
                    }
                    if self.eat(":", &mut p, F::Colon) {
                        let ty = self.type_node();
                        Self::add(&mut p, F::Type, ty);
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
                while !self.eof() && !matches!(self.text(), "in" | "async" | "throws" | "->") {
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
        if self.enter() {
            self.items(&mut c, F::Statements, false, false);
            self.depth -= 1;
        }
        self.expect("}", &mut c, F::RightBrace);
        self.finish(K::ClosureExpr, start, c)
    }
}
