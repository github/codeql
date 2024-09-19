use crate::archive::Archiver;
use crate::trap::{AsTrapKeyPart, Label, TrapClass, TrapFile, TrapId};
use crate::{generated, trap_key};
use codeql_extractor::trap;
use ra_ap_hir::db::{DefDatabase, InternDatabase};
use ra_ap_hir::HasSource;
use ra_ap_hir::TypeRef;
use ra_ap_hir::{Crate, Module, ModuleDef};
use ra_ap_hir_def::body::{Body, BodySourceMap};
use ra_ap_hir_def::hir::{
    CaptureBy, ExprId, LabelId, MatchArm, PatId, RecordFieldPat, RecordLitField, Statement,
};
use ra_ap_hir_def::path::Path;
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_ide_db::{LineIndexDatabase, RootDatabase};
use ra_ap_syntax::ast::RangeOp;
use ra_ap_syntax::{AstNode, Edition, TextRange, TextSize};
use ra_ap_vfs::{FileId, Vfs};
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use triomphe::Arc;

#[derive(Clone)]
struct FileData {
    label: trap::Label,
    line_index: Arc<LineIndex>,
}
pub struct CrateTranslator<'a> {
    db: &'a RootDatabase,
    trap: TrapFile,
    krate: &'a Crate,
    vfs: &'a Vfs,
    archiver: &'a Archiver,
    file_labels: HashMap<PathBuf, FileData>,
}

