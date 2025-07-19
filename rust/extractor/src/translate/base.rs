use super::mappings::{AddressableAst, AddressableHir, Emission, PathAst};
use crate::generated::{self};
use crate::rust_analyzer::FileSemanticInformation;
use crate::trap::{DiagnosticSeverity, TrapFile, TrapId};
use crate::trap::{Label, TrapClass};
use itertools::Either;
use ra_ap_base_db::{CrateOrigin, EditionedFileId};
use ra_ap_hir::db::ExpandDatabase;
use ra_ap_hir::{
    Adt, Crate, ItemContainer, Module, ModuleDef, PathResolution, Semantics, Type, Variant,
};
use ra_ap_hir_def::ModuleId;
use ra_ap_hir_def::type_ref::Mutability;
use ra_ap_hir_expand::{ExpandResult, ExpandTo, InFile};
use ra_ap_ide_db::RootDatabase;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_parser::SyntaxKind;
use ra_ap_span::TextSize;
use ra_ap_syntax::ast::{HasAttrs, HasName};
use ra_ap_syntax::{
    AstNode, NodeOrToken, SyntaxElementChildren, SyntaxError, SyntaxNode, SyntaxToken, TextRange,
    ast,
};

impl Emission<ast::Item> for Translator<'_> {
    fn pre_emit(&mut self, node: &ast::Item) -> Option<Label<generated::Item>> {
        self.item_pre_emit(node).map(Into::into)
    }

    fn post_emit(&mut self, node: &ast::Item, label: Label<generated::Item>) {
        self.item_post_emit(node, label);
    }
}

impl Emission<ast::AssocItem> for Translator<'_> {
    fn pre_emit(&mut self, node: &ast::AssocItem) -> Option<Label<generated::AssocItem>> {
        self.item_pre_emit(&node.clone().into()).map(Into::into)
    }

    fn post_emit(&mut self, node: &ast::AssocItem, label: Label<generated::AssocItem>) {
        self.item_post_emit(&node.clone().into(), label.into());
    }
}

impl Emission<ast::ExternItem> for Translator<'_> {
    fn pre_emit(&mut self, node: &ast::ExternItem) -> Option<Label<generated::ExternItem>> {
        self.item_pre_emit(&node.clone().into()).map(Into::into)
    }

    fn post_emit(&mut self, node: &ast::ExternItem, label: Label<generated::ExternItem>) {
        self.item_post_emit(&node.clone().into(), label.into());
    }
}

impl Emission<ast::Meta> for Translator<'_> {
    fn pre_emit(&mut self, _node: &ast::Meta) -> Option<Label<generated::Meta>> {
        self.macro_context_depth += 1;
        None
    }

    fn post_emit(&mut self, _node: &ast::Meta, _label: Label<generated::Meta>) {
        self.macro_context_depth -= 1;
    }
}

impl Emission<ast::Fn> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Fn, label: Label<generated::Function>) {
        self.emit_function_has_implementation(node, label);
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Struct> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Struct, label: Label<generated::Struct>) {
        self.emit_derive_expansion(node, label);
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Enum> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Enum, label: Label<generated::Enum>) {
        self.emit_derive_expansion(node, label);
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Union> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Union, label: Label<generated::Union>) {
        self.emit_derive_expansion(node, label);
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Trait> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Trait, label: Label<generated::Trait>) {
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Module> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Module, label: Label<generated::Module>) {
        self.extract_canonical_origin(node, label.into());
    }
}

impl Emission<ast::Variant> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Variant, label: Label<generated::Variant>) {
        self.extract_canonical_origin_of_enum_variant(node, label);
    }
}

impl Emission<ast::PathExpr> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::PathExpr, label: Label<generated::PathExpr>) {
        self.extract_path_canonical_destination(node, label.into());
    }
}

impl Emission<ast::RecordExpr> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::RecordExpr, label: Label<generated::StructExpr>) {
        self.extract_path_canonical_destination(node, label.into());
    }
}

impl Emission<ast::PathPat> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::PathPat, label: Label<generated::PathPat>) {
        self.extract_path_canonical_destination(node, label.into());
    }
}

