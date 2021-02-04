private import codeql_ruby.AST
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Variable

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

    final override string toString() { result = this.getValueText() }
  }
}

module NilLiteral {
  class Range extends Literal::Range, @token_nil {
    final override Generated::Nil generated;

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = this.getValueText() }
  }
}

module BooleanLiteral {
  class DbUnion = @token_true or @token_false;

  class Range extends Literal::Range, DbUnion {
    final override Generated::Token generated;

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = this.getValueText() }

    predicate isTrue() { this instanceof @token_true }

    predicate isFalse() { this instanceof @token_false }
  }
}

// TODO: expand this. It's a minimal placeholder so we can test `=~` and `!~`.
module RegexLiteral {
  class Range extends Literal::Range, @regex {
    final override Generated::Regex generated;

    final override string getValueText() {
      forall(AstNode n | n = generated.getChild(_) | n instanceof Generated::Token) and
      result =
        concat(int i, string s |
          s = generated.getChild(i).(Generated::Token).getValue()
        |
          s order by i
        )
    }

    final override string toString() {
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

// TODO: expand this minimal placeholder.
module StringLiteral {
  class Range extends Literal::Range, @string__ {
    final override Generated::String generated;

    final override string getValueText() {
      strictcount(generated.getChild(_)) = 1 and
      result = generated.getChild(0).(Generated::Token).getValue()
    }

    final override string toString() {
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

// TODO: expand this minimal placeholder.
module SymbolLiteral {
  abstract class Range extends Literal::Range { }

  class SimpleSymbolRange extends SymbolLiteral::Range {
    final override Generated::SimpleSymbol generated;

    // Tree-sitter gives us value text including the colon, which we skip.
    final override string getValueText() { result = generated.getValue().suffix(1) }

    final override string toString() { result = generated.getValue() }
  }

  abstract private class ComplexSymbolRange extends SymbolLiteral::Range {
    abstract Generated::AstNode getChild(int i);

    final override string getValueText() {
      strictcount(this.getChild(_)) = 1 and
      result = this.getChild(0).(Generated::Token).getValue()
    }

    private string summaryString() {
      result =
        concat(AstNode c, int i, string s |
          c = this.getChild(i) and
          if c instanceof Generated::Token
          then s = c.(Generated::Token).getValue()
          else s = "#{...}"
        |
          s order by i
        )
    }

    final override string toString() {
      if summaryString().regexpMatch("[a-zA-z_][a-zA-Z_0-9]*")
      then result = ":" + summaryString()
      else result = ":\"" + summaryString() + "\""
    }
  }

  class DelimitedSymbolRange extends ComplexSymbolRange, @delimited_symbol {
    final override Generated::DelimitedSymbol generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }
  }

  class BareSymbolRange extends ComplexSymbolRange, @bare_symbol {
    final override Generated::BareSymbol generated;

    final override Generated::AstNode getChild(int i) { result = generated.getChild(i) }
  }

  class HashKeySymbolRange extends SymbolLiteral::Range, @token_hash_key_symbol {
    final override Generated::HashKeySymbol generated;

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = ":" + this.getValueText() }
  }
}

module ExprSequence {
  abstract class Range extends Expr::Range {
    abstract Expr getExpr(int n);
  }
}

module BodyStatement {
  abstract class Range extends ExprSequence::Range { }
}

module ParenthesizedExpr {
  class Range extends ExprSequence::Range, @parenthesized_statements {
    final override Generated::ParenthesizedStatements generated;

    final override Expr getExpr(int n) { result = generated.getChild(n) }
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

module ScopeResolution {
  class Range extends Expr::Range, @scope_resolution {
    final override Generated::ScopeResolution generated;

    final Expr getScope() { result = generated.getScope() }

    final string getName() { result = generated.getName().(Generated::Token).getValue() }
  }
}

module Pair {
  class Range extends Expr::Range, @pair {
    final override Generated::Pair generated;

    final Expr getKey() { result = generated.getKey() }

    final Expr getValue() { result = generated.getValue() }
  }
}
