use crate::archive::Archiver;
use crate::trap::{AsTrapKeyPart, TrapFile, TrapId};
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
    extract_dependencies: bool,
    file_labels: HashMap<PathBuf, FileData>,
}

impl CrateTranslator<'_> {
    pub fn new<'a>(
        db: &'a RootDatabase,
        trap: TrapFile,
        krate: &'a Crate,
        vfs: &'a Vfs,
        archiver: &'a Archiver,
        extract_dependencies: bool,
    ) -> CrateTranslator<'a> {
        CrateTranslator {
            db,
            trap,
            krate,
            vfs,
            archiver,
            extract_dependencies,
            file_labels: HashMap::new(),
        }
    }

    fn emit_file(&mut self, file_id: FileId) -> Option<FileData> {
        self.vfs.file_path(file_id).as_path().and_then(|abs_path| {
            let mut canonical = PathBuf::from(abs_path.as_str());
            if !self.file_labels.contains_key(&canonical) {
                self.archiver.archive(&canonical);
                canonical = fs::canonicalize(&canonical).unwrap_or(canonical);
                let name = canonical.to_string_lossy();
                let label = self.trap.emit(generated::DbFile {
                    id: trap_key!["file;", name.as_ref()],
                    name: String::from(name),
                });
                let line_index = <dyn LineIndexDatabase>::line_index(self.db, file_id);
                self.file_labels
                    .insert(canonical.clone(), FileData { label, line_index });
            }
            self.file_labels.get(&canonical).cloned()
        })
    }

    fn emit_location_for_ast_ptr<T>(
        &mut self,
        source: ra_ap_hir::InFile<ra_ap_syntax::AstPtr<T>>,
    ) -> Option<trap::Label>
    where
        T: AstNode,
    {
        source
            .file_id
            .file_id()
            .map(|f| (f.file_id(), source))
            .and_then(|(file_id, source)| self.emit_file(file_id).map(|data| (data, source)))
            .map(|(data, source)| {
                let range = source.value.text_range();
                self.emit_location_for_textrange(data, range)
            })
    }

    fn emit_location_for_expr(
        &mut self,
        expr: ra_ap_hir_def::hir::ExprId,
        source_map: &BodySourceMap,
    ) -> Option<trap::Label> {
        let source = source_map.expr_syntax(expr).ok()?;
        self.emit_location_for_ast_ptr(source)
    }

    fn emit_location_for_pat(
        &mut self,
        pat_id: ra_ap_hir_def::hir::PatId,
        source_map: &BodySourceMap,
    ) -> Option<trap::Label> {
        let source = source_map.pat_syntax(pat_id).ok()?;
        self.emit_location_for_ast_ptr(source)
    }

    fn emit_literal_or_const_pat(
        &mut self,
        pat: &ra_ap_hir_def::hir::LiteralOrConst,
        location: Option<trap::Label>,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        match pat {
            ra_ap_hir_def::hir::LiteralOrConst::Literal(_literal) => {
                let expr = self.trap.emit(generated::LiteralExpr {
                    id: TrapId::Star,
                    location: None,
                });
                self.trap.emit(generated::LitPat {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::LiteralOrConst::Const(inner) => {
                self.emit_pat(*inner, body, source_map)
            }
        }
    }

    fn emit_location_for_label(
        &mut self,
        label_id: ra_ap_hir_def::hir::LabelId,
        source_map: &BodySourceMap,
    ) -> Option<trap::Label> {
        // 'catch' a panic if the source map is incomplete
        let source = std::panic::catch_unwind(|| source_map.label_syntax(label_id)).ok();
        source.and_then(|source| self.emit_location_for_ast_ptr(source))
    }
    fn emit_location<T: HasSource>(&mut self, entity: T) -> Option<trap::Label>
    where
        T::Ast: AstNode,
    {
        entity
            .source(self.db)
            .and_then(|source| source.file_id.file_id().map(|f| (f.file_id(), source)))
            .and_then(|(file_id, source)| self.emit_file(file_id).map(|data| (data, source)))
            .map(|(data, source)| {
                let range = source.value.syntax().text_range();
                self.emit_location_for_textrange(data, range)
            })
    }
    fn emit_location_for_textrange(&mut self, data: FileData, range: TextRange) -> trap::Label {
        let start = data.line_index.line_col(range.start());
        let end = data.line_index.line_col(
            range
                .end()
                .checked_sub(TextSize::new(1))
                .unwrap_or(range.end()),
        );
        self.trap.emit_location(data.label, start, end)
    }
    fn emit_label(
        &mut self,
        label_id: LabelId,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        let location: Option<trap::Label> = self.emit_location_for_label(label_id, source_map);
        let label = &body.labels[label_id];
        self.trap.emit(generated::Label {
            id: TrapId::Star,
            location,
            name: label.name.as_str().into(),
        })
    }

    fn emit_path(&mut self, _path: &Path, location: Option<trap::Label>) -> trap::Label {
        self.trap.emit(generated::Path {
            id: TrapId::Star,
            location,
        })
    }

    fn emit_record_field_pat(
        &mut self,
        field_pat: &RecordFieldPat,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        let RecordFieldPat { name, pat } = field_pat;
        let location = self.emit_location_for_pat(*pat, source_map);
        let pat = self.emit_pat(*pat, body, source_map);
        self.trap.emit(generated::RecordFieldPat {
            id: TrapId::Star,
            location,
            name: name.as_str().into(),
            pat,
        })
    }

    fn emit_record_lit_field(
        &mut self,
        field_expr: &RecordLitField,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        let RecordLitField { name, expr } = field_expr;
        let location = self.emit_location_for_expr(*expr, source_map);
        let expr = self.emit_expr(*expr, body, source_map);
        self.trap.emit(generated::RecordLitField {
            id: TrapId::Star,
            location,
            name: name.as_str().into(),
            expr,
        })
    }
    fn emit_pat(&mut self, pat_id: PatId, body: &Body, source_map: &BodySourceMap) -> trap::Label {
        let location: Option<trap::Label> = self.emit_location_for_pat(pat_id, source_map);
        let pat = &body.pats[pat_id];
        match pat {
            ra_ap_hir_def::hir::Pat::Missing => self.trap.emit(generated::MissingPat {
                id: TrapId::Star,
                location,
            }),
            ra_ap_hir_def::hir::Pat::Wild => self.trap.emit(generated::WildPat {
                id: TrapId::Star,
                location,
            }),
            ra_ap_hir_def::hir::Pat::Tuple { args, ellipsis } => {
                let args = args
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                let ellipsis_index = ellipsis.and_then(|x| x.try_into().ok());
                self.trap.emit(generated::TuplePat {
                    id: TrapId::Star,
                    location,
                    args,
                    ellipsis_index,
                })
            }
            ra_ap_hir_def::hir::Pat::Or(args) => {
                let args = args
                    .into_iter()
                    .map(|pat| self.emit_pat(*pat, body, source_map))
                    .collect();
                self.trap.emit(generated::OrPat {
                    id: TrapId::Star,
                    location,
                    args,
                })
            }
            ra_ap_hir_def::hir::Pat::Record {
                path,
                args,
                ellipsis,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path, location));
                let args = args
                    .into_iter()
                    .map(|arg| self.emit_record_field_pat(arg, body, source_map))
                    .collect();
                self.trap.emit(generated::RecordPat {
                    id: TrapId::Star,
                    location,
                    path,
                    args,
                    has_ellipsis: *ellipsis,
                })
            }
            ra_ap_hir_def::hir::Pat::Range { start, end } => {
                let start = start
                    .as_ref()
                    .map(|x| self.emit_literal_or_const_pat(x, location, body, source_map));
                let end = end
                    .as_ref()
                    .map(|x| self.emit_literal_or_const_pat(x, location, body, source_map));
                self.trap.emit(generated::RangePat {
                    id: TrapId::Star,
                    location,
                    start,
                    end,
                })
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
                self.trap.emit(generated::SlicePat {
                    id: TrapId::Star,
                    location,
                    prefix,
                    slice,
                    suffix,
                })
            }
            ra_ap_hir_def::hir::Pat::Path(path) => {
                let path = self.emit_path(path, location);
                self.trap.emit(generated::PathPat {
                    id: TrapId::Star,
                    location,
                    path,
                })
            }
            ra_ap_hir_def::hir::Pat::Lit(expr) => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::LitPat {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Pat::Bind { id, subpat } => {
                let subpat = subpat.map(|pat| self.emit_pat(pat, body, source_map));
                self.trap.emit(generated::BindPat {
                    id: TrapId::Star,
                    location,
                    subpat,
                    binding_id: body.bindings[*id].name.as_str().into(),
                })
            }
            ra_ap_hir_def::hir::Pat::TupleStruct {
                path,
                args,
                ellipsis,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path, location));
                let args = args
                    .into_iter()
                    .map(|arg| self.emit_pat(*arg, body, source_map))
                    .collect();
                self.trap.emit(generated::TupleStructPat {
                    id: TrapId::Star,
                    location,
                    path,
                    args,
                    ellipsis_index: ellipsis.map(|x| x as usize),
                })
            }
            ra_ap_hir_def::hir::Pat::Ref { pat, mutability } => {
                let pat = self.emit_pat(*pat, body, source_map);
                self.trap.emit(generated::RefPat {
                    id: TrapId::Star,
                    location,
                    pat,
                    is_mut: mutability.is_mut(),
                })
            }
            ra_ap_hir_def::hir::Pat::Box { inner } => {
                let inner = self.emit_pat(*inner, body, source_map);
                self.trap.emit(generated::BoxPat {
                    id: TrapId::Star,
                    location,
                    inner,
                })
            }
            ra_ap_hir_def::hir::Pat::ConstBlock(expr) => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::ConstBlockPat {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
        }
    }
    fn emit_type_ref(&mut self, _type_ref: &TypeRef) -> trap::Label {
        self.trap.emit(generated::TypeRef {
            id: TrapId::Star,
            location: None,
        })
    }
    fn emit_match_arm(
        &mut self,
        arm: &MatchArm,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        let location: Option<trap::Label> = self.emit_location_for_pat(arm.pat, source_map);
        let pat = self.emit_pat(arm.pat, body, source_map);
        let guard = arm.guard.map(|g| self.emit_expr(g, body, source_map));
        let expr = self.emit_expr(arm.expr, body, source_map);
        self.trap.emit(generated::MatchArm {
            id: TrapId::Star,
            location,
            pat,
            guard,
            expr,
        })
    }
    fn emit_stmt(
        &mut self,
        stmt: &Statement,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        match stmt {
            Statement::Let {
                pat,
                type_ref,
                initializer,
                else_branch,
            } => {
                // TODO: find a way to get the location of the entire statement
                let location = self.emit_location_for_pat(*pat, source_map);
                let pat = self.emit_pat(*pat, body, source_map);
                let type_ref = type_ref
                    .as_ref()
                    .map(|type_ref| self.emit_type_ref(type_ref));
                let initializer =
                    initializer.map(|initializer| self.emit_expr(initializer, body, source_map));
                let else_ = else_branch.map(|else_| self.emit_expr(else_, body, source_map));

                self.trap.emit(generated::LetStmt {
                    id: TrapId::Star,
                    location,
                    pat,
                    type_ref,
                    initializer,
                    else_,
                })
            }
            Statement::Expr { expr, has_semi } => {
                let location = self.emit_location_for_expr(*expr, source_map);
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::ExprStmt {
                    id: TrapId::Star,
                    location,
                    expr,
                    has_semicolon: *has_semi,
                })
            }
            Statement::Item => self.trap.emit(generated::ItemStmt {
                id: TrapId::Star,
                location: None,
            }),
        }
    }
    fn emit_expr(
        &mut self,
        expr_id: ExprId,
        body: &Body,
        source_map: &BodySourceMap,
    ) -> trap::Label {
        let location: Option<trap::Label> = self.emit_location_for_expr(expr_id, source_map);
        let expr = &body[expr_id];
        match expr {
            ra_ap_hir_def::hir::Expr::Missing => self.trap.emit(generated::MissingExpr {
                id: TrapId::Star,
                location,
            }),
            ra_ap_hir_def::hir::Expr::Path(path) => {
                let path = self.emit_path(path, location);
                self.trap.emit(generated::PathExpr {
                    id: TrapId::Star,
                    location,
                    path,
                })
            }
            ra_ap_hir_def::hir::Expr::If {
                condition,
                then_branch,
                else_branch,
            } => {
                let condition = self.emit_expr(*condition, body, source_map);
                let then = self.emit_expr(*then_branch, body, source_map);
                let else_ = else_branch.map(|x| self.emit_expr(x, body, source_map));
                self.trap.emit(generated::IfExpr {
                    id: TrapId::Star,
                    location,
                    condition,
                    then,
                    else_,
                })
            }
            ra_ap_hir_def::hir::Expr::Let { pat, expr } => {
                let pat = self.emit_pat(*pat, body, source_map);
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::LetExpr {
                    id: TrapId::Star,
                    location,
                    pat,
                    expr,
                })
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
                self.trap.emit(generated::BlockExpr {
                    id: TrapId::Star,
                    location,
                    statements,
                    tail,
                    label,
                })
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
                self.trap.emit(generated::AsyncBlockExpr {
                    id: TrapId::Star,
                    location,
                    statements,
                    tail,
                })
            }
            ra_ap_hir_def::hir::Expr::Const(const_block) => {
                let expr_id = self.db.lookup_intern_anonymous_const(*const_block).root;
                let expr = self.emit_expr(expr_id, body, source_map);
                self.trap.emit(generated::ConstExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
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
                self.trap.emit(generated::UnsafeBlockExpr {
                    id: TrapId::Star,
                    location,
                    statements,
                    tail,
                })
            }
            ra_ap_hir_def::hir::Expr::Loop {
                body: loop_body,
                label,
            } => {
                let loop_body = self.emit_expr(*loop_body, body, source_map);
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap.emit(generated::LoopExpr {
                    id: TrapId::Star,
                    location,
                    body: loop_body,
                    label,
                })
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
                self.trap.emit(generated::CallExpr {
                    id: TrapId::Star,
                    location,
                    callee,
                    args,
                    is_assignee_expr: *is_assignee_expr,
                })
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
                    self.trap.emit(generated::GenericArgs {
                        id: TrapId::Star,
                        location: None,
                    })
                });
                self.trap.emit(generated::MethodCallExpr {
                    id: TrapId::Star,
                    location,
                    receiver,
                    method_name: method_name.as_str().into(),
                    args,
                    generic_args,
                })
            }
            ra_ap_hir_def::hir::Expr::Match { expr, arms } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let branches = arms
                    .into_iter()
                    .map(|e| self.emit_match_arm(e, body, source_map))
                    .collect();

                self.trap.emit(generated::MatchExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    branches,
                })
            }
            ra_ap_hir_def::hir::Expr::Continue { label } => {
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap.emit(generated::ContinueExpr {
                    id: TrapId::Star,
                    location,
                    label,
                })
            }
            ra_ap_hir_def::hir::Expr::Break { expr, label } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                let label = label.map(|l| self.emit_label(l, body, source_map));
                self.trap.emit(generated::BreakExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    label,
                })
            }
            ra_ap_hir_def::hir::Expr::Return { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap.emit(generated::ReturnExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Become { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::BecomeExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Yield { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap.emit(generated::YieldExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Yeet { expr } => {
                let expr = expr.map(|e| self.emit_expr(e, body, source_map));
                self.trap.emit(generated::YeetExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::RecordLit {
                path, //TODO
                fields,
                spread,
                ellipsis,
                is_assignee_expr,
            } => {
                let path = path.as_ref().map(|path| self.emit_path(path, location));
                let fields = fields
                    .into_iter()
                    .map(|field| self.emit_record_lit_field(field, body, source_map))
                    .collect();
                let spread = spread.map(|expr_id| self.emit_expr(expr_id, body, source_map));
                self.trap.emit(generated::RecordLitExpr {
                    id: TrapId::Star,
                    location,
                    path,
                    fields,
                    spread,
                    has_ellipsis: *ellipsis,
                    is_assignee_expr: *is_assignee_expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Field { expr, name } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::FieldExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    name: name.as_str().into(),
                })
            }
            ra_ap_hir_def::hir::Expr::Await { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::AwaitExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Cast { expr, type_ref } => {
                let expr: trap::Label = self.emit_expr(*expr, body, source_map);
                let type_ref: trap::Label = self.emit_type_ref(type_ref.as_ref());
                self.trap.emit(generated::CastExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    type_ref,
                })
            }
            ra_ap_hir_def::hir::Expr::Ref {
                expr,
                rawness,
                mutability,
            } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::RefExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    is_mut: mutability.is_mut(),
                    is_raw: rawness.is_raw(),
                })
            }
            ra_ap_hir_def::hir::Expr::Box { expr } => {
                let expr = self.emit_expr(*expr, body, source_map);
                self.trap.emit(generated::BoxExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
            ra_ap_hir_def::hir::Expr::UnaryOp { expr, op } => {
                let expr = self.emit_expr(*expr, body, source_map);
                let op = match op {
                    ra_ap_syntax::ast::UnaryOp::Deref => "*",
                    ra_ap_syntax::ast::UnaryOp::Not => "!",
                    ra_ap_syntax::ast::UnaryOp::Neg => "-",
                };
                self.trap.emit(generated::UnaryOpExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                    op: op.into(),
                })
            }
            ra_ap_hir_def::hir::Expr::BinaryOp { lhs, rhs, op } => {
                let lhs = self.emit_expr(*lhs, body, source_map);
                let rhs = self.emit_expr(*rhs, body, source_map);
                let op = op.map(|op| format!("{op}"));
                self.trap.emit(generated::BinaryOpExpr {
                    id: TrapId::Star,
                    location,
                    lhs,
                    rhs,
                    op,
                })
            }
            ra_ap_hir_def::hir::Expr::Range {
                lhs,
                rhs,
                range_type,
            } => {
                let lhs = lhs.map(|lhs| self.emit_expr(lhs, body, source_map));
                let rhs = rhs.map(|rhs| self.emit_expr(rhs, body, source_map));
                self.trap.emit(generated::RangeExpr {
                    id: TrapId::Star,
                    location,
                    lhs,
                    rhs,
                    is_inclusive: *range_type == RangeOp::Inclusive,
                })
            }
            ra_ap_hir_def::hir::Expr::Index {
                base,
                index,
                is_assignee_expr,
            } => {
                let base = self.emit_expr(*base, body, source_map);
                let index = self.emit_expr(*index, body, source_map);
                self.trap.emit(generated::IndexExpr {
                    id: TrapId::Star,
                    location,
                    base,
                    index,
                    is_assignee_expr: *is_assignee_expr,
                })
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
                self.trap.emit(generated::ClosureExpr {
                    id: TrapId::Star,
                    location,
                    args,
                    arg_types,
                    body: expr,
                    ret_type,
                    closure_kind: format!("{:?}", closure_kind),
                    is_move: *capture_by == CaptureBy::Value,
                })
            }
            ra_ap_hir_def::hir::Expr::Tuple {
                exprs,
                is_assignee_expr,
            } => {
                let exprs = exprs
                    .into_iter()
                    .map(|expr| self.emit_expr(*expr, body, source_map))
                    .collect();
                self.trap.emit(generated::TupleExpr {
                    id: TrapId::Star,
                    location,
                    exprs,
                    is_assignee_expr: *is_assignee_expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Array(ra_ap_hir_def::hir::Array::ElementList {
                elements,
                is_assignee_expr,
            }) => {
                let elements = elements
                    .into_iter()
                    .map(|expr| self.emit_expr(*expr, body, source_map))
                    .collect();
                self.trap.emit(generated::ElementListExpr {
                    id: TrapId::Star,
                    location,
                    elements,
                    is_assignee_expr: *is_assignee_expr,
                })
            }
            ra_ap_hir_def::hir::Expr::Array(ra_ap_hir_def::hir::Array::Repeat {
                initializer,
                repeat,
            }) => {
                let initializer: trap::Label = self.emit_expr(*initializer, body, source_map);
                let repeat: trap::Label = self.emit_expr(*repeat, body, source_map);

                self.trap.emit(generated::RepeatExpr {
                    id: TrapId::Star,
                    location,
                    initializer,
                    repeat,
                })
            }
            ra_ap_hir_def::hir::Expr::Literal(_literal) => self.trap.emit(generated::LiteralExpr {
                id: TrapId::Star,
                location,
            }),
            ra_ap_hir_def::hir::Expr::Underscore => self.trap.emit(generated::UnderscoreExpr {
                id: TrapId::Star,
                location,
            }),
            ra_ap_hir_def::hir::Expr::OffsetOf(offset) => {
                let container = self.emit_type_ref(&offset.container);
                let fields = offset.fields.iter().map(|x| x.as_str().into()).collect();
                self.trap.emit(generated::OffsetOfExpr {
                    id: TrapId::Star,
                    location,
                    container,
                    fields,
                })
            }
            ra_ap_hir_def::hir::Expr::InlineAsm(asm) => {
                let expr = self.emit_expr(asm.e, body, source_map);
                self.trap.emit(generated::InlineAsmExpr {
                    id: TrapId::Star,
                    location,
                    expr,
                })
            }
        }
    }

    fn emit_definition(
        &mut self,
        module_label: trap::Label,
        id: ModuleDef,
        labels: &mut Vec<trap::Label>,
    ) {
        match id {
            ModuleDef::Module(_module) => {
                let location = None;
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Function(function) => {
                let def: ra_ap_hir::DefWithBody = function.into();

                let name = function.name(self.db);
                let location = self.emit_location(function);

                let body = if self.extract_dependencies || self.krate.origin(self.db).is_local() {
                    let (body, source_map) = self.db.body_with_source_map(def.into());
                    let txt = body.pretty_print(self.db, def.into(), Edition::Edition2021);
                    log::trace!("{}", &txt);
                    self.emit_expr(body.body_expr, &body, &source_map)
                } else {
                    self.trap.emit(generated::MissingExpr {
                        id: TrapId::Star,
                        location: None,
                    })
                };
                labels.push(self.trap.emit(generated::Function {
                    id: trap_key![module_label, name.as_str()],
                    location,
                    name: name.as_str().into(),
                    body,
                }))
            }
            ModuleDef::Adt(adt) => {
                let location = self.emit_location(adt);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Variant(variant) => {
                let location = self.emit_location(variant);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Const(const_) => {
                let location = self.emit_location(const_);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Static(static_) => {
                let location = self.emit_location(static_);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Trait(trait_) => {
                let location = self.emit_location(trait_);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::TraitAlias(alias) => {
                let location = self.emit_location(alias);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::TypeAlias(type_alias) => {
                let location = self.emit_location(type_alias);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::BuiltinType(_builtin_type) => {
                let location = None;
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
            ModuleDef::Macro(macro_) => {
                let location = self.emit_location(macro_);
                self.trap.emit(generated::UnimplementedDeclaration {
                    id: TrapId::Star,
                    location,
                });
            }
        }
    }

    fn emit_module(&mut self, label: trap::Label, module: Module) {
        let mut children = Vec::new();
        for id in module.declarations(self.db) {
            self.emit_definition(label, id, &mut children);
        }
        self.trap.emit(generated::Module {
            id: label.into(),
            location: None,
            declarations: children,
        });
    }

    pub fn emit_crate(&mut self) -> std::io::Result<()> {
        self.emit_file(self.krate.root_file(self.db));
        let mut map = HashMap::<Module, trap::Label>::new();
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
