private import codeql_ruby.AST
private import codeql_ruby.regexp.RegExpTreeView as RETV
private import internal.AST
private import internal.Scope
private import internal.TreeSitter

/**
 * A literal.
 *
 * This is the QL root class for all literals.
 */
class Literal extends Expr, TLiteral {
  /**
   * Gets the source text for this literal, if this is a simple literal.
   *
   * For complex literals, such as arrays, hashes, and strings with
   * interpolations, this predicate has no result.
   */
  string getValueText() { none() }
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
class NumericLiteral extends Literal, TNumericLiteral { }

/**
 * An integer literal.
 *
 * ```rb
 *  123
 *  0xff
 * ```
 */
class IntegerLiteral extends NumericLiteral, TIntegerLiteral {
  /** Gets the numerical value of this integer literal. */
  int getValue() { none() }

  final override string toString() { result = this.getValueText() }

  final override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

private class IntegerLiteralReal extends IntegerLiteral, TIntegerLiteralReal {
  private Generated::Integer g;

  IntegerLiteralReal() { this = TIntegerLiteralReal(g) }

  final override string getValueText() { result = g.getValue() }

  final override int getValue() {
    exists(string s, string values, string str |
      s = this.getValueText().toLowerCase() and
      (
        s.matches("0b%") and
        values = "01" and
        str = s.suffix(2)
        or
        s.matches("0x%") and
        values = "0123456789abcdef" and
        str = s.suffix(2)
        or
        s.charAt(0) = "0" and
        not s.charAt(1) = ["b", "x", "o"] and
        values = "01234567" and
        str = s.suffix(1)
        or
        s.matches("0o%") and
        values = "01234567" and
        str = s.suffix(2)
        or
        s.charAt(0) != "0" and values = "0123456789" and str = s
      )
    |
      result =
        sum(int index, string c, int v, int exp |
          c = str.replaceAll("_", "").charAt(index) and
          v = values.indexOf(c.toLowerCase()) and
          exp = str.replaceAll("_", "").length() - index - 1
        |
          v * values.length().pow(exp)
        )
    )
  }
}

private class IntegerLiteralSynth extends IntegerLiteral, TIntegerLiteralSynth {
  private int value;

  IntegerLiteralSynth() { this = TIntegerLiteralSynth(_, _, value) }

  final override string getValueText() { result = value.toString() }

  final override int getValue() { result = value }
}

/**
 * A floating-point literal.
 *
 * ```rb
 * 1.3
 * 2.7e+5
 * ```
 */
class FloatLiteral extends NumericLiteral, TFloatLiteral {
  private Generated::Float g;

