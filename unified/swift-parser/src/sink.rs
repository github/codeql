/// A half-open UTF-8 byte range in the source.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

pub use crate::kinds::{FieldKind, SyntaxKind};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct NodeFlags {
    pub is_missing: bool,
    pub is_error: bool,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Child<N> {
    pub field: FieldKind,
    pub node: N,
}

/// Stable trivia ids, matching the swift-syntax adapter's extra tokens.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(usize)]
pub enum TriviaKind {
    LineComment = 1,
    BlockComment,
    DocLineComment,
    DocBlockComment,
    UnexpectedText,
}

#[derive(Debug)]
pub struct Diagnostic {
    pub span: Span,
    pub message: String,
}

/// Receives the final syntax tree without requiring an intermediate tree.
///
/// Child handles must come from earlier calls to `node` on this sink. Missing
/// tokens have empty spans. Trivia is emitted in source order. Syntax errors
/// are reported through `diagnostic` while parsing continues with a recovered
/// tree; fatal failures are returned by [`crate::Parser::parse_into`] instead.
pub trait SyntaxSink {
    type Node: Copy;

    fn node(
        &mut self,
        kind: SyntaxKind,
        span: Span,
        flags: NodeFlags,
        children: &[Child<Self::Node>],
    ) -> Self::Node;

    fn trivia(&mut self, kind: TriviaKind, span: Span);

    fn diagnostic(&mut self, diagnostic: Diagnostic);
}
