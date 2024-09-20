use crate::generated;
use crate::trap::{Label, TrapClass, TrapFile, TrapId};
use codeql_extractor::trap::{self};
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_syntax::ast::{
    HasArgList, HasAttrs, HasGenericArgs, HasGenericParams, HasLoopBody, HasModuleItem, HasName,
    HasTypeBounds, HasVisibility, RangeItem,
};
use ra_ap_syntax::{ast, AstNode, Edition, SourceFile, TextSize};

pub struct SourceFileTranslator {
    trap: TrapFile,
    label: trap::Label,
    line_index: LineIndex,
}

trait TextValue {
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
impl SourceFileTranslator {
    pub fn new(trap: TrapFile, label: trap::Label, line_index: LineIndex) -> SourceFileTranslator {
        SourceFileTranslator {
            trap,
            label,
            line_index,
        }
    }
    pub fn extract(&mut self, path: &str, input: &str) -> Result<(), std::io::Error> {
        let parse = ra_ap_syntax::ast::SourceFile::parse(input, Edition::CURRENT);
        for err in parse.errors() {
            let start = self.line_index.line_col(err.range().start());
            log::warn!("{}:{}:{}: {}", path, start.line + 1, start.col + 1, err);
        }
        if let Some(ast) = SourceFile::cast(parse.syntax_node()) {
            self.emit_source_file(ast);
        } else {
            log::warn!("Skipped {}", path);
        }
        self.trap.commit()
    }
    fn emit_else_branch(&mut self, node: ast::ElseBranch) -> Label<generated::Expr> {
        match node {
            ast::ElseBranch::IfExpr(inner) => self.emit_if_expr(inner).into(),
            ast::ElseBranch::Block(inner) => self.emit_block_expr(inner).into(),
        }
    }
    fn emit_location<T: TrapClass>(&mut self, label: Label<T>, node: impl AstNode) {
        let range = node.syntax().text_range();
        let start = self.line_index.line_col(range.start());
        let end = self.line_index.line_col(
            range
                .end()
                .checked_sub(TextSize::new(1))
                .unwrap_or(range.end()),
        );
        self.trap.emit_location(self.label, label, start, end)
    }
    fn emit_assoc_item(&mut self, node: ast::AssocItem) -> Label<generated::AssocItem> {
        match node {
            ast::AssocItem::Const(inner) => self.emit_const(inner).into(),
            ast::AssocItem::Fn(inner) => self.emit_fn(inner).into(),
            ast::AssocItem::MacroCall(inner) => self.emit_macro_call(inner).into(),
            ast::AssocItem::TypeAlias(inner) => self.emit_type_alias(inner).into(),
        }
    }

    fn emit_expr(&mut self, node: ast::Expr) -> Label<generated::Expr> {
        match node {
            ast::Expr::ArrayExpr(inner) => self.emit_array_expr(inner).into(),
            ast::Expr::AsmExpr(inner) => self.emit_asm_expr(inner).into(),
            ast::Expr::AwaitExpr(inner) => self.emit_await_expr(inner).into(),
            ast::Expr::BecomeExpr(inner) => self.emit_become_expr(inner).into(),
            ast::Expr::BinExpr(inner) => self.emit_bin_expr(inner).into(),
            ast::Expr::BlockExpr(inner) => self.emit_block_expr(inner).into(),
            ast::Expr::BreakExpr(inner) => self.emit_break_expr(inner).into(),
            ast::Expr::CallExpr(inner) => self.emit_call_expr(inner).into(),
            ast::Expr::CastExpr(inner) => self.emit_cast_expr(inner).into(),
            ast::Expr::ClosureExpr(inner) => self.emit_closure_expr(inner).into(),
            ast::Expr::ContinueExpr(inner) => self.emit_continue_expr(inner).into(),
            ast::Expr::FieldExpr(inner) => self.emit_field_expr(inner).into(),
            ast::Expr::ForExpr(inner) => self.emit_for_expr(inner).into(),
            ast::Expr::FormatArgsExpr(inner) => self.emit_format_args_expr(inner).into(),
            ast::Expr::IfExpr(inner) => self.emit_if_expr(inner).into(),
            ast::Expr::IndexExpr(inner) => self.emit_index_expr(inner).into(),
            ast::Expr::LetExpr(inner) => self.emit_let_expr(inner).into(),
            ast::Expr::Literal(inner) => self.emit_literal(inner).into(),
            ast::Expr::LoopExpr(inner) => self.emit_loop_expr(inner).into(),
            ast::Expr::MacroExpr(inner) => self.emit_macro_expr(inner).into(),
            ast::Expr::MatchExpr(inner) => self.emit_match_expr(inner).into(),
            ast::Expr::MethodCallExpr(inner) => self.emit_method_call_expr(inner).into(),
            ast::Expr::OffsetOfExpr(inner) => self.emit_offset_of_expr(inner).into(),
            ast::Expr::ParenExpr(inner) => self.emit_paren_expr(inner).into(),
            ast::Expr::PathExpr(inner) => self.emit_path_expr(inner).into(),
            ast::Expr::PrefixExpr(inner) => self.emit_prefix_expr(inner).into(),
            ast::Expr::RangeExpr(inner) => self.emit_range_expr(inner).into(),
            ast::Expr::RecordExpr(inner) => self.emit_record_expr(inner).into(),
            ast::Expr::RefExpr(inner) => self.emit_ref_expr(inner).into(),
            ast::Expr::ReturnExpr(inner) => self.emit_return_expr(inner).into(),
            ast::Expr::TryExpr(inner) => self.emit_try_expr(inner).into(),
            ast::Expr::TupleExpr(inner) => self.emit_tuple_expr(inner).into(),
            ast::Expr::UnderscoreExpr(inner) => self.emit_underscore_expr(inner).into(),
            ast::Expr::WhileExpr(inner) => self.emit_while_expr(inner).into(),
            ast::Expr::YeetExpr(inner) => self.emit_yeet_expr(inner).into(),
            ast::Expr::YieldExpr(inner) => self.emit_yield_expr(inner).into(),
        }
    }

    fn emit_extern_item(&mut self, node: ast::ExternItem) -> Label<generated::ExternItem> {
        match node {
            ast::ExternItem::Fn(inner) => self.emit_fn(inner).into(),
            ast::ExternItem::MacroCall(inner) => self.emit_macro_call(inner).into(),
            ast::ExternItem::Static(inner) => self.emit_static(inner).into(),
            ast::ExternItem::TypeAlias(inner) => self.emit_type_alias(inner).into(),
        }
    }

