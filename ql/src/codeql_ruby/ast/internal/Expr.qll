private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Statement
private import codeql_ruby.ast.internal.TreeSitter

module Expr {
  abstract class Range extends Stmt::Range { }
}

module Literal {
  abstract class Range extends Expr::Range {
    abstract string getValueText();

    override string toString() { result = this.getValueText() }
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
        concat(Generated::AstNode c, int i, string s |
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
        concat(Generated::AstNode c, int i, string s |
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
        concat(Generated::AstNode c, int i, string s |
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

    final override string toString() { result = "ensure ... end" }
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
