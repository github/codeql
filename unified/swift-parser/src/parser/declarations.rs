use super::{Children, F, K, Node, Span, State, SyntaxSink};

impl<S: SyntaxSink> State<'_, S> {
    #[allow(clippy::too_many_lines)]
    pub(super) fn item(&mut self, member: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        while self.at("@")
            || (self.at("#if")
                && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                    .conditional_attributes())
        {
            let attr = if self.at("@") {
                self.attribute()
            } else {
                self.attribute_config()
            };
            Self::add(&mut c, F::Attributes, attr);
        }
        while self.is_modifier() {
            let start = self.start();
            let mut modifier = self.children();
            self.kw(&mut modifier, F::Name);
            if self.at("(") {
                let start = self.start();
                let mut detail = self.children();
                self.take(&mut detail, F::LeftParen);
                self.take(&mut detail, F::Detail);
                self.expect(")", &mut detail, F::RightParen);
                let node = self.finish(K::DeclModifierDetail, start, detail);
                Self::add(&mut modifier, F::Detail, node);
            }
            let node = self.finish(K::DeclModifier, start, modifier);
            Self::add(&mut c, F::Modifiers, node);
        }
        let kind = match self.text() {
            "#" if member || !c.is_empty() => {
                return self.macro_expansion(K::MacroExpansionDecl, start, c, true);
            }
            "#if" => {
                self.recycle(c);
                return self.if_config(member);
            }
            "#sourceLocation" => {
                self.recycle(c);
                return self.source_location();
            }
            "import" => {
                self.kw(&mut c, F::ImportKeyword);
                let scoped = matches!(
                    self.text(),
                    "typealias" | "struct" | "class" | "enum" | "protocol" | "let" | "var" | "func"
                );
                if scoped {
                    self.kw(&mut c, F::ImportKindSpecifier);
                }
                let separator = if scoped && self.nth(1) == "::" {
                    "::"
                } else {
                    "."
                };
                loop {
                    let start = self.start();
                    let mut path = self.children();
                    let name = self.bump_as(K::Identifier);
                    Self::add(&mut path, F::Name, name);
                    let more = self.eat(separator, &mut path, F::TrailingPeriod);
                    let node = self.finish(K::ImportPathComponent, start, path);
                    Self::add(&mut c, F::Path, node);
                    if !more {
                        break;
                    }
                }
                K::ImportDecl
            }
            "let" | "var" | "inout" | "_borrowing" => {
                self.kw(&mut c, F::BindingSpecifier);
                loop {
                    let before = self.pos;
                    let start = self.start();
                    let mut binding = self.children();
                    let pattern = self.pattern();
                    Self::add(&mut binding, F::Pattern, pattern);
                    if self.at(":") {
                        let ty = self.annotation();
                        Self::add(&mut binding, F::TypeAnnotation, ty);
                    }
                    let has_initializer = self.at("=");
                    if has_initializer {
                        let init = self.initializer();
                        Self::add(&mut binding, F::Initializer, init);
                    }
                    if self.at("{")
                        && (!has_initializer
                            || !self.newline()
                            || super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                                .observing_accessor_block())
                    {
                        let accessors = self.accessors();
                        Self::add(&mut binding, F::AccessorBlock, accessors);
                    }
                    let more = self.eat(",", &mut binding, F::TrailingComma);
                    let node = self.finish(K::PatternBinding, start, binding);
                    Self::add(&mut c, F::Bindings, node);
                    if !more || before == self.pos {
                        break;
                    }
                }
                K::VariableDecl
            }
            "func" | "init" | "deinit" | "subscript" | "macro"
                if !self.at("macro") || self.label(1) =>
            {
                let text = self.text();
                let (kind, field) = match text {
                    "init" => (K::InitializerDecl, F::InitKeyword),
                    "deinit" => (K::DeinitializerDecl, F::DeinitKeyword),
                    "subscript" => (K::SubscriptDecl, F::SubscriptKeyword),
                    "macro" => (K::MacroDecl, F::MacroKeyword),
                    _ => (K::FunctionDecl, F::FuncKeyword),
                };
                self.kw(&mut c, field);
                if matches!(kind, K::FunctionDecl | K::MacroDecl) {
                    if matches!(
                        self.token().kind,
                        K::BinaryOperator
                            | K::PrefixOperator
                            | K::PostfixOperator
                            | K::ExclamationMark
                    ) {
                        let name = if self.text().ends_with('<')
                            && self.text().len() > 1
                            && (self.label(1) || self.nth(1) == "@")
                        {
                            self.token_prefix(self.text().len() - 1, K::BinaryOperator)
                        } else {
                            self.bump_as(K::BinaryOperator)
                        };
                        Self::add(&mut c, F::Name, name);
                    } else {
                        self.take(&mut c, F::Name);
                    }
                }
                if kind == K::InitializerDecl && self.text().starts_with(['?', '!']) {
                    let mark = self.token_prefix(
                        1,
                        if self.text().starts_with('?') {
                            K::InfixQuestionMark
                        } else {
                            K::ExclamationMark
                        },
                    );
                    Self::add(&mut c, F::OptionalMark, mark);
                }
                if self.at("<") {
                    let node = self.generic_parameters();
                    Self::add(&mut c, F::GenericParameterClause, node);
                }
                if kind != K::DeinitializerDecl {
                    if kind == K::SubscriptDecl {
                        let node = self.parameters(false);
                        Self::add(&mut c, F::ParameterClause, node);
                        let node = self.return_clause();
                        Self::add(&mut c, F::ReturnClause, node);
                    } else {
                        let start = self.start();
                        let mut sig = self.children();
                        let parameters = self.parameters(false);
                        Self::add(&mut sig, F::ParameterClause, parameters);
                        if let Some(effects) = self.effects(K::FunctionEffectSpecifiers) {
                            Self::add(&mut sig, F::EffectSpecifiers, effects);
                        }
                        if self.at("->") {
                            let node = self.return_clause();
                            Self::add(&mut sig, F::ReturnClause, node);
                        }
                        let node = self.finish(K::FunctionSignature, start, sig);
                        Self::add(&mut c, F::Signature, node);
                    }
                }
                if kind == K::MacroDecl && self.at("=") {
                    let node = self.initializer();
                    Self::add(&mut c, F::Definition, node);
                }
                if self.at("where") {
                    let node = self.where_clause();
                    Self::add(&mut c, F::GenericWhereClause, node);
                }
                if self.at("{") {
                    let node = if kind == K::SubscriptDecl {
                        self.accessors()
                    } else {
                        self.block(false)
                    };
                    Self::add(
                        &mut c,
                        if kind == K::SubscriptDecl {
                            F::AccessorBlock
                        } else {
                            F::Body
                        },
                        node,
                    );
                }
                kind
            }
            "struct" | "class" | "enum" | "protocol" | "actor" | "extension"
                if !self.at("actor") || self.label(1) =>
            {
                let (kind, field) = match self.text() {
                    "class" => (K::ClassDecl, F::ClassKeyword),
                    "enum" => (K::EnumDecl, F::EnumKeyword),
                    "protocol" => (K::ProtocolDecl, F::ProtocolKeyword),
                    "actor" => (K::ActorDecl, F::ActorKeyword),
                    "extension" => (K::ExtensionDecl, F::ExtensionKeyword),
                    _ => (K::StructDecl, F::StructKeyword),
                };
                self.kw(&mut c, field);
                if kind == K::ExtensionDecl {
                    let ty = self.type_node();
                    Self::add(&mut c, F::ExtendedType, ty);
                } else {
                    self.take(&mut c, F::Name);
                }
                if self.at("<") {
                    if kind == K::ProtocolDecl {
                        let node = self.primary_associated_types();
                        Self::add(&mut c, F::PrimaryAssociatedTypeClause, node);
                    } else {
                        let node = self.generic_parameters();
                        Self::add(&mut c, F::GenericParameterClause, node);
                    }
                }
                if self.at(":") {
                    let node = self.inheritance();
                    Self::add(&mut c, F::InheritanceClause, node);
                }
                if self.at("where") {
                    let node = self.where_clause();
                    Self::add(&mut c, F::GenericWhereClause, node);
                }
                if self.at("{") {
                    let node = self.block(true);
                    Self::add(&mut c, F::MemberBlock, node);
                }
                kind
            }
            "typealias" | "associatedtype" => {
                let associated = self.at("associatedtype");
                self.kw(
                    &mut c,
                    if associated {
                        F::AssociatedtypeKeyword
                    } else {
                        F::TypealiasKeyword
                    },
                );
                self.take(&mut c, F::Name);
                if self.at("<") {
                    let node = self.generic_parameters();
                    Self::add(&mut c, F::GenericParameterClause, node);
                }
                if self.at(":") {
                    let node = self.inheritance();
                    Self::add(&mut c, F::InheritanceClause, node);
                }
                if self.at("=") {
                    let start = self.start();
                    let mut init = self.children();
                    self.take(&mut init, F::Equal);
                    let ty = self.type_node();
                    Self::add(&mut init, F::Value, ty);
                    let node = self.finish(K::TypeInitializerClause, start, init);
                    Self::add(&mut c, F::Initializer, node);
                }
                if self.at("where") {
                    let node = self.where_clause();
                    Self::add(&mut c, F::GenericWhereClause, node);
                }
                if associated {
                    K::AssociatedTypeDecl
                } else {
                    K::TypeAliasDecl
                }
            }
            "case" if member => {
                self.kw(&mut c, F::CaseKeyword);
                loop {
                    let start = self.start();
                    let mut el = self.children();
                    self.take(&mut el, F::Name);
                    if self.at("(") {
                        let node = self.parameters(true);
                        Self::add(&mut el, F::ParameterClause, node);
                    }
                    if self.at("=") {
                        let init = self.initializer();
                        Self::add(&mut el, F::RawValue, init);
                    }
                    let comma = self.eat(",", &mut el, F::TrailingComma);
                    let node = self.finish(K::EnumCaseElement, start, el);
                    Self::add(&mut c, F::Elements, node);
                    if !comma {
                        break;
                    }
                }
                K::EnumCaseDecl
            }
            "infix" | "prefix" | "postfix" if self.nth(1) == "operator" => {
                self.kw(&mut c, F::FixitySpecifier);
                self.kw(&mut c, F::OperatorKeyword);
                let node = self.bump_as(K::BinaryOperator);
                Self::add(&mut c, F::Name, node);
                if self.at(":") {
                    let start = self.start();
                    let mut precedence = self.children();
                    self.take(&mut precedence, F::Colon);
                    self.take(&mut precedence, F::PrecedenceGroup);
                    let node = self.finish(K::OperatorPrecedenceAndTypes, start, precedence);
                    Self::add(&mut c, F::OperatorPrecedenceAndTypes, node);
                }
                K::OperatorDecl
            }
            "precedencegroup" => {
                self.kw(&mut c, F::PrecedencegroupKeyword);
                self.take(&mut c, F::Name);
                self.expect("{", &mut c, F::LeftBrace);
                while !self.exhausted && !self.eof() && !self.at("}") {
                    let start = self.start();
                    let mut attr = self.children();
                    let kind = match self.text() {
                        "associativity" => {
                            self.kw(&mut attr, F::AssociativityLabel);
                            self.expect(":", &mut attr, F::Colon);
                            self.kw(&mut attr, F::Value);
                            K::PrecedenceGroupAssociativity
                        }
                        "assignment" => {
                            self.kw(&mut attr, F::AssignmentLabel);
                            self.expect(":", &mut attr, F::Colon);
                            self.kw(&mut attr, F::Value);
                            K::PrecedenceGroupAssignment
                        }
                        "higherThan" | "lowerThan" => {
                            self.kw(&mut attr, F::HigherThanOrLowerThanLabel);
                            self.expect(":", &mut attr, F::Colon);
                            loop {
                                let start = self.start();
                                let mut name = self.children();
                                self.take(&mut name, F::Name);
                                let comma = self.eat(",", &mut name, F::TrailingComma);
                                let node = self.finish(K::PrecedenceGroupName, start, name);
                                Self::add(&mut attr, F::PrecedenceGroups, node);
                                if !comma {
                                    break;
                                }
                            }
                            K::PrecedenceGroupRelation
                        }
                        _ => {
                            self.recycle(attr);
                            let node = self.recover();
                            Self::add(&mut c, F::GroupAttributes, node);
                            continue;
                        }
                    };
                    let node = self.finish(kind, start, attr);
                    Self::add(&mut c, F::GroupAttributes, node);
                }
                self.expect("}", &mut c, F::RightBrace);
                K::PrecedenceGroupDecl
            }
            _ => {
                self.recycle(c);
                return self.statement();
            }
        };
        self.finish(kind, start, c)
    }

    fn source_location(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::PoundSourceLocation);
        self.expect("(", &mut c, F::LeftParen);
        if !self.at(")") {
            let start = self.start();
            let mut arguments = self.children();
            self.kw(&mut arguments, F::FileLabel);
            self.expect(":", &mut arguments, F::FileColon);
            let file = self.string_literal_as(K::SimpleStringLiteralExpr);
            Self::add(&mut arguments, F::FileName, file);
            self.expect(",", &mut arguments, F::Comma);
            self.kw(&mut arguments, F::LineLabel);
            self.expect(":", &mut arguments, F::LineColon);
            self.take(&mut arguments, F::LineNumber);
            let arguments = self.finish(K::PoundSourceLocationArguments, start, arguments);
            Self::add(&mut c, F::Arguments, arguments);
        }
        self.expect(")", &mut c, F::RightParen);
        self.finish(K::PoundSourceLocation, start, c)
    }

    fn is_modifier(&self) -> bool {
        if self.nth(1) == "(" {
            let detail = match self.text() {
                "private" | "public" | "open" | "internal" | "fileprivate" | "package" => {
                    self.nth(2) == "set"
                }
                "unowned" => matches!(self.nth(2), "safe" | "unsafe"),
                "nonisolated" => matches!(self.nth(2), "unsafe" | "nonsending"),
                _ => false,
            };
            return detail
                && self.nth(3) == ")"
                && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                    .modifier_declaration();
        }
        if !self.label(1) && self.nth(1) != "#" {
            return false;
        }
        (self.at("async") && matches!(self.nth(1), "let" | "var"))
            || (matches!(self.text(), "prefix" | "postfix" | "infix")
                && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                    .modifier_declaration())
            || super::lookahead::declaration_modifier(self.text())
            || (self.at("class")
                && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                    .class_modifier())
    }

    fn primary_associated_types(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut clause = self.children();
        self.angle(true, &mut clause);
        while !self.eof() && !self.text().starts_with('>') {
            let start = self.start();
            let mut ty = self.children();
            self.take(&mut ty, F::Name);
            let comma = self.eat(",", &mut ty, F::TrailingComma);
            let node = self.finish(K::PrimaryAssociatedType, start, ty);
            Self::add(&mut clause, F::PrimaryAssociatedTypes, node);
            if !comma {
                break;
            }
        }
        self.angle(false, &mut clause);
        self.finish(K::PrimaryAssociatedTypeClause, start, clause)
    }

    fn attribute_config(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut c = self.children();
        while !self.eof() && matches!(self.text(), "#if" | "#elseif" | "#else") {
            let start = self.start();
            let mut clause = self.children();
            let condition = !self.at("#else");
            self.take(&mut clause, F::PoundKeyword);
            if condition {
                let node = self.directive_condition();
                Self::add(&mut clause, F::Condition, node);
            }
            while self.at("@") || self.at("#if") {
                let attr = if self.at("@") {
                    self.attribute()
                } else {
                    self.attribute_config()
                };
                Self::add(&mut clause, F::Elements, attr);
            }
            let node = self.finish(K::IfConfigClause, start, clause);
            Self::add(&mut c, F::Clauses, node);
        }
        self.expect("#endif", &mut c, F::PoundEndif);
        self.depth -= 1;
        self.finish(K::IfConfigDecl, start, c)
    }

    fn if_config(&mut self, member: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut c = self.children();
        while !self.exhausted && (self.at("#if") || self.at("#elseif") || self.at("#else")) {
            let start = self.start();
            let mut clause = self.children();
            let has_condition = !self.at("#else");
            self.take(&mut clause, F::PoundKeyword);
            if has_condition {
                let condition = self.directive_condition();
                Self::add(&mut clause, F::Condition, condition);
            }
            self.items(&mut clause, F::Elements, member, false);
            let node = self.finish(K::IfConfigClause, start, clause);
            Self::add(&mut c, F::Clauses, node);
        }
        self.expect("#endif", &mut c, F::PoundEndif);
        self.depth -= 1;
        self.finish(K::IfConfigDecl, start, c)
    }

    pub(super) fn initializer(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::Equal);
        let value = self.expression(true);
        Self::add(&mut c, F::Value, value);
        self.finish(K::InitializerClause, start, c)
    }

    pub(super) fn pattern(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingPattern);
        }
        let node = self.pattern_inner();
        self.depth -= 1;
        node
    }

    fn pattern_inner(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        let kind = if self.binding_pattern() {
            self.kw(&mut c, F::BindingSpecifier);
            let pattern = self.pattern();
            Self::add(&mut c, F::Pattern, pattern);
            K::ValueBindingPattern
        } else if self.at("_") {
            self.take(&mut c, F::Wildcard);
            K::WildcardPattern
        } else if self.at("(") {
            self.take(&mut c, F::LeftParen);
            while !self.eof() && !self.at(")") {
                let before = self.pos;
                let start = self.start();
                let mut el = self.children();
                if self.nth(1) == ":" {
                    self.take(&mut el, F::Label);
                    self.take(&mut el, F::Colon);
                }
                let p = self.pattern();
                Self::add(&mut el, F::Pattern, p);
                let comma = self.eat(",", &mut el, F::TrailingComma);
                let node = self.finish(K::TuplePatternElement, start, el);
                Self::add(&mut c, F::Elements, node);
                if !comma || before == self.pos {
                    break;
                }
            }
            self.expect(")", &mut c, F::RightParen);
            K::TuplePattern
        } else if self.at_kind(K::Identifier) {
            self.take(&mut c, F::Identifier);
            K::IdentifierPattern
        } else {
            self.recycle(c);
            return self.missing(K::MissingPattern);
        };
        self.finish(kind, start, c)
    }

    pub(super) fn matching_pattern(&mut self) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingPattern);
        }
        let node = self.matching_pattern_inner();
        self.depth -= 1;
        node
    }

    fn matching_pattern_inner(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        if self.binding_pattern() {
            self.kw(&mut c, F::BindingSpecifier);
            let previous = self.binding_context;
            self.binding_context = true;
            let node = self.matching_pattern();
            self.binding_context = previous;
            Self::add(&mut c, F::Pattern, node);
            return self.finish(K::ValueBindingPattern, start, c);
        }
        let expression_start = matches!(self.text(), "try" | "await" | "true" | "false" | "nil")
            || (matches!(self.text(), "consume" | "borrow" | "copy" | "unsafe")
                && self.contextual_prefix(self.at("unsafe"), false));
        if self.binding_context
            && !expression_start
            && self.binding_identifier()
            && !matches!(self.nth(1), "." | "(" | "as" | "is" | "<")
            && !self.nth(1).starts_with(['?', '!'])
            && !self.at("_")
        {
            self.recycle(c);
            return self.pattern();
        }
        if self.at("is") {
            self.kw(&mut c, F::IsKeyword);
            let ty = self.type_node();
            Self::add(&mut c, F::Type, ty);
            return self.finish(K::IsTypePattern, start, c);
        }
        let previous = self.pattern_context;
        self.pattern_context = true;
        let expr = self.expression(false);
        self.pattern_context = previous;
        Self::add(&mut c, F::Expression, expr);
        self.make(K::ExpressionPattern, expr.span, c)
    }

    pub(super) fn binding_pattern(&self) -> bool {
        matches!(self.text(), "let" | "var" | "inout")
            || (matches!(self.text(), "borrowing" | "_borrowing")
                && self.label(1)
                && !Self::lexical_keyword(self.nth(1))
                && self.tokens.get(self.pos + 1).is_some_and(|t| !t.newline))
    }

    pub(super) fn binding_identifier(&self) -> bool {
        self.at_kind(K::Identifier)
            && (!Self::lexical_keyword(self.text())
                || matches!(self.text(), "self" | "init" | "deinit" | "subscript"))
    }

    fn inheritance(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::Colon);
        loop {
            let before = self.pos;
            let start = self.start();
            let mut ty = self.children();
            let node = self.type_node();
            Self::add(&mut ty, F::Type, node);
            let comma = self.eat(",", &mut ty, F::TrailingComma);
            let node = self.finish(K::InheritedType, start, ty);
            Self::add(&mut c, F::InheritedTypes, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.finish(K::InheritanceClause, start, c)
    }

    fn parameters(&mut self, enum_case: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.expect("(", &mut c, F::LeftParen);
        while !self.eof() && !self.at(")") && !self.at("{") {
            let before = self.pos;
            let start = self.start();
            let mut p = self.children();
            while !enum_case && self.at("@") {
                let node = self.attribute();
                Self::add(&mut p, F::Attributes, node);
            }
            self.parameter_modifiers(&mut p, false);
            if !enum_case || self.labels_before_colon() {
                let name = self.bump_as(self.token().kind);
                Self::add(&mut p, F::FirstName, name);
                if !self.at(":") {
                    let name = self.bump_as(self.token().kind);
                    Self::add(&mut p, F::SecondName, name);
                }
                self.expect(":", &mut p, F::Colon);
            }
            let ty = self.type_node();
            Self::add(&mut p, F::Type, ty);
            if self.at("...") {
                let node = self.bump_as(K::Ellipsis);
                Self::add(&mut p, F::Ellipsis, node);
            }
            if self.at("=") {
                let init = self.initializer();
                Self::add(&mut p, F::DefaultValue, init);
            }
            let comma = self.eat(",", &mut p, F::TrailingComma);
            let node = self.finish(
                if enum_case {
                    K::EnumCaseParameter
                } else {
                    K::FunctionParameter
                },
                start,
                p,
            );
            Self::add(&mut c, F::Parameters, node);
            if !comma || before == self.pos {
                break;
            }
        }
        self.expect(")", &mut c, F::RightParen);
        self.finish(
            if enum_case {
                K::EnumCaseParameterClause
            } else {
                K::FunctionParameterClause
            },
            start,
            c,
        )
    }

    pub(super) fn parameter_modifiers(&mut self, c: &mut Children<S::Node>, closure: bool) {
        while super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
            .parameter_modifier(closure)
        {
            let start = self.start();
            let mut modifier = self.children();
            self.kw(&mut modifier, F::Name);
            let modifier = self.finish(K::DeclModifier, start, modifier);
            Self::add(c, F::Modifiers, modifier);
        }
    }

    pub(super) fn attribute(&mut self) -> Node<S::Node> {
        self.attribute_with_context(false)
    }

    pub(super) fn type_attribute(&mut self) -> Node<S::Node> {
        self.attribute_with_context(true)
    }

    fn attribute_with_context(&mut self, type_context: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::AtSign);
        let accepts_arguments =
            super::lookahead::attribute_accepts_arguments(self.text(), type_context);
        let custom_arguments =
            super::lookahead::custom_attribute_arguments(self.text(), type_context);
        let availability = self.at("available") || self.at("_spi_available");
        let objc = self.at("objc");
        let documentation = self.at("_documentation");
        let specialize = self.at("_specialize");
        let effects = self.at("_effects");
        let macro_role = self.at("attached") || self.at("freestanding");
        let structured = match self.text() {
            "_implements" => Some(K::ImplementsAttributeArguments),
            "_dynamicReplacement" => Some(K::DynamicReplacementAttributeArguments),
            "_backDeploy" | "backDeployed" => Some(K::BackDeployedAttributeArguments),
            "_originallyDefinedIn" => Some(K::OriginallyDefinedInAttributeArguments),
            "specialized" => Some(K::SpecializedAttributeArgument),
            "abi" => Some(K::AbiAttributeArguments),
            "differentiable" => Some(K::DifferentiableAttributeArguments),
            "derivative" | "transpose" => Some(K::DerivativeAttributeArguments),
            _ => None,
        };
        let ty = self.attribute_name();
        Self::add(&mut c, F::AttributeName, ty);
        if accepts_arguments
            && self.at("(")
            && !self.newline()
            && super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                .attribute_arguments(custom_arguments)
        {
            self.take(&mut c, F::LeftParen);
            if effects {
                while !self.eof() && !self.at(")") {
                    let token = self.raw_token();
                    Self::add(&mut c, F::Arguments, token);
                }
            } else if let Some(kind) = structured {
                let node = self.structured_attribute_arguments(kind);
                Self::add(&mut c, F::Arguments, node);
            } else if documentation {
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let mut arg = self.children();
                    self.kw(&mut arg, F::Label);
                    self.expect(":", &mut arg, F::Colon);
                    if matches!(
                        self.token().kind,
                        K::StringQuote | K::MultilineStringQuote | K::RawStringPoundDelimiter
                    ) {
                        let value = self.string_literal_as(K::StringLiteralExpr);
                        Self::add(&mut arg, F::Value, value);
                    } else {
                        self.kw(&mut arg, F::Value);
                    }
                    let comma = self.eat(",", &mut arg, F::TrailingComma);
                    let node = self.finish(K::DocumentationAttributeArgument, start, arg);
                    Self::add(&mut c, F::Arguments, node);
                    if !comma {
                        break;
                    }
                }
            } else if specialize {
                self.specialize_attribute_arguments(&mut c);
            } else if objc {
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let mut piece = self.children();
                    if !self.text().starts_with(':') {
                        self.take(&mut piece, F::Name);
                    }
                    if self.text().starts_with(':') {
                        let colon = self.token_prefix(1, K::Colon);
                        Self::add(&mut piece, F::Colon, colon);
                    }
                    let node = self.finish(K::ObjCSelectorPiece, start, piece);
                    Self::add(&mut c, F::Arguments, node);
                }
            } else if availability {
                self.availability_arguments(&mut c, F::Arguments);
            } else {
                if macro_role && !self.at(")") {
                    let argument = self.macro_role_argument();
                    Self::add(&mut c, F::Arguments, argument);
                }
                let previous = self.attribute_arguments;
                self.attribute_arguments = macro_role;
                self.arguments(&mut c, F::Arguments, ")");
                self.attribute_arguments = previous;
            }
            self.expect(")", &mut c, F::RightParen);
        }
        self.depth -= 1;
        self.finish(K::Attribute, start, c)
    }

    fn macro_role_argument(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut reference = self.children();
        let name = self.bump_as(K::Identifier);
        Self::add(&mut reference, F::BaseName, name);
        let reference = self.finish(K::DeclReferenceExpr, start, reference);
        let mut argument = self.children();
        Self::add(&mut argument, F::Expression, reference);
        self.eat(",", &mut argument, F::TrailingComma);
        self.finish(K::LabeledExpr, start, argument)
    }

    fn specialize_attribute_arguments(&mut self, c: &mut Children<S::Node>) {
        while !self.eof() && !self.at(")") {
            if self.at("where") {
                let node = self.where_clause();
                Self::add(c, F::Arguments, node);
                break;
            }
            let start = self.start();
            let mut arg = self.children();
            let availability = self.at("availability");
            let target = self.at("target");
            self.kw(
                &mut arg,
                if availability {
                    F::AvailabilityLabel
                } else if target {
                    F::TargetLabel
                } else {
                    F::Label
                },
            );
            self.expect(":", &mut arg, F::Colon);
            if availability {
                self.availability_arguments(&mut arg, F::AvailabilityArguments);
                self.expect(";", &mut arg, F::Semicolon);
            } else if target {
                let name = self.declaration_reference(true);
                Self::add(&mut arg, F::DeclName, name);
            } else if self.at("true") || self.at("false") {
                self.kw(&mut arg, F::Value);
            } else {
                self.take(&mut arg, F::Value);
            }
            let comma = !availability && self.eat(",", &mut arg, F::TrailingComma);
            let kind = if availability {
                K::SpecializeAvailabilityArgument
            } else if target {
                K::SpecializeTargetFunctionArgument
            } else {
                K::LabeledSpecializeArgument
            };
            let node = self.finish(kind, start, arg);
            Self::add(c, F::Arguments, node);
            if !availability && !comma {
                break;
            }
        }
    }

    fn structured_attribute_arguments(&mut self, kind: K) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        match kind {
            K::DifferentiableAttributeArguments | K::DerivativeAttributeArguments => {
                self.recycle(c);
                return self.differentiable_arguments(kind);
            }
            K::AbiAttributeArguments => {
                let decl = self.item(false);
                Self::add(&mut c, F::Provider, decl);
            }
            K::ImplementsAttributeArguments => {
                let ty = self.type_node();
                Self::add(&mut c, F::Type, ty);
                self.expect(",", &mut c, F::Comma);
                let name = self.declaration_reference(true);
                Self::add(&mut c, F::DeclName, name);
            }
            K::DynamicReplacementAttributeArguments => {
                self.kw(&mut c, F::ForLabel);
                self.expect(":", &mut c, F::Colon);
                let name = self.declaration_reference(true);
                Self::add(&mut c, F::DeclName, name);
            }
            K::SpecializedAttributeArgument => {
                let requirements = self.where_clause();
                Self::add(&mut c, F::GenericWhereClause, requirements);
            }
            _ => {
                if kind == K::OriginallyDefinedInAttributeArguments {
                    self.kw(&mut c, F::ModuleLabel);
                    self.expect(":", &mut c, F::Colon);
                    let name = self.string_literal_as(K::StringLiteralExpr);
                    Self::add(&mut c, F::ModuleName, name);
                    self.expect(",", &mut c, F::Comma);
                } else {
                    self.kw(&mut c, F::BeforeLabel);
                    self.expect(":", &mut c, F::Colon);
                }
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let platform = self.platform_version();
                    let mut item = self.children();
                    Self::add(&mut item, F::PlatformVersion, platform);
                    let comma = self.eat(",", &mut item, F::TrailingComma);
                    let item = self.finish(K::PlatformVersionItem, start, item);
                    Self::add(&mut c, F::Platforms, item);
                    if !comma {
                        break;
                    }
                }
            }
        }
        self.finish(kind, start, c)
    }

    fn differentiable_arguments(&mut self, kind: K) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        if kind == K::DerivativeAttributeArguments {
            self.kw(&mut c, F::OfLabel);
            self.expect(":", &mut c, F::Colon);
            let name = self.qualified_reference();
            Self::add(&mut c, F::OriginalDeclName, name);
            if self.eat(".", &mut c, F::Period) {
                self.kw(&mut c, F::AccessorSpecifier);
            }
            self.eat(",", &mut c, F::Comma);
        } else if matches!(self.text(), "reverse" | "_forward" | "_linear") {
            self.kw(&mut c, F::KindSpecifier);
            self.eat(",", &mut c, F::KindSpecifierComma);
        }
        if self.at("wrt") {
            let wrt_start = self.start();
            let mut wrt = self.children();
            self.kw(&mut wrt, F::WrtLabel);
            self.expect(":", &mut wrt, F::Colon);
            let start = self.start();
            let mut arguments = self.children();
            let multiple = self.eat("(", &mut arguments, F::LeftParen);
            while !self.eof() && !self.at(")") {
                let start = self.start();
                let mut argument = self.children();
                self.take(&mut argument, F::Argument);
                let comma = self.eat(",", &mut argument, F::TrailingComma);
                let argument = self.finish(K::DifferentiabilityArgument, start, argument);
                Self::add(&mut arguments, F::Arguments, argument);
                if !multiple || !comma {
                    break;
                }
            }
            if multiple {
                self.expect(")", &mut arguments, F::RightParen);
                let arguments = self.finish(K::DifferentiabilityArguments, start, arguments);
                Self::add(&mut wrt, F::Arguments, arguments);
            } else {
                wrt.append(&mut arguments);
                self.recycle(arguments);
            }
            let argument = self.finish(K::DifferentiabilityWithRespectToArgument, wrt_start, wrt);
            Self::add(&mut c, F::Arguments, argument);
            if kind == K::DifferentiableAttributeArguments {
                self.eat(",", &mut c, F::ArgumentsComma);
            }
        }
        if self.at("where") {
            let requirements = self.where_clause();
            Self::add(&mut c, F::GenericWhereClause, requirements);
        }
        self.finish(kind, start, c)
    }

    pub(super) fn availability_arguments(&mut self, c: &mut Children<S::Node>, field: F) {
        self.availability_list(c, field, true);
    }

    pub(super) fn availability_specifications(&mut self, c: &mut Children<S::Node>, field: F) {
        self.availability_list(c, field, false);
    }

    fn availability_list(&mut self, c: &mut Children<S::Node>, field: F, attribute: bool) {
        while !self.eof() && !self.at(")") {
            let before = self.pos;
            let start = self.start();
            let mut arg = self.children();
            let argument = if self.nth(1) == ":" {
                let mut labeled = self.children();
                self.kw(&mut labeled, F::Label);
                self.take(&mut labeled, F::Colon);
                let value = if matches!(
                    self.token().kind,
                    K::StringQuote | K::MultilineStringQuote | K::RawStringPoundDelimiter
                ) {
                    self.string_literal_as(K::SimpleStringLiteralExpr)
                } else {
                    self.version()
                };
                Self::add(&mut labeled, F::Value, value);
                self.finish(K::AvailabilityLabeledArgument, start, labeled)
            } else if self.at_kind(K::Identifier)
                && (!attribute
                    || (self.nth(1) != ","
                        && !matches!(self.text(), "deprecated" | "unavailable" | "noasync")))
            {
                self.platform_version()
            } else if self.at_kind(K::Identifier)
                && !matches!(self.text(), "deprecated" | "unavailable" | "noasync")
            {
                self.bump_as(K::Identifier)
            } else {
                self.word()
            };
            Self::add(&mut arg, F::Argument, argument);
            let comma = self.eat(",", &mut arg, F::TrailingComma);
            let node = self.finish(K::AvailabilityArgument, start, arg);
            Self::add(c, field, node);
            if !comma || before == self.pos {
                break;
            }
        }
    }

    fn platform_version(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        let platform = self.bump_as(K::Identifier);
        Self::add(&mut c, F::Platform, platform);
        if matches!(self.token().kind, K::IntegerLiteral | K::FloatLiteral) {
            let version = self.version();
            Self::add(&mut c, F::Version, version);
        }
        self.finish(K::PlatformVersion, start, c)
    }

    fn version(&mut self) -> Node<S::Node> {
        let start = self.start();
        if !matches!(self.token().kind, K::IntegerLiteral | K::FloatLiteral) {
            return self.missing(K::VersionTuple);
        }
        let mut c = self.children();
        self.pos += 1;
        while self.at(".")
            && self
                .tokens
                .get(self.pos + 1)
                .is_some_and(|t| matches!(t.kind, K::IntegerLiteral | K::FloatLiteral))
        {
            self.pos += 2;
        }
        self.last_end = self.tokens[self.pos - 1].span.end;
        let end = self.end();
        let mut offset = start;
        let mut first = true;
        while offset < end {
            let component_start = offset;
            let mut component = self.children();
            if !first {
                let period = self.make(
                    K::Period,
                    Span {
                        start: offset,
                        end: offset + 1,
                    },
                    Vec::new(),
                );
                Self::add(&mut component, F::Period, period);
                offset += 1;
            }
            let number_start = offset;
            while offset < end && self.source.as_bytes()[offset].is_ascii_digit() {
                offset += 1;
            }
            if offset == number_start {
                self.recycle(component);
                break;
            }
            let number = self.make(
                K::IntegerLiteral,
                Span {
                    start: number_start,
                    end: offset,
                },
                Vec::new(),
            );
            if first {
                self.recycle(component);
                Self::add(&mut c, F::Major, number);
                first = false;
            } else {
                Self::add(&mut component, F::Number, number);
                let node = self.make(
                    K::VersionComponent,
                    Span {
                        start: component_start,
                        end: offset,
                    },
                    component,
                );
                Self::add(&mut c, F::Components, node);
            }
        }
        self.finish(K::VersionTuple, start, c)
    }

    fn accessors(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = self.children();
        self.take(&mut c, F::LeftBrace);
        if super::lookahead::Lookahead::new(self.source, self.tokens, self.pos)
            .accessor_declaration()
        {
            while !self.eof()
                && (self.at("@")
                    || super::lookahead::accessor_keyword(self.text())
                    || super::lookahead::accessor_modifier(self.text()))
            {
                let start = self.start();
                let mut a = self.children();
                while self.at("@") {
                    let node = self.attribute();
                    Self::add(&mut a, F::Attributes, node);
                }
                while super::lookahead::accessor_modifier(self.text()) {
                    let start = self.start();
                    let mut m = self.children();
                    self.kw(&mut m, F::Name);
                    let node = self.finish(K::DeclModifier, start, m);
                    Self::add(&mut a, F::Modifiers, node);
                }
                if !super::lookahead::accessor_keyword(self.text()) {
                    self.recycle(a);
                    let node = self.recover();
                    Self::add(&mut c, F::Accessors, node);
                    break;
                }
                self.kw(&mut a, F::AccessorSpecifier);
                if self.at("(") {
                    let start = self.start();
                    let mut p = self.children();
                    self.take(&mut p, F::LeftParen);
                    self.take(&mut p, F::Name);
                    self.expect(")", &mut p, F::RightParen);
                    let node = self.finish(K::AccessorParameters, start, p);
                    Self::add(&mut a, F::Parameters, node);
                }
                if let Some(effects) = self.effects(K::AccessorEffectSpecifiers) {
                    Self::add(&mut a, F::EffectSpecifiers, effects);
                }
                if self.at("{") {
                    let node = self.block(false);
                    Self::add(&mut a, F::Body, node);
                }
                let node = self.finish(K::AccessorDecl, start, a);
                Self::add(&mut c, F::Accessors, node);
            }
        } else {
            self.items(&mut c, F::Accessors, false, false);
        }
        self.expect("}", &mut c, F::RightBrace);
        self.finish(K::AccessorBlock, start, c)
    }
}
