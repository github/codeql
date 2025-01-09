use super::mappings::{AddressableAst, AddressableHir, PathAst};
use crate::generated::{self};
use crate::rust_analyzer::FileSemanticInformation;
use crate::trap::{DiagnosticSeverity, TrapFile, TrapId};
use crate::trap::{Label, TrapClass};
use itertools::Either;
use log::Level;
use ra_ap_base_db::ra_salsa::InternKey;
use ra_ap_base_db::CrateOrigin;
use ra_ap_hir::db::ExpandDatabase;
use ra_ap_hir::{
    Adt, Crate, ItemContainer, Module, ModuleDef, PathResolution, Semantics, Type, Variant,
};
use ra_ap_hir_def::type_ref::Mutability;
use ra_ap_hir_def::ModuleId;
use ra_ap_hir_expand::ExpandTo;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_ide_db::RootDatabase;
use ra_ap_parser::SyntaxKind;
use ra_ap_span::{EditionedFileId, TextSize};
use ra_ap_syntax::ast::HasName;
use ra_ap_syntax::{
    ast, AstNode, NodeOrToken, SyntaxElementChildren, SyntaxError, SyntaxNode, SyntaxToken,
    TextRange,
};

#[macro_export]
macro_rules! emit_detached {
    (MacroCall, $self:ident, $node:ident, $label:ident) => {
        $self.extract_macro_call_expanded(&$node, $label);
    };
    (Function, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Trait, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Struct, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Enum, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Union, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Module, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin(&$node, $label.into());
    };
    (Variant, $self:ident, $node:ident, $label:ident) => {
        $self.extract_canonical_origin_of_enum_variant(&$node, $label);
    };
    // TODO canonical origin of other items
    (PathExpr, $self:ident, $node:ident, $label:ident) => {
        $self.extract_path_canonical_destination(&$node, $label.into());
    };
    (RecordExpr, $self:ident, $node:ident, $label:ident) => {
        $self.extract_path_canonical_destination(&$node, $label.into());
    };
    (PathPat, $self:ident, $node:ident, $label:ident) => {
        $self.extract_path_canonical_destination(&$node, $label.into());
    };
    (RecordPat, $self:ident, $node:ident, $label:ident) => {
        $self.extract_path_canonical_destination(&$node, $label.into());
    };
    (TupleStructPat, $self:ident, $node:ident, $label:ident) => {
        $self.extract_path_canonical_destination(&$node, $label.into());
    };
    (MethodCallExpr, $self:ident, $node:ident, $label:ident) => {
        $self.extract_method_canonical_destination(&$node, $label);
    };
    ($($_:tt)*) => {};
}

pub struct Translator<'a> {
    pub trap: TrapFile,
    path: &'a str,
    label: Label<generated::File>,
    line_index: LineIndex,
    file_id: Option<EditionedFileId>,
    pub semantics: Option<&'a Semantics<'a, RootDatabase>>,
}

impl<'a> Translator<'a> {
    pub fn new(
        trap: TrapFile,
        path: &'a str,
        label: Label<generated::File>,
        line_index: LineIndex,
        semantic_info: Option<&FileSemanticInformation<'a>>,
    ) -> Translator<'a> {
        Translator {
            trap,
            path,
            label,
            line_index,
            file_id: semantic_info.map(|i| i.file_id),
            semantics: semantic_info.map(|i| i.semantics),
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
    pub fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: &impl ast::AstNode) {
        if let Some(range) = self.text_range_for_node(node) {
            let (start, end) = self.location(range);
            self.trap.emit_location(self.label, label, start, end)
        } else {
            self.emit_diagnostic(
                DiagnosticSeverity::Debug,
                "locations".to_owned(),
                "missing location for AstNode".to_owned(),
                "missing location for AstNode".to_owned(),
                (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 }),
            );
        }
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
                let (start, end) = self.location(token_range);
                self.trap.emit_location(self.label, label, start, end)
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
            &full_message
        );
        if severity > DiagnosticSeverity::Debug {
            let location = self.trap.emit_location_label(self.label, start, end);
            self.trap
                .emit_diagnostic(severity, tag, message, full_message, location);
        }
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
                location,
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
    fn emit_macro_expansion_parse_errors(&mut self, mcall: &ast::MacroCall, expanded: &SyntaxNode) {
        let semantics = self.semantics.as_ref().unwrap();
        if let Some(value) = semantics
            .hir_file_for(expanded)
            .macro_file()
            .and_then(|macro_file| {
                semantics
                    .db
                    .parse_macro_expansion_error(macro_file.macro_call_id)
            })
        {
            if let Some(err) = &value.err {
                let error = err.render_to_string(semantics.db);

                if err.span().anchor.file_id == semantics.hir_file_for(mcall.syntax()) {
                    let location = err.span().range
                        + semantics
                            .db
                            .ast_id_map(err.span().anchor.file_id.into())
                            .get_erased(err.span().anchor.ast_id)
                            .text_range()
                            .start();
                    self.emit_parse_error(mcall, &SyntaxError::new(error.message, location));
                };
            }
            for err in value.value.iter() {
                self.emit_parse_error(mcall, err);
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
                .and_then(|x| self.emit_macro_stmts(x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Items => ast::MacroItems::cast(expanded)
                .and_then(|x| self.emit_macro_items(x))
                .map(Into::into),

            ra_ap_hir_expand::ExpandTo::Pattern => ast::Pat::cast(expanded)
                .and_then(|x| self.emit_pat(x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Type => ast::Type::cast(expanded)
                .and_then(|x| self.emit_type(x))
                .map(Into::into),
            ra_ap_hir_expand::ExpandTo::Expr => ast::Expr::cast(expanded)
                .and_then(|x| self.emit_expr(x))
                .map(Into::into),
        }
    }
    pub(crate) fn extract_macro_call_expanded(
        &mut self,
        mcall: &ast::MacroCall,
        label: Label<generated::MacroCall>,
    ) {
        if let Some(expanded) = self
            .semantics
            .as_ref()
            .and_then(|s| s.expand_macro_call(mcall))
        {
            self.emit_macro_expansion_parse_errors(mcall, &expanded);
            let expand_to = ra_ap_hir_expand::ExpandTo::from_call_site(mcall);
            let kind = expanded.kind();
            if let Some(value) = self.emit_expanded_as(expand_to, expanded) {
                generated::MacroCall::emit_expanded(label, value, &mut self.trap.writer);
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
        if let Some(block_id) = ModuleId::from(item).containing_block() {
            // this means this is a block module, i.e. a virtual module for a block scope
            return Some(format!("{{{}}}", block_id.as_intern_id()));
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
            ItemContainer::ExternBlock() | ItemContainer::Crate(_) => Some("".to_owned()),
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
}
