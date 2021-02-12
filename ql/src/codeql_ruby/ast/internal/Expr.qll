private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Literal
private import codeql_ruby.ast.internal.Statement
private import codeql_ruby.ast.internal.TreeSitter

module Expr {
  abstract class Range extends Stmt::Range { }
}

module Self {
  class Range extends Expr::Range, @token_self {
    final override Generated::Self generated;

    final override string toString() { result = "self" }
  }
}

module StmtSequence {
  abstract class Range extends Expr::Range {
    abstract Stmt getStmt(int n);

    int getNumberOfStatements() { result = count(this.getStmt(_)) }

    override string toString() {
      exists(int c | c = this.getNumberOfStatements() |
        c = 0 and result = ";"
        or
        c = 1 and result = this.getStmt(0).toString()
        or
        c > 1 and result = "...; ..."
      )
    }
  }
}

module BodyStatement {
  abstract class Range extends StmtSequence::Range {
    final override Stmt getStmt(int n) {
      result =
        rank[n + 1](Generated::AstNode node, int i |
          node = getChild(i) and
          not node instanceof Generated::Else and
          not node instanceof Generated::Rescue and
          not node instanceof Generated::Ensure
        |
          node order by i
        )
    }

    final RescueClause getRescue(int n) {
      result = rank[n + 1](Generated::Rescue node, int i | node = getChild(i) | node order by i)
    }

    final StmtSequence getElse() { result = unique(Generated::Else s | s = getChild(_)) }

    final StmtSequence getEnsure() { result = unique(Generated::Ensure s | s = getChild(_)) }

    abstract Generated::AstNode getChild(int i);
  }
}

module ParenthesizedExpr {
  class Range extends StmtSequence::Range, @parenthesized_statements {
    final override Generated::ParenthesizedStatements generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }

    final override string toString() {
      exists(int c | c = this.getNumberOfStatements() |
        c = 0 and result = "()"
        or
        c > 0 and result = "(" + StmtSequence::Range.super.toString() + ")"
      )
    }
  }
}

module BeginBlock {
  class Range extends StmtSequence::Range, @begin_block {
    final override Generated::BeginBlock generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }

    final override string toString() { result = "BEGIN { ... }" }
  }
}

module ThenExpr {
  class Range extends StmtSequence::Range, @then {
    final override Generated::Then generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }
  }
}

module ElseExpr {
  class Range extends StmtSequence::Range, @else {
    final override Generated::Else generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }
  }
}

module DoExpr {
  class Range extends StmtSequence::Range, @do {
    final override Generated::Do generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }
  }
}

module Ensure {
  class Range extends StmtSequence::Range, @ensure {
    final override Generated::Ensure generated;

    final override Stmt getStmt(int n) { result = generated.getChild(n) }

    final override string toString() { result = "ensure ..." }
  }
}

module RescueClause {
  class Range extends Expr::Range, @rescue {
    final override Generated::Rescue generated;

    final Expr getException(int n) { result = generated.getExceptions().getChild(n) }

    final Expr getVariableExpr() { result = generated.getVariable() }

    final StmtSequence getBody() { result = generated.getBody() }

    final override string toString() { result = "rescue ..." }
  }
}

module RescueModifierExpr {
  class Range extends Expr::Range, @rescue_modifier {
    final override Generated::RescueModifier generated;

    final Stmt getBody() { result = generated.getBody() }

    final Stmt getHandler() { result = generated.getHandler() }

    final override string toString() { result = "... rescue ..." }
  }
}

module Pair {
  class Range extends Expr::Range, @pair {
    final override Generated::Pair generated;

    final Expr getKey() { result = generated.getKey() }

    final Expr getValue() { result = generated.getValue() }

    final override string toString() { result = "Pair" }
  }
}

module StringConcatenation {
  class Range extends Expr::Range, @chained_string {
    final override Generated::ChainedString generated;

    final StringLiteral::Range getString(int i) { result = generated.getChild(i) }

    final override string toString() { result = "\"...\" \"...\"" }
  }
}
