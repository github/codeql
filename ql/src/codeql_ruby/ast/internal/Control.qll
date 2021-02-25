private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern
private import codeql_ruby.ast.internal.TreeSitter

module ControlExpr {
  abstract class Range extends Expr::Range { }
}

module ConditionalExpr {
  abstract class Range extends ControlExpr::Range {
    abstract Expr getCondition();

    abstract Stmt getBranch(boolean cond);

    override predicate child(string label, AstNode::Range child) {
      label = "getCondition" and child = getCondition()
      or
      label = "getBranch" and child = getBranch(_)
    }
  }
}

module IfExpr {
  abstract class Range extends ConditionalExpr::Range {
    abstract Stmt getThen();

    abstract Stmt getElse();

    final override string toString() {
      if this instanceof @elsif then result = "elsif ..." else result = "if ..."
    }

    override predicate child(string label, AstNode::Range child) {
      super.child(label, child)
      or
      label = "getThen" and child = getThen()
      or
      label = "getElse" and child = getElse()
    }
  }

  private class IfRange extends IfExpr::Range, @if {
    final override Generated::If generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override Stmt getThen() { result = generated.getConsequence() }

    final override Stmt getElse() { result = generated.getAlternative() }

    final override Stmt getBranch(boolean cond) {
      cond = true and result = getThen()
      or
      cond = false and result = getElse()
    }
  }

  private class ElsifRange extends IfExpr::Range, @elsif {
    final override Generated::Elsif generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override Stmt getThen() { result = generated.getConsequence() }

    final override Stmt getElse() { result = generated.getAlternative() }

    final override Expr getBranch(boolean cond) {
      cond = true and result = getThen()
      or
      cond = false and result = getElse()
    }
  }
}

module UnlessExpr {
  class Range extends ConditionalExpr::Range, @unless {
    final override Generated::Unless generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Stmt getThen() { result = generated.getConsequence() }

    final Stmt getElse() { result = generated.getAlternative() }

    final override Expr getBranch(boolean cond) {
      cond = false and result = getThen()
      or
      cond = true and result = getElse()
    }

    final override string toString() { result = "unless ..." }

    override predicate child(string label, AstNode::Range child) {
      ConditionalExpr::Range.super.child(label, child)
      or
      label = "getThen" and child = getThen()
      or
      label = "getElse" and child = getElse()
    }
  }
}

module IfModifierExpr {
  class Range extends ConditionalExpr::Range, @if_modifier {
    final override Generated::IfModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Stmt getBody() { result = generated.getBody() }

    final override Stmt getBranch(boolean cond) { cond = true and result = getBody() }

    final override string toString() { result = "... if ..." }

    override predicate child(string label, AstNode::Range child) {
      ConditionalExpr::Range.super.child(label, child)
      or
      label = "getBody" and child = getBody()
    }
  }
}

module UnlessModifierExpr {
  class Range extends ConditionalExpr::Range, @unless_modifier {
    final override Generated::UnlessModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Stmt getBody() { result = generated.getBody() }

    final override Stmt getBranch(boolean cond) { cond = false and result = getBody() }

    final override string toString() { result = "... unless ..." }

    override predicate child(string label, AstNode::Range child) {
      ConditionalExpr::Range.super.child(label, child)
      or
      label = "getBody" and child = getBody()
    }
  }
}

module TernaryIfExpr {
  class Range extends ConditionalExpr::Range, @conditional {
    final override Generated::Conditional generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Stmt getThen() { result = generated.getConsequence() }

    final Stmt getElse() { result = generated.getAlternative() }

    final override Stmt getBranch(boolean cond) {
      cond = true and result = getThen()
      or
      cond = false and result = getElse()
    }

    final override string toString() { result = "... ? ... : ..." }

    override predicate child(string label, AstNode::Range child) {
      ConditionalExpr::Range.super.child(label, child)
      or
      label = "getThen" and child = getThen()
      or
      label = "getElse" and child = getElse()
    }
  }
}

module CaseExpr {
  class Range extends ControlExpr::Range, @case__ {
    final override Generated::Case generated;

    final Expr getValue() { result = generated.getValue() }

    final Expr getBranch(int n) { result = generated.getChild(n) }

    final override string toString() { result = "case ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getValue" and child = getValue()
      or
      label = "getBranch" and child = getBranch(_)
    }
  }
}

module WhenExpr {
  class Range extends Expr::Range, @when {
    final override Generated::When generated;

    final Stmt getBody() { result = generated.getBody() }

    final Expr getPattern(int n) { result = generated.getPattern(n).getChild() }

    final override string toString() { result = "when ..." }

    override predicate child(string label, AstNode::Range child) {
      label = "getBody" and child = getBody()
      or
      label = "getPattern" and child = getPattern(_)
    }
  }
}

module Loop {
  abstract class Range extends ControlExpr::Range {
    abstract Stmt getBody();

    override predicate child(string label, AstNode::Range child) {
      label = "getBody" and child = getBody()
    }
  }
}

module ConditionalLoop {
  abstract class Range extends Loop::Range {
    abstract Expr getCondition();

    override predicate child(string label, AstNode::Range child) {
      super.child(label, child)
      or
      label = "getCondition" and child = getCondition()
    }
  }
}

module WhileExpr {
  class Range extends ConditionalLoop::Range, @while {
    final override Generated::While generated;

    final override Stmt getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "while ..." }
  }
}

module UntilExpr {
  class Range extends ConditionalLoop::Range, @until {
    final override Generated::Until generated;

    final override Stmt getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "until ..." }
  }
}

module WhileModifierExpr {
  class Range extends ConditionalLoop::Range, @while_modifier {
    final override Generated::WhileModifier generated;

    final override Stmt getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "... while ..." }
  }
}

module UntilModifierExpr {
  class Range extends ConditionalLoop::Range, @until_modifier {
    final override Generated::UntilModifier generated;

    final override Stmt getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "... until ..." }
  }
}

module ForExpr {
  class Range extends Loop::Range, @for {
    final override Generated::For generated;

    final override StmtSequence getBody() { result = generated.getBody() }

    final Pattern getPattern() { result = generated.getPattern() }

    final Expr getValue() { result = generated.getValue().getChild() }

    final override string toString() { result = "for ... in ..." }

    override predicate child(string label, AstNode::Range child) {
      Loop::Range.super.child(label, child)
      or
      label = "getPattern" and child = getPattern()
      or
      label = "getValue" and child = getValue()
    }
  }
}
