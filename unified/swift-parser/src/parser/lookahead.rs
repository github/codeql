//! Non-emitting, type-shaped lookahead. Each recursion consumes a delimiter;
//! the depth bound also prevents adversarial comparison chains from rescanning
//! an unbounded suffix for every possible generic specialization.
use super::{K, Token};

pub(super) fn accessor_keyword(text: &str) -> bool {
    matches!(
        text,
        "get"
            | "set"
            | "willSet"
            | "didSet"
            | "_read"
            | "_modify"
            | "borrow"
            | "mutate"
            | "init"
            | "unsafeAddress"
            | "addressWithOwner"
            | "addressWithNativeOwner"
            | "unsafeMutableAddress"
            | "mutableAddressWithOwner"
            | "mutableAddressWithNativeOwner"
    )
}

pub(super) fn accessor_modifier(text: &str) -> bool {
    matches!(
        text,
        "mutating" | "nonmutating" | "__consuming" | "consuming" | "borrowing" | "yielding"
    )
}

pub(super) fn simple_type_specifier(text: &str) -> bool {
    matches!(
        text,
        "inout"
            | "borrowing"
            | "consuming"
            | "isolated"
            | "sending"
            | "__owned"
            | "__shared"
            | "_const"
    )
}

pub(super) fn declaration_modifier(text: &str) -> bool {
    matches!(
        text,
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
            | "__consuming"
            | "__owned"
            | "__shared"
            | "_const"
            | "_local"
    )
}

pub(super) fn attribute_accepts_arguments(text: &str, type_context: bool) -> bool {
    !(matches!(
        text,
        "escaping" | "autoclosure" | "Sendable" | "noescape" | "concurrent"
    ) || type_context
        && matches!(
            text,
            "_local"
                | "_noMetadata"
                | "async"
                | "noDerivative"
                | "preconcurrency"
                | "retroactive"
                | "unchecked"
        ))
}

pub(super) fn custom_attribute_arguments(text: &str, type_context: bool) -> bool {
    if type_context {
        !matches!(text, "differentiable" | "isolated")
    } else {
        !matches!(
            text,
            "_backDeploy"
                | "_documentation"
                | "_dynamicReplacement"
                | "_effects"
                | "_implements"
                | "_originallyDefinedIn"
                | "specialized"
                | "_specialize"
                | "_spi_available"
                | "abi"
                | "available"
                | "backDeployed"
                | "derivative"
                | "differentiable"
                | "objc"
                | "transpose"
        )
    }
}

pub(super) struct Lookahead<'a> {
    source: &'a str,
    tokens: &'a [Token],
    pos: usize,
    offset: usize,
    depth: usize,
}

impl<'a> Lookahead<'a> {
    pub fn new(source: &'a str, tokens: &'a [Token], pos: usize) -> Self {
        Self {
            source,
            tokens,
            pos,
            offset: 0,
            depth: 0,
        }
    }
    pub fn can_have_parameter_specifier(&self) -> bool {
        let Some(next) = self.tokens.get(self.pos + 1) else {
            return false;
        };
        let text = &self.source[next.span.start..next.span.end];
        match next.kind {
            K::AtSign | K::LeftParen | K::LeftSquare | K::Wildcard => true,
            K::Identifier => {
                !super::lexical_keyword(text)
                    || matches!(text, "inout" | "Any" | "Self" | "var" | "let")
            }
            K::PrefixOperator => text == "~",
            _ => false,
        }
    }
    pub fn parameter_modifier(&self, closure: bool) -> bool {
        if !matches!(self.text(), "_const" | "isolated") {
            return false;
        }
        let Some(next) = self.tokens.get(self.pos + 1) else {
            return false;
        };
        match next.kind {
            K::Colon => false,
            K::Identifier | K::Wildcard | K::DollarIdentifier => self
                .tokens
                .get(self.pos + 2)
                .is_none_or(|t| t.kind != K::Colon),
            K::InfixQuestionMark | K::ExclamationMark => true,
            _ => !closure,
        }
    }

