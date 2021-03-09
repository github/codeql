private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Parameter
private import codeql_ruby.ast.internal.Scope
private import TreeSitter

module Callable {
  abstract class Range extends Expr::Range {
    abstract Parameter::Range getParameter(int n);

    override predicate child(string label, AstNode::Range child) {
      label = "getParameter" and child = getParameter(_)
    }
  }
}

module MethodBase {
  abstract class Range extends Callable::Range, BodyStatement::Range, Scope::Range {
    abstract string getName();

    override predicate child(string label, AstNode::Range child) {
      Callable::Range.super.child(label, child) or BodyStatement::Range.super.child(label, child)
    }

    override string toString() { result = BodyStatement::Range.super.toString() }
  }
}

module Method {
  class Range extends MethodBase::Range, @method {
    final override Generated::Method generated;

    override Parameter::Range getParameter(int n) { result = generated.getParameters().getChild(n) }

    override string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }

    final predicate isSetter() { generated.getName() instanceof Generated::Setter }

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final override string toString() { result = this.getName() }
  }
}

module SingletonMethod {
  class Range extends MethodBase::Range, @singleton_method {
    final override Generated::SingletonMethod generated;

    override Parameter::Range getParameter(int n) { result = generated.getParameters().getChild(n) }

    override string getName() {
      result = generated.getName().(Generated::Token).getValue() or
      result = generated.getName().(SymbolLiteral).getValueText() or
      result = generated.getName().(Generated::Setter).getName().getValue() + "="
    }

    final Generated::AstNode getObject() { result = generated.getObject() }

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final override string toString() { result = this.getName() }

    override predicate child(string label, AstNode::Range child) {
      MethodBase::Range.super.child(label, child)
      or
      label = "getObject" and child = getObject()
    }
  }
}

module Lambda {
  class Range extends Callable::Range, BodyStatement::Range, @lambda {
    final override Generated::Lambda generated;

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override Generated::AstNode getChild(int i) {
      result = generated.getBody().(Generated::DoBlock).getChild(i) or
      result = generated.getBody().(Generated::Block).getChild(i)
    }

    final override string toString() { result = "-> { ... }" }

    override predicate child(string label, AstNode::Range child) {
      Callable::Range.super.child(label, child)
      or
      BodyStatement::Range.super.child(label, child)
    }
  }
}

module Block {
  abstract class Range extends Callable::Range, StmtSequence::Range, Scope::Range {
    Range() { not generated.getParent() instanceof Generated::Lambda }

    override predicate child(string label, AstNode::Range child) {
      Callable::Range.super.child(label, child)
      or
      StmtSequence::Range.super.child(label, child)
    }

    override string toString() { result = StmtSequence::Range.super.toString() }
  }
}

module DoBlock {
  class Range extends Block::Range, BodyStatement::Range, @do_block {
    final override Generated::DoBlock generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override string toString() { result = "do ... end" }

    override predicate child(string label, AstNode::Range child) {
      Block::Range.super.child(label, child)
      or
      BodyStatement::Range.super.child(label, child)
    }
  }
}

module BraceBlock {
  class Range extends Block::Range, @block {
    final override Generated::Block generated;

    final override Parameter::Range getParameter(int n) {
      result = generated.getParameters().getChild(n)
    }

    final override Stmt getStmt(int i) { result = generated.getChild(i) }

    final override string toString() { result = "{ ... }" }
  }
}
