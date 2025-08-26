use crate::trap::{Label, TrapClass};
use ra_ap_hir::{Enum, Function, HasContainer, Module, Semantics, Struct, Trait, Union};
use ra_ap_ide_db::RootDatabase;
use ra_ap_syntax::{AstNode, ast, ast::RangeItem};

pub(crate) trait HasTrapClass: AstNode {
    type TrapClass: TrapClass;
}

pub(crate) trait Emission<T: HasTrapClass> {
    fn pre_emit(&mut self, _node: &T) -> Option<Label<T::TrapClass>> {
        None
    }

    fn post_emit(&mut self, _node: &T, _label: Label<T::TrapClass>) {}
}

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
