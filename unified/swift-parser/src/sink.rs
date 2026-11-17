/// A half-open UTF-8 byte range in the source.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

/// Syntax kinds supported by the parser interface so far.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(u16)]
pub enum SyntaxKind {
    SourceFile,
    Identifier,
    EndOfFile,
}

impl SyntaxKind {
    pub const ALL: &[Self] = &[Self::SourceFile, Self::Identifier, Self::EndOfFile];

    pub const fn name(self) -> &'static str {
        match self {
            Self::SourceFile => "sourceFile",
            Self::Identifier => "identifier",
            Self::EndOfFile => "endOfFile",
        }
    }

    pub const fn is_token(self) -> bool {
        !matches!(self, Self::SourceFile)
    }

    pub const fn is_named(self) -> bool {
        !matches!(self, Self::EndOfFile)
    }
}

/// SwiftSyntax-compatible structural field names.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(u16)]
pub enum FieldKind {
    Statements,
    EndOfFileToken,
}

impl FieldKind {
    pub const ALL: &[Self] = &[Self::Statements, Self::EndOfFileToken];

    pub const fn name(self) -> &'static str {
        match self {
            Self::Statements => "statements",
            Self::EndOfFileToken => "endOfFileToken",
        }
    }
}

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
