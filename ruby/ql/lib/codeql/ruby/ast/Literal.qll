private import codeql.ruby.AST
private import codeql.ruby.Regexp as RE
private import internal.AST
private import internal.Constant
private import internal.Literal
private import internal.Scope
private import internal.TreeSitter
private import codeql.ruby.controlflow.CfgNodes

/**
 * A literal.
 *
 * This is the QL root class for all literals.
 */
class Literal extends Expr, TLiteral { }

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
class NumericLiteral extends Literal, TNumericLiteral { }

/**
 * An integer literal.
 *
 * ```rb
 *  123
 *  0xff
 * ```
 */
class IntegerLiteral extends NumericLiteral instanceof IntegerLiteralImpl {
  /** Gets the numerical value of this integer literal. */
  final int getValue() { result = super.getValue() }

  final override ConstantValue::ConstantIntegerValue getConstantValue() {
    result = NumericLiteral.super.getConstantValue()
  }

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
class FloatLiteral extends NumericLiteral instanceof FloatLiteralImpl {
  final override ConstantValue::ConstantFloatValue getConstantValue() {
    result = NumericLiteral.super.getConstantValue()
  }

  final override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

/**
 * A rational literal.
 *
 * ```rb
 * 123r
 * ```
 */
class RationalLiteral extends NumericLiteral instanceof RationalLiteralImpl {
  final override ConstantValue::ConstantRationalValue getConstantValue() {
    result = NumericLiteral.super.getConstantValue()
  }

  final override string getAPrimaryQlClass() { result = "RationalLiteral" }
}

/**
 * A complex literal.
 *
 * ```rb
 * 1i
 * ```
 */
class ComplexLiteral extends NumericLiteral instanceof ComplexLiteralImpl {
  final override ConstantValue::ConstantComplexValue getConstantValue() {
    result = NumericLiteral.super.getConstantValue()
  }

  final override string getAPrimaryQlClass() { result = "ComplexLiteral" }
}

/** A `nil` literal. */
class NilLiteral extends Literal instanceof NilLiteralImpl {
  final override ConstantValue::ConstantNilValue getConstantValue() { result = TNil() }

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
class BooleanLiteral extends Literal instanceof BooleanLiteralImpl {
  final override string getAPrimaryQlClass() { result = "BooleanLiteral" }

  /** Holds if the Boolean literal is `true` or `TRUE`. */
  final predicate isTrue() { this.getValue() = true }

  /** Holds if the Boolean literal is `false` or `FALSE`. */
  final predicate isFalse() { this.getValue() = false }

  /** Gets the value of this Boolean literal. */
  boolean getValue() { result = super.getValue() }

  final override ConstantValue::ConstantBooleanValue getConstantValue() {
    result = Literal.super.getConstantValue()
  }
}

/**
 * An `__ENCODING__` literal.
 */
class EncodingLiteral extends Literal instanceof EncodingLiteralImpl {
  final override string getAPrimaryQlClass() { result = "EncodingLiteral" }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result = Literal.super.getConstantValue()
  }
}

/**
 * A `__LINE__` literal.
 */
class LineLiteral extends Literal instanceof LineLiteralImpl {
  final override string getAPrimaryQlClass() { result = "LineLiteral" }

  final override ConstantValue::ConstantIntegerValue getConstantValue() {
    result = Literal.super.getConstantValue()
  }
}

/**
 * A `__FILE__` literal.
 */
class FileLiteral extends Literal instanceof FileLiteralImpl {
  final override string getAPrimaryQlClass() { result = "FileLiteral" }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result = Literal.super.getConstantValue()
  }
}

/**
 * The base class for a component of a string: `StringTextComponent`,
 * `StringEscapeSequenceComponent`, or `StringInterpolationComponent`.
 */
class StringComponent extends AstNode instanceof StringComponentImpl {
  /**
   * DEPRECATED: Use `getConstantValue` instead.
   *
   * Gets the source text for this string component. Has no result if this is
   * a `StringInterpolationComponent`.
   */
  deprecated string getValueText() { result = this.getConstantValue().toString() }

  /** Gets the constant value of this string component, if any. */
  ConstantValue::ConstantStringValue getConstantValue() { result = TString(super.getValue()) }
}

/**
 * A component of a string (or string-like) literal that is simply text.
 *
 * For example, the following string literals all contain `StringTextComponent`
 * components whose `getConstantValue()` returns `"foo"`:
 *
 * ```rb
 * 'foo'
 * "#{ bar() }foo"
 * "foo#{ bar() } baz"
 * ```
 */
class StringTextComponent extends StringComponent instanceof StringTextComponentImpl {
  final override string getAPrimaryQlClass() { result = "StringTextComponent" }

  /** Gets the text of this component as it appears in the source code. */
  final string getRawText() { result = super.getRawTextImpl() }
}

/**
 * An escape sequence component of a string or string-like literal.
 */
class StringEscapeSequenceComponent extends StringComponent instanceof StringEscapeSequenceComponentImpl {
  final override string getAPrimaryQlClass() { result = "StringEscapeSequenceComponent" }

