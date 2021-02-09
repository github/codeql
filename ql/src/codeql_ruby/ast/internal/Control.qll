private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern
private import codeql_ruby.ast.internal.TreeSitter

module ControlExpr {
  abstract class Range extends Expr::Range { }
}

module ConditionalExpr {
  abstract class Range extends ControlExpr::Range {
    abstract Expr getCondition();

    abstract Expr getBranch(boolean cond);
  }
}

module IfExpr {
  abstract class Range extends ConditionalExpr::Range {
    abstract ExprSequence getThen();

    abstract Expr getElse();

    final override string toString() {
      if this instanceof @elsif then result = "elsif ..." else result = "if ..."
    }
  }

  private class IfRange extends IfExpr::Range, @if {
    final override Generated::If generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override ExprSequence getThen() { result = generated.getConsequence() }

    final override Expr getElse() { result = generated.getAlternative() }

    final override Expr getBranch(boolean cond) {
      cond = true and result = getThen()
      or
      cond = false and result = getElse()
    }
  }

  private class ElsifRange extends IfExpr::Range, @elsif {
    final override Generated::Elsif generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override ExprSequence getThen() { result = generated.getConsequence() }

    final override Expr getElse() { result = generated.getAlternative() }

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

    final ExprSequence getThen() { result = generated.getConsequence() }

    final ExprSequence getElse() { result = generated.getAlternative() }

    final override Expr getBranch(boolean cond) {
      cond = false and result = getThen()
      or
      cond = true and result = getElse()
    }

    final override string toString() { result = "unless ..." }
  }
}

module IfModifierExpr {
  class Range extends ConditionalExpr::Range, @if_modifier {
    final override Generated::IfModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Expr getExpr() { result = generated.getBody() }

    final override Expr getBranch(boolean cond) { cond = true and result = getExpr() }

    final override string toString() { result = "... if ..." }
  }
}

module UnlessModifierExpr {
  class Range extends ConditionalExpr::Range, @unless_modifier {
    final override Generated::UnlessModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Expr getExpr() { result = generated.getBody() }

    final override Expr getBranch(boolean cond) { cond = false and result = getExpr() }

    final override string toString() { result = "... unless ..." }
  }
}

module TernaryIfExpr {
  class Range extends ConditionalExpr::Range, @conditional {
    final override Generated::Conditional generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final Expr getThen() { result = generated.getConsequence() }

    final Expr getElse() { result = generated.getAlternative() }

    final override Expr getBranch(boolean cond) {
      cond = true and result = getThen()
      or
      cond = false and result = getElse()
    }

    final override string toString() { result = "... ? ... : ..." }
  }
}

module CaseExpr {
  class Range extends ControlExpr::Range, @case__ {
    final override Generated::Case generated;

    final Expr getValue() { result = generated.getValue() }

    final Expr getBranch(int n) { result = generated.getChild(n) }

    final override string toString() { result = "case ..." }
  }
}

module WhenExpr {
  class Range extends Expr::Range, @when {
    final override Generated::When generated;

    final ExprSequence getBody() { result = generated.getBody() }

    final Expr getPattern(int n) { result = generated.getPattern(n).getChild() }

    final override string toString() { result = "when ..." }
  }
}

module Loop {
  abstract class Range extends ControlExpr::Range {
    abstract Expr getBody();
  }
}

module ConditionalLoop {
  abstract class Range extends Loop::Range {
    abstract Expr getCondition();
  }
}

module WhileExpr {
  class Range extends ConditionalLoop::Range, @while {
    final override Generated::While generated;

    final override ExprSequence getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "while ..." }
  }
}

module UntilExpr {
  class Range extends ConditionalLoop::Range, @until {
    final override Generated::Until generated;

    final override ExprSequence getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "until ..." }
  }
}

module WhileModifierExpr {
  class Range extends ConditionalLoop::Range, @while_modifier {
    final override Generated::WhileModifier generated;

    final override Expr getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "... while ..." }
  }
}

module UntilModifierExpr {
  class Range extends ConditionalLoop::Range, @until_modifier {
    final override Generated::UntilModifier generated;

    final override Expr getBody() { result = generated.getBody() }

    final override Expr getCondition() { result = generated.getCondition() }

    final override string toString() { result = "... until ..." }
  }
}

module ForExpr {
  class Range extends Loop::Range, @for {
    final override Generated::For generated;

    final override ExprSequence getBody() { result = generated.getBody() }

    final Pattern getPattern() { result = generated.getPattern() }

    final Expr getValue() { result = generated.getValue().getChild() }

    final override string toString() { result = "for ... in ..." }
  }
}
