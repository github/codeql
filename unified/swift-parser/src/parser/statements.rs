use super::{Children, F, K, Node, State, SyntaxSink};

impl<S: SyntaxSink> State<'_, S> {
    pub(super) fn directive_condition(&mut self) -> Node<S::Node> {
        let previous = self.condition_line;
        self.condition_line = true;
        let condition = self.expression(false);
        self.condition_line = previous;
        condition
    }
    #[allow(clippy::too_many_lines)]
    pub(super) fn statement(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        if self.label(0) && !matches!(self.text(), "case" | "default") && self.nth(1) == ":" {
            if !self.enter() {
                self.recycle(c);
                return self.missing(K::MissingStmt);
            }
            self.take(&mut c, F::Label);
            self.take(&mut c, F::Colon);
            let statement = self.statement();
            Self::add(&mut c, F::Statement, statement);
            self.depth -= 1;
            return self.finish(K::LabeledStmt, start, c);
        }
        let kind = match self.text() {
            "yield" if !self.contextual_prefix(false, true) => {
                self.recycle(c);
                return self.expression(true);
            }
            "discard" if self.contextual_prefix(false, true) => {
                self.kw(&mut c, F::DiscardKeyword);
                let value = self.expression(true);
                Self::add(&mut c, F::Expression, value);
                K::DiscardStmt
            }
            "return" | "throw" | "yield" => {
                let (kind, field) = match self.text() {
                    "throw" => (K::ThrowStmt, F::ThrowKeyword),
                    "yield" => (K::YieldStmt, F::YieldKeyword),
                    _ => (K::ReturnStmt, F::ReturnKeyword),
                };
                self.kw(&mut c, field);
                if !self.starts_statement() {
                    let value = self.expression(true);
                    Self::add(
                        &mut c,
                        if kind == K::YieldStmt {
                            F::YieldedExpressions
                        } else {
                            F::Expression
                        },
                        value,
                    );
                }
                kind
            }
            "break" | "continue" | "fallthrough" => {
                let (kind, field) = match self.text() {
                    "continue" => (K::ContinueStmt, F::ContinueKeyword),
                    "fallthrough" => (K::FallThroughStmt, F::FallthroughKeyword),
                    _ => (K::BreakStmt, F::BreakKeyword),
                };
                self.kw(&mut c, field);
                if !self.newline() && self.at_kind(K::Identifier) {
                    self.take(&mut c, F::Label);
                }
                kind
            }
            "if" | "switch" => {
                let value = if self.at("if") {
                    self.if_expr()
                } else {
                    self.switch_expr()
                };
                Self::add(&mut c, F::Expression, value);
                K::ExpressionStmt
            }
            "while" | "guard" => {
                let guard = self.at("guard");
                self.kw(
                    &mut c,
                    if guard {
                        F::GuardKeyword
                    } else {
                        F::WhileKeyword
                    },
                );
                self.conditions(&mut c);
                if guard && self.at("else") {
                    self.kw(&mut c, F::ElseKeyword);
                }
                let body = self.block(false);
                Self::add(&mut c, F::Body, body);
                if guard { K::GuardStmt } else { K::WhileStmt }
            }
            "for" => {
                self.kw(&mut c, F::ForKeyword);
                if self.at("try") {
                    self.kw(&mut c, F::TryKeyword);
                }
                if self.at("await") {
                    self.kw(&mut c, F::AwaitKeyword);
                }
                if self.at("unsafe") && !matches!(self.nth(1), "in" | ":") {
                    self.kw(&mut c, F::UnsafeKeyword);
                }
                let matching = self.at("case");
                if matching {
                    self.kw(&mut c, F::CaseKeyword);
                }
                let pattern = if matching {
                    self.matching_pattern()
                } else {
                    self.pattern()
                };
                Self::add(&mut c, F::Pattern, pattern);
                if self.at(":") {
                    let node = self.annotation();
                    Self::add(&mut c, F::TypeAnnotation, node);
                }
                if self.at("in") {
                    self.kw(&mut c, F::InKeyword);
                }
                let sequence = self.expression(false);
                Self::add(&mut c, F::Sequence, sequence);
                if self.at("where") {
                    let start = self.start();
                    let mut w = self.children();
                    self.kw(&mut w, F::WhereKeyword);
                    let condition = self.expression(false);
                    Self::add(&mut w, F::Condition, condition);
                    let node = self.finish(K::WhereClause, start, w);
                    Self::add(&mut c, F::WhereClause, node);
                }
                let body = self.block(false);
                Self::add(&mut c, F::Body, body);
                K::ForStmt
            }
            "repeat" if self.nth(1) == "{" => {
                self.kw(&mut c, F::RepeatKeyword);
                let body = self.block(false);
                Self::add(&mut c, F::Body, body);
                if self.at("while") {
                    self.kw(&mut c, F::WhileKeyword);
                }
                let condition = self.expression(true);
                Self::add(&mut c, F::Condition, condition);
                K::RepeatStmt
            }
            "defer" | "do" => {
                let defer = self.at("defer");
                self.kw(&mut c, if defer { F::DeferKeyword } else { F::DoKeyword });
                if !defer && self.at("throws") {
                    let throws = self.throws_clause();
                    Self::add(&mut c, F::ThrowsClause, throws);
                }
                let body = self.block(false);
                Self::add(&mut c, F::Body, body);
                while self.at("catch") {
                    let start = self.start();
                    let mut catch = self.children();
                    self.kw(&mut catch, F::CatchKeyword);
                    if !self.at("{") {
                        loop {
                            let start = self.start();
                            let mut item = self.children();
                            if !self.at("where") {
                                let pattern = self.matching_pattern();
                                Self::add(&mut item, F::Pattern, pattern);
                            }
                            if self.at("where") {
                                let start = self.start();
                                let mut clause = self.children();
                                self.kw(&mut clause, F::WhereKeyword);
                                let condition = self.expression(false);
                                Self::add(&mut clause, F::Condition, condition);
                                let node = self.finish(K::WhereClause, start, clause);
                                Self::add(&mut item, F::WhereClause, node);
                            }
                            let comma = self.eat(",", &mut item, F::TrailingComma);
                            let node = self.finish(K::CatchItem, start, item);
                            Self::add(&mut catch, F::CatchItems, node);
                            if !comma {
                                break;
                            }
                        }
                    }
                    let body = self.block(false);
                    Self::add(&mut catch, F::Body, body);
                    let node = self.finish(K::CatchClause, start, catch);
                    Self::add(&mut c, F::CatchClauses, node);
                }
                if defer { K::DeferStmt } else { K::DoStmt }
            }
            _ => {
                self.recycle(c);
                return self.expression(true);
            }
        };
        self.finish(kind, start, c)
    }

    fn conditions(&mut self, c: &mut Children<S::Node>) {
        loop {
            let before = self.pos;
            let start = self.start();
            let mut el = self.children();
            let condition = if self.at("#available") || self.at("#unavailable") {
                let mut available = self.children();
                self.take(&mut available, F::AvailabilityKeyword);
                self.expect("(", &mut available, F::LeftParen);
                self.availability_specifications(&mut available, F::AvailabilityArguments);
                self.expect(")", &mut available, F::RightParen);
                self.finish(K::AvailabilityCondition, start, available)
            } else if self.at("let") || self.at("var") || self.at("case") {
                let matching = self.at("case");
                let mut bind = self.children();
                self.kw(
                    &mut bind,
                    if matching {
                        F::CaseKeyword
                    } else {
                        F::BindingSpecifier
                    },
                );
                let previous = self.binding_context;
                if !matching {
                    self.binding_context = true;
                }
                let pattern = self.matching_pattern();
                self.binding_context = previous;
                Self::add(&mut bind, F::Pattern, pattern);
                if self.at(":") {
                    let ty = self.annotation();
                    Self::add(&mut bind, F::TypeAnnotation, ty);
                }
                if self.at("=") {
                    let start = self.start();
                    let mut init = self.children();
                    self.take(&mut init, F::Equal);
                    let expr = self.expression(false);
                    Self::add(&mut init, F::Value, expr);
                    let node = self.finish(K::InitializerClause, start, init);
                    Self::add(&mut bind, F::Initializer, node);
                }
                self.finish(
                    if matching {
                        K::MatchingPatternCondition
                    } else {
                        K::OptionalBindingCondition
                    },
                    start,
                    bind,
                )
            } else {
                self.expression(false)
            };
            Self::add(&mut el, F::Condition, condition);
            let comma = self.eat(",", &mut el, F::TrailingComma);
            let node = self.finish(K::ConditionElement, start, el);
            Self::add(c, F::Conditions, node);
            if !comma || before == self.pos {
                break;
            }
        }
    }

    pub(super) fn if_expr(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingExpr);
        }
        let mut arms = Vec::new();
        let mut tail: Option<Node<S::Node>> = None;
        loop {
            let start = self.start();
            let mut c = self.children();
            self.kw(&mut c, F::IfKeyword);
            self.conditions(&mut c);
            if self.exhausted {
                self.recycle(c);
                for (_, _, children) in arms {
                    self.recycle(children);
                }
                self.depth -= 1;
                return self.missing(K::MissingExpr);
            }
            let body = self.block(false);
            Self::add(&mut c, F::Body, body);
            let mut end = body.span.end;
            let has_else = self.at("else") && !self.exhausted;
            if has_else {
                self.kw(&mut c, F::ElseKeyword);
            }
            let next_arm = has_else && self.at("if");
            if has_else && !next_arm {
                let body = self.block(false);
                end = body.span.end;
                Self::add(&mut c, F::ElseBody, body);
            }
            arms.push((start, end, c));
            if !next_arm {
                break;
            }
        }
        for (start, mut end, mut c) in arms.into_iter().rev() {
            if let Some(node) = tail {
                end = node.span.end;
                Self::add(&mut c, F::ElseBody, node);
            }
            tail = Some(self.make(K::IfExpr, super::Span { start, end }, c));
        }
        self.depth -= 1;
        tail.unwrap()
    }

    pub(super) fn switch_expr(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingExpr);
        }
        let start = self.start();
        let mut c = self.children();
        self.kw(&mut c, F::SwitchKeyword);
        let subject = self.expression(false);
        Self::add(&mut c, F::Subject, subject);
        self.expect("{", &mut c, F::LeftBrace);
        self.switch_cases(&mut c, F::Cases);
        self.expect("}", &mut c, F::RightBrace);
        self.depth -= 1;
        self.finish(K::SwitchExpr, start, c)
    }

    fn switch_cases(&mut self, c: &mut Children<S::Node>, field: F) {
        while !self.exhausted
            && !self.eof()
            && !self.at("}")
            && !matches!(
                self.token().kind,
                K::PoundElse | K::PoundElseif | K::PoundEndif
            )
        {
            let before = self.pos;
            let start = self.start();
            if self.at("#if") {
                let node = self.switch_if_config();
                Self::add(c, field, node);
                continue;
            }
            let mut case = self.children();
            if self.at("@") {
                let attr = self.attribute();
                Self::add(&mut case, F::Attribute, attr);
            }
            if !self.at("case") && !self.at("default") {
                self.recycle(case);
                let node = self.recover();
                Self::add(c, field, node);
                continue;
            }
            let label_start = self.start();
            let mut label = self.children();
            let default = self.at("default");
            self.kw(
                &mut label,
                if default {
                    F::DefaultKeyword
                } else {
                    F::CaseKeyword
                },
            );
            if !default {
                loop {
                    let start = self.start();
                    let mut item = self.children();
                    let pattern = self.matching_pattern();
                    Self::add(&mut item, F::Pattern, pattern);
                    if self.at("where") {
                        let start = self.start();
                        let mut w = self.children();
                        self.kw(&mut w, F::WhereKeyword);
                        let expr = self.expression(true);
                        Self::add(&mut w, F::Condition, expr);
                        let node = self.finish(K::WhereClause, start, w);
                        Self::add(&mut item, F::WhereClause, node);
                    }
                    let comma = self.eat(",", &mut item, F::TrailingComma);
                    let node = self.finish(K::SwitchCaseItem, start, item);
                    Self::add(&mut label, F::CaseItems, node);
                    if !comma {
                        break;
                    }
                }
            }
            self.expect(":", &mut label, F::Colon);
            let node = self.finish(
                if default {
                    K::SwitchDefaultLabel
                } else {
                    K::SwitchCaseLabel
                },
                label_start,
                label,
            );
            Self::add(&mut case, F::Label, node);
            self.items(&mut case, F::Statements, false, true);
            let node = self.finish(K::SwitchCase, start, case);
            Self::add(c, field, node);
            if before == self.pos {
                break;
            }
        }
    }

    fn switch_if_config(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut c = self.children();
        while !self.exhausted && matches!(self.text(), "#if" | "#elseif" | "#else") {
            let start = self.start();
            let mut clause = self.children();
            let has_condition = !self.at("#else");
            self.take(&mut clause, F::PoundKeyword);
            if has_condition {
                let condition = self.directive_condition();
                Self::add(&mut clause, F::Condition, condition);
            }
            self.switch_cases(&mut clause, F::Elements);
            let node = self.finish(K::IfConfigClause, start, clause);
            Self::add(&mut c, F::Clauses, node);
        }
        self.expect("#endif", &mut c, F::PoundEndif);
        self.depth -= 1;
        self.finish(K::IfConfigDecl, start, c)
    }
}
