private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.TreeSitter

module Stmt {
  abstract class Range extends AstNode::Range { }
}

module ReturningStmt {
  abstract class Range extends Stmt::Range {
    abstract Generated::ArgumentList getArgumentList();

    final Expr getValue() {
      exists(Generated::ArgumentList a, int c |
        a = this.getArgumentList() and c = count(a.getChild(_))
      |
        result = a.getChild(0) and c = 1
        or
        result = a and c > 1
      )
    }
  }
}

module ReturnStmt {
  class Range extends ReturningStmt::Range, @return {
    final override Generated::Return generated;

    final override string toString() { result = "return" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}

module BreakStmt {
  class Range extends ReturningStmt::Range, @break {
    final override Generated::Break generated;

    final override string toString() { result = "break" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}

module NextStmt {
  class Range extends ReturningStmt::Range, @next {
    final override Generated::Next generated;

    final override string toString() { result = "next" }

    final override Generated::ArgumentList getArgumentList() { result = generated.getChild() }
  }
}
