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

    abstract Expr getThen();

    abstract Expr getElse();
  }
}

module IfOrElsifExpr {
  abstract class Range extends ConditionalExpr::Range { }
}

module IfExpr {
  class Range extends IfOrElsifExpr::Range, @if {
    final override Generated::If generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override ThenExpr getThen() { result = generated.getConsequence() }

    final override Expr getElse() { result = generated.getAlternative() }
  }
}

module ElsifExpr {
  class Range extends IfOrElsifExpr::Range, @elsif {
    final override Generated::Elsif generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override ThenExpr getThen() { result = generated.getConsequence() }

    final override Expr getElse() { result = generated.getAlternative() }
  }
}

module UnlessExpr {
  class Range extends ConditionalExpr::Range, @unless {
    final override Generated::Unless generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override ThenExpr getThen() { result = generated.getConsequence() }

    final override ElseExpr getElse() { result = generated.getAlternative() }
  }
}

module IfModifierExpr {
  class Range extends ConditionalExpr::Range, @if_modifier {
    final override Generated::IfModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override Expr getThen() { result = generated.getBody() }

    final override Expr getElse() { none() }
  }
}

module UnlessModifierExpr {
  class Range extends ConditionalExpr::Range, @unless_modifier {
    final override Generated::UnlessModifier generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override Expr getThen() { result = generated.getBody() }

    final override Expr getElse() { none() }
  }
}

module TernaryIfExpr {
  class Range extends ConditionalExpr::Range, @conditional {
    final override Generated::Conditional generated;

    final override Expr getCondition() { result = generated.getCondition() }

    final override Expr getThen() { result = generated.getConsequence() }

    final override Expr getElse() { result = generated.getAlternative() }
  }
}

module CaseExpr {
  class Range extends ControlExpr::Range {
    final override Generated::Case generated;

    final Expr getValue() { result = generated.getValue() }

    final Expr getBranch(int n) { result = generated.getChild(n) }

    final WhenExpr getAWhenBranch() { result = this.getBranch(_) }

    final ElseExpr getElseBranch() { result = this.getBranch(_) }
  }
}

module WhenExpr {
  class Range extends Expr::Range, @when {
    final override Generated::When generated;

    final ThenExpr getBody() { result = generated.getBody() }

    final Expr getPattern(int n) { result = generated.getPattern(n).getChild() }
  }
}

module Loop {
  abstract class Range extends ControlExpr::Range {
    abstract Expr getBody();
  }
}

module WhileExpr {
  class Range extends Loop::Range, @while {
    final override Generated::While generated;

    final override DoExpr getBody() { result = generated.getBody() }

    final Expr getCondition() { result = generated.getCondition() }
  }
}

module UntilExpr {
  class Range extends Loop::Range, @until {
    final override Generated::Until generated;

    final override DoExpr getBody() { result = generated.getBody() }

    final Expr getCondition() { result = generated.getCondition() }
  }
}

module WhileModifierExpr {
  class Range extends Loop::Range, @while_modifier {
    final override Generated::WhileModifier generated;

    final override Expr getBody() { result = generated.getBody() }

    final Expr getCondition() { result = generated.getCondition() }
  }
}

module UntilModifierExpr {
  class Range extends Loop::Range, @until_modifier {
    final override Generated::UntilModifier generated;

    final override Expr getBody() { result = generated.getBody() }

    final Expr getCondition() { result = generated.getCondition() }
  }
}

module ForExpr {
  class Range extends Loop::Range, @for {
    final override Generated::For generated;

    final override DoExpr getBody() { result = generated.getBody() }

    final Pattern getPattern() { result = generated.getPattern() }

    final Expr getValue() { result = generated.getValue().getChild() }
  }
}
