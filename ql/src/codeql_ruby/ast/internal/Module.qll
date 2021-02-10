private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.TreeSitter

module ModuleBase {
  abstract class Range extends BodyStatement::Range { }
}

module Class {
  class Range extends ModuleBase::Range, @class {
    final override Generated::Class generated;

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result =
        generated.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    }

    final Expr getNameScopeExpr() {
      result = generated.getName().(Generated::ScopeResolution).getScope()
    }

    final predicate nameHasGlobalScope() {
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

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final Expr getValue() { result = generated.getValue() }

    final override string toString() { result = "class << ..." }
  }
}

module Module {
  class Range extends ModuleBase::Range, @module {
    final override Generated::Module generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }

    final string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result =
        generated.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    }

    final Expr getNameScopeExpr() {
      result = generated.getName().(Generated::ScopeResolution).getScope()
    }

    final predicate nameHasGlobalScope() {
      exists(Generated::ScopeResolution sr |
        sr = generated.getName() and
        not exists(sr.getScope())
      )
    }

    final override string toString() { result = this.getName() }
  }
}
