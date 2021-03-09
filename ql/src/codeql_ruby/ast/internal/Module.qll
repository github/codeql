private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Constant
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Scope
private import codeql_ruby.ast.internal.TreeSitter

module ModuleBase {
  abstract class Range extends BodyStatement::Range, Scope::Range {
    override string toString() { result = BodyStatement::Range.super.toString() }
  }
}

module Namespace {
  abstract class Range extends ModuleBase::Range, ConstantWriteAccess::Range {
    override predicate child(string label, AstNode::Range child) {
      ModuleBase::Range.super.child(label, child) or
      ConstantWriteAccess::Range.super.child(label, child)
    }

    override string toString() { result = ModuleBase::Range.super.toString() }
  }
}

module Toplevel {
  class Range extends ModuleBase::Range, @program {
    final override Generated::Program generated;

    Range() { generated.getLocation().getFile().getExtension() != "erb" }

    final override Generated::AstNode getChild(int i) {
      result = generated.getChild(i) and
      not result instanceof Generated::BeginBlock
    }

    final StmtSequence getBeginBlock(int n) {
      result = rank[n](int i, Generated::BeginBlock b | b = generated.getChild(i) | b order by i)
    }

    final override string toString() { result = generated.getLocation().getFile().getBaseName() }

    override predicate child(string label, AstNode::Range child) {
      ModuleBase::Range.super.child(label, child)
      or
      label = "getBeginBlock" and child = getBeginBlock(_)
    }
  }
}

module Class {
  class Range extends Namespace::Range, @class {
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

    override predicate child(string label, AstNode::Range child) {
      Namespace::Range.super.child(label, child)
      or
      label = "getSuperclassExpr" and child = getSuperclassExpr()
    }
  }
}

module SingletonClass {
  class Range extends ModuleBase::Range, @singleton_class {
    final override Generated::SingletonClass generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final Expr getValue() { result = generated.getValue() }

    final override string toString() { result = "class << ..." }

    override predicate child(string label, AstNode::Range child) {
      ModuleBase::Range.super.child(label, child)
      or
      label = "getValue" and child = getValue()
    }
  }
}

module Module {
  class Range extends Namespace::Range, @module {
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

    override predicate child(string label, AstNode::Range child) {
      Namespace::Range.super.child(label, child)
    }
  }
}
