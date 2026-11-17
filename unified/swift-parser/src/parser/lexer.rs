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

    fn current_char(&self) -> Option<char> {
        let byte = *self.source.as_bytes().get(self.pos)?;
        Some(if byte.is_ascii() {
            char::from(byte)
        } else {
            self.rest().chars().next().unwrap()
        })
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
            let c = self.current_char().unwrap();
            if matches!(c, '\t'..='\r' | ' ') {
                let bytes = self.source.as_bytes();
                while let Some(&byte) = bytes.get(self.pos) {
                    if !matches!(byte, b'\t'..=b'\r' | b' ') {
                        break;
                    }
                    self.newline |= matches!(byte, b'\n' | b'\r');
                    self.pos += 1;
                }
                continue;
            }
            if matches!(c, '\u{a0}' | '\0' | '\u{feff}') {
                self.pos += self
                    .rest()
                    .chars()
                    .take_while(|c| matches!(c, '\u{a0}' | '\0' | '\u{feff}'))
                    .map(char::len_utf8)
                    .sum::<usize>();
                self.sink.trivia(
                    TriviaKind::UnexpectedText,
                    Span {
                        start,
                        end: self.pos,
                    },
                );
                continue;
            }
            if !c.is_ascii() && c.is_whitespace() {
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
                let doc = self.rest().starts_with("/**") && !self.rest().starts_with("/**/");
                self.pos += 2;
                let mut depth = 1;
                let bytes = self.source.as_bytes();
                while self.pos < self.source.len() && depth > 0 {
                    if bytes[self.pos] == b'/' && bytes.get(self.pos + 1) == Some(&b'*') {
                        depth += 1;
                        self.pos += 2;
                    } else if bytes[self.pos] == b'*' && bytes.get(self.pos + 1) == Some(&b'/') {
                        depth -= 1;
                        self.pos += 2;
                    } else {
                        // Only ASCII delimiters matter inside comments. The scan ends
                        // at an ASCII delimiter or EOF, preserving UTF-8 boundaries.
                        self.newline |= matches!(bytes[self.pos], b'\n' | b'\r');
                        self.pos += 1;
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
            if (c == '/' || c == '#') && self.regex(None) {
                continue;
            }
            if c == '#' {
                let length = self
                    .rest()
                    .bytes()
                    .skip(1)
                    // SwiftSyntax scans ASCII identifier starts here, not continuations:
                    // underscores extend directive names, but digits and Unicode do not.
                    .take_while(|byte| byte.is_ascii_alphabetic() || *byte == b'_')
                    .count()
                    + 1;
                let kind = match &self.rest()[..length] {
                    "#if" => Some(K::PoundIf),
                    "#elseif" => Some(K::PoundElseif),
                    "#else" => Some(K::PoundElse),
                    "#endif" => Some(K::PoundEndif),
                    "#available" => Some(K::PoundAvailable),
                    "#unavailable" => Some(K::PoundUnavailable),
                    "#sourceLocation" => Some(K::PoundSourceLocationToken),
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
            if c == '_'
                || c == '$'
                || c.is_ascii_alphabetic()
                || (!c.is_ascii()
                    && (c.is_alphabetic()
                        || !is_operator(c)
                        // SwiftSyntax gives identifiers priority in this overlapping range.
                        || matches!(c, '\u{3021}'..='\u{302f}')))
            {
                self.pos += c.len_utf8();
                while let Some(&byte) = self.source.as_bytes().get(self.pos) {
                    if byte.is_ascii_alphanumeric() || matches!(byte, b'_' | b'$') {
                        self.pos += 1;
                        continue;
                    }
                    if byte.is_ascii() {
                        break;
                    }
                    let c = self.rest().chars().next().unwrap();
                    if !c.is_alphanumeric()
                        && !matches!(c, '\u{3021}'..='\u{302f}')
                        && (c.is_whitespace() || is_operator(c))
                    {
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
                ':' if self.rest().starts_with("::") => {
                    self.pos += 1;
                    K::ColonColon
                }
                ':' => K::Colon,
                ',' => K::Comma,
                ';' => K::Semicolon,
                '@' => K::AtSign,
                '\\' => K::Backslash,
                '#' => K::Pound,
                '.' if self.rest().starts_with("./*")
                    || self.rest().starts_with(".//")
                    || !self
                        .rest()
                        .chars()
                        .nth(1)
                        .is_some_and(|c| c == '.' || is_operator_continuation(c)) =>
                {
                    K::Period
                }
                _ if is_operator(c) || c == '.' => {
                    let left = self.tokens.last().is_some_and(|t| {
                        t.span.end == start
                            && !matches!(
                                t.kind,
                                K::LeftParen
                                    | K::LeftSquare
                                    | K::LeftBrace
                                    | K::Comma
                                    | K::Colon
                                    | K::Semicolon
                            )
                    });
                    if left && matches!(c, '?' | '!') {
                        self.pos += 1;
                        self.push(
                            if c == '?' {
                                K::InfixQuestionMark
                            } else {
                                K::ExclamationMark
                            },
                            start,
                        );
                        continue;
                    }
                    self.pos += c.len_utf8();
                    while let Some(next) = self.current_char() {
                        if !(is_operator_continuation(next) || c == '.' && next == '.') {
                            break;
                        }
                        if self.rest().starts_with("//") || self.rest().starts_with("/*") {
                            break;
                        }
                        self.pos += next.len_utf8();
                    }
                    if let Some(slash) = self.source[start..self.pos].find('/')
                        && slash > 0
                    {
                        let end = self.pos;
                        self.pos = start + slash;
                        if self.regex(Some((start, end))) {
                            continue;
                        }
                        self.pos = end;
                    }
                    let text = &self.source[start..self.pos];
                    let kind = match text {
                        "=" => K::Equal,
                        "->" => K::Arrow,
                        "?" => K::InfixQuestionMark,
                        _ => {
                            let right = self.current_char().is_some_and(|c| {
                                !c.is_whitespace()
                                    && !matches!(c, ')' | ']' | '}' | ',' | ':' | ';')
                                    && (c != '.' || !left)
                            }) && !self.rest().starts_with("//")
                                && !self.rest().starts_with("/*");
                            if left && !right {
                                K::PostfixOperator
                            } else if !left && right {
                                K::PrefixOperator
                            } else {
                                K::BinaryOperator
                            }
                        }
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

    #[allow(clippy::too_many_lines)]
    fn regex(&mut self, operator: Option<(usize, usize)>) -> bool {
        let start = self.pos;
        let operator_start = operator.map_or(start, |(start, _)| start);
        let mut operator_prefix = None;
        let pounds = self.rest().bytes().take_while(|c| *c == b'#').count();
        let slash = start + pounds;
        if self.source.as_bytes().get(slash) != Some(&b'/') {
            return false;
        }
        let mut must_be_regex = pounds > 0;
        if pounds == 0 {
            if self.tokens.last().is_some_and(|t| {
                matches!(&self.source[t.span.start..t.span.end], "func" | "operator")
            }) {
                return false;
            }
            if self.tokens.last().is_some_and(|t| {
                t.span.end == operator_start
                    && !matches!(
                        t.kind,
                        K::LeftParen
                            | K::LeftSquare
                            | K::LeftBrace
                            | K::Comma
                            | K::Colon
                            | K::Semicolon
                    )
            }) {
                return false;
            }
            let operator_end = operator.map_or_else(
                || {
                    slash
                        + self.source[slash..]
                            .chars()
                            .take_while(|c| is_operator_continuation(*c))
                            .map(char::len_utf8)
                            .sum::<usize>()
                },
                |(_, end)| end,
            );
            let right_bound = self.source[operator_end..].chars().next().is_some_and(|c| {
                !c.is_whitespace() && !matches!(c, '\0' | ')' | ']' | '}' | ',' | ':' | ';')
            });
            if operator.is_some() {
                operator_prefix = Some(if right_bound {
                    K::PrefixOperator
                } else {
                    K::BinaryOperator
                });
            }
            let prefix = self.tokens.last().is_none_or(|t| {
                matches!(
                    t.kind,
                    K::Equal
                        | K::LeftParen
                        | K::LeftSquare
                        | K::LeftBrace
                        | K::Comma
                        | K::Colon
                        | K::Semicolon
                        | K::BinaryOperator
                        | K::PrefixOperator
                        | K::InfixQuestionMark
                ) || matches!(
                    &self.source[t.span.start..t.span.end],
                    "return"
                        | "throw"
                        | "case"
                        | "in"
                        | "if"
                        | "while"
                        | "guard"
                        | "switch"
                        | "where"
                        | "yield"
                        | "await"
                        | "try"
                        | "else"
                )
            });
            let after_try = self.tokens.len() >= 2
                && matches!(
                    self.tokens[self.tokens.len() - 1].kind,
                    K::InfixQuestionMark | K::ExclamationMark
                )
                && {
                    let token = self.tokens[self.tokens.len() - 2];
                    &self.source[token.span.start..token.span.end] == "try"
                };
            if (!right_bound && !prefix && !after_try)
                || self.source[slash + 1..]
                    .chars()
                    .next()
                    .is_none_or(char::is_whitespace)
            {
                return false;
            }
            must_be_regex = !right_bound
                && (after_try
                    || self.tokens.last().is_none_or(|t| {
                        !matches!(
                            t.kind,
                            K::LeftParen | K::LeftSquare | K::Comma | K::Colon | K::ColonColon
                        )
                    }));
        }
        let closing = format!("/{}", "#".repeat(pounds));
        let mut end = slash + 1;
        let mut group_depth = 0usize;
        let mut character_class_depth = 0usize;
        let mut last_unescaped_space = None;
        while end < self.source.len() {
            let rest = &self.source[end..];
            if rest.starts_with(&closing) {
                if pounds == 0 && !must_be_regex && last_unescaped_space == Some(end - 1) {
                    return false;
                }
                break;
            }
            let ch = rest.chars().next().unwrap();
            if pounds == 0 && matches!(ch, '\n' | '\r') {
                return false;
            }
            match ch {
                '(' if character_class_depth == 0 => group_depth += 1,
                ')' if character_class_depth == 0 => {
                    if group_depth == 0 && !must_be_regex {
                        return false;
                    }
                    group_depth = group_depth.saturating_sub(1);
                }
                '[' => character_class_depth += 1,
                ']' => character_class_depth = character_class_depth.saturating_sub(1),
                ' ' | '\t' => last_unescaped_space = Some(end),
                _ => {}
            }
            end += ch.len_utf8();
            if ch == '\\'
                && let Some(ch) = self.source[end..].chars().next()
            {
                end += ch.len_utf8();
            }
        }
        if end == self.source.len() {
            return false;
        }
        if let Some(kind) = operator_prefix {
            self.pos = slash;
            self.push(kind, operator_start);
        }
        if pounds > 0 {
            self.pos = slash;
            self.push(K::RegexPoundDelimiter, start);
        }
        self.pos = slash + 1;
        self.push(K::RegexSlash, slash);
        self.pos = end;
        self.push(K::RegexLiteralPattern, slash + 1);
        self.pos += 1;
        self.push(K::RegexSlash, end);
        if pounds > 0 {
            let start = self.pos;
            self.pos += pounds;
            self.push(K::RegexPoundDelimiter, start);
        }
        true
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

    #[allow(clippy::too_many_lines)]
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
        let multiline = self.rest().starts_with("\"\"\"")
            && (pounds == 0 || {
                let after_quotes = &self.rest()[3..];
                let line = after_quotes.split(['\n', '\r']).next().unwrap_or("");
                let closing = format!("\"{}", "#".repeat(pounds));
                !line.starts_with(&"#".repeat(pounds)) && !line.contains(&closing)
            });
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
        let escape = format!("\\{}", "#".repeat(pounds));
        let mut segments = Vec::new();
        if multiline && self.rest().starts_with("\r\n") {
            self.pos += 2;
        } else if multiline && self.rest().starts_with(['\n', '\r']) {
            self.pos += 1;
        }
        let mut segment = self.pos;
        while self.pos < self.source.len() {
            if !multiline && self.rest().starts_with(['\n', '\r']) {
                self.push(K::StringSegmentToken, segment);
                return;
            }
            if self.rest().starts_with(&closing) {
                let line = self.source[..self.pos]
                    .rfind(['\n', '\r'])
                    .map_or(0, |p| p + 1);
                let indentation = &self.source[line..self.pos];
                if multiline && indentation.bytes().all(|c| matches!(c, b' ' | b'\t')) {
                    if segment != line {
                        self.string_segment(segment, &mut segments);
                    }
                    if let Some(last) = segments.last().copied() {
                        let span = &mut self.tokens[last].span;
                        if self.source[..span.end].ends_with("\r\n") {
                            span.end -= 2;
                        } else if self.source[..span.end].ends_with(['\n', '\r']) {
                            span.end -= 1;
                        }
                    }
                    for index in &segments {
                        let span = &mut self.tokens[*index].span;
                        if span.start == 0 || self.source[..span.start].ends_with(['\n', '\r']) {
                            let matching = self.source.as_bytes()[span.start..span.end]
                                .iter()
                                .zip(indentation.bytes())
                                .take_while(|(a, b)| **a == *b)
                                .count();
                            span.start += matching;
                        }
                    }
                } else {
                    self.string_segment(segment, &mut segments);
                }
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
                self.string_segment(segment, &mut segments);
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
            } else if self.rest().starts_with(&escape) {
                let escaped_newline = multiline
                    && self.rest()[escape.len()..]
                        .trim_start_matches([' ', '\t'])
                        .starts_with(['\n', '\r']);
                if escaped_newline {
                    self.string_segment(segment, &mut segments);
                    self.pos += escape.len();
                    while self.rest().starts_with([' ', '\t']) {
                        self.pos += 1;
                    }
                    self.pos += if self.rest().starts_with("\r\n") {
                        2
                    } else {
                        1
                    };
                    segment = self.pos;
                    continue;
                }
                self.pos += escape.len();
                if let Some(c) = self.rest().chars().next() {
                    self.pos += c.len_utf8();
                    let mut linebreak = c == 'n' || c == 'r';
                    if c == 'u' && self.rest().starts_with('{') {
                        let end = 1 + self.rest()[1..]
                            .bytes()
                            .take_while(u8::is_ascii_hexdigit)
                            .count();
                        if self.rest().as_bytes().get(end) == Some(&b'}') {
                            linebreak = matches!(
                                u32::from_str_radix(&self.rest()[1..end], 16),
                                Ok(10 | 13)
                            );
                            self.pos += end + 1;
                        }
                    }
                    if linebreak {
                        self.string_segment(segment, &mut segments);
                        segment = self.pos;
                    }
                }
            } else if multiline && self.rest().starts_with(['\n', '\r']) {
                if self.rest().starts_with("\r\n") {
                    self.pos += 2;
                } else {
                    self.pos += 1;
                }
                self.string_segment(segment, &mut segments);
                segment = self.pos;
            } else {
                self.pos += self.rest().chars().next().unwrap().len_utf8();
            }
        }
        self.push(K::StringSegmentToken, segment);
    }

    fn string_segment(&mut self, start: usize, segments: &mut Vec<usize>) {
        segments.push(self.tokens.len());
        self.push(K::StringSegmentToken, start);
    }
}

fn is_operator(c: char) -> bool {
    matches!(
        c,
        '/' | '=' | '-' | '+' | '!' | '*' | '%' | '<' | '>' | '&' | '|' | '^' | '?' | '~'
    ) || matches!(c as u32, 0x00a1..=0x00a7 | 0x00a9 | 0x00ab..=0x00ac | 0x00ae | 0x00b0..=0x00b1 | 0x00b6 | 0x00bb | 0x00bf | 0x00d7 | 0x00f7 | 0x2016..=0x2017 | 0x2020..=0x2027 | 0x2030..=0x203e | 0x2041..=0x2053 | 0x2055..=0x205e | 0x2190..=0x23ff | 0x2500..=0x2775 | 0x2794..=0x2bff | 0x2e00..=0x2e7f | 0x3001..=0x3003 | 0x3008..=0x3030)
}

fn is_operator_continuation(c: char) -> bool {
    is_operator(c)
        || matches!(
            c as u32,
            0x0300..=0x036f
                | 0x1dc0..=0x1dff
                | 0x20d0..=0x20ff
                | 0xfe00..=0xfe0f
                | 0xfe20..=0xfe2f
                | 0xe0100..=0xe01ef
        )
}