  /** Gets the text of this component as it appears in the source code. */
  final string getRawText() { result = super.getRawTextImpl() }
}

/**
 * An interpolation expression component of a string or string-like literal.
 */
class StringInterpolationComponent extends StringComponent, StmtSequence instanceof StringInterpolationComponentImpl {
  private Ruby::Interpolation g;

  StringInterpolationComponent() { this = TStringInterpolationComponentNonRegexp(g) }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  deprecated final override string getValueText() { none() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result = StmtSequence.super.getConstantValue()
  }

  final override string getAPrimaryQlClass() { result = "StringInterpolationComponent" }
}

/**
 * The base class for a component of a regular expression literal.
 */
class RegExpComponent extends StringComponent instanceof RegExpComponentImpl { }

/**
 * A component of a regex literal that is simply text.
 *
 * For example, the following regex literals all contain `RegExpTextComponent`
 * components whose `getConstantValue()` returns `"foo"`:
 *
 * ```rb
 * 'foo'
 * "#{ bar() }foo"
 * "foo#{ bar() } baz"
 * ```
 */
class RegExpTextComponent extends RegExpComponent instanceof RegExpTextComponentImpl {
  final override string getAPrimaryQlClass() { result = "RegExpTextComponent" }
}

/**
 * An escape sequence component of a regex literal.
 */
class RegExpEscapeSequenceComponent extends RegExpComponent instanceof RegExpEscapeSequenceComponentImpl {
  final override string getAPrimaryQlClass() { result = "RegExpEscapeSequenceComponent" }
}

/**
 * An interpolation expression component of a regex literal.
 */
class RegExpInterpolationComponent extends RegExpComponent, StmtSequence instanceof RegExpComponentImpl {
  private Ruby::Interpolation g;

  RegExpInterpolationComponent() { this = TStringInterpolationComponentRegexp(g) }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  deprecated final override string getValueText() { none() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result = StmtSequence.super.getConstantValue()
  }

  final override string getAPrimaryQlClass() { result = "RegExpInterpolationComponent" }
}

/**
 * A string, symbol, regexp, or subshell literal.
 */
class StringlikeLiteral extends Literal instanceof StringlikeLiteralImpl {
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
  final StringComponent getComponent(int n) { result = super.getComponentImpl(n) }

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

  final override AstNode getAChild(string pred) {
    result = Literal.super.getAChild(pred)
    or
    pred = "getComponent" and result = this.getComponent(_)
  }
}

/**
 * A string literal.
 *
 * ```rb
 * 'hello'
 * "hello, #{name}"
 * ```
 */
class StringLiteral extends StringlikeLiteral instanceof StringLiteralImpl {
  final override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/**
 * A regular expression literal.
 *
 * ```rb
 * /[a-z]+/
 * ```
 */
class RegExpLiteral extends StringlikeLiteral instanceof RegExpLiteralImpl {
  private Ruby::Regex g;

  RegExpLiteral() { this = TRegExpLiteral(g) }

  final override string getAPrimaryQlClass() { result = "RegExpLiteral" }

  /**
   * Gets the regexp flags as a string.
   *
   * ```rb
   * /foo/     # => ""
   * /foo/i    # => "i"
   * /foo/imxo # => "imxo"
   */
  final string getFlagString() {
    // For `/foo/i`, there should be an `/i` token in the database with `this`
    // as its parents. Strip the delimiter, which can vary.
    result =
      max(Ruby::Token t | t.getParent() = g | t.getValue().suffix(1) order by t.getParentIndex())
  }

  /**
   * Holds if the regexp was specified using the `i` flag to indicate case
   * insensitivity, as in the following example:
   *
   * ```rb
   * /foo/i
   * ```
   */
  final predicate hasCaseInsensitiveFlag() { this.getFlagString().charAt(_) = "i" }

  /**
   * Holds if the regex was specified using the `m` flag to indicate multiline
   * mode. For example:
   *
   * ```rb
   * /foo/m
   * ```
   */
  final predicate hasMultilineFlag() { this.getFlagString().charAt(_) = "m" }

  /**
   * Holds if the regex was specified using the `x` flag to indicate
   * 'free-spacing' mode (also known as 'extended' mode), meaning that
   * whitespace and comments in the pattern are ignored. For example:
   *
   * ```rb
   * %r{
   *   [a-zA-Z_] # starts with a letter or underscore
   *   \w*       # and then zero or more letters/digits/underscores
   * }/x
   * ```
   */
  final predicate hasFreeSpacingFlag() { this.getFlagString().charAt(_) = "x" }

  /** Returns the root node of the parse tree of this regular expression. */
  final RE::RegExpTerm getParsed() { result = RE::getParsedRegExp(this) }
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
class SymbolLiteral extends StringlikeLiteral instanceof SymbolLiteralImpl {
  final override string getAPrimaryQlClass() {
    not this instanceof MethodName and result = "SymbolLiteral"
  }

