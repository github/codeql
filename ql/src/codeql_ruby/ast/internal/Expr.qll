private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
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

module ArgumentList {
  private class ValidParent = @break or @return or @next or @assignment or @operator_assignment;

  abstract class Range extends Expr::Range {
    Range() { generated.getParent() instanceof ValidParent }

    abstract Expr getElement(int i);

    final override string toString() { result = "..., ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getElement" and child = getElement(_)
    }
  }

  private class ArgArgumentList extends ArgumentList::Range, @argument_list {
    final override Generated::ArgumentList generated;

    ArgArgumentList() { strictcount(generated.getChild(_)) > 1 }

    final override Expr getElement(int i) { result = generated.getChild(i) }
  }

  private class AssignmentList extends ArgumentList::Range, @right_assignment_list {
    final override Generated::RightAssignmentList generated;

    final override Expr getElement(int i) { result = generated.getChild(i) }
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

    override predicate child(string label, AstNode::Range child) {
      label = "getStmt" and child = getStmt(_)
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

    override predicate child(string label, AstNode::Range child) {
      StmtSequence::Range.super.child(label, child)
      or
      label = "getRescue" and child = getRescue(_)
      or
      label = "getElse" and child = getElse()
      or
      label = "getEnsure" and child = getEnsure()
    }
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

    final LhsExpr getVariableExpr() { result = generated.getVariable().getChild() }

    final StmtSequence getBody() { result = generated.getBody() }

    final override string toString() { result = "rescue ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getException" and child = getException(_)
      or
      label = "getVariableExpr" and child = getVariableExpr()
      or
      label = "getBody" and child = getBody()
    }
  }
}

module RescueModifierExpr {
  class Range extends Expr::Range, @rescue_modifier {
    final override Generated::RescueModifier generated;

    final Stmt getBody() { result = generated.getBody() }

    final Stmt getHandler() { result = generated.getHandler() }

    final override string toString() { result = "... rescue ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getBody" and child = getBody()
      or
      label = "getHandler" and child = getHandler()
    }
  }
}

module Pair {
  class Range extends Expr::Range, @pair {
    final override Generated::Pair generated;

    final Expr getKey() { result = generated.getKey() }

    final Expr getValue() { result = generated.getValue() }

    final override string toString() { result = "Pair" }

    override predicate child(string label, AstNode::Range child) {
      label = "getKey" and child = getKey()
      or
      label = "getValue" and child = getValue()
    }
  }
}

module StringConcatenation {
  class Range extends Expr::Range, @chained_string {
    final override Generated::ChainedString generated;

    final StringLiteral::Range getString(int i) { result = generated.getChild(i) }

    final override string toString() { result = "\"...\" \"...\"" }

    override predicate child(string label, AstNode::Range child) {
      label = "getString" and child = getString(_)
    }
  }
}
