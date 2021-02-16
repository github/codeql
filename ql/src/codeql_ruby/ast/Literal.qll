private import codeql_ruby.AST
private import internal.Literal

/**
 * A literal.
 *
 * This is the QL root class for all literals.
 */
class Literal extends Expr {
  override Literal::Range range;

  /**
   * Gets the source text for this literal, if this is a simple literal.
   *
   * For complex literals, such as arrays, hashes, and strings with
   * interpolations, this predicate has no result.
   */
  final string getValueText() { result = range.getValueText() }
}

/**
 * A numeric literal, i.e. an integer, floating-point, rational, or complex
 * value.
 *
 * ```rb
 * 123
 * 0xff
 * 3.14159
 * 1.0E2
 * 7r
 * 1i
 * ```
 */
class NumericLiteral extends Literal {
  override NumericLiteral::Range range;
}

/**
 * An integer literal.
 *
 * ```rb
 *  123
 *  0xff
 * ```
 */
class IntegerLiteral extends NumericLiteral, @token_integer {
  final override IntegerLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

/**
 * A floating-point literal.
 *
 * ```rb
 * 1.3
 * 2.7e+5
 * ```
 */
class FloatLiteral extends NumericLiteral, @token_float {
  final override FloatLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

/**
 * A rational literal.
 *
 * ```rb
 * 123r
 * ```
 */
class RationalLiteral extends NumericLiteral, @rational {
  final override RationalLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "RationalLiteral" }
}

/**
 * A complex literal.
 *
 * ```rb
 * 1i
 * ```
 */
class ComplexLiteral extends NumericLiteral, @token_complex {
  final override ComplexLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "ComplexLiteral" }
}

/** A `nil` literal. */
class NilLiteral extends Literal, @token_nil {
  final override NilLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "NilLiteral" }
}

/**
 * A Boolean literal.
 * ```rb
 * true
 * false
 * TRUE
 * FALSE
 * ```
 */
class BooleanLiteral extends Literal, BooleanLiteral::DbUnion {
  final override BooleanLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "BooleanLiteral" }

  /** Holds if the Boolean literal is `true` or `TRUE`. */
  predicate isTrue() { range.isTrue() }

  /** Holds if the Boolean literal is `false` or `FALSE`. */
  predicate isFalse() { range.isFalse() }
}

/**
 * The base class for a component of a string: `StringTextComponent`,
 * `StringEscapeSequenceComponent`, or `StringInterpolationComponent`.
 */
class StringComponent extends AstNode {
  override StringComponent::Range range;

  /**
   * Gets the source text for this string component. Has no result if this is
   * a `StringInterpolationComponent`.
   */
  final string getValueText() { result = range.getValueText() }
}

/**
 * A component of a string (or string-like) literal that is simply text.
 *
 * For example, the following string literals all contain `StringTextComponent`
 * components whose `getValueText()` returns `"foo"`:
 *
 * ```rb
 * 'foo'
 * "#{ bar() }foo"
 * "foo#{ bar() } baz"
 * ```
 */
class StringTextComponent extends StringComponent, StringTextComponent::StringContentToken {
  final override StringTextComponent::Range range;

  final override string getAPrimaryQlClass() { result = "StringTextComponent" }
}

/**
 * An escape sequence component of a string or string-like literal.
 */
class StringEscapeSequenceComponent extends StringComponent, @token_escape_sequence {
  final override StringEscapeSequenceComponent::Range range;

  final override string getAPrimaryQlClass() { result = "StringEscapeSequenceComponent" }
}

/**
 * An interpolation expression component of a string or string-like literal.
 */
class StringInterpolationComponent extends StringComponent, StmtSequence, @interpolation {
  final override StringInterpolationComponent::Range range;

  final override string getAPrimaryQlClass() { result = "StringInterpolationComponent" }
}

/**
 * A string, symbol, regex, or subshell literal.
 */
class StringlikeLiteral extends Literal {
  override StringlikeLiteral::Range range;

  /**
   * Gets the `n`th component of this string or string-like literal. The result
   * will be one of `StringTextComponent`, `StringInterpolationComponent`, and
   * `StringEscapeSequenceComponent`.
   *
   * In the following example, the result for `n = 0` is the
   * `StringTextComponent` for `foo_`, and the result for `n = 1` is the
   * `StringInterpolationComponent` for `Time.now`.
   *
   * ```rb
   * "foo_#{ Time.now }"
   * ```
   */
  final StringComponent getComponent(int n) { result = range.getComponent(n) }

  /**
   * Gets the number of components in this string or string-like literal.
   *
   * For the empty string `""`, the result is 0.
   *
   * For the string `"foo"`, the result is 1: there is a single
   * `StringTextComponent`.
   *
   * For the following example, the result is 3: there is a
   * `StringTextComponent` for the substring `"foo_"`; a
   * `StringEscapeSequenceComponent` for the escaped quote; and a
   * `StringInterpolationComponent` for the interpolation.
   *
   * ```rb
   * "foo\"#{bar}"
   * ```
   */
  final int getNumberOfComponents() { result = count(this.getComponent(_)) }
}

/**
 * A string literal.
 *
 * ```rb
 * 'hello'
 * "hello, #{name}"
 * ```
 */
class StringLiteral extends StringlikeLiteral {
  final override StringLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/**
 * A regular expression literal.
 *
 * ```rb
 * /[a-z]+/
 * ```
 */
class RegexLiteral extends StringlikeLiteral, @regex {
  final override RegexLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "RegexLiteral" }