  final override ConstantValue::ConstantSymbolValue getConstantValue() {
    result = StringlikeLiteral.super.getConstantValue()
  }
}

/**
 * A subshell literal.
 *
 * ```rb
 * `ls -l`
 * %x(/bin/sh foo.sh)
 * ```
 */
class SubshellLiteral extends StringlikeLiteral instanceof SubshellLiteralImpl {
  private Ruby::Subshell g;

  SubshellLiteral() { this = TSubshellLiteral(g) }

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
class CharacterLiteral extends Literal instanceof CharacterLiteralImpl {
  final override string getAPrimaryQlClass() { result = "CharacterLiteral" }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result = Literal.super.getConstantValue()
  }
}

/**
 * A "here document". For example:
 * ```rb
 * query = <<SQL
 * SELECT * FROM person
 * WHERE age > 21
 * SQL
 * ```
 */
class HereDoc extends StringlikeLiteral instanceof HereDocImpl {
  private Ruby::HeredocBeginning g;

  HereDoc() { this = THereDoc(g) }

  final override string getAPrimaryQlClass() { result = "HereDoc" }

  /**
   * Holds if this here document is executed in a subshell.
   * ```rb
   * <<`COMMAND`
   * echo "Hello world!"
   * COMMAND
   * ```
   */
  final predicate isSubShell() { this.getQuoteStyle() = "`" }

  /**
   * Gets the quotation mark (`"`, `'` or `` ` ``) that surrounds the here document identifier, if any.
   * ```rb
   * <<"IDENTIFIER"
   * <<'IDENTIFIER'
   * <<`IDENTIFIER`
   * ```
   */
  final string getQuoteStyle() {
    exists(string s |
      s = g.getValue() and
      s.charAt(s.length() - 1) = result and
      result = ["'", "`", "\""]
    )
  }

  /**
   * Gets the indentation modifier (`-` or `~`) of the here document identifier, if any.
   * ```rb
   * <<~IDENTIFIER
   * <<-IDENTIFIER
   * <<IDENTIFIER
   * ```
   */
  final string getIndentationModifier() {
    exists(string s |
      s = g.getValue() and
      s.charAt(2) = result and
      result = ["-", "~"]
    )
  }
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
class ArrayLiteral extends Literal instanceof ArrayLiteralImpl {
  final override string getAPrimaryQlClass() { result = "ArrayLiteral" }

  /** Gets the `n`th element in this array literal. */
  final Expr getElement(int n) { result = super.getElementImpl(n) }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = this.getElement(_) }

  /** Gets the number of elements in this array literal. */
  final int getNumberOfElements() { result = super.getNumberOfElementsImpl() }

  final override AstNode getAChild(string pred) {
    result = Literal.super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

/**
 * A hash literal.
 *
 * ```rb
 * { foo: 123, bar: 456 }
 * ```
 */
class HashLiteral extends Literal instanceof HashLiteralImpl {
  private Ruby::Hash g;

  HashLiteral() { this = THashLiteral(g) }

  final override string getAPrimaryQlClass() { result = "HashLiteral" }

  /**
   * Gets the `n`th element in this hash literal.
   *
   * In the following example, the 0th element is a `Pair`, and the 1st element
   * is a `HashSplatExpr`.
   *
   * ```rb
   * { foo: 123, **bar }
   * ```
   */
  final Expr getElement(int n) { toGenerated(result) = g.getChild(n) }

  /** Gets an element in this hash literal. */
  final Expr getAnElement() { result = this.getElement(_) }

  /** Gets a key-value `Pair` in this hash literal. */
  final Pair getAKeyValuePair() { result = this.getAnElement() }

  /** Gets the number of elements in this hash literal. */
  final int getNumberOfElements() { result = super.getNumberOfElementsImpl() }

  final override AstNode getAChild(string pred) {
    result = Literal.super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

/**
 * A range literal.
 *
 * ```rb
 * (1..10)
 * (1024...2048)
 * ```
 */
class RangeLiteral extends Literal instanceof RangeLiteralImpl {
  final override string getAPrimaryQlClass() { result = "RangeLiteral" }

  /** Gets the begin expression of this range, if any. */
  final Expr getBegin() { result = super.getBeginImpl() }

  /** Gets the end expression of this range, if any. */
  final Expr getEnd() { result = super.getEndImpl() }

  /**
   * Holds if the range is inclusive of the end value, i.e. uses the `..`
   * operator.
   */
  final predicate isInclusive() { super.isInclusiveImpl() }

  /**
   * Holds if the range is exclusive of the end value, i.e. uses the `...`
   * operator.
   */
  final predicate isExclusive() { super.isExclusiveImpl() }

  final override AstNode getAChild(string pred) {
    result = Literal.super.getAChild(pred)
    or
    pred = "getBegin" and result = this.getBegin()
    or
    pred = "getEnd" and result = this.getEnd()
  }
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
  MethodName() { MethodName::range(toGenerated(this)) }

  final override string getAPrimaryQlClass() { result = "MethodName" }
}
