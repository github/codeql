use super::{Children, F, K, Node, Span, State, SyntaxSink};

#[derive(Clone, Copy, PartialEq, Eq)]
enum OptionalSuffix {
    None,
    All,
    BeforeMember,
    BeforeComposition,
}

impl<S: SyntaxSink> State<'_, S> {
    #[allow(clippy::too_many_lines)]
    pub(super) fn type_node(&mut self) -> Node<S::Node> {
        self.type_with_composition(true, true, OptionalSuffix::All)
    }
    pub(super) fn type_root(&mut self) -> Node<S::Node> {
        self.type_with_composition(false, false, OptionalSuffix::None)
    }
    pub(super) fn key_path_root(&mut self) -> Node<S::Node> {
        self.type_with_composition(false, false, OptionalSuffix::All)
    }

    fn at_type_specifier(&self) -> bool {
        (super::lookahead::simple_type_specifier(self.text())
            || (self.at("nonisolated")
                && !(self.nth(1) == "("
                    && self.tokens.get(self.pos + 1).is_some_and(|t| t.newline))))
            && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                .can_have_parameter_specifier()
    }

    fn type_specifier(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        let kind = if self.at("nonisolated") {
            self.kw(&mut c, F::NonisolatedKeyword);
            if self.at("(") && self.nth(1) == "nonsending" {
                let start = self.start();
                let mut arg = self.children();
                self.take(&mut arg, F::LeftParen);
                self.kw(&mut arg, F::NonsendingKeyword);
                self.expect(")", &mut arg, F::RightParen);
                let arg = self.finish(K::NonisolatedSpecifierArgument, start, arg);
                Self::add(&mut c, F::Argument, arg);
            }
            K::NonisolatedTypeSpecifier
        } else {
            self.kw(&mut c, F::Specifier);
            K::SimpleTypeSpecifier
        };
        self.finish(kind, start, c)
    }

    pub(super) fn attribute_name(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        if let Some(selector) = self.module_selector() {
            Self::add(&mut c, F::ModuleSelector, selector);
        }
        let name = self.bump_as(K::Identifier);
        Self::add(&mut c, F::Name, name);
        if self.text().starts_with('<') {
            let args = self.generic_arguments();
            Self::add(&mut c, F::GenericArgumentClause, args);
        }
        let mut node = self.finish(K::IdentifierType, start, c);
        while self.at(".") {
            let mut c = self.children();
            Self::add(&mut c, F::BaseType, node);
            self.take(&mut c, F::Period);
            if let Some(selector) = self.module_selector() {
                Self::add(&mut c, F::ModuleSelector, selector);
            }
            self.take(&mut c, F::Name);
            if self.text().starts_with('<') {
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
            }
            node = self.finish(K::MemberType, start, c);
        }
        node
    }

    #[allow(clippy::too_many_lines)]
    fn type_with_composition(
        &mut self,
        composition: bool,
        members: bool,
        optional_suffixes: OptionalSuffix,
    ) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingType);
        }
        let start = self.start();
        let mut c = self.children();
        let mut node = if self.at("~") {
            self.take(&mut c, F::WithoutTilde);
            let ty = self.type_with_composition(false, members, optional_suffixes);
            Self::add(&mut c, F::Type, ty);
            self.finish(K::SuppressedType, start, c)
        } else if self.at("repeat") || self.at("each") {
            let expansion = self.at("repeat");
            self.kw(
                &mut c,
                if expansion {
                    F::RepeatKeyword
                } else {
                    F::EachKeyword
                },
            );
            let pattern = self.type_node();
            Self::add(
                &mut c,
                if expansion {
                    F::RepetitionPattern
                } else {
                    F::Pack
                },
                pattern,
            );
            self.finish(
                if expansion {
                    K::PackExpansionType
                } else {
                    K::PackElementType
                },
                start,
                c,
            )
        } else if self.at("@") || self.at_type_specifier() {
            let mut attributes = false;
            while self.at_type_specifier() || self.at("@") {
                if self.at("@") {
                    attributes = true;
                    let attr = self.type_attribute();
                    Self::add(&mut c, F::Attributes, attr);
                    continue;
                }
                let spec = self.type_specifier();
                Self::add(
                    &mut c,
                    if attributes {
                        F::LateSpecifiers
                    } else {
                        F::Specifiers
                    },
                    spec,
                );
            }

            let base = self.type_node();
            Self::add(&mut c, F::BaseType, base);
            self.finish(K::AttributedType, start, c)
        } else if self.at("some") || self.at("any") {
            self.kw(&mut c, F::SomeOrAnySpecifier);
            let constraint =
                self.type_with_composition(true, members, OptionalSuffix::BeforeMember);
            Self::add(&mut c, F::Constraint, constraint);
            self.finish(K::SomeOrAnyType, start, c)
        } else if self.at("[") {
            self.take(&mut c, F::LeftSquare);
            if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                .inline_array_start()
            {
                self.inline_array_type(start, c)
            } else {
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
            }
        } else if self.text().starts_with('<') {
            let parameters = self.generic_parameters();
            Self::add(&mut c, F::GenericParameterClause, parameters);
            let ty = self.type_node();
            Self::add(&mut c, F::Type, ty);
            self.finish(K::NamedOpaqueReturnType, start, c)
        } else if self.at("(") {
            self.take(&mut c, F::LeftParen);
            let mut elements = Vec::new();
            while !self.eof() && !self.at(")") {
                let before = self.pos;
                let start = self.start();
                let mut el = self.children();
                if self.labels_before_colon() {
                    let name = self.bump_as(self.token().kind);
                    Self::add(&mut el, F::FirstName, name);
                    if !self.at(":") {
                        let name = self.bump_as(self.token().kind);
                        Self::add(&mut el, F::SecondName, name);
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
            let selector = self.module_selector();
            if let Some(selector) = selector {
                Self::add(&mut c, F::ModuleSelector, selector);
            }
            if selector.is_none() && matches!(self.text(), "Any" | "Self") {
                self.kw(&mut c, F::Name);
            } else if selector.is_some() {
                let name = self.bump_as(K::Identifier);
                Self::add(&mut c, F::Name, name);
            } else {
                self.take(&mut c, F::Name);
            }
            if self.text().starts_with('<') {
                let args = self.generic_arguments();
                Self::add(&mut c, F::GenericArgumentClause, args);
            }
            self.finish(K::IdentifierType, start, c)
        } else {
            self.recycle(c);
            self.missing(K::MissingType)
        };
        loop {
            if self.exhausted {
                break;
            }
            let start = node.span.start;
            let mut c = self.children();
            let kind = if self.at(".")
                && (members
                    || (optional_suffixes == OptionalSuffix::All
                        && matches!(self.nth(1), "Type" | "Protocol")))
            {
                Self::add(&mut c, F::BaseType, node);
                self.take(&mut c, F::Period);
                let selector = self.module_selector();
                if let Some(selector) = selector {
                    Self::add(&mut c, F::ModuleSelector, selector);
                }
                if selector.is_none() && (self.at("Type") || self.at("Protocol")) {
                    self.kw(&mut c, F::MetatypeSpecifier);
                    K::MetatypeType
                } else {
                    if selector.is_some() {
                        let name = self.bump_as(K::Identifier);
                        Self::add(&mut c, F::Name, name);
                    } else {
                        self.take(&mut c, F::Name);
                    }
                    if self.text().starts_with('<') {
                        let args = self.generic_arguments();
                        Self::add(&mut c, F::GenericArgumentClause, args);
                    }
                    K::MemberType
                }
            } else if self.optional_suffix_allowed(optional_suffixes)
                && self.text().starts_with(['?', '!'])
                && !self.spaced_before()
                && !(self.at("??") && self.at_kind(K::BinaryOperator))
                && !self.text().starts_with("!=")
            {
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
                self.recycle(c);
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
                let mut c = self.children();
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
                node = self.type_with_composition(
                    false,
                    members,
                    if optional_suffixes == OptionalSuffix::BeforeMember {
                        OptionalSuffix::BeforeComposition
                    } else {
                        optional_suffixes
                    },
                );
            }
            let mut c = self.children();
            for el in elements {
                Self::add(&mut c, F::Elements, el);
            }
            node = self.finish(K::CompositionType, first.span.start, c);
        }
        self.depth -= 1;
        node
    }

    fn optional_suffix_allowed(&self, suffixes: OptionalSuffix) -> bool {
        match suffixes {
            OptionalSuffix::None => false,
            OptionalSuffix::All => true,
            OptionalSuffix::BeforeMember => self.nth(1) == "." && self.text().len() == 1,
            OptionalSuffix::BeforeComposition => {
                let mut offset = 0;
                while !self.nth(offset).is_empty()
                    && self.nth(offset).chars().all(|c| matches!(c, '?' | '!'))
                {
                    offset += 1;
                }
                matches!(self.nth(offset), "." | "&")
            }
        }
    }

    pub(super) fn module_selector(&mut self) -> Option<Node<S::Node>> {
        if self.nth(1) != "::" {
            return None;
        }
        let start = self.start();
        let mut c = self.children();
        let name = self.bump_as(K::Identifier);
        Self::add(&mut c, F::ModuleName, name);
        self.take(&mut c, F::ColonColon);
        Some(self.finish(K::ModuleSelector, start, c))
    }

    pub(super) fn angle(&mut self, left: bool, c: &mut Children<S::Node>) {
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
        let mut c = self.children();
        self.angle(true, &mut c);
        while !self.eof() && !self.text().starts_with('>') {
            let before = self.pos;
            let start = self.start();
            let mut arg = self.children();
            let ty = self.generic_argument();
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

    pub(super) fn inline_array_type(
        &mut self,
        start: usize,
        mut c: Children<S::Node>,
    ) -> Node<S::Node> {
        for field in [F::Count, F::Element] {
            let start = self.start();
            let value = self.generic_argument();
            let mut argument = self.children();
            Self::add(&mut argument, F::Argument, value);
            let node = self.finish(K::GenericArgument, start, argument);
            Self::add(&mut c, field, node);
            if field == F::Count {
                self.kw(&mut c, F::Separator);
            }
        }
        self.expect("]", &mut c, F::RightSquare);
        self.finish(K::InlineArrayType, start, c)
    }

    fn generic_argument(&mut self) -> Node<S::Node> {
        let negative = self.at("-")
            && self
                .tokens
                .get(self.pos + 1)
                .is_some_and(|t| t.kind == K::IntegerLiteral);
        if !self.at_kind(K::IntegerLiteral) && !negative {
            return self.type_node();
        }
        let start = self.start();
        let minus = negative.then(|| self.bump_as(K::PrefixOperator));
        let literal_start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::Literal);
        let literal = self.finish(K::IntegerLiteralExpr, literal_start, c);
        if let Some(minus) = minus {
            let mut c = self.children();
            Self::add(&mut c, F::Operator, minus);
            Self::add(&mut c, F::Expression, literal);
            self.finish(K::PrefixOperatorExpr, start, c)
        } else {
            literal
        }
    }

    pub(super) fn generic_parameters(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.angle(true, &mut c);
        while !self.eof() && !self.text().starts_with('>') {
            let before = self.pos;
            let start = self.start();
            let mut p = self.children();
            if self.at("each") || self.at("let") {
                self.kw(&mut p, F::Specifier);
            }
            let name = self.bump_as(K::Identifier);
            Self::add(&mut p, F::Name, name);
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
        if self.at("where") {
            let requirements = self.where_clause();
            Self::add(&mut c, F::GenericWhereClause, requirements);
        }
        self.angle(false, &mut c);
        self.finish(K::GenericParameterClause, start, c)
    }

    pub(super) fn return_clause(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
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
        let mut c = self.children();
        if self.at("async") || self.at("reasync") {
            self.kw(&mut c, F::AsyncSpecifier);
        }
        if self.at("throws") || self.at("rethrows") {
            let node = self.throws_clause();
            Self::add(&mut c, F::ThrowsClause, node);
        }
        Some(self.finish(kind, start, c))
    }

    pub(super) fn throws_clause(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.kw(&mut c, F::ThrowsSpecifier);
        if self.eat("(", &mut c, F::LeftParen) {
            let ty = self.type_node();
            Self::add(&mut c, F::Type, ty);
            self.expect(")", &mut c, F::RightParen);
        }
        self.finish(K::ThrowsClause, start, c)
    }

    pub(super) fn annotation(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::Colon);
        let ty = self.type_node();
        Self::add(&mut c, F::Type, ty);
        self.finish(K::TypeAnnotation, start, c)
    }

    pub(super) fn where_clause(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.kw(&mut c, F::WhereKeyword);
        loop {
            let before = self.pos;
            let start = self.start();
            let mut req = self.children();
            let mut inner = self.children();
            let left = self.generic_argument();
            let same = self.at("==");
            let layout = self.at(":")
                && matches!(
                    self.nth(1),
                    "_Trivial"
                        | "_TrivialAtMost"
                        | "_UnknownLayout"
                        | "_RefCountedObject"
                        | "_NativeRefCountedObject"
                        | "_Class"
                        | "_NativeClass"
                        | "_BridgeObject"
                        | "_TrivialStride"
                );
            Self::add(&mut inner, if layout { F::Type } else { F::LeftType }, left);
            self.take(&mut inner, if same { F::Equal } else { F::Colon });
            if layout {
                self.kw(&mut inner, F::LayoutSpecifier);
                if self.eat("(", &mut inner, F::LeftParen) {
                    if self.at_kind(K::IntegerLiteral) {
                        self.take(&mut inner, F::Size);
                    }
                    if self.eat(",", &mut inner, F::Comma) {
                        self.take(&mut inner, F::Alignment);
                    }
                    self.expect(")", &mut inner, F::RightParen);
                }
            } else {
                let right = if same {
                    self.generic_argument()
                } else {
                    self.type_node()
                };
                Self::add(&mut inner, F::RightType, right);
            }
            let node = self.finish(
                if same {
                    K::SameTypeRequirement
                } else if layout {
                    K::LayoutRequirement
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
