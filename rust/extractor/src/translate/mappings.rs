use crate::translate::label_cache::StorableAsModuleItemCanonicalPath;
use ra_ap_hir::{Enum, Module, Semantics, Struct, Trait, Union};
use ra_ap_ide_db::RootDatabase;
use ra_ap_syntax::{ast, ast::RangeItem, AstNode};

pub(crate) trait TextValue {
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
pub trait PathAst: AstNode {
    fn path(&self) -> Option<ast::Path>;
}

impl PathAst for ast::PathExpr {
    fn path(&self) -> Option<ast::Path> {
        self.path()
    }
}

impl PathAst for ast::RecordExpr {
    fn path(&self) -> Option<ast::Path> {
        self.path()
    }
}

impl PathAst for ast::PathPat {
    fn path(&self) -> Option<ast::Path> {
        self.path()
    }
}

impl PathAst for ast::RecordPat {
    fn path(&self) -> Option<ast::Path> {
        self.path()
    }
}

impl PathAst for ast::TupleStructPat {
    fn path(&self) -> Option<ast::Path> {
        self.path()
    }
}

pub trait ModuleItem: StorableAsModuleItemCanonicalPath {
    fn module(&self, sema: &Semantics<'_, RootDatabase>) -> Module;
    fn name(&self, sema: &Semantics<'_, RootDatabase>) -> String;
}

impl ModuleItem for Enum {
    fn module(&self, sema: &Semantics<'_, RootDatabase>) -> Module {
        Enum::module(*self, sema.db)
    }

    fn name(&self, sema: &Semantics<'_, RootDatabase>) -> String {
        Enum::name(*self, sema.db).as_str().to_owned()
    }
}

impl ModuleItem for Struct {
    fn module(&self, sema: &Semantics<'_, RootDatabase>) -> Module {
        Struct::module(*self, sema.db)
    }

    fn name(&self, sema: &Semantics<'_, RootDatabase>) -> String {
        Struct::name(*self, sema.db).as_str().to_owned()
    }
}

impl ModuleItem for Union {
    fn module(&self, sema: &Semantics<'_, RootDatabase>) -> Module {
        Union::module(*self, sema.db)
    }

    fn name(&self, sema: &Semantics<'_, RootDatabase>) -> String {
        Union::name(*self, sema.db).as_str().to_owned()
    }
}

impl ModuleItem for Trait {
    fn module(&self, sema: &Semantics<'_, RootDatabase>) -> Module {
        Trait::module(*self, sema.db)
    }

    fn name(&self, sema: &Semantics<'_, RootDatabase>) -> String {
        Trait::name(*self, sema.db).as_str().to_owned()
    }
}
