private import codeql_ruby.AST
private import codeql_ruby.ast.internal.TreeSitter

module Expr {
  abstract class Range extends AstNode { }
}

module Literal {
  abstract class Range extends Expr::Range {
    abstract string getValueText();
  }
}

module IntegerLiteral {
  class Range extends Literal::Range, @token_integer {
    final override Generated::Integer generated;

    final override string getValueText() { result = generated.getValue() }
  }
}

module NilLiteral {
  class Range extends Literal::Range, @token_nil {
    final override Generated::Nil generated;

    final override string getValueText() { result = generated.getValue() }
  }
}

module BooleanLiteral {
  class DbUnion = @token_true or @token_false;

  class Range extends Literal::Range, DbUnion {
    final override Generated::Token generated;

    final override string getValueText() { result = generated.getValue() }

    predicate isTrue() { this instanceof @token_true }

    predicate isFalse() { this instanceof @token_false }
  }
}

// TODO: expand this. It's a minimal placeholder so we can test `=~` and `!~`.
module RegexLiteral {
  class Range extends Literal::Range, @regex {
    final override Generated::Regex generated;

    final override string getValueText() {
      result =
        concat(AstNode c, int i, string s |
          c = generated.getChild(i) and
          if c instanceof Generated::Token
          then s = c.(Generated::Token).getValue()
          else s = "#{...}"
        |
          s order by i
        )
    }
  }
}

module ExprSequence {
  abstract class Range extends Expr::Range {
    abstract Expr getExpr(int n);
  }
}

module ThenExpr {
  class Range extends ExprSequence::Range, @then {
    final override Generated::Then generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }
  }
}

module ElseExpr {
  class Range extends ExprSequence::Range, @else {
    final override Generated::Else generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }
  }
}

module DoExpr {
  class Range extends ExprSequence::Range, @do {
    final override Generated::Do generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }
  }
}
