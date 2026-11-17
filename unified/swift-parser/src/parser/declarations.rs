use super::{Children, F, K, Node, Span, State, SyntaxSink};

impl<S: SyntaxSink> State<'_, S> {
    #[allow(clippy::too_many_lines)]
    pub(super) fn item(&mut self, member: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        while self.at("@") {
            let attr = self.attribute();
            Self::add(&mut c, F::Attributes, attr);
        }
        while self.is_modifier() {
            let start = self.start();
            let mut modifier = Vec::new();
            self.kw(&mut modifier, F::Name);
            if self.at("(") {
                let start = self.start();
                let mut detail = Vec::new();
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
            "#if" => return self.if_config(member),
            "import" => {
                self.kw(&mut c, F::ImportKeyword);
                if matches!(
                    self.text(),
                    "typealias" | "struct" | "class" | "enum" | "protocol" | "let" | "var" | "func"
                ) {
                    self.kw(&mut c, F::ImportKindSpecifier);
                }
                loop {
                    let start = self.start();
                    let mut path = Vec::new();
                    self.take(&mut path, F::Name);
                    let more = self.eat(".", &mut path, F::TrailingPeriod);
                    let node = self.finish(K::ImportPathComponent, start, path);
                    Self::add(&mut c, F::Path, node);
                    if !more {
                        break;
                    }
                }
                K::ImportDecl
            }
            "let" | "var" => {
                self.kw(&mut c, F::BindingSpecifier);
                loop {
                    let before = self.pos;
                    let start = self.start();
                    let mut binding = Vec::new();
                    let pattern = self.pattern();
                    Self::add(&mut binding, F::Pattern, pattern);
                    if self.at(":") {
                        let ty = self.annotation();
                        Self::add(&mut binding, F::TypeAnnotation, ty);
                    }
                    if self.at("=") {
                        let init = self.initializer();
                        Self::add(&mut binding, F::Initializer, init);
                    }
                    if self.at("{") {
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
            "func" | "init" | "deinit" | "subscript" => {
                let text = self.text();
                let (kind, field) = match text {
                    "init" => (K::InitializerDecl, F::InitKeyword),
                    "deinit" => (K::DeinitializerDecl, F::DeinitKeyword),
                    "subscript" => (K::SubscriptDecl, F::SubscriptKeyword),
                    _ => (K::FunctionDecl, F::FuncKeyword),
                };
                self.kw(&mut c, field);
                if kind == K::FunctionDecl {
                    self.take(&mut c, F::Name);
                }
                if kind == K::InitializerDecl && (self.at("?") || self.at("!")) {
                    self.take(&mut c, F::OptionalMark);
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
                        let mut sig = Vec::new();
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
            "struct" | "class" | "enum" | "protocol" | "actor" | "extension" => {
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
                    let node = self.generic_parameters();
                    Self::add(&mut c, F::GenericParameterClause, node);
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
                    let mut init = Vec::new();
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
                    let mut el = Vec::new();
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
                    let mut precedence = Vec::new();
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
                    let mut attr = Vec::new();
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
                                let mut name = Vec::new();
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
            _ => return self.statement(),
        };
        self.finish(kind, start, c)
    }

    fn is_modifier(&self) -> bool {
        matches!(
            self.text(),
            "public"
                | "private"
                | "fileprivate"
                | "internal"
                | "open"
                | "static"
                | "final"
                | "override"
                | "mutating"
                | "nonmutating"
                | "lazy"
                | "weak"
                | "unowned"
                | "required"
                | "convenience"
                | "indirect"
                | "dynamic"
                | "optional"
                | "nonisolated"
                | "isolated"
                | "distributed"
                | "borrowing"
                | "consuming"
                | "package"
        ) || (self.at("class") && matches!(self.nth(1), "func" | "var" | "subscript"))
    }

    fn if_config(&mut self, member: bool) -> Node<S::Node> {
        if !self.enter() {
            return self.missing(K::MissingDecl);
        }
        let start = self.start();
        let mut c = Vec::new();
        while !self.exhausted && (self.at("#if") || self.at("#elseif") || self.at("#else")) {
            let start = self.start();
            let mut clause = Vec::new();
            let has_condition = !self.at("#else");
            self.take(&mut clause, F::PoundKeyword);
            if has_condition {
                let condition = self.expression(false);
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
        let mut c = Vec::new();
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
        let mut c = Vec::new();
        let kind = if self.at("let") || self.at("var") {
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
                let mut el = Vec::new();
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
        let mut c = Vec::new();
        if self.at("let") || self.at("var") {
            self.kw(&mut c, F::BindingSpecifier);
            let previous = self.binding_context;
            self.binding_context = true;
            let node = self.matching_pattern();
            self.binding_context = previous;
            Self::add(&mut c, F::Pattern, node);
            return self.finish(K::ValueBindingPattern, start, c);
        }
        if self.binding_context
            && ((self.label(0) && !matches!(self.nth(1), "." | "(" | "as" | "is" | "<"))
                || self.at("(")
                || self.at("_"))
        {
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

    fn inheritance(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::Colon);
        loop {
            let before = self.pos;
            let start = self.start();
            let mut ty = Vec::new();
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
        let mut c = Vec::new();
        self.expect("(", &mut c, F::LeftParen);
        while !self.eof() && !self.at(")") && !self.at("{") {
            let before = self.pos;
            let start = self.start();
            let mut p = Vec::new();
            while self.at("@") {
                let node = self.attribute();
                Self::add(&mut p, F::Attributes, node);
            }
            if !enum_case || self.labels_before_colon() {
                self.take(&mut p, F::FirstName);
                if !self.at(":") {
                    self.take(&mut p, F::SecondName);
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

    pub(super) fn attribute(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.take(&mut c, F::AtSign);
        let accepts_arguments = !matches!(
            self.text(),
            "escaping" | "autoclosure" | "Sendable" | "noescape"
        );
        let availability = self.at("available") || self.at("_spi_available");
        let objc = self.at("objc");
        let ty = self.type_node();
        Self::add(&mut c, F::AttributeName, ty);
        if accepts_arguments && self.at("(") && !self.newline() {
            self.take(&mut c, F::LeftParen);
            if objc {
                while !self.eof() && !self.at(")") {
                    let start = self.start();
                    let mut piece = Vec::new();
                    if !self.at(":") {
                        self.take(&mut piece, F::Name);
                    }
                    self.eat(":", &mut piece, F::Colon);
                    let node = self.finish(K::ObjCSelectorPiece, start, piece);
                    Self::add(&mut c, F::Arguments, node);
                }
            } else if availability {
                self.availability_arguments(&mut c, F::Arguments);
            } else {
                self.arguments(&mut c, F::Arguments, ")");
            }
            self.expect(")", &mut c, F::RightParen);
        }
        self.finish(K::Attribute, start, c)
    }

    pub(super) fn availability_arguments(&mut self, c: &mut Children<S::Node>, field: F) {
        while !self.eof() && !self.at(")") {
            let before = self.pos;
            let start = self.start();
            let mut arg = Vec::new();
            let argument = if self.nth(1) == ":" {
                let mut labeled = Vec::new();
                self.kw(&mut labeled, F::Label);
                self.take(&mut labeled, F::Colon);
                let value = if self.at_kind(K::StringQuote) {
                    self.string_literal_as(K::SimpleStringLiteralExpr)
                } else {
                    self.version()
                };
                Self::add(&mut labeled, F::Value, value);
                self.finish(K::AvailabilityLabeledArgument, start, labeled)
            } else if self
                .tokens
                .get(self.pos + 1)
                .is_some_and(|t| matches!(t.kind, K::IntegerLiteral | K::FloatLiteral))
            {
                let mut platform = Vec::new();
                self.take(&mut platform, F::Platform);
                let version = self.version();
                Self::add(&mut platform, F::Version, version);
                self.finish(K::PlatformVersion, start, platform)
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

    fn version(&mut self) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        if !matches!(self.token().kind, K::IntegerLiteral | K::FloatLiteral) {
            return self.missing(K::VersionTuple);
        }
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
            let mut component = Vec::new();
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
        let mut c = Vec::new();
        self.take(&mut c, F::LeftBrace);
        if self.at("@")
            || matches!(
                self.text(),
                "get"
                    | "set"
                    | "willSet"
                    | "didSet"
                    | "_read"
                    | "_modify"
                    | "mutating"
                    | "nonmutating"
            )
        {
            while !self.eof()
                && (self.at("@")
                    || matches!(
                        self.text(),
                        "get"
                            | "set"
                            | "willSet"
                            | "didSet"
                            | "_read"
                            | "_modify"
                            | "mutating"
                            | "nonmutating"
                    ))
            {
                let start = self.start();
                let mut a = Vec::new();
                while self.at("@") {
                    let node = self.attribute();
                    Self::add(&mut a, F::Attributes, node);
                }
                while self.at("mutating") || self.at("nonmutating") {
                    let start = self.start();
                    let mut m = Vec::new();
                    self.kw(&mut m, F::Name);
                    let node = self.finish(K::DeclModifier, start, m);
                    Self::add(&mut a, F::Modifiers, node);
                }
                if !matches!(
                    self.text(),
                    "get" | "set" | "willSet" | "didSet" | "_read" | "_modify"
                ) {
                    let node = self.recover();
                    Self::add(&mut c, F::Accessors, node);
                    break;
                }
                self.kw(&mut a, F::AccessorSpecifier);
                if self.at("(") {
                    let start = self.start();
                    let mut p = Vec::new();
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