    fn emit_field_list(&mut self, node: ast::FieldList) -> Label<generated::FieldList> {
        match node {
            ast::FieldList::RecordFieldList(inner) => self.emit_record_field_list(inner).into(),
            ast::FieldList::TupleFieldList(inner) => self.emit_tuple_field_list(inner).into(),
        }
    }

    fn emit_generic_arg(&mut self, node: ast::GenericArg) -> Label<generated::GenericArg> {
        match node {
            ast::GenericArg::AssocTypeArg(inner) => self.emit_assoc_type_arg(inner).into(),
            ast::GenericArg::ConstArg(inner) => self.emit_const_arg(inner).into(),
            ast::GenericArg::LifetimeArg(inner) => self.emit_lifetime_arg(inner).into(),
            ast::GenericArg::TypeArg(inner) => self.emit_type_arg(inner).into(),
        }
    }

    fn emit_generic_param(&mut self, node: ast::GenericParam) -> Label<generated::GenericParam> {
        match node {
            ast::GenericParam::ConstParam(inner) => self.emit_const_param(inner).into(),
            ast::GenericParam::LifetimeParam(inner) => self.emit_lifetime_param(inner).into(),
            ast::GenericParam::TypeParam(inner) => self.emit_type_param(inner).into(),
        }
    }

    fn emit_pat(&mut self, node: ast::Pat) -> Label<generated::Pat> {
        match node {
            ast::Pat::BoxPat(inner) => self.emit_box_pat(inner).into(),
            ast::Pat::ConstBlockPat(inner) => self.emit_const_block_pat(inner).into(),
            ast::Pat::IdentPat(inner) => self.emit_ident_pat(inner).into(),
            ast::Pat::LiteralPat(inner) => self.emit_literal_pat(inner).into(),
            ast::Pat::MacroPat(inner) => self.emit_macro_pat(inner).into(),
            ast::Pat::OrPat(inner) => self.emit_or_pat(inner).into(),
            ast::Pat::ParenPat(inner) => self.emit_paren_pat(inner).into(),
            ast::Pat::PathPat(inner) => self.emit_path_pat(inner).into(),
            ast::Pat::RangePat(inner) => self.emit_range_pat(inner).into(),
            ast::Pat::RecordPat(inner) => self.emit_record_pat(inner).into(),
            ast::Pat::RefPat(inner) => self.emit_ref_pat(inner).into(),
            ast::Pat::RestPat(inner) => self.emit_rest_pat(inner).into(),
            ast::Pat::SlicePat(inner) => self.emit_slice_pat(inner).into(),
            ast::Pat::TuplePat(inner) => self.emit_tuple_pat(inner).into(),
            ast::Pat::TupleStructPat(inner) => self.emit_tuple_struct_pat(inner).into(),
            ast::Pat::WildcardPat(inner) => self.emit_wildcard_pat(inner).into(),
        }
    }

    fn emit_stmt(&mut self, node: ast::Stmt) -> Label<generated::Stmt> {
        match node {
            ast::Stmt::ExprStmt(inner) => self.emit_expr_stmt(inner).into(),
            ast::Stmt::Item(inner) => self.emit_item(inner).into(),
            ast::Stmt::LetStmt(inner) => self.emit_let_stmt(inner).into(),
        }
    }

    fn emit_type(&mut self, node: ast::Type) -> Label<generated::TypeRef> {
        match node {
            ast::Type::ArrayType(inner) => self.emit_array_type(inner).into(),
            ast::Type::DynTraitType(inner) => self.emit_dyn_trait_type(inner).into(),
            ast::Type::FnPtrType(inner) => self.emit_fn_ptr_type(inner).into(),
            ast::Type::ForType(inner) => self.emit_for_type(inner).into(),
            ast::Type::ImplTraitType(inner) => self.emit_impl_trait_type(inner).into(),
            ast::Type::InferType(inner) => self.emit_infer_type(inner).into(),
            ast::Type::MacroType(inner) => self.emit_macro_type(inner).into(),
            ast::Type::NeverType(inner) => self.emit_never_type(inner).into(),
            ast::Type::ParenType(inner) => self.emit_paren_type(inner).into(),
            ast::Type::PathType(inner) => self.emit_path_type(inner).into(),
            ast::Type::PtrType(inner) => self.emit_ptr_type(inner).into(),
            ast::Type::RefType(inner) => self.emit_ref_type(inner).into(),
            ast::Type::SliceType(inner) => self.emit_slice_type(inner).into(),
            ast::Type::TupleType(inner) => self.emit_tuple_type(inner).into(),
        }
    }

    fn emit_item(&mut self, node: ast::Item) -> Label<generated::Item> {
        match node {
            ast::Item::Const(inner) => self.emit_const(inner).into(),
            ast::Item::Enum(inner) => self.emit_enum(inner).into(),
            ast::Item::ExternBlock(inner) => self.emit_extern_block(inner).into(),
            ast::Item::ExternCrate(inner) => self.emit_extern_crate(inner).into(),
            ast::Item::Fn(inner) => self.emit_fn(inner).into(),
            ast::Item::Impl(inner) => self.emit_impl(inner).into(),
            ast::Item::MacroCall(inner) => self.emit_macro_call(inner).into(),
            ast::Item::MacroDef(inner) => self.emit_macro_def(inner).into(),
            ast::Item::MacroRules(inner) => self.emit_macro_rules(inner).into(),
            ast::Item::Module(inner) => self.emit_module(inner).into(),
            ast::Item::Static(inner) => self.emit_static(inner).into(),
            ast::Item::Struct(inner) => self.emit_struct(inner).into(),
            ast::Item::Trait(inner) => self.emit_trait(inner).into(),
            ast::Item::TraitAlias(inner) => self.emit_trait_alias(inner).into(),
            ast::Item::TypeAlias(inner) => self.emit_type_alias(inner).into(),
            ast::Item::Union(inner) => self.emit_union(inner).into(),
            ast::Item::Use(inner) => self.emit_use(inner).into(),
        }
    }