impl Emission<ast::RecordPat> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::RecordPat, label: Label<generated::StructPat>) {
        self.extract_path_canonical_destination(node, label.into());
    }
}

impl Emission<ast::TupleStructPat> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::TupleStructPat, label: Label<generated::TupleStructPat>) {
        self.extract_path_canonical_destination(node, label.into());
    }
}

impl Emission<ast::MethodCallExpr> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::MethodCallExpr, label: Label<generated::MethodCallExpr>) {
        self.extract_method_canonical_destination(node, label);
    }
}

impl Emission<ast::PathSegment> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::PathSegment, label: Label<generated::PathSegment>) {
        self.extract_types_from_path_segment(node, label);
    }
}

impl Emission<ast::Const> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::Const, label: Label<generated::Const>) {
        self.emit_const_has_implementation(node, label);
    }
}

impl Emission<ast::MacroCall> for Translator<'_> {
    fn post_emit(&mut self, node: &ast::MacroCall, label: Label<generated::MacroCall>) {
        self.extract_macro_call_expanded(node, label);
    }
}

// see https://github.com/tokio-rs/tracing/issues/2730
macro_rules! dispatch_to_tracing {
    ($lvl:ident, $($arg:tt)+) => {
        match $lvl {
            DiagnosticSeverity::Debug => ::tracing::debug!($($arg)+),
            DiagnosticSeverity::Info => ::tracing::info!($($arg)+),
            DiagnosticSeverity::Warning => ::tracing::warn!($($arg)+),
            DiagnosticSeverity::Error => ::tracing::error!($($arg)+),
        }
    };
}

#[derive(Copy, Clone, PartialEq, Eq)]
pub enum ResolvePaths {
    Yes,
    No,
}
#[derive(Copy, Clone, PartialEq, Eq)]
pub enum SourceKind {
    Source,
    Library,
}

pub struct Translator<'a> {
    pub trap: TrapFile,
    path: &'a str,
    label: Label<generated::File>,
    line_index: LineIndex,
    file_id: Option<EditionedFileId>,
    pub semantics: Option<&'a Semantics<'a, RootDatabase>>,
    resolve_paths: bool,
    source_kind: SourceKind,
    pub(crate) macro_context_depth: usize,
    diagnostic_count: usize,
}

const UNKNOWN_LOCATION: (LineCol, LineCol) =
    (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 });

const DIAGNOSTIC_LIMIT_PER_FILE: usize = 100;