  /**
   * Gets the regex flags as a string.
   *
   * ```rb
   * /foo/     # => ""
   * /foo/i    # => "i"
   * /foo/imxo # => "imxo"
   */
  final string getFlagString() { result = range.getFlagString() }

  /**
   * Holds if the regex was specified using the `i` flag to indicate case
   * insensitivity, as in the following example:
   *
   * ```rb
   * /foo/i
   * ```
   */
  final predicate hasCaseInsensitiveFlag() { this.getFlagString().charAt(_) = "i" }
}

/**
 * A symbol literal.
 *
 * ```rb
 * :foo
 * :"foo bar"
 * :"foo bar #{baz}"
 * ```
 */
class SymbolLiteral extends StringlikeLiteral {
  final override SymbolLiteral::Range range;

  SymbolLiteral() {
    not any(UndefStmt u).getAMethodName() = this and
    not any(AliasStmt a).getNewName() = this and
    not any(AliasStmt a).getOldName() = this
  }

  final override string getAPrimaryQlClass() { result = "SymbolLiteral" }
}

/**
 * A subshell literal.
 *
 * ```rb
 * `ls -l`
 * %x(/bin/sh foo.sh)
 * ```
 */
class SubshellLiteral extends StringlikeLiteral, @subshell {
  final override SubshellLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "SubshellLiteral" }
}

/**
 * A character literal.
 *
 * ```rb
 * ?a
 * ?\u{61}
 * ```
 */
class CharacterLiteral extends Literal, @token_character {
  final override CharacterLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "CharacterLiteral" }
}

/**
 * A "here document". For example:
 * ```rb
 * query = <<SQL
 * SELECT * FROM person
 * WHERE age > 21
 * ```
 */
class HereDoc extends StringlikeLiteral {
  final override HereDoc::Range range;

  final override string getAPrimaryQlClass() { result = "HereDoc" }

  /**
   * Holds if this here document is executed in a subshell.
   * ```rb
   * <<`COMMAND`
   * echo "Hello world!"
   * COMMAND
   * ```
   */
  final predicate isSubShell() { getQuoteStyle() = "`" }

  /**
   * Gets the quotation mark (`"`, `'` or `` ` ``) that surrounds the here document identifier, if any.
   * ```rb
   * <<"IDENTIFIER"
   * <<'IDENTIFIER'
   * <<`IDENTIFIER`
   * ```
   */
  final string getQuoteStyle() { result = range.getQuoteStyle() }

  /**
   * Gets the indentation modifier (`-` or `~`) of the here document identifier, if any.
   * ```rb
   * <<~IDENTIFIER
   * <<-IDENTIFIER
   * <<IDENTIFIER
   * ```
   */
  final string getIndentationModifier() { result = range.getIndentationModifier() }
}

/**
 * An array literal.
 *
 * ```rb
 * [123, 'foo', bar()]
 * %w(foo bar)
 * %i(foo bar)
 * ```
 */
class ArrayLiteral extends Literal {
  final override ArrayLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "ArrayLiteral" }

  /** Gets the `n`th element in this array literal. */
  final Expr getElement(int n) { result = range.getElement(n) }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = range.getElement(_) }

  /** Gets the number of elements in this array literal. */
  final int getNumberOfElements() { result = count(range.getElement(_)) }
}

/**
 * A hash literal.
 *
 * ```rb
 * { foo: 123, bar: 456 }
 * ```
 */
class HashLiteral extends Literal, @hash {
  final override HashLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "HashLiteral" }

  /**
   * Gets the `n`th element in this array literal.
   *
   * In the following example, the 0th element is a `Pair`, and the 1st element
   * is a `HashSplatArgument`.
   *
   * ```rb
   * { foo: 123, **bar }
   * ```
   */
  final Expr getElement(int n) { result = range.getElement(n) }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = range.getElement(_) }

  /** Gets a key-value `Pair` in this hash literal. */
  final Pair getAKeyValuePair() { result = this.getAnElement() }

  /** Gets the number of elements in this hash literal. */
  final int getNumberOfElements() { result = count(range.getElement(_)) }
}

/**
 * A range literal.
 *
 * ```rb
 * (1..10)
 * (1024...2048)
 * ```
 */
class RangeLiteral extends Literal, @range {
  final override RangeLiteral::Range range;

  final override string getAPrimaryQlClass() { result = "RangeLiteral" }

  /** Gets the begin expression of this range, if any. */
  final Expr getBegin() { result = range.getBegin() }

  /** Gets the end expression of this range, if any. */
  final Expr getEnd() { result = range.getEnd() }

  /**
   * Holds if the range is inclusive of the end value, i.e. uses the `..`
   * operator.
   */
  final predicate isInclusive() { range.isInclusive() }

  /**
   * Holds if the range is exclusive of the end value, i.e. uses the `...`
   * operator.
   */
  final predicate isExclusive() { range.isExclusive() }
}

/**
 * A method name literal. For example:
 * ```rb
 * method_name      # a normal name
 * +                # an operator
 * :method_name     # a symbol
 * :"eval_#{name}"  # a complex symbol
 * ```
 */
class MethodName extends Literal {
  final override MethodName::Range range;

  final override string getAPrimaryQlClass() { result = "MethodName" }
}
