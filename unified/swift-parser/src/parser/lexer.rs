use crate::{Span, SyntaxKind as K, SyntaxSink, TriviaKind};

#[derive(Clone, Copy, Debug)]
pub(crate) struct Token {
    pub kind: K,
    pub span: Span,
    pub newline: bool,
}

pub(super) fn lex<S: SyntaxSink>(source: &str, sink: &mut S, tokens: &mut Vec<Token>) -> bool {
    tokens.clear();
    let mut lexer = Lexer {
        source,
        sink,
        tokens,
        pos: 0,
        newline: false,
        depth: 0,
        exhausted: false,
    };
    lexer.code(false);
    lexer.push(K::EndOfFile, lexer.pos);
    !lexer.exhausted
}

struct Lexer<'a, S: SyntaxSink> {
    source: &'a str,
    sink: &'a mut S,
    tokens: &'a mut Vec<Token>,
    pos: usize,
    newline: bool,
    depth: usize,
    exhausted: bool,
}

impl<S: SyntaxSink> Lexer<'_, S> {
    fn push(&mut self, kind: K, start: usize) {
        self.tokens.push(Token {
            kind,
            span: Span {
                start,
                end: self.pos,
            },
            newline: self.newline,
        });
        self.newline = false;
    }

    fn rest(&self) -> &str {
        &self.source[self.pos..]
    }

    fn code(&mut self, interpolation: bool) {
        if self.depth >= 128 {
            self.exhausted = true;
            self.pos = self.source.len();
            return;
        }
        self.depth += 1;
        self.code_inner(interpolation);
        self.depth -= 1;
    }

    #[allow(clippy::too_many_lines)]
    fn code_inner(&mut self, interpolation: bool) {
        let mut parens = 0usize;
        while self.pos < self.source.len() {
            let start = self.pos;
            let c = self.rest().chars().next().unwrap();
            if c.is_whitespace() {
                self.newline |= c == '\n' || c == '\r';
                self.pos += c.len_utf8();
                continue;
            }
            if self.rest().starts_with("//") {
                let doc = self.rest().starts_with("///");
                self.pos += self
                    .rest()
                    .find(['\n', '\r'])
                    .unwrap_or_else(|| self.rest().len());
                self.sink.trivia(
                    if doc {
                        TriviaKind::DocLineComment
                    } else {
                        TriviaKind::LineComment
                    },
                    Span {
                        start,
                        end: self.pos,
                    },
                );
                continue;
            }
            if self.rest().starts_with("/*") {
                let doc = self.rest().starts_with("/**");
                self.pos += 2;
                let mut depth = 1;
                while self.pos < self.source.len() && depth > 0 {
                    if self.rest().starts_with("/*") {
                        depth += 1;
                        self.pos += 2;
                    } else if self.rest().starts_with("*/") {
                        depth -= 1;
                        self.pos += 2;
                    } else {
                        let c = self.rest().chars().next().unwrap();
                        self.newline |= c == '\n' || c == '\r';
                        self.pos += c.len_utf8();
                    }
                }
                self.sink.trivia(
                    if doc {
                        TriviaKind::DocBlockComment
                    } else {
                        TriviaKind::BlockComment
                    },
                    Span {
                        start,
                        end: self.pos,
                    },
                );
                continue;
            }
            if c == '"' || (c == '#' && self.rest().trim_start_matches('#').starts_with('"')) {
                self.string();
                continue;
            }
            if c == '#' {
                let length = self
                    .rest()
                    .bytes()
                    .skip(1)
                    .take_while(u8::is_ascii_alphabetic)
                    .count()
                    + 1;
                let kind = match &self.rest()[..length] {
                    "#if" => Some(K::PoundIf),
                    "#elseif" => Some(K::PoundElseif),
                    "#else" => Some(K::PoundElse),
                    "#endif" => Some(K::PoundEndif),
                    "#available" => Some(K::PoundAvailable),
                    "#unavailable" => Some(K::PoundUnavailable),
                    _ => None,
                };
                if let Some(kind) = kind {
                    self.pos += length;
                    self.push(kind, start);
                    continue;
                }
            }
            if start == 0 && self.rest().starts_with("#!") {
                self.pos += self
                    .rest()
                    .find(['\n', '\r'])
                    .unwrap_or_else(|| self.rest().len());
                self.push(K::Shebang, start);
                continue;
            }
            if c == '`' {
                self.pos += 1;
                self.pos += self
                    .rest()
                    .find('`')
                    .map_or_else(|| self.rest().len(), |n| n + 1);
                self.push(K::Identifier, start);
                continue;
            }
            if c == '_' || c == '$' || c.is_alphabetic() || (c as u32 >= 0x80 && !is_operator(c)) {
                self.pos += c.len_utf8();
                while let Some(c) = self.rest().chars().next() {
                    if !(c == '_' || c.is_alphanumeric() || (c as u32 >= 0x80 && !is_operator(c))) {
                        break;
                    }
                    self.pos += c.len_utf8();
                }
                let text = &self.source[start..self.pos];
                let kind = if text == "_" {
                    K::Wildcard
                } else if c == '$' && text.as_bytes().get(1).is_some_and(u8::is_ascii_digit) {
                    K::DollarIdentifier
                } else {
                    K::Identifier
                };
                self.push(kind, start);
                continue;
            }
            if c.is_ascii_digit() {
                self.number();
                continue;
            }
            let kind = match c {
                '(' => {
                    parens += 1;
                    K::LeftParen
                }
                ')' => {
                    if interpolation && parens == 0 {
                        self.pos += 1;
                        self.push(K::RightParen, start);
                        return;
                    }
                    parens = parens.saturating_sub(1);
                    K::RightParen
                }
                '{' => K::LeftBrace,
                '}' => K::RightBrace,
                '[' => K::LeftSquare,
                ']' => K::RightSquare,
                ':' => K::Colon,
                ',' => K::Comma,
                ';' => K::Semicolon,
                '@' => K::AtSign,
                '\\' => K::Backslash,
                '#' => K::Pound,
                '.' if !self
                    .rest()
                    .chars()
                    .nth(1)
                    .is_some_and(|c| c == '.' || is_operator(c)) =>
                {
                    K::Period
                }
                _ if is_operator(c) || c == '.' => {
                    self.pos += c.len_utf8();
                    while let Some(next) = self.rest().chars().next() {
                        if !(is_operator(next) || c == '.' && next == '.') {
                            break;
                        }
                        if self.rest().starts_with("//") || self.rest().starts_with("/*") {
                            break;
                        }
                        self.pos += next.len_utf8();
                    }
                    let text = &self.source[start..self.pos];
                    let kind = match text {
                        "=" => K::Equal,
                        "->" => K::Arrow,
                        "!" => K::ExclamationMark,
                        "?" => K::InfixQuestionMark,
                        _ => K::BinaryOperator,
                    };
                    self.push(kind, start);
                    continue;
                }
                _ => K::Unknown,
            };
            self.pos += c.len_utf8();
            self.push(kind, start);
        }
    }

    fn digits(&mut self, hex: bool) {
        while self.rest().as_bytes().first().is_some_and(|c| {
            *c == b'_'
                || if hex {
                    c.is_ascii_hexdigit()
                } else {
                    c.is_ascii_digit()
                }
        }) {
            self.pos += 1;
        }
    }

    fn number(&mut self) {
        let start = self.pos;
        if self.tokens.last().is_some_and(|t| t.kind == K::Period) {
            self.digits(false);
            self.push(K::IntegerLiteral, start);
            return;
        }
        let hex = self.rest().starts_with("0x");
        let based = hex || self.rest().starts_with("0b") || self.rest().starts_with("0o");
        if based {
            self.pos += 2;
        }
        self.digits(hex);
        let mut float = false;
        let fractional_hex = hex && self.rest().starts_with('.') && {
            let fraction =
                self.rest()[1..].trim_start_matches(|c: char| c.is_ascii_hexdigit() || c == '_');
            fraction.starts_with(['p', 'P'])
        };
        if fractional_hex
            || (!based
                && self.rest().starts_with('.')
                && self
                    .rest()
                    .as_bytes()
                    .get(1)
                    .is_some_and(u8::is_ascii_digit))
        {
            self.pos += 1;
            self.digits(hex);
            float = true;
        }
        if (hex && self.rest().starts_with(['p', 'P']))
            || (!based && self.rest().starts_with(['e', 'E']))
        {
            self.pos += 1;
            if self.rest().starts_with(['+', '-']) {
                self.pos += 1;
            }
            self.digits(false);
            float = true;
        }
        self.push(
            if float {
                K::FloatLiteral
            } else {
                K::IntegerLiteral
            },
            start,
        );
    }

    fn string(&mut self) {
        let start = self.pos;
        while self.rest().starts_with('#') {
            self.pos += 1;
        }
        let pounds = self.pos - start;
        if pounds > 0 {
            self.push(K::RawStringPoundDelimiter, start);
        }
        let quote = self.pos;
        let multiline = self.rest().starts_with("\"\"\"");
        self.pos += if multiline { 3 } else { 1 };
        let kind = if multiline {
            K::MultilineStringQuote
        } else {
            K::StringQuote
        };
        self.push(kind, quote);
        let closing = format!(
            "{}{}",
            if multiline { "\"\"\"" } else { "\"" },
            "#".repeat(pounds)
        );
        let interpolation = format!("\\{}(", "#".repeat(pounds));
        let mut segment = self.pos;
        while self.pos < self.source.len() {
            if !multiline && self.rest().starts_with(['\n', '\r']) {
                self.push(K::StringSegmentToken, segment);
                return;
            }
            if self.rest().starts_with(&closing) {
                self.push(K::StringSegmentToken, segment);
                let quote = self.pos;
                self.pos += if multiline { 3 } else { 1 };
                self.push(kind, quote);
                if pounds > 0 {
                    let start = self.pos;
                    self.pos += pounds;
                    self.push(K::RawStringPoundDelimiter, start);
                }
                return;
            }
            if self.rest().starts_with(&interpolation) {
                self.push(K::StringSegmentToken, segment);
                let slash = self.pos;
                self.pos += 1;
                self.push(K::Backslash, slash);
                if pounds > 0 {
                    let start = self.pos;
                    self.pos += pounds;
                    self.push(K::RawStringPoundDelimiter, start);
                }
                let paren = self.pos;
                self.pos += 1;
                self.push(K::LeftParen, paren);
                self.code(true);
                segment = self.pos;
            } else if self.rest().starts_with('\\') && pounds == 0 {
                self.pos += 1;
                if let Some(c) = self.rest().chars().next() {
                    self.pos += c.len_utf8();
                    if c == 'n' || c == 'r' {
                        self.push(K::StringSegmentToken, segment);
                        segment = self.pos;
                    }
                }
            } else {
                self.pos += self.rest().chars().next().unwrap().len_utf8();
            }
        }
        self.push(K::StringSegmentToken, segment);
    }
}

fn is_operator(c: char) -> bool {
    matches!(
        c,
        '/' | '=' | '-' | '+' | '!' | '*' | '%' | '<' | '>' | '&' | '|' | '^' | '?' | '~'
    ) || matches!(c as u32, 0x00a1..=0x00a7 | 0x00a9 | 0x00ab..=0x00ac | 0x00ae | 0x00b0..=0x00b1 | 0x00b6 | 0x00bb | 0x00bf | 0x00d7 | 0x00f7 | 0x2016..=0x2017 | 0x2020..=0x2027 | 0x2030..=0x203e | 0x2041..=0x2053 | 0x2055..=0x205e | 0x2190..=0x23ff | 0x2500..=0x2775 | 0x2794..=0x2bff | 0x2e00..=0x2e7f | 0x3001..=0x3003 | 0x3008..=0x3020 | 0x3030)
}