impl<'a> Translator<'a> {
    pub fn new(
        trap: TrapFile,
        path: &'a str,
        label: Label<generated::File>,
        line_index: LineIndex,
        semantic_info: Option<&FileSemanticInformation<'a>>,
        resolve_paths: ResolvePaths,
        source_kind: SourceKind,
    ) -> Translator<'a> {
        Translator {
            trap,
            path,
            label,
            line_index,
            file_id: semantic_info.map(|i| i.file_id),
            semantics: semantic_info.map(|i| i.semantics),
            resolve_paths: resolve_paths == ResolvePaths::Yes,
            source_kind,
            macro_context_depth: 0,
            diagnostic_count: 0,
        }
    }
    fn location(&self, range: TextRange) -> Option<(LineCol, LineCol)> {
        let start = self.line_index.try_line_col(range.start())?;
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
                return Some((start, end));
            }
        }
        let end = self.line_index.try_line_col(range_end)?;
        Some((start, end))
    }

    pub fn text_range_for_node(&mut self, node: &impl ast::AstNode) -> Option<TextRange> {
        if let Some(semantics) = self.semantics.as_ref() {
            let file_range = semantics.original_range(node.syntax());
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

    fn location_for_node(&mut self, node: &impl ast::AstNode) -> Option<(LineCol, LineCol)> {
        self.text_range_for_node(node)
            .and_then(|r| self.location(r))
    }

    pub fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: &impl ast::AstNode) {
        match self.location_for_node(node) {
            None => self.emit_diagnostic(
                DiagnosticSeverity::Debug,
                "locations".to_owned(),
                "missing location for AstNode".to_owned(),
                "missing location for AstNode".to_owned(),
                UNKNOWN_LOCATION,
            ),
            Some((start, end)) => self.trap.emit_location(self.label, label, start, end),
        };
    }
    pub fn emit_location_token(
        &mut self,
        label: Label<generated::Token>,
        parent: &impl ast::AstNode,
        token: &SyntaxToken,
    ) {
        let parent_range = parent.syntax().text_range();
        let token_range = token.text_range();
        if let Some(clipped_range) = token_range.intersect(parent_range) {
            if let Some(parent_range2) = self.text_range_for_node(parent) {
                let token_range = clipped_range + parent_range2.start() - parent_range.start();
                if let Some((start, end)) = self.location(token_range) {
                    self.trap.emit_location(self.label, label, start, end)
                }
            }
        }
    }
    pub fn emit_diagnostic(
        &mut self,
        severity: DiagnosticSeverity,
        tag: String,
        message: String,
        full_message: String,
        location: (LineCol, LineCol),
    ) {
        let severity = if self.source_kind == SourceKind::Library {
            match severity {
                DiagnosticSeverity::Error => DiagnosticSeverity::Info,
                _ => DiagnosticSeverity::Debug,
            }
        } else {
            severity
        };
        if severity > DiagnosticSeverity::Debug {
            self.diagnostic_count += 1;
            if self.diagnostic_count > DIAGNOSTIC_LIMIT_PER_FILE {
                return;
            }
        }
        self.emit_diagnostic_unchecked(severity, tag, message, full_message, location);
    }
    pub fn emit_truncated_diagnostics_message(&mut self) {
        if self.diagnostic_count > DIAGNOSTIC_LIMIT_PER_FILE {
            let count = self.diagnostic_count - DIAGNOSTIC_LIMIT_PER_FILE;
            self.emit_diagnostic_unchecked(
                DiagnosticSeverity::Warning,
                "diagnostics".to_owned(),
                "Too many diagnostic messages".to_owned(),
                format!(
                    "Too many diagnostic messages, {count} diagnostic messages were suppressed"
                ),
                UNKNOWN_LOCATION,
            );
        }
    }
    fn emit_diagnostic_unchecked(
        &mut self,
        severity: DiagnosticSeverity,
        tag: String,
        message: String,
        full_message: String,
        location: (LineCol, LineCol),
    ) {
        let (start, end) = location;
        dispatch_to_tracing!(
            severity,
            "{}:{}:{}: {}",
            self.path,
            start.line + 1,
            start.col + 1,
            &full_message,
        );

        if severity > DiagnosticSeverity::Debug {
            let location = self.trap.emit_location_label(self.label, start, end);
            self.trap
                .emit_diagnostic(severity, tag, message, full_message, location);
        }
    }

    pub fn emit_diagnostic_for_node(
        &mut self,
        node: &impl ast::AstNode,
        severity: DiagnosticSeverity,
        tag: String,
        message: String,
        full_message: String,
    ) {
        let location = self.location_for_node(node);
        self.emit_diagnostic(
            severity,
            tag,
            message,
            full_message,
            location.unwrap_or(UNKNOWN_LOCATION),
        );
    }

    pub fn emit_parse_error(&mut self, owner: &impl ast::AstNode, err: &SyntaxError) {
        let owner_range: TextRange = owner.syntax().text_range();
        let err_range = err.range();
        if let Some(owner_range2) = self.text_range_for_node(owner) {
            let location = if let Some(clipped_range) = err_range.intersect(owner_range) {
                let err_range = clipped_range + owner_range2.start() - owner_range.start();
                self.location(err_range)
            } else {
                self.location(owner_range2)
            };
            let message = err.to_string();
            self.emit_diagnostic(
                DiagnosticSeverity::Warning,
                "parse_error".to_owned(),
                message.clone(),
                message,
                location.unwrap_or(UNKNOWN_LOCATION),
            );
        }
    }
    pub fn emit_tokens(
        &mut self,
        parent_node: &impl ast::AstNode,
        parent_label: Label<generated::AstNode>,
        children: SyntaxElementChildren,
    ) {
        for child in children {
            if let NodeOrToken::Token(token) = child {
                if token.kind() == SyntaxKind::COMMENT {
                    let label = self.trap.emit(generated::Comment {
                        id: TrapId::Star,
                        parent: parent_label,
                        text: token.text().to_owned(),
                    });
                    self.emit_location_token(label.into(), parent_node, &token);
                }
            }
        }
    }
    fn emit_macro_expansion_parse_errors(
        &mut self,
        node: &impl ast::AstNode,
        expanded: &SyntaxNode,
    ) {
        let semantics = self.semantics.as_ref().unwrap();
        if let Some(value) = semantics
            .hir_file_for(expanded)
            .macro_file()
            .and_then(|macro_call_id| semantics.db.parse_macro_expansion_error(macro_call_id))
        {
            if let Some(err) = &value.err {
                let error = err.render_to_string(semantics.db);
                let hir_file_id = semantics.hir_file_for(node.syntax());
                if Some(err.span().anchor.file_id.file_id())
                    == hir_file_id.file_id().map(|f| f.file_id(semantics.db))
                {
                    let location = err.span().range
                        + semantics
                            .db
                            .ast_id_map(hir_file_id)
                            .get_erased(err.span().anchor.ast_id)
                            .text_range()
                            .start();
                    self.emit_parse_error(node, &SyntaxError::new(error.message, location));
                };
            }
            for err in value.value.iter() {
                self.emit_parse_error(node, err);
            }
        }
    }

    fn emit_expanded_as(
        &mut self,
        expand_to: ExpandTo,
        expanded: SyntaxNode,
    ) -> Option<Label<generated::AstNode>> {
        match expand_to {
            ra_ap_hir_expand::ExpandTo::Statements => ast::MacroStmts::cast(expanded)
                .and_then(|x| self.emit_macro_stmts(&x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Items => ast::MacroItems::cast(expanded)
                .and_then(|x| self.emit_macro_items(&x))
                .map(Into::into),

            ra_ap_hir_expand::ExpandTo::Pattern => ast::Pat::cast(expanded)
                .and_then(|x| self.emit_pat(&x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Type => ast::Type::cast(expanded)
                .and_then(|x| self.emit_type(&x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Expr => ast::Expr::cast(expanded)
                .and_then(|x| self.emit_expr(&x))
                .map(Into::into),
        }
    }
    pub(crate) fn extract_macro_call_expanded(
        &mut self,
        mcall: &ast::MacroCall,
        label: Label<generated::MacroCall>,
    ) {
        if self.macro_context_depth > 0 {
            // we are in an attribute macro, don't emit anything: we would be failing to expand any
            // way as from version 0.0.274 rust-analyser only expands in the context of an expansion
            return;
        }
        if let Some(expanded) = self
            .semantics
            .as_ref()
            .and_then(|s| s.expand_macro_call(mcall))
        {
            self.emit_macro_expansion_parse_errors(mcall, &expanded.value);
            let expand_to = ra_ap_hir_expand::ExpandTo::from_call_site(mcall);
            let kind = expanded.kind();
            if let Some(value) = self.emit_expanded_as(expand_to, expanded.value) {
                generated::MacroCall::emit_macro_call_expansion(
                    label,
                    value,
                    &mut self.trap.writer,
                );
            } else {
                let range = self.text_range_for_node(mcall);
                self.emit_parse_error(mcall, &SyntaxError::new(
                    format!(
                        "macro expansion failed: the macro '{}' expands to {:?} but a {:?} was expected",
                        mcall.path().map(|p| p.to_string()).unwrap_or_default(),
                        kind, expand_to
                    ),
                    range.unwrap_or_else(|| TextRange::empty(TextSize::from(0))),
                ));
            }
        } else if self.semantics.is_some() {
            // let's not spam warnings if we don't have semantics, we already emitted one
            let range = self.text_range_for_node(mcall);
            self.emit_parse_error(
                mcall,
                &SyntaxError::new(
                    format!(
                        "macro expansion failed: could not resolve macro '{}'",
                        mcall.path().map(|p| p.to_string()).unwrap_or_default()
                    ),
                    range.unwrap_or_else(|| TextRange::empty(TextSize::from(0))),
                ),
            );
        }
    }

    pub(crate) fn emit_else_branch(
        &mut self,
        node: &ast::ElseBranch,
    ) -> Option<Label<generated::Expr>> {
        match node {
            ast::ElseBranch::IfExpr(inner) => self.emit_if_expr(inner).map(Into::into),
            ast::ElseBranch::Block(inner) => self.emit_block_expr(inner).map(Into::into),
        }
    }

    fn canonical_path_from_type(&self, ty: Type) -> Option<String> {
        let sema = self.semantics.as_ref().unwrap();
        // rust-analyzer doesn't provide a type enum directly
        if let Some(it) = ty.as_adt() {
            return match it {
                Adt::Struct(it) => self.canonical_path_from_hir(it),
                Adt::Union(it) => self.canonical_path_from_hir(it),
                Adt::Enum(it) => self.canonical_path_from_hir(it),
            };
        };
        if let Some((it, size)) = ty.as_array(sema.db) {
            return self
                .canonical_path_from_type(it)
                .map(|p| format!("[{p}; {size}]"));
        }
        if let Some(it) = ty.as_slice() {
            return self
                .canonical_path_from_type(it)
                .map(|p| format!("[{}]", p));
        }
        if let Some(it) = ty.as_builtin() {
            return Some(it.name().as_str().to_owned());
        }
        if let Some(it) = ty.as_dyn_trait() {
            return self.canonical_path_from_hir(it).map(|p| format!("dyn {p}"));
        }
        if let Some((it, mutability)) = ty.as_reference() {
            let mut_str = match mutability {
                Mutability::Shared => "",
                Mutability::Mut => "mut ",
            };
            return self
                .canonical_path_from_type(it)
                .map(|p| format!("&{mut_str}{p}"));
        }
        if let Some(it) = ty.as_impl_traits(sema.db) {
            let paths = it
                .map(|t| self.canonical_path_from_hir(t))
                .collect::<Option<Vec<_>>>()?;
            return Some(format!("impl {}", paths.join(" + ")));
        }
        if ty.as_type_param(sema.db).is_some() {
            // from the canonical path perspective, we just want a special name
            // e.g. `crate::<_ as SomeTrait>::func`
            return Some("_".to_owned());
        }
        None
    }

    fn canonical_path_from_hir_module(&self, item: Module) -> Option<String> {
        if ModuleId::from(item).containing_block().is_some() {
            // this means this is a block module, i.e. a virtual module for an anonymous block scope
            return None;
        }
        if item.is_crate_root() {
            return Some("crate".into());
        }
        self.canonical_path_from_hir::<ast::Module>(item)
    }

    fn canonical_path_from_hir<T: AstNode>(&self, item: impl AddressableHir<T>) -> Option<String> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let name = item.name(sema)?;
        let container = item.container(sema.db);
        let prefix = match container {
            ItemContainer::Trait(it) => self.canonical_path_from_hir(it),
            ItemContainer::Impl(it) => {
                let ty = self.canonical_path_from_type(it.self_ty(sema.db))?;
                if let Some(trait_) = it.trait_(sema.db) {
                    let tr = self.canonical_path_from_hir(trait_)?;
                    Some(format!("<{ty} as {tr}>"))
                } else {
                    Some(format!("<{ty}>"))
                }
            }
            ItemContainer::Module(it) => self.canonical_path_from_hir_module(it),
            ItemContainer::ExternBlock(..) | ItemContainer::Crate(..) => Some("".to_owned()),
        }?;
        Some(format!("{prefix}::{name}"))
    }

    fn canonical_path_from_module_def(&self, item: ModuleDef) -> Option<String> {
        match item {
            ModuleDef::Module(it) => self.canonical_path_from_hir(it),
            ModuleDef::Function(it) => self.canonical_path_from_hir(it),
            ModuleDef::Adt(Adt::Enum(it)) => self.canonical_path_from_hir(it),
            ModuleDef::Adt(Adt::Struct(it)) => self.canonical_path_from_hir(it),
            ModuleDef::Adt(Adt::Union(it)) => self.canonical_path_from_hir(it),
            ModuleDef::Trait(it) => self.canonical_path_from_hir(it),
            ModuleDef::Variant(it) => self.canonical_path_from_enum_variant(it),
            ModuleDef::Static(_) => None,
            ModuleDef::TraitAlias(_) => None,
            ModuleDef::TypeAlias(_) => None,
            ModuleDef::BuiltinType(_) => None,
            ModuleDef::Macro(_) => None,
            ModuleDef::Const(_) => None,
        }
    }

    fn canonical_path_from_enum_variant(&self, item: Variant) -> Option<String> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let prefix = self.canonical_path_from_hir(item.parent_enum(sema.db))?;
        let name = item.name(sema.db);
        Some(format!("{prefix}::{}", name.as_str()))
    }

    fn origin_from_hir<T: AstNode>(&self, item: impl AddressableHir<T>) -> String {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        self.origin_from_crate(item.module(sema).krate())
    }

    fn origin_from_crate(&self, item: Crate) -> String {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        match item.origin(sema.db) {
            CrateOrigin::Rustc { name } => format!("rustc:{}", name),
            CrateOrigin::Local { repo, name } => format!(
                "repo:{}:{}",
                repo.unwrap_or_default(),
                name.map(|s| s.as_str().to_owned()).unwrap_or_default()
            ),
            CrateOrigin::Library { repo, name } => {
                format!("repo:{}:{}", repo.unwrap_or_default(), name)
            }
            CrateOrigin::Lang(it) => format!("lang:{}", it),
        }
    }

    fn origin_from_module_def(&self, item: ModuleDef) -> Option<String> {
        match item {
            ModuleDef::Module(it) => Some(self.origin_from_hir(it)),
            ModuleDef::Function(it) => Some(self.origin_from_hir(it)),
            ModuleDef::Adt(Adt::Enum(it)) => Some(self.origin_from_hir(it)),
            ModuleDef::Adt(Adt::Struct(it)) => Some(self.origin_from_hir(it)),
            ModuleDef::Adt(Adt::Union(it)) => Some(self.origin_from_hir(it)),
            ModuleDef::Trait(it) => Some(self.origin_from_hir(it)),
            ModuleDef::Variant(it) => Some(self.origin_from_enum_variant(it)),
            ModuleDef::Static(_) => None,
            ModuleDef::TraitAlias(_) => None,
            ModuleDef::TypeAlias(_) => None,
            ModuleDef::BuiltinType(_) => None,
            ModuleDef::Macro(_) => None,
            ModuleDef::Const(_) => None,
        }
    }

    fn origin_from_enum_variant(&self, item: Variant) -> String {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        self.origin_from_hir(item.parent_enum(sema.db))
    }

    pub(crate) fn extract_canonical_origin<T: AddressableAst + HasName>(
        &mut self,
        item: &T,
        label: Label<generated::Addressable>,
    ) {
        if !self.resolve_paths {
            return;
        }
        (|| {
            let sema = self.semantics.as_ref()?;
            let def = T::Hir::try_from_source(item, sema)?;
            let path = self.canonical_path_from_hir(def)?;
            let origin = self.origin_from_hir(def);
            generated::Addressable::emit_crate_origin(label, origin, &mut self.trap.writer);
            generated::Addressable::emit_extended_canonical_path(
                label,
                path,
                &mut self.trap.writer,
            );
            Some(())
        })();
    }

    pub(crate) fn extract_canonical_origin_of_enum_variant(
        &mut self,
        item: &ast::Variant,
        label: Label<generated::Variant>,
    ) {
        if !self.resolve_paths {
            return;
        }
        (|| {
            let sema = self.semantics.as_ref()?;
            let def = sema.to_enum_variant_def(item)?;
            let path = self.canonical_path_from_enum_variant(def)?;
            let origin = self.origin_from_enum_variant(def);
            generated::Addressable::emit_crate_origin(label.into(), origin, &mut self.trap.writer);
            generated::Addressable::emit_extended_canonical_path(
                label.into(),
                path,
                &mut self.trap.writer,
            );
            Some(())
        })();
    }

    pub(crate) fn extract_path_canonical_destination(
        &mut self,
        item: &impl PathAst,
        label: Label<generated::Resolvable>,
    ) {
        if !self.resolve_paths {
            return;
        }
        (|| {
            let path = item.path()?;
            let sema = self.semantics.as_ref()?;
            let resolution = sema.resolve_path(&path)?;
            let PathResolution::Def(def) = resolution else {
                return None;
            };
            let origin = self.origin_from_module_def(def)?;
            let path = self.canonical_path_from_module_def(def)?;
            generated::Resolvable::emit_resolved_crate_origin(label, origin, &mut self.trap.writer);
            generated::Resolvable::emit_resolved_path(label, path, &mut self.trap.writer);
            Some(())
        })();
    }

    pub(crate) fn extract_method_canonical_destination(
        &mut self,
        item: &ast::MethodCallExpr,
        label: Label<generated::MethodCallExpr>,
    ) {
        if !self.resolve_paths {
            return;
        }
        (|| {
            let sema = self.semantics.as_ref()?;
            let resolved = sema.resolve_method_call_fallback(item)?;
            let (Either::Left(function), _) = resolved else {
                return None;
            };
            let origin = self.origin_from_hir(function);
            let path = self.canonical_path_from_hir(function)?;
            generated::Resolvable::emit_resolved_crate_origin(
                label.into(),
                origin,
                &mut self.trap.writer,
            );
            generated::Resolvable::emit_resolved_path(label.into(), path, &mut self.trap.writer);
            Some(())
        })();
    }

    pub(crate) fn should_be_excluded(&self, item: &impl ast::HasAttrs) -> bool {
        self.semantics.is_some_and(|sema| {
            item.attrs().any(|attr| {
                attr.as_simple_call().is_some_and(|(name, tokens)| {
                    name == "cfg" && sema.check_cfg_attr(&tokens) == Some(false)
                })
            })
        })
    }

    pub(crate) fn should_skip_bodies(&self) -> bool {
        self.source_kind == SourceKind::Library
    }

    pub(crate) fn extract_types_from_path_segment(
        &mut self,
        item: &ast::PathSegment,
        label: Label<generated::PathSegment>,
    ) {
        // work around a bug in rust-analyzer AST generation machinery
        // this code was inspired by rust-analyzer's own workaround for this:
        // https://github.com/rust-lang/rust-analyzer/blob/a642aa8023be11d6bc027fc6a68c71c2f3fc7f72/crates/syntax/src/ast/node_ext.rs#L290-L297
        if let Some(anchor) = item.type_anchor() {
            // <T> or <T as Trait>
            // T is any TypeRef, Trait has to be a PathType
            let mut type_refs = anchor
                .syntax()
                .children()
                .filter(|node| ast::Type::can_cast(node.kind()));
            if let Some(t) = type_refs
                .next()
                .and_then(ast::Type::cast)
                .and_then(|t| self.emit_type(&t))
            {
                generated::PathSegment::emit_type_repr(label, t, &mut self.trap.writer)
            }
            if let Some(t) = type_refs
                .next()
                .and_then(ast::PathType::cast)
                .and_then(|t| self.emit_path_type(&t))
            {
                generated::PathSegment::emit_trait_type_repr(label, t, &mut self.trap.writer)
            }
            // moreover as we're skipping emission of TypeAnchor, we need to attach its comments to
            // this path segment
            self.emit_tokens(
                &anchor,
                label.into(),
                anchor.syntax().children_with_tokens(),
            );
        }
    }

    fn is_attribute_macro_target(&self, node: &ast::Item) -> bool {
        // rust-analyzer considers as an `attr_macro_call` also a plain macro call, but we want to
        // process that differently (in `extract_macro_call_expanded`)
        !matches!(node, ast::Item::MacroCall(_))
            && self.semantics.is_some_and(|semantics| {
                let file = semantics.hir_file_for(node.syntax());
                let node = InFile::new(file, node);
                semantics.is_attr_macro_call(node)
            })
    }

    fn process_item_macro_expansion(
        &mut self,
        node: &impl ast::AstNode,
        ExpandResult { value, err }: ExpandResult<SyntaxNode>,
    ) -> Option<Label<generated::MacroItems>> {
        let semantics = self.semantics.unwrap(); // if we are here, we have semantics
        self.emit_macro_expansion_parse_errors(node, &value);
        if let Some(err) = err {
            let rendered = err.render_to_string(semantics.db);
            self.emit_diagnostic_for_node(
                node,
                DiagnosticSeverity::Warning,
                "item_expansion".to_owned(),
                format!("item expansion failed ({})", rendered.kind),
                rendered.message,
            );
        }
        if let Some(items) = ast::MacroItems::cast(value) {
            self.emit_macro_items(&items)
        } else {
            let message =
                "attribute or derive macro expansion cannot be cast to MacroItems".to_owned();
            self.emit_diagnostic_for_node(
                node,
                DiagnosticSeverity::Warning,
                "item_expansion".to_owned(),
                message.clone(),
                message,
            );
            None
        }
    }

    fn emit_attribute_macro_expansion(
        &mut self,
        node: &ast::Item,
    ) -> Option<Label<generated::MacroItems>> {
        if self.macro_context_depth > 0 {
            // only expand the outermost attribute macro
            return None;
        }
        let expansion = self.semantics?.expand_attr_macro(node)?;
        self.process_item_macro_expansion(node, expansion.map(|x| x.value))
    }

    pub(crate) fn item_pre_emit(
        &mut self,
        node: &ast::Item,
    ) -> Option<Label<generated::MacroCall>> {
        if !self.is_attribute_macro_target(node) {
            return None;
        }
        if self.source_kind == SourceKind::Library {
            // if the item expands via an attribute macro, we want to only emit the expansion
            if let Some(expanded) = self.emit_attribute_macro_expansion(node) {
                // we wrap it in a dummy MacroCall to get a single Item label that can replace
                // the original Item
                let label = self.trap.emit(generated::MacroCall {
                    id: TrapId::Star,
                    attrs: vec![],
                    path: None,
                    token_tree: None,
                });
                generated::Item::emit_attribute_macro_expansion(
                    label.into(),
                    expanded,
                    &mut self.trap.writer,
                );
                self.emit_location(label, node);
                return Some(label);
            }
        }
        self.macro_context_depth += 1;
        None
    }

    pub(crate) fn item_post_emit(&mut self, node: &ast::Item, label: Label<generated::Item>) {
        if !self.is_attribute_macro_target(node) {
            return;
        }
        // see `item_pre_emit`:
        // if self.is_attribute_macro_target(node), then we either exited early with `Some(label)`
        // and are not here, or we did self.macro_context_depth += 1
        assert!(
            self.macro_context_depth > 0,
            "macro_context_depth should be > 0 for an attribute macro target"
        );
        self.macro_context_depth -= 1;
        if let Some(expanded) = self.emit_attribute_macro_expansion(node) {
            generated::Item::emit_attribute_macro_expansion(label, expanded, &mut self.trap.writer);
        }
    }

    pub(crate) fn emit_function_has_implementation(
        &mut self,
        node: &ast::Fn,
        label: Label<generated::Function>,
    ) {
        if node.body().is_some() {
            generated::Function::emit_has_implementation(label, &mut self.trap.writer);
        }
    }

    pub(crate) fn emit_const_has_implementation(
        &mut self,
        node: &ast::Const,
        label: Label<generated::Const>,
    ) {
        if node.body().is_some() {
            generated::Const::emit_has_implementation(label, &mut self.trap.writer);
        }
    }

    pub(crate) fn emit_derive_expansion(
        &mut self,
        node: &(impl Into<ast::Adt> + Clone),
        label: impl Into<Label<generated::Adt>> + Copy,
    ) {
        let Some(semantics) = self.semantics else {
            return;
        };
        let node: ast::Adt = node.clone().into();
        let expansions = node
            .attrs()
            .filter_map(|attr| semantics.expand_derive_macro(&attr))
            .flatten()
            .filter_map(|expanded| self.process_item_macro_expansion(&node, expanded))
            .collect::<Vec<_>>();
        generated::Adt::emit_derive_macro_expansions(
            label.into(),
            expansions,
            &mut self.trap.writer,
        );
    }
}
