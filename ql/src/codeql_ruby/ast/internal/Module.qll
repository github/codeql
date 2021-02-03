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
      result = this.getNameScopeResolution().getName()
    }

    final ScopeResolution getNameScopeResolution() { result = generated.getName() }

    final Expr getSuperclassExpr() { result = generated.getSuperclass().getChild() }
  }
}

module SingletonClass {
  class Range extends ModuleBase::Range, @singleton_class {
    final override Generated::SingletonClass generated;

    final override Expr getExpr(int i) { result = generated.getChild(i) }

    final Expr getValue() { result = generated.getValue() }
  }
}

module Module {
  class Range extends ModuleBase::Range, @module {
    final override Generated::Module generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }

    final string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = this.getNameScopeResolution().getName()
    }

    final ScopeResolution getNameScopeResolution() { result = generated.getName() }
  }
}
