//! Non-emitting, type-shaped lookahead. Each recursion consumes a delimiter;
//! the depth bound also prevents adversarial comparison chains from rescanning
//! an unbounded suffix for every possible generic specialization.
use super::{K, Token};

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
            )
        {
            self.bump();
            true
        } else {
            false
        }
    }
    fn balanced(&mut self, open: &str, close: &str) -> bool {
        if self.depth >= 128 || !self.eat(open) {
            return false;
        }
        self.depth += 1;
        while !self.text().is_empty() && self.text() != close {
            let success = match self.text() {
                "(" => self.balanced("(", ")"),
                "[" => self.balanced("[", "]"),
                "{" => self.balanced("{", "}"),
                ")" | "]" | "}" => false,
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
        self.eat(close)
    }
    pub fn generic_arguments(&mut self) -> bool {
        if self.depth >= 128 || !self.prefix('<') {
            return false;
        }
        self.depth += 1;
        let valid = self.ty() && {
            let mut valid = true;
            while self.eat(",") {
                if self.text().starts_with('>') {
                    break;
                }
                if !self.ty() {
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
        self.generic_arguments()
            && (matches!(
                self.text(),
                "(" | ")" | "[" | "]" | "." | "," | ":" | "?" | "!" | "}" | ";" | "" | "=" | "=="
            ) || self.tokens.get(self.pos).is_some_and(|t| t.newline))
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
    fn ty_inner(&mut self) -> bool {
        while self.eat("@") {
            let args = !matches!(self.text(), "escaping" | "autoclosure" | "Sendable");
            if !self.name() {
                return false;
            }
            if args && self.text() == "(" && !self.balanced("(", ")") {
                return false;
            }
        }
        while matches!(
            self.text(),
            "inout"
                | "borrowing"
                | "consuming"
                | "isolated"
                | "sending"
                | "some"
                | "any"
                | "__owned"
                | "__shared"
        ) {
            self.bump();
        }
        if self.eat("[") {
            if !self.ty() || (self.eat(":") && !self.ty()) || !self.eat("]") {
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
            if self.text() == "<" && !self.generic_arguments() {
                return false;
            }
        }
        loop {
            if self.eat(".") {
                if !self.name() {
                    return false;
                }
                if self.text() == "<" && !self.generic_arguments() {
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
        if self.text() == "[" && !self.balanced("[", "]") {
            return false;
        }
        if self.eat("(") {
            while self.text() != ")" {
                if !self.name() {
                    return false;
                }
                if !matches!(self.text(), ":" | "," | ")") {
                    self.name();
                }
                if self.eat(":") && !self.ty() {
                    return false;
                }
                if !self.eat(",") {
                    break;
                }
            }
            if !self.eat(")") {
                return false;
            }
        } else if !matches!(self.text(), "in" | "async" | "throws" | "->") {
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

    pub fn conditional_switch_cases(&mut self) -> bool {
        while matches!(self.text(), "#if" | "#elseif" | "#else") {
            self.bump();
            while !self.text().is_empty() && !self.tokens.get(self.pos).is_some_and(|t| t.newline) {
                self.bump();
            }
        }
        matches!(self.text(), "case" | "default") || (self.eat("@") && self.text() == "unknown")
    }
}
