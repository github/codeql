private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.TreeSitter

module Stmt {
  abstract class Range extends AstNode::Range { }
}

module EmptyStmt {
  class Range extends Stmt::Range, @token_empty_statement {
    final override Generated::EmptyStatement generated;

    final override string toString() { result = ";" }

    override predicate child(string label, AstNode::Range child) { none() }
  }
}

module EndBlock {
  class Range extends StmtSequence::Range, @end_block {
    final override Generated::EndBlock generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }

    final override string toString() { result = "END { ... }" }
  }
}

module UndefStmt {
  class Range extends Stmt::Range, @undef {
    final override Generated::Undef generated;

    final MethodName getMethodName(int n) { result = generated.getChild(n) }

    final override string toString() { result = "undef ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getMethodName" and child = getMethodName(_)
    }
  }
}

module AliasStmt {
  class Range extends Stmt::Range, @alias {
    final override Generated::Alias generated;

    final MethodName getNewName() { result = generated.getName() }

    final MethodName getOldName() { result = generated.getAlias() }

    final override string toString() { result = "alias ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getNewName" and child = getNewName()
      or
      label = "getOldName" and child = getOldName()
    }
  }
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

    override predicate child(string label, AstNode::Range child) {
      label = "getValue" and child = getValue()
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

module RedoStmt {
  class Range extends Stmt::Range, @redo {
    final override Generated::Redo generated;

    final override string toString() { result = "redo" }
  }
}

module RetryStmt {
  class Range extends Stmt::Range, @retry {
    final override Generated::Retry generated;

    final override string toString() { result = "retry" }
  }
}
