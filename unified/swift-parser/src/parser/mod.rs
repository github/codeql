//! Recursive descent over trivia-free UTF-8 tokens. Nodes are committed directly
//! to the sink; only operator chains keep a small, temporary handle stack.
mod declarations;
mod expressions;
mod lexer;
mod lookahead;
mod operators;
mod statements;
mod types;

use crate::{
    Child, Diagnostic, FieldKind as F, NodeFlags, ParseError, Span, SyntaxKind as K, SyntaxSink,
};
pub(crate) use lexer::Token;

#[derive(Clone, Copy)]
struct Node<N: Copy> {
    id: N,
    kind: K,
    span: Span,
}

type Children<N> = Vec<Child<N>>;

pub(crate) fn parse<S: SyntaxSink>(
    source: &str,
    sink: &mut S,
    tokens: &mut Vec<Token>,
) -> Result<S::Node, ParseError> {
    if !lexer::lex(source, sink, tokens) {
        return Err(ParseError::NestingLimit);
    }
    let operators = operators::OperatorTable::from_source(source, tokens);
    let mut parser = State {
        source,
        sink,
        tokens,
        pos: 0,
        last_end: 0,
        depth: 0,
        exhausted: false,
        operators,
        pattern_context: false,
        binding_context: false,
        condition_line: false,
        attribute_arguments: false,
    };
    let start = parser.start();
    let mut children = Vec::new();
    if parser.at_kind(K::Shebang) {
        parser.take(&mut children, F::Shebang);
    }
    parser.items(&mut children, F::Statements, false, false);
    while !parser.eof() && !parser.exhausted {
        let node = parser.recover();
        let mut item = Vec::new();
        State::<S>::add(&mut item, F::Item, node);
        let node = parser.make(K::CodeBlockItem, node.span, item);
        State::<S>::add(&mut children, F::Statements, node);
        parser.items(&mut children, F::Statements, false, false);
    }
    if parser.exhausted {
        return Err(ParseError::NestingLimit);
    }
    parser.take(&mut children, F::EndOfFileToken);
    let root = parser.make(
        K::SourceFile,
        Span {
            start,
            end: source.len(),
        },
        children,
    );
    if parser.exhausted {
        Err(ParseError::NestingLimit)
    } else {
        Ok(root.id)
    }
}

struct State<'a, S: SyntaxSink> {
    source: &'a str,
    sink: &'a mut S,
    tokens: &'a mut [Token],
    pos: usize,
    last_end: usize,
    depth: usize,
    exhausted: bool,
    operators: operators::OperatorTable,
    pattern_context: bool,
    binding_context: bool,
    condition_line: bool,
    attribute_arguments: bool,
}

