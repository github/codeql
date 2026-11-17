use super::{Children, F, K, Node, Span, State, SyntaxSink};

impl<S: SyntaxSink> State<'_, S> {
    #[allow(clippy::too_many_lines)]
    pub(super) fn type_node(&mut self) -> Node<S::Node> {
        self.type_with_composition(true)
    }

    #[allow(clippy::too_many_lines)]
    fn type_with_composition(&mut self, composition: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingType);
        }
        let start = self.start();
        let mut c = Vec::new();
        let mut node = if self.at("@")
            || matches!(
                self.text(),
                "inout"
                    | "borrowing"
                    | "consuming"
                    | "isolated"
                    | "sending"
                    | "__owned"
                    | "__shared"
            ) {
            while self.at("@") {
                let attr = self.attribute();
                Self::add(&mut c, F::Attributes, attr);
            }
            while matches!(
                self.text(),
                "inout"
                    | "borrowing"
                    | "consuming"
                    | "isolated"
                    | "sending"
                    | "__owned"
                    | "__shared"
            ) {
                let start = self.start();
                let mut spec = Vec::new();
                self.kw(&mut spec, F::Specifier);
                let spec = self.finish(K::SimpleTypeSpecifier, start, spec);
                Self::add(&mut c, F::Specifiers, spec);
            }
            let base = self.type_node();
            Self::add(&mut c, F::BaseType, base);
            self.finish(K::AttributedType, start, c)
        } else if self.at("some") || self.at("any") {
            self.kw(&mut c, F::SomeOrAnySpecifier);
            let constraint = self.type_node();
            Self::add(&mut c, F::Constraint, constraint);
            self.finish(K::SomeOrAnyType, start, c)
        } else if self.at("[") {
            self.take(&mut c, F::LeftSquare);
            let first = self.type_node();
            let kind = if self.at(":") {
                Self::add(&mut c, F::Key, first);
                self.take(&mut c, F::Colon);
                let value = self.type_node();
                Self::add(&mut c, F::Value, value);
                K::DictionaryType
            } else {
                Self::add(&mut c, F::Element, first);
                K::ArrayType
            };
            self.expect("]", &mut c, F::RightSquare);
            self.finish(kind, start, c)
        } else if self.at("(") {
            self.take(&mut c, F::LeftParen);
            let mut elements = Vec::new();
            while !self.eof() && !self.at(")") {
                let before = self.pos;
                let start = self.start();
                let mut el = Vec::new();
                if self.labels_before_colon() {
                    self.take(&mut el, F::FirstName);
                    if !self.at(":") {
                        self.take(&mut el, F::SecondName);
                    }
                    self.expect(":", &mut el, F::Colon);
                }
                let ty = self.type_node();
                Self::add(&mut el, F::Type, ty);
                if self.at("...") {
                    let op = self.bump_as(K::Ellipsis);
                    Self::add(&mut el, F::Ellipsis, op);
                }
                let comma = self.eat(",", &mut el, F::TrailingComma);
                elements.push(self.finish(K::TupleTypeElement, start, el));
                if !comma || before == self.pos {
                    break;
                }
            }
            self.expect(")", &mut c, F::RightParen);
            let function =
                self.at("->") || self.at("async") || self.at("throws") || self.at("rethrows");
            for el in elements {
                Self::add(
                    &mut c,
                    if function { F::Parameters } else { F::Elements },
                    el,
                );
            }
            if function {
                if let Some(effects) = self.effects(K::TypeEffectSpecifiers) {
                    Self::add(&mut c, F::EffectSpecifiers, effects);
                }
                let ret = self.return_clause();
                Self::add(&mut c, F::ReturnClause, ret);
            }
            self.finish(
                if function {
                    K::FunctionType
                } else {
                    K::TupleType
                },
                start,
                c,
            )
        } else if self.at("class") {
            self.kw(&mut c, F::ClassKeyword);
            self.finish(K::ClassRestrictionType, start, c)
        } else if self.at_kind(K::Identifier) || self.at_kind(K::Wildcard) {
            if matches!(self.text(), "Any" | "Self") {
                self.kw(&mut c, F::Name);
            } else {
                self.take(&mut c, F::Name);
            }
            if self.at("<") {
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
            }
            self.finish(K::IdentifierType, start, c)
        } else {
            self.missing(K::MissingType)
        };
        loop {
            if self.exhausted {
                break;
            }
            let start = node.span.start;
            let mut c = Vec::new();
            let kind = if self.at(".") {
                Self::add(&mut c, F::BaseType, node);
                self.take(&mut c, F::Period);
                if self.at("Type") || self.at("Protocol") {
                    self.kw(&mut c, F::MetatypeSpecifier);
                    K::MetatypeType
                } else {
                    self.take(&mut c, F::Name);
                    if self.at("<") {
                        let args = self.generic_arguments();
                        Self::add(&mut c, F::GenericArgumentClause, args);
                    }
                    K::MemberType
                }
            } else if self.text().starts_with(['?', '!']) {
                let optional = self.text().starts_with('?');
                Self::add(&mut c, F::WrappedType, node);
                let token = self.token_prefix(
                    1,
                    if optional {
                        K::InfixQuestionMark
                    } else {
                        K::ExclamationMark
                    },
                );
                Self::add(
                    &mut c,
                    if optional {
                        F::QuestionMark
                    } else {
                        F::ExclamationMark
                    },
                    token,
                );
                if optional {
                    K::OptionalType
                } else {
                    K::ImplicitlyUnwrappedOptionalType
                }
            } else {
                break;
            };
            node = self.finish(kind, start, c);
        }
        if composition && self.at("&") {
            let mut elements = Vec::new();
            let first = node;
            loop {
                if self.exhausted {
                    break;
                }
                let mut c = Vec::new();
                Self::add(&mut c, F::Type, node);
                let more = if self.at("&") {
                    let op = self.bump_as(K::BinaryOperator);
                    Self::add(&mut c, F::Ampersand, op);
                    true
                } else {
                    false
                };
                elements.push(self.finish(K::CompositionTypeElement, node.span.start, c));
                if !more {
                    break;
                }
                node = self.type_with_composition(false);
            }
            let mut c = Vec::new();
            for el in elements {
                Self::add(&mut c, F::Elements, el);
            }
            node = self.finish(K::CompositionType, first.span.start, c);
        }
        self.depth -= 1;
        node
    }

    fn angle(&mut self, left: bool, c: &mut Children<S::Node>) {
        let text = if left { "<" } else { ">" };
        if self.text().starts_with(text) {
            let token = self.token();
            let node = self.make(
                if left { K::LeftAngle } else { K::RightAngle },
                Span {
                    start: token.span.start,
                    end: token.span.start + 1,
                },
                Vec::new(),
            );
            Self::add(c, if left { F::LeftAngle } else { F::RightAngle }, node);
            self.last_end = node.span.end;
            if token.span.end > token.span.start + 1 {
                self.tokens[self.pos].span.start += 1;
            } else {
                self.pos += 1;
            }
        }
    }

    pub(super) fn generic_arguments(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.angle(true, &mut c);
        while !self.eof() && !self.text().starts_with('>') {
            let before = self.pos;
            let start = self.start();
            let mut arg = Vec::new();
            let ty = self.type_node();
            Self::add(&mut arg, F::Argument, ty);
            let comma = self.eat(",", &mut arg, F::TrailingComma);
            let node = self.finish(K::GenericArgument, start, arg);
            Self::add(&mut c, F::Arguments, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.angle(false, &mut c);
        self.finish(K::GenericArgumentClause, start, c)
    }

    pub(super) fn generic_parameters(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.angle(true, &mut c);
        while !self.eof() && !self.text().starts_with('>') {
            let before = self.pos;
            let start = self.start();
            let mut p = Vec::new();
            if self.at("each") {
                self.kw(&mut p, F::Specifier);
            }
            self.take(&mut p, F::Name);
            if self.eat(":", &mut p, F::Colon) {
                let ty = self.type_node();
                Self::add(&mut p, F::InheritedType, ty);
            }
            let comma = self.eat(",", &mut p, F::TrailingComma);
            let node = self.finish(K::GenericParameter, start, p);
            Self::add(&mut c, F::Parameters, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.angle(false, &mut c);
        self.finish(K::GenericParameterClause, start, c)
    }

    pub(super) fn return_clause(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.expect("->", &mut c, F::Arrow);
        let ty = self.type_node();
        Self::add(&mut c, F::Type, ty);
        self.finish(K::ReturnClause, start, c)
    }

    pub(super) fn effects(&mut self, kind: K) -> Option<Node<S::Node>> {
        if !matches!(self.text(), "async" | "reasync" | "throws" | "rethrows") {
            return None;
        }
        let start = self.start();
        let mut c = Vec::new();
        if self.at("async") || self.at("reasync") {
            self.kw(&mut c, F::AsyncSpecifier);
        }
        if self.at("throws") || self.at("rethrows") {
            let start = self.start();
            let mut t = Vec::new();
            self.kw(&mut t, F::ThrowsSpecifier);
            if self.eat("(", &mut t, F::LeftParen) {
                let ty = self.type_node();
                Self::add(&mut t, F::Type, ty);
                self.expect(")", &mut t, F::RightParen);
            }
            let node = self.finish(K::ThrowsClause, start, t);
            Self::add(&mut c, F::ThrowsClause, node);
        }
        Some(self.finish(kind, start, c))
    }

    pub(super) fn annotation(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::Colon);
        let ty = self.type_node();
        Self::add(&mut c, F::Type, ty);
        self.finish(K::TypeAnnotation, start, c)
    }

    pub(super) fn where_clause(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.kw(&mut c, F::WhereKeyword);
        loop {
            let before = self.pos;
            let start = self.start();
            let mut req = Vec::new();
            let mut inner = Vec::new();
            let left = self.type_node();
            Self::add(&mut inner, F::LeftType, left);
            let same = self.at("==");
            self.take(&mut inner, if same { F::Equal } else { F::Colon });
            let right = self.type_node();
            Self::add(&mut inner, F::RightType, right);
            let node = self.finish(
                if same {
                    K::SameTypeRequirement
                } else {
                    K::ConformanceRequirement
                },
                start,
                inner,
            );
            Self::add(&mut req, F::Requirement, node);
            let comma = self.eat(",", &mut req, F::TrailingComma);
            let node = self.finish(K::GenericRequirement, start, req);
            Self::add(&mut c, F::Requirements, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.finish(K::GenericWhereClause, start, c)
    }
}
