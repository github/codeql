use crate::generated::{self, AstNode};
use crate::trap::{DiagnosticSeverity, TrapFile, TrapId};
use crate::trap::{Label, TrapClass};
use codeql_extractor::trap::{self};
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_parser::SyntaxKind;
use ra_ap_syntax::ast::RangeItem;
use ra_ap_syntax::{ast, NodeOrToken, SyntaxElementChildren, SyntaxError, SyntaxToken, TextRange};
pub trait TextValue {
    fn try_get_text(&self) -> Option<String>;
}

impl TextValue for ast::Lifetime {
    fn try_get_text(&self) -> Option<String> {
        self.text().to_string().into()
    }
}
impl TextValue for ast::Name {
    fn try_get_text(&self) -> Option<String> {
        self.text().to_string().into()
    }
}
impl TextValue for ast::Literal {
    fn try_get_text(&self) -> Option<String> {
        self.token().text().to_string().into()
    }
}
impl TextValue for ast::NameRef {
    fn try_get_text(&self) -> Option<String> {
        self.text().to_string().into()
    }
}
impl TextValue for ast::Abi {
    fn try_get_text(&self) -> Option<String> {
        self.abi_string().map(|x| x.to_string())
    }
}

impl TextValue for ast::BinExpr {
    fn try_get_text(&self) -> Option<String> {
        self.op_token().map(|x| x.text().to_string())
    }
}
impl TextValue for ast::PrefixExpr {
    fn try_get_text(&self) -> Option<String> {
        self.op_token().map(|x| x.text().to_string())
    }
}
impl TextValue for ast::RangeExpr {
    fn try_get_text(&self) -> Option<String> {
        self.op_token().map(|x| x.text().to_string())
    }
}
impl TextValue for ast::RangePat {
    fn try_get_text(&self) -> Option<String> {
        self.op_token().map(|x| x.text().to_string())
    }
}
pub struct Translator {
    pub trap: TrapFile,
    label: trap::Label,
    line_index: LineIndex,
}

impl Translator {
    pub fn new(trap: TrapFile, label: trap::Label, line_index: LineIndex) -> Translator {
        Translator {
            trap,
            label,
            line_index,
        }
    }
    pub fn location(&self, range: TextRange) -> (LineCol, LineCol) {
        let start = self.line_index.line_col(range.start());
        let range_end = range.end();
        // QL end positions are inclusive, while TextRange offsets are exclusive and point at the position
        // right after the last character of the range. We need to shift the end offset one character to the left to
        // get the right inclusive QL position. Unfortunately, simply subtracting `1` from the end-offset may cause
        // the offset to point in the middle of a mult-byte character, resulting in a `panic`. Therefore we use `try_line_col`
        // with decreasing offsets to find the start of the last character included in the range.
        for i in 1..4 {
            if let Some(end) = range_end
                .checked_sub(i.into())
                .and_then(|x| self.line_index.try_line_col(x))
            {
                return (start, end);
            }
        }
        let end = self.line_index.line_col(range_end);
        (start, end)
    }
    pub fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: &impl ast::AstNode) {
        let (start, end) = self.location(node.syntax().text_range());
        self.trap.emit_location(self.label, label, start, end)
    }
    pub fn emit_location_token(&mut self, label: Label<generated::Token>, token: &SyntaxToken) {
        let (start, end) = self.location(token.text_range());
        self.trap.emit_location(self.label, label, start, end)
    }
    pub fn emit_parse_error(&mut self, path: &str, err: SyntaxError) {
        let (start, end) = self.location(err.range());
        log::warn!("{}:{}:{}: {}", path, start.line + 1, start.col + 1, err);
        let message = err.to_string();
        let location = self.trap.emit_location_label(self.label, start, end);
        self.trap.emit_diagnostic(
            DiagnosticSeverity::Warning,
            "parse_error".to_owned(),
            message.clone(),
            message,
            location,
        );
    }
    pub fn emit_tokens(&mut self, parent: Label<AstNode>, children: SyntaxElementChildren) {
        for child in children {
            if let NodeOrToken::Token(token) = child {
                if token.kind() == SyntaxKind::COMMENT {
                    let label = self.trap.emit(generated::Comment {
                        id: TrapId::Star,
                        parent,
                        text: token.text().to_owned(),
                    });
                    self.emit_location_token(label.into(), &token);
                }
            }
        }
    }
}