    fn text(&self) -> &'a str {
        self.tokens
            .get(self.pos)
            .map_or("", |t| &self.source[t.span.start + self.offset..t.span.end])
    }
    fn bump(&mut self) {
        self.pos += 1;
        self.offset = 0;
    }
    fn eat(&mut self, text: &str) -> bool {
        if self.text() == text {
            self.bump();
            true
        } else {
            false
        }
    }
    fn prefix(&mut self, c: char) -> bool {
        if !self.text().starts_with(c) {
            return false;
        }
        self.offset += 1;
        if self.text().is_empty() {
            self.bump();
        }
        true
    }
    fn name(&mut self) -> bool {
        if self
            .tokens
            .get(self.pos + 1)
            .is_some_and(|t| t.kind == K::ColonColon)
        {
            self.bump();
            self.bump();
        }
        if self
            .tokens
            .get(self.pos)
            .is_some_and(|t| matches!(t.kind, K::Identifier | K::Wildcard))
            && !matches!(
                self.text(),
                "for"
                    | "while"
                    | "if"
                    | "else"
                    | "switch"
                    | "return"
                    | "throw"
                    | "let"
                    | "var"
                    | "guard"
                    | "init"
                    | "deinit"
                    | "subscript"
                    | "defer"
                    | "do"
                    | "case"
                    | "default"
                    | "in"
                    | "func"
                    | "class"
                    | "struct"
                    | "enum"
                    | "import"
                    | "as"
                    | "is"
            )
        {
            self.bump();
            true
        } else {
            false
        }
    }
    fn balanced(&mut self, open: &str, close: &str) -> bool {
        let opening = match open {
            "(" => K::LeftParen,
            "[" => K::LeftSquare,
            _ => K::LeftBrace,
        };
        let closing = match close {
            ")" => K::RightParen,
            "]" => K::RightSquare,
            _ => K::RightBrace,
        };
        if self.depth >= 128 || self.kind() != opening {
            return false;
        }
        self.bump();
        self.depth += 1;
        while self.kind() != K::EndOfFile && self.kind() != closing {
            let success = match self.kind() {
                K::LeftParen => self.balanced("(", ")"),
                K::LeftSquare => self.balanced("[", "]"),
                K::LeftBrace => self.balanced("{", "}"),
                K::RightParen | K::RightSquare | K::RightBrace => false,
                _ => {
                    self.bump();
                    true
                }
            };
            if !success {
                self.depth -= 1;
                return false;
            }
        }
        self.depth -= 1;
        if self.kind() == closing {
            self.bump();
            true
        } else {
            false
        }
    }
    fn kind(&self) -> K {
        self.tokens.get(self.pos).map_or(K::EndOfFile, |t| t.kind)
    }

    pub fn trailing_closure(&mut self, basic: bool) -> bool {
        let start = self.pos;
        if !self.eat("{") || self.text() == "case" {
            return false;
        }
        let newline = self.tokens.get(self.pos).is_some_and(|t| t.newline);
        while self.text() == "@" {
            if self
                .source
                .get(self.tokens[self.pos + 1].span.start..self.tokens[self.pos + 1].span.end)
                == Some("_accessorBlock")
                || !self.attribute(false)
            {
                return false;
            }
        }
        if matches!(self.text(), "didSet" | "willSet" | "init") {
            return false;
        }
        if basic {
            return true;
        }
        if newline {
            return false;
        }
        self.pos = start;
        if !self.balanced("{", "}") {
            return false;
        }
        if matches!(self.text(), "{" | "where" | ",") {
            return true;
        }
        !self.tokens.get(self.pos).is_some_and(|t| t.newline)
            && (matches!(
                self.text(),
                "[" | "(" | "." | "is" | "as" | "?" | "!" | ":" | "="
            ) || matches!(self.kind(), K::BinaryOperator | K::PostfixOperator))
    }
    pub fn generic_arguments(&mut self) -> bool {
        if self.depth >= 128 || !self.prefix('<') {
            return false;
        }
        if self.prefix('>') {
            return true;
        }
        self.depth += 1;
        let valid = self.generic_argument() && {
            let mut valid = true;
            while self.eat(",") {
                if self.text().starts_with('>') {
                    break;
                }
                if !self.generic_argument() {
                    valid = false;
                    break;
                }
            }
            valid && self.prefix('>')
        };
        self.depth -= 1;
        valid
    }
    pub fn specialization(&mut self) -> bool {
        if self.text().starts_with("<>") || !self.generic_arguments() {
            return false;
        }
        if self.offset > 0 && self.text().starts_with(['?', '!']) {
            return true;
        }
        match self.text() {
            ")" | "]" | "." | "," | ":" | "{" | "}" | ";" | "" => true,
            "(" | "[" => !self.tokens.get(self.pos).is_some_and(|t| t.newline),
            "&" => self.kind() == K::BinaryOperator,
            "!" => self.offset > 0 || self.kind() == K::ExclamationMark,
            "?" => {
                self.offset > 0
                    || (self.pos > 0
                        && self.tokens[self.pos - 1].span.end == self.tokens[self.pos].span.start)
            }
            _ => false,
        }
    }

    fn generic_argument(&mut self) -> bool {
        if self.kind() == K::IntegerLiteral {
            self.bump();
            return true;
        }
        if self.text() == "-" {
            self.bump();
            if self.kind() != K::IntegerLiteral {
                return false;
            }
            self.bump();
            return true;
        }
        self.ty()
    }
    pub fn inline_array_start(&mut self) -> bool {
        self.generic_argument()
            && !self.tokens.get(self.pos).is_none_or(|t| t.newline)
            && self.eat("of")
    }
    fn collection_type_body(&mut self) -> bool {
        let value = self.kind() == K::IntegerLiteral || self.text() == "-";
        if !self.generic_argument() {
            return false;
        }
        if self.text() == "of" && self.tokens.get(self.pos).is_some_and(|t| !t.newline) {
            self.bump();
            if !self.generic_argument() {
                return false;
            }
        } else if value || (self.eat(":") && !self.ty()) {
            return false;
        }
        self.eat("]")
    }
    pub fn attribute_arguments(&mut self, custom: bool) -> bool {
        self.balanced("(", ")")
            && (!custom
                || !matches!(
                    self.text(),
                    "->" | "throw"
                        | "throws"
                        | "rethrows"
                        | ")"
                        | "}"
                        | "]"
                        | ">"
                        | "async"
                        | "reasync"
                ))
    }
    fn ty(&mut self) -> bool {
        if self.depth >= 128 {
            return false;
        }
        self.depth += 1;
        let result = self.ty_inner();
        self.depth -= 1;
        result
    }
    fn named_opaque_body(&mut self) -> bool {
        loop {
            self.eat("each");
            self.eat("let");
            if !self.name() || (self.eat(":") && !self.ty()) {
                return false;
            }
            if !self.eat(",") {
                break;
            }
        }
        if self.eat("where") {
            loop {
                if !self.ty() || !(self.eat("==") || self.eat(":")) || !self.ty() {
                    return false;
                }
                if !self.eat(",") {
                    break;
                }
            }
        }
        self.prefix('>') && self.ty()
    }

    fn ty_inner(&mut self) -> bool {
        if self.prefix('<') {
            return self.named_opaque_body();
        }
        loop {
            if self.text() == "@" {
                if !self.attribute(true) {
                    return false;
                }
            } else if self.text() == "nonisolated" && self.can_have_parameter_specifier() {
                self.bump();
                if self.text() == "(" && !self.balanced("(", ")") {
                    return false;
                }
            } else if (simple_type_specifier(self.text()) && self.can_have_parameter_specifier())
                || matches!(self.text(), "some" | "any" | "repeat" | "each")
            {
                self.bump();
            } else {
                break;
            }
        }
        self.eat("~");
        if self.eat("[") {
            if !self.collection_type_body() {
                return false;
            }
        } else if self.eat("(") {
            while self.text() != ")" {
                let saved = (self.pos, self.offset);
                if self.name() {
                    if self.text() != ":" {
                        self.name();
                    }
                    if !self.eat(":") {
                        (self.pos, self.offset) = saved;
                    }
                }
                if !self.ty() {
                    return false;
                }
                self.eat("...");
                if !self.eat(",") {
                    break;
                }
            }
            if !self.eat(")") {
                return false;
            }
        } else {
            if !self.name() {
                return false;
            }
            if self.text().starts_with('<') && !self.generic_arguments() {
                return false;
            }
        }
        loop {
            if self.eat(".") {
                if !self.name() {
                    return false;
                }
                if self.text().starts_with('<') && !self.generic_arguments() {
                    return false;
                }
            } else if self.text().starts_with(['?', '!']) {
                self.prefix(self.text().chars().next().unwrap());
            } else {
                break;
            }
        }
        if self.eat("&") && !self.ty() {
            return false;
        }
        if self.eat("async") || self.text() == "throws" || self.text() == "rethrows" {
            if (self.eat("throws") || self.eat("rethrows"))
                && self.text() == "("
                && !self.balanced("(", ")")
            {
                return false;
            }
            if !self.eat("->") {
                return false;
            }
            return self.ty();
        }
        if self.eat("->") {
            return self.ty();
        }
        true
    }
    pub fn closure_signature(&mut self) -> bool {
        while self.text() == "@" {
            if !self.attribute(false) {
                return false;
            }
        }
        if self.text() == "[" && !self.balanced("[", "]") {
            return false;
        }
        if self.eat("(") {
            while self.text() != ")" {
                while self.text() == "@" {
                    if !self.attribute(false) {
                        return false;
                    }
                }
                while self.parameter_modifier(true) {
                    self.bump();
                }
                if !self.name() {
                    return false;
                }
                if !matches!(self.text(), ":" | "," | ")") {
                    self.name();
                }
                if self.eat(":") && !self.ty() {
                    return false;
                }
                self.eat("...");
                if !self.eat(",") {
                    break;
                }
            }
            if !self.eat(")") {
                return false;
            }
        } else if !matches!(self.text(), "in" | "async" | "throws" | "->")
            || (self.text() == "async"
                && self
                    .tokens
                    .get(self.pos + 1)
                    .is_some_and(|t| matches!(&self.source[t.span.start..t.span.end], "in" | ",")))
        {
            if !self.name() {
                return false;
            }
            while self.eat(",") {
                if !self.name() {
                    return false;
                }
            }
        }
        self.eat("async");
        if (self.eat("throws") || self.eat("rethrows"))
            && self.text() == "("
            && !self.balanced("(", ")")
        {
            return false;
        }
        if self.eat("->") && !self.ty() {
            return false;
        }
        self.eat("in")
    }

    fn attribute(&mut self, type_context: bool) -> bool {
        if !self.eat("@") {
            return false;
        }
        let args = attribute_accepts_arguments(self.text(), type_context);
        let custom = custom_attribute_arguments(self.text(), type_context);
        if !self.name() {
            return false;
        }
        while self.eat(".") {
            if !self.name() {
                return false;
            }
        }
        if self.text() == "<" && !self.generic_arguments() {
            return false;
        }
        if args && self.text() == "(" {
            let saved = (self.pos, self.offset);
            if !self.attribute_arguments(custom) {
                (self.pos, self.offset) = saved;
            }
        }
        true
    }

    pub fn existential_type(&mut self) -> bool {
        if self.text() != "any"
            || !self.tokens.get(self.pos + 1).is_some_and(|t| {
                !t.newline
                    && (matches!(t.kind, K::Identifier | K::Wildcard)
                        || &self.source[t.span.start..t.span.end] == "~")
            })
        {
            return false;
        }
        self.bump();
        self.ty()
    }

    pub fn qualified_base(&mut self) -> bool {
        self.name()
            && (!self.text().starts_with('<') || self.generic_arguments())
            && self.text().starts_with('.')
    }

    pub fn modifier_declaration(&mut self) -> bool {
        loop {
            if matches!(
                self.text(),
                "let"
                    | "var"
                    | "inout"
                    | "_borrowing"
                    | "func"
                    | "class"
                    | "struct"
                    | "enum"
                    | "protocol"
                    | "actor"
                    | "extension"
                    | "subscript"
                    | "init"
                    | "deinit"
                    | "typealias"
                    | "associatedtype"
                    | "macro"
                    | "#"
            ) {
                return true;
            }
            if self.text() == "@" {
                if !self.attribute(false) {
                    return false;
                }
            } else if declaration_modifier(self.text())
                || matches!(self.text(), "prefix" | "postfix" | "infix" | "async")
            {
                self.bump();
                if self.text() == "(" && !self.balanced("(", ")") {
                    return false;
                }
            } else {
                return false;
            }
        }
    }

    pub fn observing_accessor_block(&mut self) -> bool {
        if !self.eat("{") {
            return false;
        }
        while self.text() == "@" {
            if self.tokens.get(self.pos + 1).is_some_and(|token| {
                &self.source[token.span.start..token.span.end] == "_accessorBlock"
            }) {
                return true;
            }
            if !self.attribute(false) {
                return false;
            }
        }
        matches!(self.text(), "didSet" | "willSet" | "init")
    }

    pub fn accessor_declaration(&mut self) -> bool {
        while self.text() == "@" {
            if !self.attribute(false) {
                return false;
            }
        }
        while accessor_modifier(self.text()) {
            self.bump();
        }
        accessor_keyword(self.text())
    }

    pub fn class_modifier(&mut self) -> bool {
        if !self.eat("class") {
            return false;
        }
        while matches!(
            self.text(),
            "override"
                | "final"
                | "dynamic"
                | "private"
                | "public"
                | "internal"
                | "fileprivate"
                | "open"
                | "nonisolated"
                | "isolated"
                | "mutating"
                | "nonmutating"
                | "package"
        ) {
            self.bump();
            if self.text() == "(" && !self.balanced("(", ")") {
                return false;
            }
        }
        matches!(self.text(), "var" | "let" | "func" | "subscript")
    }

    pub fn conditional_switch_cases(&mut self) -> bool {
        self.skip_directive_headers();
        matches!(self.text(), "case" | "default") || (self.eat("@") && self.text() == "unknown")
    }

    pub fn conditional_postfix(&mut self) -> bool {
        self.skip_directive_headers();
        self.text() == "."
    }

    pub fn conditional_attributes(&mut self) -> bool {
        if self.depth >= 128 || !self.eat("#if") {
            return false;
        }
        self.depth += 1;
        self.skip_line();
        let mut did_see_attributes = false;
        'attributes: loop {
            let before = self.pos;
            if self.eat("@") {
                did_see_attributes = true;
                if !self.name() {
                    break;
                }
                while self.eat(".") {
                    if !self.name() {
                        break 'attributes;
                    }
                }
                if self.text() == "<" && !self.generic_arguments() {
                    break;
                }
                if self.text() == "("
                    && !self.tokens.get(self.pos).is_some_and(|t| t.newline)
                    && !self.balanced("(", ")")
                {
                    break;
                }
            } else if self.text() == "#if" {
                did_see_attributes |= self.conditional_attributes();
            } else if self.eat("#elseif") || self.eat("#else") {
                self.skip_line();
            } else {
                break;
            }
            if self.pos == before {
                break;
            }
        }
        let result = did_see_attributes
            && self.tokens.get(self.pos).is_some_and(|t| t.newline)
            && self.eat("#endif");
        self.depth -= 1;
        result
    }

    pub fn arrow_operator(&mut self) -> bool {
        self.eat("async");
        if (self.eat("throws") || self.eat("rethrows"))
            && self.text() == "("
            && !self.balanced("(", ")")
        {
            return false;
        }
        self.text() == "->"
    }

    fn skip_line(&mut self) {
        while !self.text().is_empty() && !self.tokens.get(self.pos).is_some_and(|t| t.newline) {
            self.bump();
        }
    }

    fn skip_directive_headers(&mut self) {
        while matches!(self.text(), "#if" | "#elseif" | "#else") {
            self.bump();
            while !self.text().is_empty() && !self.tokens.get(self.pos).is_some_and(|t| t.newline) {
                self.bump();
            }
        }
    }
}
