//! Swift source parser for the CodeQL Unified extractor.
//!
//! Parsing writes committed nodes bottom-up into a caller-provided sink.
//! Spans are half-open UTF-8 byte offsets into the input, excluding trivia.
//! Children retain their order within each field; collection nodes are elided.

mod sink;

pub use sink::{Child, Diagnostic, FieldKind, NodeFlags, Span, SyntaxKind, SyntaxSink, TriviaKind};

#[derive(Debug, PartialEq, Eq)]
pub enum ParseError {
    NotImplemented,
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::NotImplemented => f.write_str("the Rust Swift parser is not implemented yet"),
        }
    }
}

impl std::error::Error for ParseError {}

/// A parser instance whose scratch storage can be reused between files.
#[derive(Default)]
pub struct Parser;

impl Parser {
    pub const fn new() -> Self {
        Self
    }

    /// Parse into `sink`, returning the root handle.
    ///
    /// The grammar is not implemented yet. For now this returns an error
    /// without writing any nodes, trivia, or diagnostics to the sink.
    pub fn parse_into<S: SyntaxSink>(
        &mut self,
        _source: &str,
        _sink: &mut S,
    ) -> Result<S::Node, ParseError> {
        Err(ParseError::NotImplemented)
    }
}