    fn emit_abi(&mut self, node: ast::Abi) -> Label<generated::Abi> {
        let abi_string = node.try_get_text();
        let label = self.trap.emit(generated::Abi {
            id: TrapId::Star,
            abi_string,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_arg_list(&mut self, node: ast::ArgList) -> Label<generated::ArgList> {
        let args = node.args().map(|x| self.emit_expr(x)).collect();
        let label = self.trap.emit(generated::ArgList {
            id: TrapId::Star,
            args,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_array_expr(&mut self, node: ast::ArrayExpr) -> Label<generated::ArrayExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let exprs = node.exprs().map(|x| self.emit_expr(x)).collect();
        let label = self.trap.emit(generated::ArrayExpr {
            id: TrapId::Star,
            attrs,
            exprs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_array_type(&mut self, node: ast::ArrayType) -> Label<generated::ArrayType> {
        let const_arg = node.const_arg().map(|x| self.emit_const_arg(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::ArrayType {
            id: TrapId::Star,
            const_arg,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_asm_expr(&mut self, node: ast::AsmExpr) -> Label<generated::AsmExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::AsmExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_assoc_item_list(
        &mut self,
        node: ast::AssocItemList,
    ) -> Label<generated::AssocItemList> {
        let assoc_items = node
            .assoc_items()
            .map(|x| self.emit_assoc_item(x))
            .collect();
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = self.trap.emit(generated::AssocItemList {
            id: TrapId::Star,
            assoc_items,
            attrs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_assoc_type_arg(&mut self, node: ast::AssocTypeArg) -> Label<generated::AssocTypeArg> {
        let const_arg = node.const_arg().map(|x| self.emit_const_arg(x));
        let generic_arg_list = node
            .generic_arg_list()
            .map(|x| self.emit_generic_arg_list(x));
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let param_list = node.param_list().map(|x| self.emit_param_list(x));
        let ret_type = node.ret_type().map(|x| self.emit_ret_type(x));
        let return_type_syntax = node
            .return_type_syntax()
            .map(|x| self.emit_return_type_syntax(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::AssocTypeArg {
            id: TrapId::Star,
            const_arg,
            generic_arg_list,
            name_ref,
            param_list,
            ret_type,
            return_type_syntax,
            ty,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_attr(&mut self, node: ast::Attr) -> Label<generated::Attr> {
        let meta = node.meta().map(|x| self.emit_meta(x));
        let label = self.trap.emit(generated::Attr {
            id: TrapId::Star,
            meta,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_await_expr(&mut self, node: ast::AwaitExpr) -> Label<generated::AwaitExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::AwaitExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_become_expr(&mut self, node: ast::BecomeExpr) -> Label<generated::BecomeExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::BecomeExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_bin_expr(&mut self, node: ast::BinExpr) -> Label<generated::BinaryExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let lhs = node.lhs().map(|x| self.emit_expr(x));
        let operator_name = node.try_get_text();
        let rhs = node.rhs().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::BinaryExpr {
            id: TrapId::Star,
            attrs,
            lhs,
            operator_name,
            rhs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_block_expr(&mut self, node: ast::BlockExpr) -> Label<generated::BlockExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = node.label().map(|x| self.emit_label(x));
        let stmt_list = node.stmt_list().map(|x| self.emit_stmt_list(x));
        let label = self.trap.emit(generated::BlockExpr {
            id: TrapId::Star,
            attrs,
            label,
            stmt_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_box_pat(&mut self, node: ast::BoxPat) -> Label<generated::BoxPat> {
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::BoxPat {
            id: TrapId::Star,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_break_expr(&mut self, node: ast::BreakExpr) -> Label<generated::BreakExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let label = self.trap.emit(generated::BreakExpr {
            id: TrapId::Star,
            attrs,
            expr,
            lifetime,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_call_expr(&mut self, node: ast::CallExpr) -> Label<generated::CallExpr> {
        let arg_list = node.arg_list().map(|x| self.emit_arg_list(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::CallExpr {
            id: TrapId::Star,
            arg_list,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_cast_expr(&mut self, node: ast::CastExpr) -> Label<generated::CastExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::CastExpr {
            id: TrapId::Star,
            attrs,
            expr,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_closure_binder(&mut self, node: ast::ClosureBinder) -> Label<generated::ClosureBinder> {
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let label = self.trap.emit(generated::ClosureBinder {
            id: TrapId::Star,
            generic_param_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_closure_expr(&mut self, node: ast::ClosureExpr) -> Label<generated::ClosureExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let body = node.body().map(|x| self.emit_expr(x));
        let closure_binder = node.closure_binder().map(|x| self.emit_closure_binder(x));
        let param_list = node.param_list().map(|x| self.emit_param_list(x));
        let ret_type = node.ret_type().map(|x| self.emit_ret_type(x));
        let label = self.trap.emit(generated::ClosureExpr {
            id: TrapId::Star,
            attrs,
            body,
            closure_binder,
            param_list,
            ret_type,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_const(&mut self, node: ast::Const) -> Label<generated::Const> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let body = node.body().map(|x| self.emit_expr(x));
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::Const {
            id: TrapId::Star,
            attrs,
            body,
            name,
            ty,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_const_arg(&mut self, node: ast::ConstArg) -> Label<generated::ConstArg> {
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::ConstArg {
            id: TrapId::Star,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_const_block_pat(
        &mut self,
        node: ast::ConstBlockPat,
    ) -> Label<generated::ConstBlockPat> {
        let block_expr = node.block_expr().map(|x| self.emit_block_expr(x));
        let label = self.trap.emit(generated::ConstBlockPat {
            id: TrapId::Star,
            block_expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_const_param(&mut self, node: ast::ConstParam) -> Label<generated::ConstParam> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let default_val = node.default_val().map(|x| self.emit_const_arg(x));
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::ConstParam {
            id: TrapId::Star,
            attrs,
            default_val,
            name,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_continue_expr(&mut self, node: ast::ContinueExpr) -> Label<generated::ContinueExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let label = self.trap.emit(generated::ContinueExpr {
            id: TrapId::Star,
            attrs,
            lifetime,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_dyn_trait_type(&mut self, node: ast::DynTraitType) -> Label<generated::DynTraitType> {
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::DynTraitType {
            id: TrapId::Star,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_enum(&mut self, node: ast::Enum) -> Label<generated::Enum> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let variant_list = node.variant_list().map(|x| self.emit_variant_list(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Enum {
            id: TrapId::Star,
            attrs,
            generic_param_list,
            name,
            variant_list,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_expr_stmt(&mut self, node: ast::ExprStmt) -> Label<generated::ExprStmt> {
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::ExprStmt {
            id: TrapId::Star,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_extern_block(&mut self, node: ast::ExternBlock) -> Label<generated::ExternBlock> {
        let abi = node.abi().map(|x| self.emit_abi(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let extern_item_list = node
            .extern_item_list()
            .map(|x| self.emit_extern_item_list(x));
        let label = self.trap.emit(generated::ExternBlock {
            id: TrapId::Star,
            abi,
            attrs,
            extern_item_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_extern_crate(&mut self, node: ast::ExternCrate) -> Label<generated::ExternCrate> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let rename = node.rename().map(|x| self.emit_rename(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::ExternCrate {
            id: TrapId::Star,
            attrs,
            name_ref,
            rename,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_extern_item_list(
        &mut self,
        node: ast::ExternItemList,
    ) -> Label<generated::ExternItemList> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let extern_items = node
            .extern_items()
            .map(|x| self.emit_extern_item(x))
            .collect();
        let label = self.trap.emit(generated::ExternItemList {
            id: TrapId::Star,
            attrs,
            extern_items,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_field_expr(&mut self, node: ast::FieldExpr) -> Label<generated::FieldExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let label = self.trap.emit(generated::FieldExpr {
            id: TrapId::Star,
            attrs,
            expr,
            name_ref,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_fn(&mut self, node: ast::Fn) -> Label<generated::Function> {
        let abi = node.abi().map(|x| self.emit_abi(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let body = node.body().map(|x| self.emit_block_expr(x));
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let param_list = node.param_list().map(|x| self.emit_param_list(x));
        let ret_type = node.ret_type().map(|x| self.emit_ret_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Function {
            id: TrapId::Star,
            abi,
            attrs,
            body,
            generic_param_list,
            name,
            param_list,
            ret_type,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_fn_ptr_type(&mut self, node: ast::FnPtrType) -> Label<generated::FnPtrType> {
        let abi = node.abi().map(|x| self.emit_abi(x));
        let param_list = node.param_list().map(|x| self.emit_param_list(x));
        let ret_type = node.ret_type().map(|x| self.emit_ret_type(x));
        let label = self.trap.emit(generated::FnPtrType {
            id: TrapId::Star,
            abi,
            param_list,
            ret_type,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_for_expr(&mut self, node: ast::ForExpr) -> Label<generated::ForExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let iterable = node.iterable().map(|x| self.emit_expr(x));
        let label = node.label().map(|x| self.emit_label(x));
        let loop_body = node.loop_body().map(|x| self.emit_block_expr(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::ForExpr {
            id: TrapId::Star,
            attrs,
            iterable,
            label,
            loop_body,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_for_type(&mut self, node: ast::ForType) -> Label<generated::ForType> {
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::ForType {
            id: TrapId::Star,
            generic_param_list,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_format_args_arg(
        &mut self,
        node: ast::FormatArgsArg,
    ) -> Label<generated::FormatArgsArg> {
        let expr = node.expr().map(|x| self.emit_expr(x));
        let name = node.name().map(|x| self.emit_name(x));
        let label = self.trap.emit(generated::FormatArgsArg {
            id: TrapId::Star,
            expr,
            name,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_format_args_expr(
        &mut self,
        node: ast::FormatArgsExpr,
    ) -> Label<generated::FormatArgsExpr> {
        let args = node.args().map(|x| self.emit_format_args_arg(x)).collect();
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let template = node.template().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::FormatArgsExpr {
            id: TrapId::Star,
            args,
            attrs,
            template,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_generic_arg_list(
        &mut self,
        node: ast::GenericArgList,
    ) -> Label<generated::GenericArgList> {
        let generic_args = node
            .generic_args()
            .map(|x| self.emit_generic_arg(x))
            .collect();
        let label = self.trap.emit(generated::GenericArgList {
            id: TrapId::Star,
            generic_args,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_generic_param_list(
        &mut self,
        node: ast::GenericParamList,
    ) -> Label<generated::GenericParamList> {
        let generic_params = node
            .generic_params()
            .map(|x| self.emit_generic_param(x))
            .collect();
        let label = self.trap.emit(generated::GenericParamList {
            id: TrapId::Star,
            generic_params,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ident_pat(&mut self, node: ast::IdentPat) -> Label<generated::IdentPat> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let name = node.name().map(|x| self.emit_name(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::IdentPat {
            id: TrapId::Star,
            attrs,
            name,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_if_expr(&mut self, node: ast::IfExpr) -> Label<generated::IfExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let condition = node.condition().map(|x| self.emit_expr(x));
        let else_ = node.else_branch().map(|x| self.emit_else_branch(x));
        let then = node.then_branch().map(|x| self.emit_block_expr(x));
        let label = self.trap.emit(generated::IfExpr {
            id: TrapId::Star,
            attrs,
            condition,
            else_,
            then,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_impl(&mut self, node: ast::Impl) -> Label<generated::Impl> {
        let assoc_item_list = node.assoc_item_list().map(|x| self.emit_assoc_item_list(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let self_ty = node.self_ty().map(|x| self.emit_type(x));
        let trait_ = node.trait_().map(|x| self.emit_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Impl {
            id: TrapId::Star,
            assoc_item_list,
            attrs,
            generic_param_list,
            self_ty,
            trait_,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_impl_trait_type(
        &mut self,
        node: ast::ImplTraitType,
    ) -> Label<generated::ImplTraitType> {
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::ImplTraitType {
            id: TrapId::Star,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_index_expr(&mut self, node: ast::IndexExpr) -> Label<generated::IndexExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let base = node.base().map(|x| self.emit_expr(x));
        let index = node.index().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::IndexExpr {
            id: TrapId::Star,
            attrs,
            base,
            index,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_infer_type(&mut self, node: ast::InferType) -> Label<generated::InferType> {
        let label = self.trap.emit(generated::InferType { id: TrapId::Star });
        self.emit_location(label, node);
        label
    }

    fn emit_item_list(&mut self, node: ast::ItemList) -> Label<generated::ItemList> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let items = node.items().map(|x| self.emit_item(x)).collect();
        let label = self.trap.emit(generated::ItemList {
            id: TrapId::Star,
            attrs,
            items,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_label(&mut self, node: ast::Label) -> Label<generated::Label> {
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let label = self.trap.emit(generated::Label {
            id: TrapId::Star,
            lifetime,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_let_else(&mut self, node: ast::LetElse) -> Label<generated::LetElse> {
        let block_expr = node.block_expr().map(|x| self.emit_block_expr(x));
        let label = self.trap.emit(generated::LetElse {
            id: TrapId::Star,
            block_expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_let_expr(&mut self, node: ast::LetExpr) -> Label<generated::LetExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::LetExpr {
            id: TrapId::Star,
            attrs,
            expr,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_let_stmt(&mut self, node: ast::LetStmt) -> Label<generated::LetStmt> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let initializer = node.initializer().map(|x| self.emit_expr(x));
        let let_else = node.let_else().map(|x| self.emit_let_else(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::LetStmt {
            id: TrapId::Star,
            attrs,
            initializer,
            let_else,
            pat,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_lifetime(&mut self, node: ast::Lifetime) -> Label<generated::Lifetime> {
        let text = node.try_get_text();
        let label = self.trap.emit(generated::Lifetime {
            id: TrapId::Star,
            text,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_lifetime_arg(&mut self, node: ast::LifetimeArg) -> Label<generated::LifetimeArg> {
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let label = self.trap.emit(generated::LifetimeArg {
            id: TrapId::Star,
            lifetime,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_lifetime_param(&mut self, node: ast::LifetimeParam) -> Label<generated::LifetimeParam> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::LifetimeParam {
            id: TrapId::Star,
            attrs,
            lifetime,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_literal(&mut self, node: ast::Literal) -> Label<generated::LiteralExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let text_value = node.try_get_text();
        let label = self.trap.emit(generated::LiteralExpr {
            id: TrapId::Star,
            attrs,
            text_value,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_literal_pat(&mut self, node: ast::LiteralPat) -> Label<generated::LiteralPat> {
        let literal = node.literal().map(|x| self.emit_literal(x));
        let label = self.trap.emit(generated::LiteralPat {
            id: TrapId::Star,
            literal,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_loop_expr(&mut self, node: ast::LoopExpr) -> Label<generated::LoopExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = node.label().map(|x| self.emit_label(x));
        let loop_body = node.loop_body().map(|x| self.emit_block_expr(x));
        let label = self.trap.emit(generated::LoopExpr {
            id: TrapId::Star,
            attrs,
            label,
            loop_body,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_call(&mut self, node: ast::MacroCall) -> Label<generated::MacroCall> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let path = node.path().map(|x| self.emit_path(x));
        let token_tree = node.token_tree().map(|x| self.emit_token_tree(x));
        let label = self.trap.emit(generated::MacroCall {
            id: TrapId::Star,
            attrs,
            path,
            token_tree,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_def(&mut self, node: ast::MacroDef) -> Label<generated::MacroDef> {
        let args = node.args().map(|x| self.emit_token_tree(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let body = node.body().map(|x| self.emit_token_tree(x));
        let name = node.name().map(|x| self.emit_name(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::MacroDef {
            id: TrapId::Star,
            args,
            attrs,
            body,
            name,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_expr(&mut self, node: ast::MacroExpr) -> Label<generated::MacroExpr> {
        let macro_call = node.macro_call().map(|x| self.emit_macro_call(x));
        let label = self.trap.emit(generated::MacroExpr {
            id: TrapId::Star,
            macro_call,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_pat(&mut self, node: ast::MacroPat) -> Label<generated::MacroPat> {
        let macro_call = node.macro_call().map(|x| self.emit_macro_call(x));
        let label = self.trap.emit(generated::MacroPat {
            id: TrapId::Star,
            macro_call,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_rules(&mut self, node: ast::MacroRules) -> Label<generated::MacroRules> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let name = node.name().map(|x| self.emit_name(x));
        let token_tree = node.token_tree().map(|x| self.emit_token_tree(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::MacroRules {
            id: TrapId::Star,
            attrs,
            name,
            token_tree,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_macro_type(&mut self, node: ast::MacroType) -> Label<generated::MacroType> {
        let macro_call = node.macro_call().map(|x| self.emit_macro_call(x));
        let label = self.trap.emit(generated::MacroType {
            id: TrapId::Star,
            macro_call,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_match_arm(&mut self, node: ast::MatchArm) -> Label<generated::MatchArm> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let guard = node.guard().map(|x| self.emit_match_guard(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::MatchArm {
            id: TrapId::Star,
            attrs,
            expr,
            guard,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_match_arm_list(&mut self, node: ast::MatchArmList) -> Label<generated::MatchArmList> {
        let arms = node.arms().map(|x| self.emit_match_arm(x)).collect();
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = self.trap.emit(generated::MatchArmList {
            id: TrapId::Star,
            arms,
            attrs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_match_expr(&mut self, node: ast::MatchExpr) -> Label<generated::MatchExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let match_arm_list = node.match_arm_list().map(|x| self.emit_match_arm_list(x));
        let label = self.trap.emit(generated::MatchExpr {
            id: TrapId::Star,
            attrs,
            expr,
            match_arm_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_match_guard(&mut self, node: ast::MatchGuard) -> Label<generated::MatchGuard> {
        let condition = node.condition().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::MatchGuard {
            id: TrapId::Star,
            condition,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_meta(&mut self, node: ast::Meta) -> Label<generated::Meta> {
        let expr = node.expr().map(|x| self.emit_expr(x));
        let path = node.path().map(|x| self.emit_path(x));
        let token_tree = node.token_tree().map(|x| self.emit_token_tree(x));
        let label = self.trap.emit(generated::Meta {
            id: TrapId::Star,
            expr,
            path,
            token_tree,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_method_call_expr(
        &mut self,
        node: ast::MethodCallExpr,
    ) -> Label<generated::MethodCallExpr> {
        let arg_list = node.arg_list().map(|x| self.emit_arg_list(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_arg_list = node
            .generic_arg_list()
            .map(|x| self.emit_generic_arg_list(x));
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let receiver = node.receiver().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::MethodCallExpr {
            id: TrapId::Star,
            arg_list,
            attrs,
            generic_arg_list,
            name_ref,
            receiver,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_module(&mut self, node: ast::Module) -> Label<generated::Module> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let item_list = node.item_list().map(|x| self.emit_item_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::Module {
            id: TrapId::Star,
            attrs,
            item_list,
            name,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_name(&mut self, node: ast::Name) -> Label<generated::Name> {
        let text = node.try_get_text();
        let label = self.trap.emit(generated::Name {
            id: TrapId::Star,
            text,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_name_ref(&mut self, node: ast::NameRef) -> Label<generated::NameRef> {
        let text = node.try_get_text();
        let label = self.trap.emit(generated::NameRef {
            id: TrapId::Star,
            text,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_never_type(&mut self, node: ast::NeverType) -> Label<generated::NeverType> {
        let label = self.trap.emit(generated::NeverType { id: TrapId::Star });
        self.emit_location(label, node);
        label
    }

    fn emit_offset_of_expr(&mut self, node: ast::OffsetOfExpr) -> Label<generated::OffsetOfExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let fields = node.fields().map(|x| self.emit_name_ref(x)).collect();
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::OffsetOfExpr {
            id: TrapId::Star,
            attrs,
            fields,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_or_pat(&mut self, node: ast::OrPat) -> Label<generated::OrPat> {
        let pats = node.pats().map(|x| self.emit_pat(x)).collect();
        let label = self.trap.emit(generated::OrPat {
            id: TrapId::Star,
            pats,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_param(&mut self, node: ast::Param) -> Label<generated::Param> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let pat = node.pat().map(|x| self.emit_pat(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::Param {
            id: TrapId::Star,
            attrs,
            pat,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_param_list(&mut self, node: ast::ParamList) -> Label<generated::ParamList> {
        let params = node.params().map(|x| self.emit_param(x)).collect();
        let self_param = node.self_param().map(|x| self.emit_self_param(x));
        let label = self.trap.emit(generated::ParamList {
            id: TrapId::Star,
            params,
            self_param,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_paren_expr(&mut self, node: ast::ParenExpr) -> Label<generated::ParenExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::ParenExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_paren_pat(&mut self, node: ast::ParenPat) -> Label<generated::ParenPat> {
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::ParenPat {
            id: TrapId::Star,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_paren_type(&mut self, node: ast::ParenType) -> Label<generated::ParenType> {
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::ParenType {
            id: TrapId::Star,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_path(&mut self, node: ast::Path) -> Label<generated::Path> {
        let qualifier = node.qualifier().map(|x| self.emit_path(x));
        let part = node.segment().map(|x| self.emit_path_segment(x));
        let label = self.trap.emit(generated::Path {
            id: TrapId::Star,
            qualifier,
            part,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_path_expr(&mut self, node: ast::PathExpr) -> Label<generated::PathExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let path = node.path().map(|x| self.emit_path(x));
        let label = self.trap.emit(generated::PathExpr {
            id: TrapId::Star,
            attrs,
            path,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_path_pat(&mut self, node: ast::PathPat) -> Label<generated::PathPat> {
        let path = node.path().map(|x| self.emit_path(x));
        let label = self.trap.emit(generated::PathPat {
            id: TrapId::Star,
            path,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_path_segment(&mut self, node: ast::PathSegment) -> Label<generated::PathSegment> {
        let generic_arg_list = node
            .generic_arg_list()
            .map(|x| self.emit_generic_arg_list(x));
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let param_list = node.param_list().map(|x| self.emit_param_list(x));
        let path_type = node.path_type().map(|x| self.emit_path_type(x));
        let ret_type = node.ret_type().map(|x| self.emit_ret_type(x));
        let return_type_syntax = node
            .return_type_syntax()
            .map(|x| self.emit_return_type_syntax(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::PathSegment {
            id: TrapId::Star,
            generic_arg_list,
            name_ref,
            param_list,
            path_type,
            ret_type,
            return_type_syntax,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_path_type(&mut self, node: ast::PathType) -> Label<generated::PathType> {
        let path = node.path().map(|x| self.emit_path(x));
        let label = self.trap.emit(generated::PathType {
            id: TrapId::Star,
            path,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_prefix_expr(&mut self, node: ast::PrefixExpr) -> Label<generated::PrefixExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let operator_name = node.try_get_text();
        let label = self.trap.emit(generated::PrefixExpr {
            id: TrapId::Star,
            attrs,
            expr,
            operator_name,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ptr_type(&mut self, node: ast::PtrType) -> Label<generated::PtrType> {
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::PtrType {
            id: TrapId::Star,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_range_expr(&mut self, node: ast::RangeExpr) -> Label<generated::RangeExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let end = node.end().map(|x| self.emit_expr(x));
        let operator_name = node.try_get_text();
        let start = node.start().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::RangeExpr {
            id: TrapId::Star,
            attrs,
            end,
            operator_name,
            start,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_range_pat(&mut self, node: ast::RangePat) -> Label<generated::RangePat> {
        let end = node.end().map(|x| self.emit_pat(x));
        let operator_name = node.try_get_text();
        let start = node.start().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::RangePat {
            id: TrapId::Star,
            end,
            operator_name,
            start,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_expr(&mut self, node: ast::RecordExpr) -> Label<generated::RecordExpr> {
        let path = node.path().map(|x| self.emit_path(x));
        let record_expr_field_list = node
            .record_expr_field_list()
            .map(|x| self.emit_record_expr_field_list(x));
        let label = self.trap.emit(generated::RecordExpr {
            id: TrapId::Star,
            path,
            record_expr_field_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_expr_field(
        &mut self,
        node: ast::RecordExprField,
    ) -> Label<generated::RecordExprField> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let label = self.trap.emit(generated::RecordExprField {
            id: TrapId::Star,
            attrs,
            expr,
            name_ref,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_expr_field_list(
        &mut self,
        node: ast::RecordExprFieldList,
    ) -> Label<generated::RecordExprFieldList> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let fields = node
            .fields()
            .map(|x| self.emit_record_expr_field(x))
            .collect();
        let spread = node.spread().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::RecordExprFieldList {
            id: TrapId::Star,
            attrs,
            fields,
            spread,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_field(&mut self, node: ast::RecordField) -> Label<generated::RecordField> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::RecordField {
            id: TrapId::Star,
            attrs,
            name,
            ty,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_field_list(
        &mut self,
        node: ast::RecordFieldList,
    ) -> Label<generated::RecordFieldList> {
        let fields = node.fields().map(|x| self.emit_record_field(x)).collect();
        let label = self.trap.emit(generated::RecordFieldList {
            id: TrapId::Star,
            fields,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_pat(&mut self, node: ast::RecordPat) -> Label<generated::RecordPat> {
        let path = node.path().map(|x| self.emit_path(x));
        let record_pat_field_list = node
            .record_pat_field_list()
            .map(|x| self.emit_record_pat_field_list(x));
        let label = self.trap.emit(generated::RecordPat {
            id: TrapId::Star,
            path,
            record_pat_field_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_pat_field(
        &mut self,
        node: ast::RecordPatField,
    ) -> Label<generated::RecordPatField> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let name_ref = node.name_ref().map(|x| self.emit_name_ref(x));
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::RecordPatField {
            id: TrapId::Star,
            attrs,
            name_ref,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_record_pat_field_list(
        &mut self,
        node: ast::RecordPatFieldList,
    ) -> Label<generated::RecordPatFieldList> {
        let fields = node
            .fields()
            .map(|x| self.emit_record_pat_field(x))
            .collect();
        let rest_pat = node.rest_pat().map(|x| self.emit_rest_pat(x));
        let label = self.trap.emit(generated::RecordPatFieldList {
            id: TrapId::Star,
            fields,
            rest_pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ref_expr(&mut self, node: ast::RefExpr) -> Label<generated::RefExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::RefExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ref_pat(&mut self, node: ast::RefPat) -> Label<generated::RefPat> {
        let pat = node.pat().map(|x| self.emit_pat(x));
        let label = self.trap.emit(generated::RefPat {
            id: TrapId::Star,
            pat,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ref_type(&mut self, node: ast::RefType) -> Label<generated::RefType> {
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::RefType {
            id: TrapId::Star,
            lifetime,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_rename(&mut self, node: ast::Rename) -> Label<generated::Rename> {
        let name = node.name().map(|x| self.emit_name(x));
        let label = self.trap.emit(generated::Rename {
            id: TrapId::Star,
            name,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_rest_pat(&mut self, node: ast::RestPat) -> Label<generated::RestPat> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = self.trap.emit(generated::RestPat {
            id: TrapId::Star,
            attrs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_ret_type(&mut self, node: ast::RetType) -> Label<generated::RetType> {
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::RetType {
            id: TrapId::Star,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_return_expr(&mut self, node: ast::ReturnExpr) -> Label<generated::ReturnExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::ReturnExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_return_type_syntax(
        &mut self,
        node: ast::ReturnTypeSyntax,
    ) -> Label<generated::ReturnTypeSyntax> {
        let label = self
            .trap
            .emit(generated::ReturnTypeSyntax { id: TrapId::Star });
        self.emit_location(label, node);
        label
    }

    fn emit_self_param(&mut self, node: ast::SelfParam) -> Label<generated::SelfParam> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::SelfParam {
            id: TrapId::Star,
            attrs,
            lifetime,
            name,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_slice_pat(&mut self, node: ast::SlicePat) -> Label<generated::SlicePat> {
        let pats = node.pats().map(|x| self.emit_pat(x)).collect();
        let label = self.trap.emit(generated::SlicePat {
            id: TrapId::Star,
            pats,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_slice_type(&mut self, node: ast::SliceType) -> Label<generated::SliceType> {
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::SliceType {
            id: TrapId::Star,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_source_file(&mut self, node: ast::SourceFile) -> Label<generated::SourceFile> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let items = node.items().map(|x| self.emit_item(x)).collect();
        let label = self.trap.emit(generated::SourceFile {
            id: TrapId::Star,
            attrs,
            items,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_static(&mut self, node: ast::Static) -> Label<generated::Static> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let body = node.body().map(|x| self.emit_expr(x));
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::Static {
            id: TrapId::Star,
            attrs,
            body,
            name,
            ty,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_stmt_list(&mut self, node: ast::StmtList) -> Label<generated::StmtList> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let statements = node.statements().map(|x| self.emit_stmt(x)).collect();
        let tail_expr = node.tail_expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::StmtList {
            id: TrapId::Star,
            attrs,
            statements,
            tail_expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_struct(&mut self, node: ast::Struct) -> Label<generated::Struct> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let field_list = node.field_list().map(|x| self.emit_field_list(x));
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Struct {
            id: TrapId::Star,
            attrs,
            field_list,
            generic_param_list,
            name,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_token_tree(&mut self, node: ast::TokenTree) -> Label<generated::TokenTree> {
        let label = self.trap.emit(generated::TokenTree { id: TrapId::Star });
        self.emit_location(label, node);
        label
    }

    fn emit_trait(&mut self, node: ast::Trait) -> Label<generated::Trait> {
        let assoc_item_list = node.assoc_item_list().map(|x| self.emit_assoc_item_list(x));
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Trait {
            id: TrapId::Star,
            assoc_item_list,
            attrs,
            generic_param_list,
            name,
            type_bound_list,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_trait_alias(&mut self, node: ast::TraitAlias) -> Label<generated::TraitAlias> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::TraitAlias {
            id: TrapId::Star,
            attrs,
            generic_param_list,
            name,
            type_bound_list,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_try_expr(&mut self, node: ast::TryExpr) -> Label<generated::TryExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::TryExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_expr(&mut self, node: ast::TupleExpr) -> Label<generated::TupleExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let fields = node.fields().map(|x| self.emit_expr(x)).collect();
        let label = self.trap.emit(generated::TupleExpr {
            id: TrapId::Star,
            attrs,
            fields,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_field(&mut self, node: ast::TupleField) -> Label<generated::TupleField> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let ty = node.ty().map(|x| self.emit_type(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::TupleField {
            id: TrapId::Star,
            attrs,
            ty,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_field_list(
        &mut self,
        node: ast::TupleFieldList,
    ) -> Label<generated::TupleFieldList> {
        let fields = node.fields().map(|x| self.emit_tuple_field(x)).collect();
        let label = self.trap.emit(generated::TupleFieldList {
            id: TrapId::Star,
            fields,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_pat(&mut self, node: ast::TuplePat) -> Label<generated::TuplePat> {
        let fields = node.fields().map(|x| self.emit_pat(x)).collect();
        let label = self.trap.emit(generated::TuplePat {
            id: TrapId::Star,
            fields,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_struct_pat(
        &mut self,
        node: ast::TupleStructPat,
    ) -> Label<generated::TupleStructPat> {
        let fields = node.fields().map(|x| self.emit_pat(x)).collect();
        let path = node.path().map(|x| self.emit_path(x));
        let label = self.trap.emit(generated::TupleStructPat {
            id: TrapId::Star,
            fields,
            path,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_tuple_type(&mut self, node: ast::TupleType) -> Label<generated::TupleType> {
        let fields = node.fields().map(|x| self.emit_type(x)).collect();
        let label = self.trap.emit(generated::TupleType {
            id: TrapId::Star,
            fields,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_type_alias(&mut self, node: ast::TypeAlias) -> Label<generated::TypeAlias> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::TypeAlias {
            id: TrapId::Star,
            attrs,
            generic_param_list,
            name,
            ty,
            type_bound_list,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_type_arg(&mut self, node: ast::TypeArg) -> Label<generated::TypeArg> {
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::TypeArg {
            id: TrapId::Star,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_type_bound(&mut self, node: ast::TypeBound) -> Label<generated::TypeBound> {
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let label = self.trap.emit(generated::TypeBound {
            id: TrapId::Star,
            generic_param_list,
            lifetime,
            ty,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_type_bound_list(
        &mut self,
        node: ast::TypeBoundList,
    ) -> Label<generated::TypeBoundList> {
        let bounds = node.bounds().map(|x| self.emit_type_bound(x)).collect();
        let label = self.trap.emit(generated::TypeBoundList {
            id: TrapId::Star,
            bounds,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_type_param(&mut self, node: ast::TypeParam) -> Label<generated::TypeParam> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let default_type = node.default_type().map(|x| self.emit_type(x));
        let name = node.name().map(|x| self.emit_name(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::TypeParam {
            id: TrapId::Star,
            attrs,
            default_type,
            name,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_underscore_expr(
        &mut self,
        node: ast::UnderscoreExpr,
    ) -> Label<generated::UnderscoreExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let label = self.trap.emit(generated::UnderscoreExpr {
            id: TrapId::Star,
            attrs,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_union(&mut self, node: ast::Union) -> Label<generated::Union> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let record_field_list = node
            .record_field_list()
            .map(|x| self.emit_record_field_list(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let where_clause = node.where_clause().map(|x| self.emit_where_clause(x));
        let label = self.trap.emit(generated::Union {
            id: TrapId::Star,
            attrs,
            generic_param_list,
            name,
            record_field_list,
            visibility,
            where_clause,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_use(&mut self, node: ast::Use) -> Label<generated::Use> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let use_tree = node.use_tree().map(|x| self.emit_use_tree(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::Use {
            id: TrapId::Star,
            attrs,
            use_tree,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_use_tree(&mut self, node: ast::UseTree) -> Label<generated::UseTree> {
        let path = node.path().map(|x| self.emit_path(x));
        let rename = node.rename().map(|x| self.emit_rename(x));
        let use_tree_list = node.use_tree_list().map(|x| self.emit_use_tree_list(x));
        let label = self.trap.emit(generated::UseTree {
            id: TrapId::Star,
            path,
            rename,
            use_tree_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_use_tree_list(&mut self, node: ast::UseTreeList) -> Label<generated::UseTreeList> {
        let use_trees = node.use_trees().map(|x| self.emit_use_tree(x)).collect();
        let label = self.trap.emit(generated::UseTreeList {
            id: TrapId::Star,
            use_trees,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_variant(&mut self, node: ast::Variant) -> Label<generated::Variant> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let field_list = node.field_list().map(|x| self.emit_field_list(x));
        let name = node.name().map(|x| self.emit_name(x));
        let visibility = node.visibility().map(|x| self.emit_visibility(x));
        let label = self.trap.emit(generated::Variant {
            id: TrapId::Star,
            attrs,
            expr,
            field_list,
            name,
            visibility,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_variant_list(&mut self, node: ast::VariantList) -> Label<generated::VariantList> {
        let variants = node.variants().map(|x| self.emit_variant(x)).collect();
        let label = self.trap.emit(generated::VariantList {
            id: TrapId::Star,
            variants,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_visibility(&mut self, node: ast::Visibility) -> Label<generated::Visibility> {
        let path = node.path().map(|x| self.emit_path(x));
        let label = self.trap.emit(generated::Visibility {
            id: TrapId::Star,
            path,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_where_clause(&mut self, node: ast::WhereClause) -> Label<generated::WhereClause> {
        let predicates = node.predicates().map(|x| self.emit_where_pred(x)).collect();
        let label = self.trap.emit(generated::WhereClause {
            id: TrapId::Star,
            predicates,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_where_pred(&mut self, node: ast::WherePred) -> Label<generated::WherePred> {
        let generic_param_list = node
            .generic_param_list()
            .map(|x| self.emit_generic_param_list(x));
        let lifetime = node.lifetime().map(|x| self.emit_lifetime(x));
        let ty = node.ty().map(|x| self.emit_type(x));
        let type_bound_list = node.type_bound_list().map(|x| self.emit_type_bound_list(x));
        let label = self.trap.emit(generated::WherePred {
            id: TrapId::Star,
            generic_param_list,
            lifetime,
            ty,
            type_bound_list,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_while_expr(&mut self, node: ast::WhileExpr) -> Label<generated::WhileExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let condition = node.condition().map(|x| self.emit_expr(x));
        let label = node.label().map(|x| self.emit_label(x));
        let loop_body = node.loop_body().map(|x| self.emit_block_expr(x));
        let label = self.trap.emit(generated::WhileExpr {
            id: TrapId::Star,
            attrs,
            condition,
            label,
            loop_body,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_wildcard_pat(&mut self, node: ast::WildcardPat) -> Label<generated::WildcardPat> {
        let label = self.trap.emit(generated::WildcardPat { id: TrapId::Star });
        self.emit_location(label, node);
        label
    }

    fn emit_yeet_expr(&mut self, node: ast::YeetExpr) -> Label<generated::YeetExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::YeetExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }

    fn emit_yield_expr(&mut self, node: ast::YieldExpr) -> Label<generated::YieldExpr> {
        let attrs = node.attrs().map(|x| self.emit_attr(x)).collect();
        let expr = node.expr().map(|x| self.emit_expr(x));
        let label = self.trap.emit(generated::YieldExpr {
            id: TrapId::Star,
            attrs,
            expr,
        });
        self.emit_location(label, node);
        label
    }
}
