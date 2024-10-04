use crate::generated::MacroCall;
use crate::generated::{self};
use crate::trap::{DiagnosticSeverity, TrapFile, TrapId};
use crate::trap::{Label, TrapClass};
use codeql_extractor::trap::{self};
use log::Level;
use ra_ap_hir::db::ExpandDatabase;
use ra_ap_hir::Semantics;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_ide_db::RootDatabase;
use ra_ap_parser::SyntaxKind;
use ra_ap_span::{EditionedFileId, TextSize};
use ra_ap_syntax::ast::RangeItem;
use ra_ap_syntax::{
    ast, AstNode, NodeOrToken, SyntaxElementChildren, SyntaxError, SyntaxToken, TextRange,
};
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

pub struct Translator<'a> {
    pub trap: TrapFile,
    path: &'a str,
    label: trap::Label,
    line_index: LineIndex,
    file_id: Option<EditionedFileId>,
    pub semi: Option<Semantics<'a, RootDatabase>>,
}

impl<'a> Translator<'a> {
    pub fn new(
        trap: TrapFile,
        path: &'a str,
        label: trap::Label,
        line_index: LineIndex,
        file_id: Option<EditionedFileId>,
        semi: Option<Semantics<'a, RootDatabase>>,
    ) -> Translator<'a> {
        Translator {
            trap,
            path,
            label,
            line_index,
            file_id,
            semi,
        }
    }
    fn location(&self, range: TextRange) -> (LineCol, LineCol) {
        let start = self.line_index.line_col(range.start());
        let range_end = range.end();
        // QL end positions are inclusive, while TextRange offsets are exclusive and point at the position
        // right after the last character of the range. We need to shift the end offset one character to the left to
        // get the right inclusive QL position. Unfortunately, simply subtracting `1` from the end-offset may cause
        // the offset to point in the middle of a multi-byte character, resulting in a `panic`. Therefore we use `try_line_col`
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

    pub fn text_range_for_node(&mut self, node: &impl ast::AstNode) -> Option<TextRange> {
        if let Some(semi) = self.semi.as_ref() {
            let file_range = semi.original_range(node.syntax());
            let file_id = self.file_id?;
            if file_id == file_range.file_id {
                Some(file_range.range)
            } else {
                None
            }
        } else {
            Some(node.syntax().text_range())
        }
    }
    pub fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: &impl ast::AstNode) {
        if let Some(range) = self.text_range_for_node(node) {
            let (start, end) = self.location(range);
            self.trap.emit_location(self.label, label, start, end)
        } else {
            self.emit_diagnostic(
                DiagnosticSeverity::Info,
                "locations".to_owned(),
                "missing location for AstNode".to_owned(),
                "missing location for AstNode".to_owned(),
                (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 }),
            );
        }
    }
    pub fn emit_location_token(&mut self, label: Label<generated::Token>, token: &SyntaxToken) {
        let (start, end) = self.location(token.text_range());
        self.trap.emit_location(self.label, label, start, end)
    }
    pub fn emit_diagnostic(
        &mut self,
        severity: DiagnosticSeverity,
        error_tag: String,
        error_message: String,
        full_error_message: String,
        location: (LineCol, LineCol),
    ) {
        let (start, end) = location;
        let level = match severity {
            DiagnosticSeverity::Debug => Level::Debug,
            DiagnosticSeverity::Info => Level::Info,
            DiagnosticSeverity::Warning => Level::Warn,
            DiagnosticSeverity::Error => Level::Error,
        };
        log::log!(
            level,
            "{}:{}:{}: {}",
            self.path,
            start.line + 1,
            start.col + 1,
            &error_message
        );
        let location = self.trap.emit_location_label(self.label, start, end);
        self.trap.emit_diagnostic(
            severity,
            error_tag,
            error_message,
            full_error_message,
            location,
        );
    }
    pub fn emit_parse_error(&mut self, err: &SyntaxError) {
        let location = self.location(err.range());
        let message = err.to_string();
        self.emit_diagnostic(
            DiagnosticSeverity::Warning,
            "parse_error".to_owned(),
            message.clone(),
            message,
            location,
        );
    }
    pub fn emit_tokens(
        &mut self,
        parent: Label<generated::AstNode>,
        children: SyntaxElementChildren,
    ) {
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
    pub(crate) fn extract_macro_call_expanded(
        &mut self,
        mcall: &ast::MacroCall,
        label: Label<generated::MacroCall>,
    ) {
        if let Some(semi) = &self.semi {
            if let Some(expanded) = semi.expand(mcall) {
                if let Some(value) =
                    semi.hir_file_for(&expanded)
                        .macro_file()
                        .and_then(|macro_file| {
                            semi.db
                                .parse_macro_expansion_error(macro_file.macro_call_id)
                        })
                {
                    if let Some(err) = &value.err {
                        let (message, _error) = err.render_to_string(semi.db);

                        if err.span().anchor.file_id == semi.hir_file_for(mcall.syntax()) {
                            let location = err.span().range
                                + semi
                                    .db
                                    .ast_id_map(err.span().anchor.file_id.into())
                                    .get_erased(err.span().anchor.ast_id)
                                    .text_range()
                                    .start();
                            self.emit_parse_error(&SyntaxError::new(message, location));
                        };
                    }
                    for err in value.value.iter() {
                        self.emit_parse_error(err);
                    }
                }
                let expand_to = ra_ap_hir_expand::ExpandTo::from_call_site(mcall);
                let kind = expanded.kind();
                let value: Option<Label<crate::generated::AstNode>> = match expand_to {
                    ra_ap_hir_expand::ExpandTo::Statements => {
                        ast::MacroStmts::cast(expanded).map(|x| self.emit_macro_stmts(x).into())
                    }
                    ra_ap_hir_expand::ExpandTo::Items => {
                        ast::MacroItems::cast(expanded).map(|x| self.emit_macro_items(x).into())
                    }

                    ra_ap_hir_expand::ExpandTo::Pattern => {
                        ast::Pat::cast(expanded).map(|x| self.emit_pat(x).into())
                    }
                    ra_ap_hir_expand::ExpandTo::Type => {
                        ast::Type::cast(expanded).map(|x| self.emit_type(x).into())
                    }
                    ra_ap_hir_expand::ExpandTo::Expr => {
                        ast::Expr::cast(expanded).map(|x| self.emit_expr(x).into())
                    }
                };
                if let Some(value) = value {
                    MacroCall::emit_expanded(label, value, &mut self.trap.writer);
                } else {
                    let range = self.text_range_for_node(mcall);
                    self.emit_parse_error(&SyntaxError::new(
                        format!(
                            "macro expansion failed: the macro '{}' expands to {:?} but a {:?} was expected",
                            mcall.path().map(|p| p.to_string()).unwrap_or_default(),
                            kind, expand_to
                        ),
                        range.unwrap_or_else(|| TextRange::empty(TextSize::from(0))),
                    ));
                }
            } else {
                let range = self.text_range_for_node(mcall);

                self.emit_parse_error(&SyntaxError::new(
                    format!(
                        "macro expansion failed: could not resolve macro '{}'",
                        mcall.path().map(|p| p.to_string()).unwrap_or_default()
                    ),
                    range.unwrap_or_else(|| TextRange::empty(TextSize::from(0))),
                ));
            }
        }
    }
}
