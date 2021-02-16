private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.TreeSitter

module Literal {
  abstract class Range extends Expr::Range {
    abstract string getValueText();

    override string toString() { result = this.getValueText() }
  }
}

module NumericLiteral {
  abstract class Range extends Literal::Range { }
}

module IntegerLiteral {
  class Range extends NumericLiteral::Range, @token_integer {
    final override Generated::Integer generated;

    Range() { not any(Generated::Rational r).getChild() = this }

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = this.getValueText() }
  }
}

module FloatLiteral {
  class Range extends NumericLiteral::Range, @token_float {
    final override Generated::Float generated;

    Range() { not any(Generated::Rational r).getChild() = this }

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = this.getValueText() }
  }
}

module RationalLiteral {
  class Range extends NumericLiteral::Range, @rational {
    final override Generated::Rational generated;

    final override string getValueText() {
      result = generated.getChild().(Generated::Token).getValue()
    }

    final override string toString() { result = this.getValueText() + "r" }
  }
}

module ComplexLiteral {
  class Range extends NumericLiteral::Range, @token_complex {
    final override Generated::Complex generated;

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

module StringComponent {
  abstract class Range extends AstNode::Range {
    abstract string getValueText();
  }
}

module StringTextComponent {
  class Range extends StringComponent::Range, @token_string_content {
    final override Generated::StringContent generated;

    final override string toString() { result = generated.getValue() }

    final override string getValueText() { result = generated.getValue() }
  }
}

module StringEscapeSequenceComponent {
  class Range extends StringComponent::Range, @token_escape_sequence {
    final override Generated::EscapeSequence generated;

    final override string toString() { result = generated.getValue() }

    final override string getValueText() { result = generated.getValue() }
  }
}

module StringInterpolationComponent {
  class Range extends StringComponent::Range, StmtSequence::Range, @interpolation {
    final override Generated::Interpolation generated;

    final override string toString() { result = "#{...}" }

    final override Expr getStmt(int n) {
      // TODO: fix grammar to properly handle a sequence of more than one expr,
      // e.g. #{ foo; bar }
      n = 0 and
      result = generated.getChild()
    }

    final override string getValueText() { none() }
  }
}

module StringlikeLiteral {
  abstract class Range extends Literal::Range {
    abstract StringComponent::Range getComponent(int i);

    string getStartDelimiter() { result = "" }

    string getEndDelimiter() { result = "" }

    final predicate isSimple() { count(this.getComponent(_)) <= 1 }

    override string getValueText() {
      // 0 components should result in the empty string
      // if there are any interpolations, there should be no result
      // otherwise, concatenate all the components
      forall(StringComponent c | c = this.getComponent(_) |
        not c instanceof StringInterpolationComponent::Range
      ) and
      result =
        concat(StringComponent::Range c, int i |
          c = this.getComponent(i)
        |
          c.getValueText() order by i
        )
    }

    override string toString() {
      exists(string full, string summary |
        full =
          concat(StringComponent::Range c, int i, string s |
            c = this.getComponent(i) and
            if c instanceof Generated::Token
            then s = c.(Generated::Token).getValue()
            else s = "#{...}"
          |
            s order by i
          ) and
        (
          // summary should be 32 chars max (incl. ellipsis)
          full.length() > 32 and summary = full.substring(0, 29) + "..."
          or
          full.length() <= 32 and summary = full
        ) and
        result = this.getStartDelimiter() + summary + this.getEndDelimiter()
      )
    }
  }
}

module StringLiteral {
  abstract class Range extends StringlikeLiteral::Range {
    final override string getStartDelimiter() { result = "\"" }

    final override string getEndDelimiter() { result = "\"" }
  }

  private class RegularStringRange extends StringLiteral::Range, @string__ {
    final override Generated::String generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }
  }

  private class BareStringRange extends StringLiteral::Range, @bare_string {
    final override Generated::BareString generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }
  }
}

module RegexLiteral {
  class Range extends StringlikeLiteral::Range, @regex {
    final override Generated::Regex generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }

    final override string getStartDelimiter() { result = "/" }

    final override string getEndDelimiter() { result = "/" }

    final string getFlagString() {
      // For `/foo/i`, there should be an `/i` token in the database with `this`
      // as its parents. Strip the delimiter, which can vary.
      result =
        max(Generated::Token t |
          t.getParent() = this
        |
          t.getValue().suffix(1) order by t.getParentIndex()
        )
    }
  }
}