impl<S: SyntaxSink> State<'_, S> {
    fn token(&self) -> Token {
        self.tokens[self.pos.min(self.tokens.len() - 1)]
    }
    fn text(&self) -> &str {
        if self.exhausted {
            return "";
        }
        let s = self.token().span;
        &self.source[s.start..s.end]
    }
    fn nth(&self, n: usize) -> &str {
        self.tokens
            .get(self.pos + n)
            .map_or("", |t| &self.source[t.span.start..t.span.end])
    }
    fn at(&self, text: &str) -> bool {
        self.text() == text
    }
    fn at_kind(&self, kind: K) -> bool {
        self.token().kind == kind
    }
    fn eof(&self) -> bool {
        self.exhausted || self.at_kind(K::EndOfFile)
    }
    fn start(&self) -> usize {
        self.token().span.start
    }
    fn end(&self) -> usize {
        self.last_end
    }
    fn newline(&self) -> bool {
        self.token().newline
    }
    fn make(&mut self, kind: K, span: Span, children: Children<S::Node>) -> Node<S::Node> {
        let id = self.sink.node(kind, span, NodeFlags::default(), &children);
        drop(children);
        Node { id, kind, span }
    }
    fn finish(&mut self, kind: K, start: usize, children: Children<S::Node>) -> Node<S::Node> {
        self.make(
            kind,
            Span {
                start,
                end: self.end().max(start),
            },
            children,
        )
    }
    fn add(children: &mut Children<S::Node>, field: F, node: Node<S::Node>) {
        children.push(Child {
            field,
            node: node.id,
        });
    }
    fn bump_as(&mut self, kind: K) -> Node<S::Node> {
        let token = self.token();
        self.last_end = token.span.end;
        if !self.eof() {
            self.pos += 1;
        }
        self.make(kind, token.span, Vec::new())
    }
    fn token_prefix(&mut self, len: usize, kind: K) -> Node<S::Node> {
        let token = self.token();
        let span = Span {
            start: token.span.start,
            end: token.span.start + len,
        };
        if span.end == token.span.end {
            self.pos += 1;
        } else {
            self.tokens[self.pos].span.start = span.end;
            self.tokens[self.pos].newline = false;
            self.tokens[self.pos].kind = match &self.source[span.end..token.span.end] {
                "=" => K::Equal,
                "?" => K::InfixQuestionMark,
                "!" => K::ExclamationMark,
                "." => K::Period,
                ":" => K::Colon,
                "->" => K::Arrow,
                _ => token.kind,
            };
        }
        self.last_end = span.end;
        self.make(kind, span, Vec::new())
    }
    fn bump(&mut self) -> Node<S::Node> {
        let kind = self.token().kind;
        // The lexer deliberately leaves words unclassified. Contextual Swift
        // keywords are identifiers outside the productions that consume them.
        if kind == K::Identifier && matches!(self.text(), "self" | "Self" | "Any") {
            self.word()
        } else {
            self.bump_as(kind)
        }
    }
    fn word(&mut self) -> Node<S::Node> {
        self.bump_as(K::keyword(self.text()).unwrap_or_else(|| self.token().kind))
    }
    fn raw_token(&mut self) -> Node<S::Node> {
        if Self::lexical_keyword(self.text()) {
            self.word()
        } else {
            self.bump()
        }
    }
    fn lexical_keyword(text: &str) -> bool {
        lexical_keyword(text)
    }
    fn take(&mut self, children: &mut Children<S::Node>, field: F) {
        let node = self.bump();
        Self::add(children, field, node);
    }
    fn kw(&mut self, children: &mut Children<S::Node>, field: F) {
        let node = self.word();
        Self::add(children, field, node);
    }
    fn eat(&mut self, text: &str, children: &mut Children<S::Node>, field: F) -> bool {
        if !self.exhausted && self.at(text) {
            self.take(children, field);
            true
        } else {
            false
        }
    }
    fn expect(&mut self, text: &str, children: &mut Children<S::Node>, field: F) {
        if self.exhausted {
            return;
        }
        if !self.eat(text, children, field) {
            self.sink.diagnostic(Diagnostic {
                span: self.token().span,
                message: format!("expected {text:?}"),
            });
        }
    }
    fn enter(&mut self) -> bool {
        if self.exhausted || self.depth >= 256 {
            self.exhausted = true;
            false
        } else {
            self.depth += 1;
            true
        }
    }
    fn missing(&mut self, kind: K) -> Node<S::Node> {
        let pos = self.end();
        let span = Span {
            start: pos,
            end: pos,
        };
        if !self.exhausted {
            self.sink.diagnostic(Diagnostic {
                span,
                message: format!("expected {}", kind.name()),
            });
        }
        // SwiftSyntax omits missing tokens from its serialized layouts. Missing
        // layout nodes themselves are ordinary named nodes, not missing tokens.
        let flags = NodeFlags {
            is_missing: kind.is_token(),
            is_error: false,
        };
        Node {
            id: self.sink.node(kind, span, flags, &[]),
            kind,
            span,
        }
    }
    fn recover(&mut self) -> Node<S::Node> {
        let span = self.token().span;
        self.sink.diagnostic(Diagnostic {
            span,
            message: "unexpected token".into(),
        });
        let token = self.bump();
        let children = [Child {
            field: F::Item,
            node: token.id,
        }];
        Node {
            id: self.sink.node(
                K::UnexpectedCodeDecl,
                span,
                NodeFlags {
                    is_missing: false,
                    is_error: true,
                },
                &children,
            ),
            kind: K::UnexpectedCodeDecl,
            span,
        }
    }
    fn items(&mut self, children: &mut Children<S::Node>, field: F, member: bool, switch: bool) {
        while !self.exhausted
            && !self.eof()
            && !self.at("}")
            && !matches!(
                self.token().kind,
                K::PoundElse | K::PoundElseif | K::PoundEndif
            )
            && !(switch
                && (self.at("case")
                    || self.at("default")
                    || (self.at("#if")
                        && lookahead::Lookahead::new(self.source, self.tokens, self.pos)
                            .conditional_switch_cases())
                    || (self.at("@") && self.nth(1) == "unknown")))
        {
            let before = self.pos;
            let start = self.start();
            let mut item = Vec::new();
            let mut node = self.item(member);
            if self.exhausted {
                return;
            }
            if self.pos == before {
                node = self.recover();
            }
            Self::add(&mut item, if member { F::Decl } else { F::Item }, node);
            self.eat(";", &mut item, F::Semicolon);
            let node = self.finish(
                if member {
                    K::MemberBlockItem
                } else {
                    K::CodeBlockItem
                },
                start,
                item,
            );
            Self::add(children, field, node);
        }
    }
    fn block(&mut self, member: bool) -> Node<S::Node> {
        let start = self.start();
        let mut c = Vec::new();
        self.expect("{", &mut c, F::LeftBrace);
        if self.enter() {
            self.items(
                &mut c,
                if member { F::Members } else { F::Statements },
                member,
                false,
            );
            self.depth -= 1;
        }
        self.expect("}", &mut c, F::RightBrace);
        self.finish(if member { K::MemberBlock } else { K::CodeBlock }, start, c)
    }
    fn label(&self, n: usize) -> bool {
        self.tokens
            .get(self.pos + n)
            .is_some_and(|t| matches!(t.kind, K::Identifier | K::Wildcard))
    }
    fn labels_before_colon(&self) -> bool {
        self.label(0) && (self.nth(1) == ":" || (self.label(1) && self.nth(2) == ":"))
    }
    fn starts_statement(&self) -> bool {
        matches!(
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
                | "extension"
                | "import"
                | "typealias"
                | "associatedtype"
                | "return"
                | "throw"
                | "while"
                | "for"
                | "guard"
                | "break"
                | "continue"
                | "defer"
                | "do"
                | "case"
                | "default"
                | "}"
                | ";"
                | "#if"
                | "#else"
                | "#elseif"
                | "#endif"
                | "#sourceLocation"
        ) || (matches!(self.text(), "yield" | "discard") && self.contextual_prefix(false, true))
            || (self.at("repeat") && self.nth(1) == "{")
            || (self.at("@") && self.nth(1) == "unknown")
            || self.eof()
    }
}

fn lexical_keyword(text: &str) -> bool {
    matches!(
        text,
        "Any"
            | "as"
            | "associatedtype"
            | "break"
            | "case"
            | "catch"
            | "class"
            | "continue"
            | "default"
            | "defer"
            | "deinit"
            | "do"
            | "else"
            | "enum"
            | "extension"
            | "fallthrough"
            | "false"
            | "fileprivate"
            | "for"
            | "func"
            | "guard"
            | "if"
            | "import"
            | "in"
            | "init"
            | "inout"
            | "internal"
            | "is"
            | "let"
            | "nil"
            | "operator"
            | "precedencegroup"
            | "private"
            | "protocol"
            | "public"
            | "repeat"
            | "rethrows"
            | "return"
            | "self"
            | "Self"
            | "static"
            | "struct"
            | "subscript"
            | "super"
            | "switch"
            | "throw"
            | "throws"
            | "true"
            | "try"
            | "typealias"
            | "var"
            | "where"
            | "while"
    )
}
