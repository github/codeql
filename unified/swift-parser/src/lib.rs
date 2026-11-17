//! Swift source parser for the CodeQL Unified extractor.
//!
//! Parsing writes committed nodes bottom-up into a caller-provided sink.
//! Spans are half-open UTF-8 byte offsets into the input, excluding trivia.
//! Children retain their order within each field; collection nodes are elided.

mod kinds;
mod parser;
mod sink;

pub use sink::{Child, Diagnostic, FieldKind, NodeFlags, Span, SyntaxKind, SyntaxSink, TriviaKind};

#[derive(Debug, PartialEq, Eq)]
pub enum ParseError {
    NestingLimit,
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::NestingLimit => f.write_str("Swift parser nesting limit exceeded"),
        }
    }
}

impl std::error::Error for ParseError {}

/// A parser instance whose token storage is reused between files.
#[derive(Default)]
pub struct Parser {
    tokens: Vec<parser::Token>,
}

impl Parser {
    pub const fn new() -> Self {
        Self { tokens: Vec::new() }
    }

    /// Parse into `sink`, returning the root handle.
    ///
    /// Excessively nested input returns [`ParseError::NestingLimit`].
    pub fn parse_into<S: SyntaxSink>(
        &mut self,
        source: &str,
        sink: &mut S,
    ) -> Result<S::Node, ParseError> {
        parser::parse(source, sink, &mut self.tokens)
    }
}