impl CrateTranslator<'_> {
    pub fn new<'a>(
        db: &'a RootDatabase,
        trap: TrapFile,
        krate: &'a Crate,
        vfs: &'a Vfs,
        archiver: &'a Archiver,
    ) -> CrateTranslator<'a> {
        CrateTranslator {
            db,
            trap,
            krate,
            vfs,
            archiver,
            file_labels: HashMap::new(),
        }
    }

    fn emit_file(&mut self, file_id: FileId) -> Option<FileData> {
        self.vfs.file_path(file_id).as_path().and_then(|abs_path| {
            let mut canonical = PathBuf::from(abs_path.as_str());
            if !self.file_labels.contains_key(&canonical) {
                self.archiver.archive(&canonical);
                canonical = fs::canonicalize(&canonical).unwrap_or(canonical);
                let label = self.trap.emit_file(&canonical);
                let line_index = <dyn LineIndexDatabase>::line_index(self.db, file_id);
                self.file_labels
                    .insert(canonical.clone(), FileData { label, line_index });
            }
            self.file_labels.get(&canonical).cloned()
        })
    }

    fn emit_location_for_ast_ptr<E: TrapClass, T: AstNode>(
        &mut self,
        label: Label<E>,
        source: ra_ap_hir::InFile<ra_ap_syntax::AstPtr<T>>,
    ) {
        if let Some(data) = source
            .file_id
            .file_id()
            .map(|f| f.file_id())
            .and_then(|file_id| self.emit_file(file_id))
        {
            let range = source.value.text_range();
            self.emit_location_for_textrange(label, data, range)
        }
    }

    fn emit_location_for_expr<E: TrapClass>(
        &mut self,
        label: Label<E>,
        expr: ra_ap_hir_def::hir::ExprId,
        source_map: &BodySourceMap,
    ) {
        if let Ok(source) = source_map.expr_syntax(expr) {
            self.emit_location_for_ast_ptr(label, source);
        }
    }

    fn emit_location_for_pat<E: TrapClass>(
        &mut self,
        label: Label<E>,
        pat_id: ra_ap_hir_def::hir::PatId,
        source_map: &BodySourceMap,
    ) {
        if let Ok(source) = source_map.pat_syntax(pat_id) {
            self.emit_location_for_ast_ptr(label, source);
        }
    }

    fn emit_literal_or_const_pat(
        &mut self,
        pat: &ra_ap_hir_def::hir::LiteralOrConst,
        body: &Body,
        source_map: &BodySourceMap,
        emit_location: impl FnOnce(&mut CrateTranslator<'_>, Label<generated::LiteralPat>),
    ) -> Label<generated::Pat> {
        match pat {
            ra_ap_hir_def::hir::LiteralOrConst::Literal(_literal) => {
                let expr = self.trap.emit(generated::LiteralExpr { id: TrapId::Star });
                let label = self.trap.emit(generated::LiteralPat {
                    id: TrapId::Star,
                    expr: expr.into(),
                });
                emit_location(self, label);
                label.into()
            }
            ra_ap_hir_def::hir::LiteralOrConst::Const(inner) => {
                self.emit_pat(*inner, body, source_map)
            }
        }
    }

    fn emit_location_for_label<E: TrapClass>(
        &mut self,
        label: Label<E>,
        label_id: ra_ap_hir_def::hir::LabelId,
        source_map: &BodySourceMap,
    ) {
        // 'catch' a panic if the source map is incomplete
        let source = std::panic::catch_unwind(|| source_map.label_syntax(label_id)).ok();
        if let Some(source) = source {
            self.emit_location_for_ast_ptr(label, source)
        }
    }
    fn emit_location<E: TrapClass, T: HasSource>(&mut self, label: Label<E>, entity: T)
    where
        T::Ast: AstNode,
    {
        if let Some((data, source)) = entity
            .source(self.db)
            .and_then(|source| source.file_id.file_id().map(|f| (f.file_id(), source)))
            .and_then(|(file_id, source)| self.emit_file(file_id).map(|data| (data, source)))
        {
            let range = source.value.syntax().text_range();
            self.emit_location_for_textrange(label, data, range);
        }
    }
    fn emit_location_for_textrange<E: TrapClass>(
        &mut self,
        label: Label<E>,
        data: FileData,
        range: TextRange,
    ) {
        let start = data.line_index.line_col(range.start());
        let end = data.line_index.line_col(
            range
                .end()
                .checked_sub(TextSize::new(1))
                .unwrap_or(range.end()),
        );
        self.trap.emit_location(data.label, label, start, end)
    }
    fn emit_label(
        &mut self,
        label_id: LabelId,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::Label> {
        let label = &body.labels[label_id];
        let ret = self.trap.emit(generated::Label {
            id: TrapId::Star,
            name: label.name.as_str().into(),
        });
        self.emit_location_for_label(ret, label_id, source_map);
        ret
    }

    fn emit_path(&mut self, _path: &Path) -> Label<generated::Path> {
        self.trap.emit(generated::Path { id: TrapId::Star })
    }

    fn emit_record_field_pat(
        &mut self,
        field_pat: &RecordFieldPat,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::RecordPatField> {
        let RecordFieldPat { name, pat } = field_pat;
        let pat_label = self.emit_pat(*pat, body, source_map);
        let ret = self.trap.emit(generated::RecordPatField {
            id: TrapId::Star,
            name: name.as_str().into(),
            pat: pat_label,
        });
        self.emit_location_for_pat(ret, *pat, source_map);
        ret
    }

    fn emit_record_lit_field(
        &mut self,
        field_expr: &RecordLitField,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::RecordExprField> {
        let RecordLitField { name, expr } = field_expr;
        let expr_label = self.emit_expr(*expr, body, source_map);
        let ret = self.trap.emit(generated::RecordExprField {
            id: TrapId::Star,
            name: name.as_str().into(),
            expr: expr_label,
        });
        self.emit_location_for_expr(ret, *expr, source_map);
        ret
    }
    fn emit_pat(
        &mut self,
        pat_id: PatId,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::Pat> {
        let pat = &body.pats[pat_id];
        let ret = match pat {
            ra_ap_hir_def::hir::Pat::Missing => self
                .trap
                .emit(generated::MissingPat { id: TrapId::Star })
                .into(),
            ra_ap_hir_def::hir::Pat::Wild => self
                .trap
                .emit(generated::WildcardPat { id: TrapId::Star })
                .into(),
            ra_ap_hir_def::hir::Pat::Tuple { args, ellipsis } => {
                let args = args
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                let ellipsis_index = ellipsis.and_then(|x| x.try_into().ok());
                self.trap
                    .emit(generated::TuplePat {
                        id: TrapId::Star,
                        args,
                        ellipsis_index,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Or(args) => {
                let args = args
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::OrPat {
                        id: TrapId::Star,
                        args,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Record {
                path,
                args,
                ellipsis,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path));
                if let Some(p) = path {
                    self.emit_location_for_pat(p, pat_id, source_map)
                }
                let flds = args
                    .into_iter()
                    .map(|arg| self.emit_record_field_pat(arg, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::RecordPat {
                        id: TrapId::Star,
                        path,
                        flds,
                        has_ellipsis: *ellipsis,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Range { start, end } => {
                let emit_location_for_const =
                    |this: &mut CrateTranslator, label: Label<generated::LiteralPat>| {
                        this.emit_location_for_pat(label, pat_id, source_map)
                    };
                let start = start.as_ref().map(|x| {
                    self.emit_literal_or_const_pat(x, body, source_map, emit_location_for_const)
                });

                let end = end.as_ref().map(|x| {
                    self.emit_literal_or_const_pat(x, body, source_map, emit_location_for_const)
                });
                self.trap
                    .emit(generated::RangePat {
                        id: TrapId::Star,
                        start,
                        end,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Slice {
                prefix,
                slice,
                suffix,
            } => {
                let prefix = prefix
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                let slice = slice.map(|pat| self.emit_pat(pat, body, source_map));
                let suffix = suffix
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::SlicePat {
                        id: TrapId::Star,
                        prefix,
                        slice,
                        suffix,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Path(path) => {
                let path = self.emit_path(path);
                self.emit_location_for_pat(path, pat_id, source_map);

                self.trap
                    .emit(generated::PathPat {
                        id: TrapId::Star,
                        path,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Lit(expr) => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::LiteralPat {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Bind { id, subpat } => {
                let subpat = subpat.map(|pat| self.emit_pat(pat, body, source_map));
                self.trap
                    .emit(generated::IdentPat {
                        id: TrapId::Star,
                        subpat,
                        binding_id: body.bindings[*id].name.as_str().into(),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::TupleStruct {
                path,
                args,
                ellipsis,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path));
                if let Some(p) = path {
                    self.emit_location_for_pat(p, pat_id, source_map)
                }

                let args = args
                    .into_iter()
                    .map(|arg| self.emit_pat(*arg, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::TupleStructPat {
                        id: TrapId::Star,
                        path,
                        args,
                        ellipsis_index: ellipsis.map(|x| x as usize),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Ref { pat, mutability } => {
                let pat = self.emit_pat(*pat, body, source_map);
                self.trap
                    .emit(generated::RefPat {
                        id: TrapId::Star,
                        pat,
                        is_mut: mutability.is_mut(),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::Box { inner } => {
                let inner = self.emit_pat(*inner, body, source_map);
                self.trap
                    .emit(generated::BoxPat {
                        id: TrapId::Star,
                        inner,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Pat::ConstBlock(expr) => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::ConstBlockPat {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
        };
        self.emit_location_for_pat(ret, pat_id, source_map);
        ret
    }
    fn emit_type_ref(&mut self, _type_ref: &TypeRef) -> Label<generated::TypeRef> {
        self.trap.emit(generated::TypeRef { id: TrapId::Star })
    }
    fn emit_match_arm(
        &mut self,
        arm: &MatchArm,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::MatchArm> {
        let pat = self.emit_pat(arm.pat, body, source_map);
        let guard = arm.guard.map(|g| self.emit_expr(g, body, source_map));
        let expr = self.emit_expr(arm.expr, body, source_map);
        let ret = self.trap.emit(generated::MatchArm {
            id: TrapId::Star,
            pat,
            guard,
            expr,
        });
        self.emit_location_for_pat(ret, arm.pat, source_map);
        ret
    }
    fn emit_stmt(
        &mut self,
        stmt: &Statement,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::Stmt> {
        match stmt {
            Statement::Let {
                pat,
                type_ref,
                initializer,
                else_branch,
            } => {
                let pat_label = self.emit_pat(*pat, body, source_map);
                let type_ = type_ref
                    .as_ref()
                    .map(|type_ref| self.emit_type_ref(type_ref));
                let initializer =
                    initializer.map(|initializer| self.emit_expr(initializer, body, source_map));
                let else_ = else_branch.map(|else_| self.emit_expr(else_, body, source_map));

                let ret = self.trap.emit(generated::LetStmt {
                    id: TrapId::Star,
                    pat: pat_label,
                    type_,
                    initializer,
                    else_,
                });
                // TODO: find a way to get the location of the entire statement
                self.emit_location_for_pat(ret, *pat, source_map);
                ret.into()
            }
            Statement::Expr { expr, has_semi } => {
                let expr_label = self.emit_expr(*expr, body, source_map);
                let ret = self.trap.emit(generated::ExprStmt {
                    id: TrapId::Star,
                    expr: expr_label,
                    has_semicolon: *has_semi,
                });
                // TODO: find a way to get the location of the entire statement
                self.emit_location_for_expr(ret, *expr, source_map);
                ret.into()
            }
            Statement::Item => self
                .trap
                .emit(generated::ItemStmt { id: TrapId::Star })
                .into(),
        }
    }
    fn emit_expr(
        &mut self,
        expr_id: ExprId,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> Label<generated::Expr> {
        let expr = &body[expr_id];
        let ret = match expr {
            ra_ap_hir_def::hir::Expr::Missing => self
                .trap
                .emit(generated::MissingExpr { id: TrapId::Star })
                .into(),
            ra_ap_hir_def::hir::Expr::Path(path) => {
                let path = self.emit_path(path);
                self.emit_location_for_expr(path, expr_id, source_map);

                self.trap
                    .emit(generated::PathExpr {
                        id: TrapId::Star,
                        path,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::If {
                condition,
                then_branch,
                else_branch,
            } => {
                let condition = self.emit_expr(*condition, body, source_map);
                let then = self.emit_expr(*then_branch, body, source_map);
                let else_ = else_branch.map(|x| self.emit_expr(x, body, source_map));
                self.trap
                    .emit(generated::IfExpr {
                        id: TrapId::Star,
                        condition,
                        then,
                        else_,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Let { pat, expr } => {
                let pat = self.emit_pat(*pat, body, source_map);
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::LetExpr {
                        id: TrapId::Star,
                        pat,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Block {
                id: _,
                statements,
                tail,
                label,
            } => {
                let statements = statements
                    .into_iter()
                    .map(|stmt| self.emit_stmt(stmt, body, source_map))
                    .collect();
                let tail = tail.map(|expr_id| self.emit_expr(expr_id, body, source_map));
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap
                    .emit(generated::BlockExpr {
                        id: TrapId::Star,
                        statements,
                        tail,
                        label,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Async {
                id: _,
                statements,
                tail,
            } => {
                let statements = statements
                    .into_iter()
                    .map(|stmt| self.emit_stmt(stmt, body, source_map))
                    .collect();
                let tail = tail.map(|expr_id| self.emit_expr(expr_id, body, source_map));
                self.trap
                    .emit(generated::AsyncBlockExpr {
                        id: TrapId::Star,
                        statements,
                        tail,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Const(const_block) => {
                let expr_id = self.db.lookup_intern_anonymous_const(*const_block).root;
                let expr = self.emit_expr(expr_id, body, source_map);
                self.trap
                    .emit(generated::ConstExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Unsafe {
                id: _,
                statements,
                tail,
            } => {
                let statements = statements
                    .into_iter()
                    .map(|stmt| self.emit_stmt(stmt, body, source_map))
                    .collect();
                let tail = tail.map(|expr_id| self.emit_expr(expr_id, body, source_map));
                self.trap
                    .emit(generated::UnsafeBlockExpr {
                        id: TrapId::Star,
                        statements,
                        tail,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Loop {
                body: loop_body,
                label,
            } => {
                let loop_body = self.emit_expr(*loop_body, body, source_map);
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap
                    .emit(generated::LoopExpr {
                        id: TrapId::Star,
                        body: loop_body,
                        label,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Call {
                callee,
                args,
                is_assignee_expr,
            } => {
                let callee = self.emit_expr(*callee, body, source_map);
                let args = args
                    .into_iter()
                    .map(|e| self.emit_expr(*e, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::CallExpr {
                        id: TrapId::Star,
                        callee,
                        args,
                        is_assignee_expr: *is_assignee_expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::MethodCall {
                receiver,
                method_name,
                args,
                generic_args,
            } => {
                let receiver = self.emit_expr(*receiver, body, source_map);
                let args = args
                    .into_iter()
                    .map(|e| self.emit_expr(*e, body, source_map))
                    .collect();
                let generic_args = generic_args.as_ref().map(|_args| {
                    self.trap
                        .emit(generated::GenericArgList { id: TrapId::Star })
                });
                self.trap
                    .emit(generated::MethodCallExpr {
                        id: TrapId::Star,
                        receiver,
                        method_name: method_name.as_str().into(),
                        args,
                        generic_args,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Match { expr, arms } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let branches = arms
                    .into_iter()
                    .map(|e| self.emit_match_arm(e, body, source_map))
                    .collect();

                self.trap
                    .emit(generated::MatchExpr {
                        id: TrapId::Star,
                        expr,
                        branches,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Continue { label } => {
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap
                    .emit(generated::ContinueExpr {
                        id: TrapId::Star,
                        label,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Break { expr, label } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap
                    .emit(generated::BreakExpr {
                        id: TrapId::Star,
                        expr,
                        label,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Return { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap
                    .emit(generated::ReturnExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Become { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::BecomeExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Yield { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap
                    .emit(generated::YieldExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Yeet { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap
                    .emit(generated::YeetExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::RecordLit {
                path, //TODO
                fields,
                spread,
                ellipsis,
                is_assignee_expr,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path));
                if let Some(p) = path {
                    self.emit_location_for_expr(p, expr_id, source_map)
                }

                let flds = fields
                    .into_iter()
                    .map(|field| self.emit_record_lit_field(field, body, source_map))
                    .collect();
                let spread = spread.map(|expr_id| self.emit_expr(expr_id, body, source_map));
                self.trap
                    .emit(generated::RecordExpr {
                        id: TrapId::Star,
                        path,
                        flds,
                        spread,
                        has_ellipsis: *ellipsis,
                        is_assignee_expr: *is_assignee_expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Field { expr, name } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::FieldExpr {
                        id: TrapId::Star,
                        expr,
                        name: name.as_str().into(),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Await { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::AwaitExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Cast { expr, type_ref } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let type_ = self.emit_type_ref(type_ref.as_ref());
                self.trap
                    .emit(generated::CastExpr {
                        id: TrapId::Star,
                        expr,
                        type_,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Ref {
                expr,
                rawness,
                mutability,
            } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::RefExpr {
                        id: TrapId::Star,
                        expr,
                        is_mut: mutability.is_mut(),
                        is_raw: rawness.is_raw(),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Box { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap
                    .emit(generated::BoxExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::UnaryOp { expr, op } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let op = match op {
                    ra_ap_syntax::ast::UnaryOp::Deref => "*",
                    ra_ap_syntax::ast::UnaryOp::Not => "!",
                    ra_ap_syntax::ast::UnaryOp::Neg => "-",
                };
                self.trap
                    .emit(generated::PrefixExpr {
                        id: TrapId::Star,
                        expr,
                        op: op.into(),
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::BinaryOp { lhs, rhs, op } => {
                let lhs = self.emit_expr(*lhs, body, source_map);
                let rhs = self.emit_expr(*rhs, body, source_map);
                let op = op.map(|op| format!("{op}"));
                self.trap
                    .emit(generated::BinaryExpr {
                        id: TrapId::Star,
                        lhs,
                        rhs,
                        op,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Range {
                lhs,
                rhs,
                range_type,
            } => {
                let lhs = lhs.map(|lhs| self.emit_expr(lhs, body, source_map));
                let rhs = rhs.map(|rhs| self.emit_expr(rhs, body, source_map));
                self.trap
                    .emit(generated::RangeExpr {
                        id: TrapId::Star,
                        lhs,
                        rhs,
                        is_inclusive: *range_type == RangeOp::Inclusive,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Index {
                base,
                index,
                is_assignee_expr,
            } => {
                let base = self.emit_expr(*base, body, source_map);
                let index = self.emit_expr(*index, body, source_map);
                self.trap
                    .emit(generated::IndexExpr {
                        id: TrapId::Star,
                        base,
                        index,
                        is_assignee_expr: *is_assignee_expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Closure {
                args,
                arg_types,
                ret_type,
                body: expr,
                closure_kind, //TODO:
                capture_by,
            } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let args = args
                    .into_iter()
                    .map(|arg| self.emit_pat(*arg, body, source_map))
                    .collect();
                let ret_type = ret_type
                    .as_ref()
                    .map(|ret_type| self.emit_type_ref(ret_type));
                let arg_types = arg_types
                    .into_iter()
                    .map(|arg_type| {
                        arg_type
                            .as_ref()
                            .map(|arg_type| self.emit_type_ref(arg_type))
                    })
                    .collect();
                self.trap
                    .emit(generated::ClosureExpr {
                        id: TrapId::Star,
                        args,
                        arg_types,
                        body: expr,
                        ret_type,
                        closure_kind: format!("{:?}", closure_kind),
                        is_move: *capture_by == CaptureBy::Value,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Tuple {
                exprs,
                is_assignee_expr,
            } => {
                let exprs = exprs
                    .into_iter()
                    .map(|expr| self.emit_expr(*expr, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::TupleExpr {
                        id: TrapId::Star,
                        exprs,
                        is_assignee_expr: *is_assignee_expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Array(ra_ap_hir_def::hir::Array::ElementList {
                elements,
                is_assignee_expr,
            }) => {
                let elements = elements
                    .into_iter()
                    .map(|expr| self.emit_expr(*expr, body, source_map))
                    .collect();
                self.trap
                    .emit(generated::ElementListExpr {
                        id: TrapId::Star,
                        elements,
                        is_assignee_expr: *is_assignee_expr,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Array(ra_ap_hir_def::hir::Array::Repeat {
                initializer,
                repeat,
            }) => {
                let initializer = self.emit_expr(*initializer, body, source_map);
                let repeat = self.emit_expr(*repeat, body, source_map);

                self.trap
                    .emit(generated::RepeatExpr {
                        id: TrapId::Star,
                        initializer,
                        repeat,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::Literal(_literal) => self
                .trap
                .emit(generated::LiteralExpr { id: TrapId::Star })
                .into(),
            ra_ap_hir_def::hir::Expr::Underscore => self
                .trap
                .emit(generated::UnderscoreExpr { id: TrapId::Star })
                .into(),
            ra_ap_hir_def::hir::Expr::OffsetOf(offset) => {
                let container = self.emit_type_ref(&offset.container);
                let fields = offset.fields.iter().map(|x| x.as_str().into()).collect();
                self.trap
                    .emit(generated::OffsetOfExpr {
                        id: TrapId::Star,
                        container,
                        fields,
                    })
                    .into()
            }
            ra_ap_hir_def::hir::Expr::InlineAsm(asm) => {
                let expr = self.emit_expr(asm.e, body, source_map);
                self.trap
                    .emit(generated::AsmExpr {
                        id: TrapId::Star,
                        expr,
                    })
                    .into()
            }
        };
        self.emit_location_for_expr(ret, expr_id, source_map);
        ret
    }

    fn emit_definition(
        &mut self,
        module_label: Label<generated::Module>,
        id: ModuleDef,
        labels: &mut Vec<Label<generated::Declaration>>,
    ) {
        let label = match id {
            ModuleDef::Module(_module) => self
                .trap
                .emit(generated::UnimplementedDeclaration { id: TrapId::Star })
                .into(),
            ModuleDef::Function(function) => {
                let def: ra_ap_hir::DefWithBody = function.into();

                let name = function.name(self.db);

                let (body, source_map) = self.db.body_with_source_map(def.into());
                let txt = body.pretty_print(self.db, def.into(), Edition::Edition2021);
                log::trace!("{}", &txt);
                let body = self.emit_expr(body.body_expr, &body, &source_map);

                let label = self.trap.emit(generated::Function {
                    id: trap_key![module_label, name.as_str()],
                    name: name.as_str().into(),
                    body,
                });
                self.emit_location(label, function);
                label.into()
            }
            ModuleDef::Adt(adt) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, adt);
                label.into()
            }
            ModuleDef::Variant(variant) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, variant);
                label.into()
            }
            ModuleDef::Const(const_) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, const_);
                label.into()
            }
            ModuleDef::Static(static_) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, static_);
                label.into()
            }
            ModuleDef::Trait(trait_) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, trait_);
                label.into()
            }
            ModuleDef::TraitAlias(alias) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, alias);
                label.into()
            }
            ModuleDef::TypeAlias(type_alias) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, type_alias);
                label.into()
            }
            ModuleDef::BuiltinType(_builtin_type) => self
                .trap
                .emit(generated::UnimplementedDeclaration { id: TrapId::Star })
                .into(),
            ModuleDef::Macro(macro_) => {
                let label = self
                    .trap
                    .emit(generated::UnimplementedDeclaration { id: TrapId::Star });
                self.emit_location(label, macro_);
                label.into()
            }
        };
        labels.push(label);
    }

    fn emit_module(&mut self, label: Label<generated::Module>, module: Module) {
        let mut children = Vec::new();
        for id in module.declarations(self.db) {
            self.emit_definition(label, id, &mut children);
        }
        self.trap.emit(generated::Module {
            id: label.into(),
            declarations: children,
        });
    }

    pub fn emit_crate(&mut self) -> std::io::Result<()> {
        self.emit_file(self.krate.root_file(self.db));
        let mut map = HashMap::<Module, Label<generated::Module>>::new();
        for module in self.krate.modules(self.db) {
            let mut key = String::new();
            if let Some(parent) = module.parent(self.db) {
                // assumption: parent was already listed
                let parent_label = *map.get(&parent).unwrap();
                key.push_str(&parent_label.as_key_part());
            }
            let def = module.definition_source(self.db);
            if let Some(file) = def.file_id.file_id() {
                if let Some(data) = self.emit_file(file.file_id()) {
                    key.push_str(&data.label.as_key_part());
                }
            }
            if let Some(name) = module.name(self.db) {
                key.push_str(name.as_str());
            }
            let label = self.trap.label(TrapId::Key(key));
            map.insert(module, label);
            self.emit_module(label, module);
        }
        self.trap.commit()
    }
}
