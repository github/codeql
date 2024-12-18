use ra_ap_hir::{Enum, Function, HasContainer, Module, Semantics, Struct, Trait, Union};
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

pub(crate) trait AddressableHir<Ast: AstNode>: HasContainer + Copy {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String>;
    fn try_from_source(value: &Ast, sema: &Semantics<'_, RootDatabase>) -> Option<Self>;
    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module;
}

impl AddressableHir<ast::Fn> for Function {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        Some(self.name(sema.db).as_str().to_owned())
    }

    fn try_from_source(value: &ast::Fn, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_fn_def(value)
    }

    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module {
        self.module(sema.db)
    }
}

impl AddressableHir<ast::Trait> for Trait {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        Some(self.name(sema.db).as_str().to_owned())
    }

    fn try_from_source(value: &ast::Trait, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_trait_def(value)
    }

    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module {
        self.module(sema.db)
    }
}

impl AddressableHir<ast::Module> for Module {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        self.name(sema.db).map(|s| s.as_str().to_owned())
    }

    fn try_from_source(value: &ast::Module, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_module_def(value)
    }

    fn module(self, _sema: &Semantics<'_, RootDatabase>) -> Module {
        self
    }
}

impl AddressableHir<ast::Struct> for Struct {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        Some(self.name(sema.db).as_str().to_owned())
    }

    fn try_from_source(value: &ast::Struct, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_struct_def(value)
    }

    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module {
        self.module(sema.db)
    }
}

impl AddressableHir<ast::Enum> for Enum {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        Some(self.name(sema.db).as_str().to_owned())
    }

    fn try_from_source(value: &ast::Enum, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_enum_def(value)
    }

    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module {
        self.module(sema.db)
    }
}

impl AddressableHir<ast::Union> for Union {
    fn name(self, sema: &Semantics<'_, RootDatabase>) -> Option<String> {
        Some(self.name(sema.db).as_str().to_owned())
    }

    fn try_from_source(value: &ast::Union, sema: &Semantics<'_, RootDatabase>) -> Option<Self> {
        sema.to_union_def(value)
    }

    fn module(self, sema: &Semantics<'_, RootDatabase>) -> Module {
        self.module(sema.db)
    }
}

pub(crate) trait AddressableAst: AstNode + Sized {
    type Hir: AddressableHir<Self>;
}

impl AddressableAst for ast::Fn {
    type Hir = Function;
}

impl AddressableAst for ast::Trait {
    type Hir = Trait;
}

impl AddressableAst for ast::Struct {
    type Hir = Struct;
}

impl AddressableAst for ast::Enum {
    type Hir = Enum;
}

impl AddressableAst for ast::Union {
    type Hir = Union;
}

impl AddressableAst for ast::Module {
    type Hir = Module;
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