  FloatLiteral() { this = TFloatLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override string toString() { result = this.getValueText() }

  final override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

/**
 * A rational literal.
 *
 * ```rb
 * 123r
 * ```
 */
class RationalLiteral extends NumericLiteral, TRationalLiteral {
  private Generated::Rational g;

  RationalLiteral() { this = TRationalLiteral(g) }

  final override string getValueText() { result = g.getChild().(Generated::Token).getValue() + "r" }

  final override string toString() { result = this.getValueText() }

  final override string getAPrimaryQlClass() { result = "RationalLiteral" }
}

/**
 * A complex literal.
 *
 * ```rb
 * 1i
 * ```
 */
class ComplexLiteral extends NumericLiteral, TComplexLiteral {
  private Generated::Complex g;

  ComplexLiteral() { this = TComplexLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override string toString() { result = this.getValueText() }

  final override string getAPrimaryQlClass() { result = "ComplexLiteral" }
}

/** A `nil` literal. */
class NilLiteral extends Literal, TNilLiteral {
  private Generated::Nil g;

  NilLiteral() { this = TNilLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override string toString() { result = this.getValueText() }

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
class BooleanLiteral extends Literal, TBooleanLiteral {
  final override string getAPrimaryQlClass() { result = "BooleanLiteral" }

  final override string toString() { result = this.getValueText() }

  /** Holds if the Boolean literal is `true` or `TRUE`. */
  predicate isTrue() { none() }

  /** Holds if the Boolean literal is `false` or `FALSE`. */
  predicate isFalse() { none() }
}

private class TrueLiteral extends BooleanLiteral, TTrueLiteral {
  private Generated::True g;

  TrueLiteral() { this = TTrueLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override predicate isTrue() { any() }
}

private class FalseLiteral extends BooleanLiteral, TFalseLiteral {
  private Generated::False g;

  FalseLiteral() { this = TFalseLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override predicate isFalse() { any() }
}

/**
 * The base class for a component of a string: `StringTextComponent`,
 * `StringEscapeSequenceComponent`, or `StringInterpolationComponent`.
 */
class StringComponent extends AstNode, TStringComponent {
  /**
   * Gets the source text for this string component. Has no result if this is
   * a `StringInterpolationComponent`.
   */
  string getValueText() { none() }
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
class StringTextComponent extends StringComponent, TStringTextComponent {
  private Generated::Token g;

  StringTextComponent() { this = TStringTextComponent(g) }

  final override string toString() { result = g.getValue() }

  final override string getValueText() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "StringTextComponent" }
}

/**
 * An escape sequence component of a string or string-like literal.
 */
class StringEscapeSequenceComponent extends StringComponent, TStringEscapeSequenceComponent {
  private Generated::EscapeSequence g;

  StringEscapeSequenceComponent() { this = TStringEscapeSequenceComponent(g) }

  final override string toString() { result = g.getValue() }

  final override string getValueText() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "StringEscapeSequenceComponent" }
}

/**
 * An interpolation expression component of a string or string-like literal.
 */
class StringInterpolationComponent extends StringComponent, StmtSequence,
  TStringInterpolationComponent {
  private Generated::Interpolation g;

  StringInterpolationComponent() { this = TStringInterpolationComponent(g) }

  final override string toString() { result = "#{...}" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  final override string getValueText() { none() }

  final override string getAPrimaryQlClass() { result = "StringInterpolationComponent" }
}

/**
 * A string, symbol, regexp, or subshell literal.
 */
class StringlikeLiteral extends Literal, TStringlikeLiteral {
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
  StringComponent getComponent(int n) { none() }

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

  private string getStartDelimiter() {
    this instanceof TStringLiteral and
    result = "\""
    or
    this instanceof TRegExpLiteral and
    result = "/"
    or
    this instanceof TSimpleSymbolLiteral and
    result = ":"
    or
    this instanceof TComplexSymbolLiteral and
    result = ":\""
    or
    this instanceof THashKeySymbolLiteral and
    result = ""
    or
    this instanceof TSubshellLiteral and
    result = "`"
    or
    this instanceof THereDoc and
    result = ""
  }

  private string getEndDelimiter() {
    this instanceof TStringLiteral and
    result = "\""
    or
    this instanceof TRegExpLiteral and
    result = "/"
    or
    this instanceof TSimpleSymbolLiteral and
    result = ""
    or
    this instanceof TComplexSymbolLiteral and
    result = "\""
    or
    this instanceof THashKeySymbolLiteral and
    result = ""
    or
    this instanceof TSubshellLiteral and
    result = "`"
    or
    this instanceof THereDoc and
    result = ""
  }

  override string getValueText() {
    // 0 components should result in the empty string
    // if there are any interpolations, there should be no result
    // otherwise, concatenate all the components
    forall(StringComponent c | c = this.getComponent(_) |
      not c instanceof StringInterpolationComponent
    ) and
    result =
      concat(StringComponent c, int i | c = this.getComponent(i) | c.getValueText() order by i)
  }

  override string toString() {
    exists(string full, string summary |
      full =
        concat(StringComponent c, int i, string s |
          c = this.getComponent(i) and
          (
            s = toGenerated(c).(Generated::Token).getValue()
            or
            not toGenerated(c) instanceof Generated::Token and
            s = "#{...}"
          )
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

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
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
class StringLiteral extends StringlikeLiteral, TStringLiteral {
  final override string getAPrimaryQlClass() { result = "StringLiteral" }
}

private class RegularStringLiteral extends StringLiteral, TRegularStringLiteral {
  private Generated::String g;

  RegularStringLiteral() { this = TRegularStringLiteral(g) }

  final override StringComponent getComponent(int n) { toGenerated(result) = g.getChild(n) }
}

private class BareStringLiteral extends StringLiteral, TBareStringLiteral {
  private Generated::BareString g;

  BareStringLiteral() { this = TBareStringLiteral(g) }

  final override StringComponent getComponent(int n) { toGenerated(result) = g.getChild(n) }
}

/**
 * A regular expression literal.
 *
 * ```rb
 * /[a-z]+/
 * ```
 */
class RegExpLiteral extends StringlikeLiteral, TRegExpLiteral {
  private Generated::Regex g;

  RegExpLiteral() { this = TRegExpLiteral(g) }

  final override string getAPrimaryQlClass() { result = "RegExpLiteral" }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }

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
      max(Generated::Token t |
        t.getParent() = g
      |
        t.getValue().suffix(1) order by t.getParentIndex()
      )
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
  final RETV::RegExpTerm getParsed() { result = RETV::getParsedRegExp(this) }
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
class SymbolLiteral extends StringlikeLiteral, TSymbolLiteral {
  final override string getAPrimaryQlClass() {
    not this instanceof MethodName and result = "SymbolLiteral"
  }
}

private class SimpleSymbolLiteral extends SymbolLiteral, TSimpleSymbolLiteral {
  private Generated::SimpleSymbol g;

  SimpleSymbolLiteral() { this = TSimpleSymbolLiteral(g) }

  // Tree-sitter gives us value text including the colon, which we skip.
  final override string getValueText() { result = g.getValue().suffix(1) }

  final override string toString() { result = g.getValue() }
}

private class ComplexSymbolLiteral extends SymbolLiteral, TComplexSymbolLiteral { }

private class DelimitedSymbolLiteral extends ComplexSymbolLiteral, TDelimitedSymbolLiteral {
  private Generated::DelimitedSymbol g;

  DelimitedSymbolLiteral() { this = TDelimitedSymbolLiteral(g) }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

private class BareSymbolLiteral extends ComplexSymbolLiteral, TBareSymbolLiteral {
  private Generated::BareSymbol g;

  BareSymbolLiteral() { this = TBareSymbolLiteral(g) }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

private class HashKeySymbolLiteral extends SymbolLiteral, THashKeySymbolLiteral {
  private Generated::HashKeySymbol g;

  HashKeySymbolLiteral() { this = THashKeySymbolLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override string toString() { result = ":" + this.getValueText() }
}

/**
 * A subshell literal.
 *
 * ```rb
 * `ls -l`
 * %x(/bin/sh foo.sh)
 * ```
 */
class SubshellLiteral extends StringlikeLiteral, TSubshellLiteral {
  private Generated::Subshell g;

  SubshellLiteral() { this = TSubshellLiteral(g) }

  final override string getAPrimaryQlClass() { result = "SubshellLiteral" }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

/**
 * A character literal.
 *
 * ```rb
 * ?a
 * ?\u{61}
 * ```
 */
class CharacterLiteral extends Literal, TCharacterLiteral {
  private Generated::Character g;

  CharacterLiteral() { this = TCharacterLiteral(g) }

  final override string getValueText() { result = g.getValue() }

  final override string toString() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "CharacterLiteral" }
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
class HereDoc extends StringlikeLiteral, THereDoc {
  private Generated::HeredocBeginning g;

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
  final predicate isSubShell() { getQuoteStyle() = "`" }

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

  final override StringComponent getComponent(int n) {
    toGenerated(result) = getHereDocBody(g).getChild(n)
  }

  final override string toString() { result = g.getValue() }
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
class ArrayLiteral extends Literal, TArrayLiteral {
  final override string getAPrimaryQlClass() { result = "ArrayLiteral" }

  /** Gets the `n`th element in this array literal. */
  Expr getElement(int n) { none() }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = this.getElement(_) }

  /** Gets the number of elements in this array literal. */
  final int getNumberOfElements() { result = count(this.getAnElement()) }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

private class RegularArrayLiteral extends ArrayLiteral, TRegularArrayLiteral {
  private Generated::Array g;

  RegularArrayLiteral() { this = TRegularArrayLiteral(g) }

  final override Expr getElement(int i) { toGenerated(result) = g.getChild(i) }

  final override string toString() { result = "[...]" }
}

private class StringArrayLiteral extends ArrayLiteral, TStringArrayLiteral {
  private Generated::StringArray g;

  StringArrayLiteral() { this = TStringArrayLiteral(g) }

  final override Expr getElement(int i) { toGenerated(result) = g.getChild(i) }

  final override string toString() { result = "%w(...)" }
}

private class SymbolArrayLiteral extends ArrayLiteral, TSymbolArrayLiteral {
  private Generated::SymbolArray g;

  SymbolArrayLiteral() { this = TSymbolArrayLiteral(g) }

  final override Expr getElement(int i) { toGenerated(result) = g.getChild(i) }

  final override string toString() { result = "%i(...)" }
}

/**
 * A hash literal.
 *
 * ```rb
 * { foo: 123, bar: 456 }
 * ```
 */
class HashLiteral extends Literal, THashLiteral {
  private Generated::Hash g;

  HashLiteral() { this = THashLiteral(g) }

  final override string getAPrimaryQlClass() { result = "HashLiteral" }

  /**
   * Gets the `n`th element in this array literal.
   *
   * In the following example, the 0th element is a `Pair`, and the 1st element
   * is a `HashSplatExpr`.
   *
   * ```rb
   * { foo: 123, **bar }
   * ```
   */
  final Expr getElement(int n) { toGenerated(result) = g.getChild(n) }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = this.getElement(_) }

  /** Gets a key-value `Pair` in this hash literal. */
  final Pair getAKeyValuePair() { result = this.getAnElement() }

  /** Gets the number of elements in this hash literal. */
  final int getNumberOfElements() { result = count(this.getAnElement()) }

  final override string toString() { result = "{...}" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
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
class RangeLiteral extends Literal, TRangeLiteral {
  final override string getAPrimaryQlClass() { result = "RangeLiteral" }

  /** Gets the begin expression of this range, if any. */
  Expr getBegin() { none() }

  /** Gets the end expression of this range, if any. */
  Expr getEnd() { none() }

  /**
   * Holds if the range is inclusive of the end value, i.e. uses the `..`
   * operator.
   */
  predicate isInclusive() { none() }

  /**
   * Holds if the range is exclusive of the end value, i.e. uses the `...`
   * operator.
   */
  predicate isExclusive() { none() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getBegin" and result = this.getBegin()
    or
    pred = "getEnd" and result = this.getEnd()
  }

  final override string toString() {
    exists(string op |
      this.isInclusive() and op = ".."
      or
      this.isExclusive() and op = "..."
    |
      result = "_ " + op + " _"
    )
  }
}

private class RangeLiteralReal extends RangeLiteral, TRangeLiteralReal {
  private Generated::Range g;

  RangeLiteralReal() { this = TRangeLiteralReal(g) }

  final override Expr getBegin() { toGenerated(result) = g.getBegin() }

  final override Expr getEnd() { toGenerated(result) = g.getEnd() }

  final override predicate isInclusive() { g instanceof @ruby_range_dotdot }

  final override predicate isExclusive() { g instanceof @ruby_range_dotdotdot }
}

private class RangeLiteralSynth extends RangeLiteral, TRangeLiteralSynth {
  private boolean inclusive;

  RangeLiteralSynth() { this = TRangeLiteralSynth(_, _, inclusive) }

  final override Expr getBegin() { result = TIntegerLiteralSynth(this, 0, _) }

  final override Expr getEnd() { result = TIntegerLiteralSynth(this, 1, _) }

  final override predicate isInclusive() { inclusive = true }

  final override predicate isExclusive() { inclusive = false }
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

private class TokenMethodName extends MethodName, TTokenMethodName {
  private MethodName::Token g;

  TokenMethodName() { this = TTokenMethodName(g) }

  final override string getValueText() {
    result = g.(Generated::Token).getValue()
    or
    result = g.(Generated::Setter).getName().getValue() + "="
  }

  final override string toString() { result = this.getValueText() }
}
