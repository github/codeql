use super::mappings::{AddressableAst, AddressableHir, PathAst};
use crate::generated::MacroCall;
use crate::generated::{self};
use crate::rust_analyzer::FileSemanticInformation;
use crate::trap::AsTrapKeyPart;
use crate::trap::{DiagnosticSeverity, TrapFile, TrapId};
use crate::trap::{Label, TrapClass};
use crate::trap_key;
use itertools::{Either, Itertools};
use log::{warn, Level};
use ra_ap_base_db::CrateOrigin;
use ra_ap_hir::db::ExpandDatabase;
use ra_ap_hir::{
    Adt, Crate, Enum, ItemContainer, Module, ModuleDef, PathResolution, Semantics, Trait, TraitRef,
    Type, Variant,
};
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
use ra_ap_vfs::Vfs;
use std::path::PathBuf;

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
    vfs: Option<&'a Vfs>,
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
            vfs: semantic_info.map(|i| i.vfs),
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
                let (message, _error) = err.render_to_string(semantics.db);

                if err.span().anchor.file_id == semantics.hir_file_for(mcall.syntax()) {
                    let location = err.span().range
                        + semantics
                            .db
                            .ast_id_map(err.span().anchor.file_id.into())
                            .get_erased(err.span().anchor.ast_id)
                            .text_range()
                            .start();
                    self.emit_parse_error(mcall, &SyntaxError::new(message, location));
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
        }
    }
    pub(crate) fn extract_macro_call_expanded(
        &mut self,
        mcall: &ast::MacroCall,
        label: Label<generated::MacroCall>,
    ) {
        if let Some(expanded) = self.semantics.as_ref().and_then(|s| s.expand(mcall)) {
            self.emit_macro_expansion_parse_errors(mcall, &expanded);
            let expand_to = ra_ap_hir_expand::ExpandTo::from_call_site(mcall);
            let kind = expanded.kind();
            if let Some(value) = self.emit_expanded_as(expand_to, expanded) {
                MacroCall::emit_expanded(label, value, &mut self.trap.writer);
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

    fn emit_derived_type_canonical_path<T: AsRef<str>>(
        &mut self,
        modifiers: &[T],
        bases: Vec<Label<generated::TypeCanonicalPath>>,
    ) -> Label<generated::TypeCanonicalPath> {
        let modifiers = modifiers
            .iter()
            .map(|s| s.as_ref().to_owned())
            .collect::<Vec<String>>();
        let id = itertools::interleave(
            modifiers.iter().cloned(),
            bases.iter().map(|t| t.as_key_part()),
        )
        .join("")
        .into();
        self.trap
            .emit(generated::DerivedTypeCanonicalPath {
                id,
                modifiers,
                base: bases,
            })
            .into()
    }

    fn canonical_path_from_type(
        &mut self,
        ty: Type,
    ) -> Option<Label<generated::TypeCanonicalPath>> {
        let sema = self.semantics.as_ref().unwrap();
        // rust-analyzer doesn't provide a type enum directly
        if let Some(it) = ty.as_adt() {
            let name = it.name(sema.db).as_str().to_owned();
            let module = it.module(sema.db);
            let mut generic_args = Vec::new();
            for arg in ty.type_arguments() {
                let path = self.canonical_path_from_type(arg)?;
                generic_args.push(
                    self.trap
                        .emit(generated::TypeGenericTypeArg {
                            id: trap_key!(path),
                            path,
                        })
                        .into(),
                );
            }
            let namespace = self.canonical_path_from_hir_module(module)?;
            let base = self.trap.emit(generated::ModuleItemCanonicalPath {
                id: trap_key!(namespace, "::", name),
                namespace,
                name,
            });
            let path = self.trap.emit(generated::ParametrizedCanonicalPath {
                id: trap_key!(base, generic_args),
                base,
                generic_args,
            });
            Some(
                self.trap
                    .emit(generated::ConcreteTypeCanonicalPath {
                        id: trap_key!(path),
                        path,
                    })
                    .into(),
            )
        } else if let Some((it, size)) = ty.as_array(sema.db) {
            let modifiers = ["[".to_owned(), format!("; {size}]")];
            let bases = vec![self.canonical_path_from_type(it)?];
            Some(self.emit_derived_type_canonical_path(&modifiers, bases))
        } else if let Some(it) = ty.as_slice() {
            let modifiers = ["[", "]"];
            let bases = vec![self.canonical_path_from_type(it)?];
            Some(self.emit_derived_type_canonical_path(&modifiers, bases))
        } else if ty.is_unit() {
            let modifiers = ["()"];
            let bases = vec![];
            Some(self.emit_derived_type_canonical_path(&modifiers, bases))
        } else if let Some(it) = ty.as_builtin() {
            let name = it.name().as_str().to_owned();
            Some(
                self.trap
                    .emit(generated::BuiltinTypeCanonicalPath {
                        id: trap_key!(name),
                        name,
                    })
                    .into(),
            )
        } else if let Some((it, mutability)) = ty.as_reference() {
            let modifiers = [format!("&{}", mutability.as_keyword_for_ref())];
            let bases = vec![self.canonical_path_from_type(it)?];
            Some(self.emit_derived_type_canonical_path(&modifiers, bases))
        } else if ty.as_type_param(sema.db).is_some() {
            // from the canonical path perspective, we just want a special name
            // e.g. `crate::<_ as SomeTrait>::func`
            // TODO: This will not work for assigning trap keys to types themselves!
            Some(
                self.trap
                    .emit(generated::PlaceholderTypeCanonicalPath { id: trap_key!("_") })
                    .into(),
            )
        } else {
            let tuple_args = ty.tuple_fields(sema.db);
            if tuple_args.is_empty() {
                None
            } else {
                let modifiers = std::iter::once("(")
                    .chain(std::iter::repeat(", ").take(tuple_args.len() - 1))
                    .chain(std::iter::once(")"))
                    .collect::<Vec<_>>();
                let bases = tuple_args
                    .into_iter()
                    .map(|arg| self.canonical_path_from_type(arg))
                    .collect::<Option<Vec<_>>>()?;
                Some(self.emit_derived_type_canonical_path(&modifiers, bases))
            }
        }
    }

    fn emit_crate_root(&mut self, item: Crate) -> Option<Label<generated::CrateRoot>> {
        let db = self.semantics.unwrap().db;
        let (repo, name) = match item.origin(db) {
            CrateOrigin::Rustc { name } => (None, Some(name)),
            CrateOrigin::Local { repo, name } => (repo, name),
            CrateOrigin::Library { repo, name } => (repo, Some(name)),
            CrateOrigin::Lang(it) => {
                let name = it.to_string();
                return Some(
                    self.trap
                        .emit(generated::LangCrateRoot {
                            id: trap_key!(name),
                            name,
                        })
                        .into(),
                );
            }
        };
        let name = name.map(|s| s.to_string());
        let vfs_path = self.vfs.unwrap().file_path(item.root_file(db));
        let Some(file) = vfs_path.as_path() else {
            warn!("Crate root file not found: {}", vfs_path);
            return None;
        };
        let source = self.trap.emit_file(&PathBuf::from(file.as_os_str()));
        Some(
            self.trap
                .emit(generated::RepoCrateRoot {
                    id: trap_key!(source, name, repo),
                    name,
                    repo,
                    source,
                })
                .into(),
        )
    }

    fn canonical_path_from_hir_module(
        &mut self,
        item: Module,
    ) -> Option<Label<generated::Namespace>> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        // do not assign namespaces to unnamed modules, i.e. a virtual modules for block scopes
        if ModuleId::from(item).is_block_module() {
            return None;
        }
        let path = item
            .path_to_root(sema.db)
            .iter()
            .filter_map(|m| m.name(sema.db))
            .map(|n| n.as_str().to_owned())
            .join("::");
        let root = self.emit_crate_root(item.krate())?;
        Some(self.trap.emit(generated::Namespace {
            id: trap_key!(root, "::", path),
            root,
            path,
        }))
    }

    fn canonical_path_from_trait(
        &mut self,
        item: Trait,
    ) -> Option<Label<generated::ModuleItemCanonicalPath>> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let module = item.module(sema.db);
        let name = item.name(sema.db).as_str().to_owned();
        let namespace = self.canonical_path_from_hir_module(module)?;
        Some(self.trap.emit(generated::ModuleItemCanonicalPath {
            id: trap_key!(namespace, "::", name),
            namespace,
            name,
        }))
    }

    fn canonical_path_from_enum(
        &mut self,
        item: Enum,
    ) -> Option<Label<generated::ModuleItemCanonicalPath>> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let module = item.module(sema.db);
        let name = item.name(sema.db).as_str().to_owned();
        let namespace = self.canonical_path_from_hir_module(module)?;
        Some(self.trap.emit(generated::ModuleItemCanonicalPath {
            id: trap_key!(namespace, "::", name),
            namespace,
            name,
        }))
    }

    fn canonical_path_from_trait_ref(
        &mut self,
        item: TraitRef,
    ) -> Option<Label<generated::ParametrizedCanonicalPath>> {
        let db = self.semantics.unwrap().db;
        let trait_ = item.trait_();
        let base = self.canonical_path_from_trait(trait_)?;
        let param_count = trait_.type_or_const_param_count(db, false);
        let mut generic_args = Vec::new();
        for i in 1..=param_count {
            // TODO seems like you can't get const arguments currently...
            let arg = item.get_type_argument(i)?;
            let path = self.canonical_path_from_type(arg)?;
            generic_args.push(
                self.trap
                    .emit(generated::TypeGenericTypeArg {
                        id: trap_key!(path),
                        path,
                    })
                    .into(),
            );
        }
        Some(self.trap.emit(generated::ParametrizedCanonicalPath {
            id: trap_key!(base, generic_args),
            base,
            generic_args,
        }))
    }

    fn canonical_path_from_hir<T: AstNode>(
        &mut self,
        item: impl AddressableHir<T>,
    ) -> Option<Label<generated::CanonicalPath>> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let name = item.name(sema)?;
        match item.container(sema.db) {
            ItemContainer::Trait(it) => {
                let parent = self.canonical_path_from_trait(it)?;
                Some(
                    self.trap
                        .emit(generated::TypeItemCanonicalPath {
                            id: trap_key!(parent, "::", name),
                            parent,
                            name,
                        })
                        .into(),
                )
            }
            ItemContainer::Impl(it) => {
                let trait_ref = it.trait_ref(sema.db);
                let type_path = self.canonical_path_from_type(it.self_ty(sema.db))?;
                let trait_path = trait_ref.and_then(|t| self.canonical_path_from_trait_ref(t));
                Some(
                    self.trap
                        .emit(generated::ImplItemCanonicalPath {
                            id: trap_key!("<", type_path, "as", trait_path, ">::", name),
                            type_path,
                            trait_path,
                            name,
                        })
                        .into(),
                )
            }
            ItemContainer::Module(it) => {
                let namespace = self.canonical_path_from_hir_module(it)?;
                Some(
                    self.trap
                        .emit(generated::ModuleItemCanonicalPath {
                            id: trap_key!(namespace, "::", name),
                            namespace,
                            name,
                        })
                        .into(),
                )
            }
            ItemContainer::ExternBlock() => None,
            ItemContainer::Crate(_) => None,
        }
    }

    fn canonical_path_from_module_def(
        &mut self,
        item: ModuleDef,
    ) -> Option<Label<generated::CanonicalPath>> {
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

    fn canonical_path_from_enum_variant(
        &mut self,
        item: Variant,
    ) -> Option<Label<generated::CanonicalPath>> {
        // if we have a Hir entity, it means we have semantics
        let sema = self.semantics.as_ref().unwrap();
        let enum_ = item.parent_enum(sema.db);
        let name = item.name(sema.db).as_str().to_owned();
        let parent = self.canonical_path_from_enum(enum_)?;
        Some(
            self.trap
                .emit(generated::TypeItemCanonicalPath {
                    id: trap_key!(parent, "::", name),
                    parent,
                    name,
                })
                .into(),
        )
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
            generated::Addressable::emit_canonical_path(label, path, &mut self.trap.writer);
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
            generated::Addressable::emit_canonical_path(label.into(), path, &mut self.trap.writer);
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
            let path = self.canonical_path_from_module_def(def)?;
            generated::Resolvable::emit_resolved_canonical_path(label, path, &mut self.trap.writer);
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
            let Either::Left(function) = resolved else {
                return None;
            };
            let path = self.canonical_path_from_hir(function)?;
            generated::Resolvable::emit_resolved_canonical_path(
                label.into(),
                path,
                &mut self.trap.writer,
            );
            Some(())
        })();
    }
}