module SymbolLiteral {
  abstract class Range extends StringlikeLiteral::Range { }

  class SimpleSymbolRange extends SymbolLiteral::Range {
    final override Generated::SimpleSymbol generated;

    final override StringComponent::Range getComponent(int i) { none() }

    final override string getStartDelimiter() { result = ":" }

    // Tree-sitter gives us value text including the colon, which we skip.
    final override string getValueText() { result = generated.getValue().suffix(1) }

    final override string toString() { result = generated.getValue() }
  }

  abstract private class ComplexSymbolRange extends SymbolLiteral::Range {
    final override string getStartDelimiter() { result = ":\"" }

    final override string getEndDelimiter() { result = "\"" }
  }

  class DelimitedSymbolRange extends ComplexSymbolRange, @delimited_symbol {
    final override Generated::DelimitedSymbol generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }
  }

  class BareSymbolRange extends ComplexSymbolRange, @bare_symbol {
    final override Generated::BareSymbol generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }
  }

  class HashKeySymbolRange extends SymbolLiteral::Range, @token_hash_key_symbol {
    final override Generated::HashKeySymbol generated;

    final override StringComponent::Range getComponent(int i) { none() }

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = ":" + this.getValueText() }
  }
}

module SubshellLiteral {
  class Range extends StringlikeLiteral::Range, @subshell {
    final override Generated::Subshell generated;

    final override StringComponent::Range getComponent(int i) { result = generated.getChild(i) }

    final override string getStartDelimiter() { result = "`" }

    final override string getEndDelimiter() { result = "`" }
  }
}

module CharacterLiteral {
  class Range extends Literal::Range, @token_character {
    final override Generated::Character generated;

    final override string getValueText() { result = generated.getValue() }

    final override string toString() { result = generated.getValue() }
  }
}

module ArrayLiteral {
  abstract class Range extends Literal::Range {
    final override string getValueText() { none() }

    abstract Expr getElement(int i);
  }

  private class RegularArrayRange extends ArrayLiteral::Range, @array {
    final override Generated::Array generated;

    final override Expr getElement(int i) { result = generated.getChild(i) }

    final override string toString() { result = "[...]" }
  }

  private class StringArrayRange extends ArrayLiteral::Range, @string_array {
    final override Generated::StringArray generated;

    final override Expr getElement(int i) { result = generated.getChild(i) }

    final override string toString() { result = "%w(...)" }
  }

  private class SymbolArrayRange extends ArrayLiteral::Range, @symbol_array {
    final override Generated::SymbolArray generated;

    final override Expr getElement(int i) { result = generated.getChild(i) }

    final override string toString() { result = "%i(...)" }
  }
}

module HashLiteral {
  class Range extends Literal::Range, @hash {
    final override Generated::Hash generated;

    final override string getValueText() { none() }

    final Expr getElement(int i) { result = generated.getChild(i) }

    final override string toString() { result = "{...}" }
  }
}

module RangeLiteral {
  class Range extends Literal::Range, @range {
    final override Generated::Range generated;

    final override string getValueText() { none() }

    final override string toString() { result = "_ " + generated.getOperator() + " _" }

    final Expr getBegin() { result = generated.getBegin() }

    final Expr getEnd() { result = generated.getEnd() }

    final predicate isInclusive() { this instanceof @range_dotdot }

    final predicate isExclusive() { this instanceof @range_dotdotdot }
  }
}

module MethodName {
  private class TokenTypes =
    @setter or @token_class_variable or @token_constant or @token_global_variable or
        @token_identifier or @token_instance_variable or @token_operator;

  abstract class Range extends Literal::Range, @underscore_method_name {
    Range() {
      exists(Generated::Undef u | u.getChild(_) = generated)
      or
      exists(Generated::Alias a | a.getName() = generated or a.getAlias() = generated)
    }
  }

  private class TokenMethodName extends MethodName::Range, TokenTypes {
    final override Generated::UnderscoreMethodName generated;

    final override string getValueText() {
      result = generated.(Generated::Token).getValue()
      or
      result = generated.(Generated::Setter).getName().getValue() + "="
    }
  }

  private class SimpleSymbolMethodName extends MethodName::Range, SymbolLiteral::SimpleSymbolRange,
    @token_simple_symbol { }

  private class DelimitedSymbolMethodName extends MethodName::Range,
    SymbolLiteral::DelimitedSymbolRange, @delimited_symbol { }
}
