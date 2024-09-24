use crate::trap::{DiagnosticSeverity, TrapFile};
use crate::trap::{Label, TrapClass};
use codeql_extractor::trap::{self};
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_syntax::ast::RangeItem;
use ra_ap_syntax::{ast, SyntaxError, TextRange, TextSize};
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
        let end = self.line_index.line_col(
            range
                .end()
                .checked_sub(TextSize::new(1))
                .unwrap_or(range.end()),
        );
        (start, end)
    }
    pub fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: impl ast::AstNode) {
        let (start, end) = self.location(node.syntax().text_range());
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
}
