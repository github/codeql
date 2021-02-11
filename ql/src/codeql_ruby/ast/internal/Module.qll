private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Constant
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.TreeSitter

module ModuleBase {
  abstract class Range extends BodyStatement::Range { }
}

module Class {
  class Range extends ModuleBase::Range, ConstantWriteAccess::Range, @class {
    final override Generated::Class generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final override string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result =
        generated.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    }

    final override Expr::Range getScopeExpr() {
      result = generated.getName().(Generated::ScopeResolution).getScope()
    }

    final override predicate hasGlobalScope() {
      exists(Generated::ScopeResolution sr |
        sr = generated.getName() and
        not exists(sr.getScope())
      )
    }

    final Expr getSuperclassExpr() { result = generated.getSuperclass().getChild() }

    final override string toString() { result = this.getName() }
  }
}

module SingletonClass {
  class Range extends ModuleBase::Range, @singleton_class {
    final override Generated::SingletonClass generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final Expr getValue() { result = generated.getValue() }

    final override string toString() { result = "class << ..." }
  }
}

module Module {
  class Range extends ModuleBase::Range, ConstantWriteAccess::Range, @module {
    final override Generated::Module generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final override string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result =
        generated.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    }

    final override Expr::Range getScopeExpr() {
      result = generated.getName().(Generated::ScopeResolution).getScope()
    }

    final override predicate hasGlobalScope() {
      exists(Generated::ScopeResolution sr |
        sr = generated.getName() and
        not exists(sr.getScope())
      )
    }

    final override string toString() { result = this.getName() }
  }
}
