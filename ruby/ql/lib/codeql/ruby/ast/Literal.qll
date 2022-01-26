private import codeql.ruby.AST
private import codeql.ruby.security.performance.RegExpTreeView as RETV
private import internal.AST
private import internal.Constant
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
class IntegerLiteral extends NumericLiteral, TIntegerLiteral {
  /** Gets the numerical value of this integer literal. */
  int getValue() { none() }

  final override ConstantValue::ConstantIntegerValue getConstantValue() {
    result.isInt(this.getValue())
  }

  final override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

private int parseInteger(Ruby::Integer i) {
  exists(string s | s = i.getValue().toLowerCase().replaceAll("_", "") |
    s.charAt(0) != "0" and
    result = s.toInt()
    or
    exists(string str, string values, int shift |
      s.matches("0b%") and
      values = "01" and
      str = s.suffix(2) and
      shift = 1
      or
      s.matches("0x%") and
      values = "0123456789abcdef" and
      str = s.suffix(2) and
      shift = 4
      or
      s.charAt(0) = "0" and
      not s.charAt(1) = ["b", "x", "o"] and
      values = "01234567" and
      str = s.suffix(1) and
      shift = 3
      or
      s.matches("0o%") and
      values = "01234567" and
      str = s.suffix(2) and
      shift = 3
    |
      result =
        sum(int index, string c, int v, int exp |
          c = str.charAt(index) and
          v = values.indexOf(c.toLowerCase()) and
          exp = str.length() - index - 1
        |
          v.bitShiftLeft((str.length() - index - 1) * shift)
        )
    )
  )
}

private class RequiredIntegerLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredInt(int i) { i = any(IntegerLiteral il).getValue() }
}

private class IntegerLiteralReal extends IntegerLiteral, TIntegerLiteralReal {
  private Ruby::Integer g;

  IntegerLiteralReal() { this = TIntegerLiteralReal(g) }

  final override int getValue() { result = parseInteger(g) }

  final override string toString() { result = g.getValue() }
}

private class IntegerLiteralSynth extends IntegerLiteral, TIntegerLiteralSynth {
  private int value;

  IntegerLiteralSynth() { this = TIntegerLiteralSynth(_, _, value) }

  final override int getValue() { result = value }

  final override string toString() { result = value.toString() }
}

// TODO: implement properly
private float parseFloat(Ruby::Float f) { result = f.getValue().toFloat() }

private class RequiredFloatConstantValue extends RequiredConstantValue {
  override predicate requiredFloat(float f) { f = parseFloat(_) }
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
  private Ruby::Float g;

  FloatLiteral() { this = TFloatLiteral(g) }

  final override ConstantValue::ConstantFloatValue getConstantValue() {
    result.isFloat(parseFloat(g))
  }

  final override string toString() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

private predicate isRationalValue(Ruby::Rational r, int numerator, int denominator) {
  numerator = parseInteger(r.getChild()) and
  denominator = 1
  or
  exists(Ruby::Float f, string regex, string before, string after |
    f = r.getChild() and
    regex = "([^.]*)\\.(.*)" and
    before = f.getValue().regexpCapture(regex, 1) and
    after = f.getValue().regexpCapture(regex, 2) and
    numerator = before.toInt() * denominator + after.toInt() and
    denominator = 10.pow(after.length())
  )
}

private class RequiredRationalConstantValue extends RequiredConstantValue {
  override predicate requiredRational(int numerator, int denominator) {
    isRationalValue(_, numerator, denominator)
  }
}

/**
 * A rational literal.
 *
 * ```rb
 * 123r
 * ```
 */
class RationalLiteral extends NumericLiteral, TRationalLiteral {
  private Ruby::Rational g;

  RationalLiteral() { this = TRationalLiteral(g) }

  final override ConstantValue::ConstantRationalValue getConstantValue() {
    exists(int numerator, int denominator |
      isRationalValue(g, numerator, denominator) and
      result.isRational(numerator, denominator)
    )
  }

  final override string toString() { result = g.getChild().(Ruby::Token).getValue() + "r" }

  final override string getAPrimaryQlClass() { result = "RationalLiteral" }
}

private float getComplexValue(Ruby::Complex c) {
  exists(string s |
    s = c.getValue() and
    result = s.prefix(s.length() - 1).toFloat()
  )
}

private class RequiredComplexConstantValue extends RequiredConstantValue {
  override predicate requiredComplex(float real, float imaginary) {
    real = 0 and
    imaginary = getComplexValue(_)
  }
}

/**
 * A complex literal.
 *
 * ```rb
 * 1i
 * ```
 */
class ComplexLiteral extends NumericLiteral, TComplexLiteral {
  private Ruby::Complex g;

  ComplexLiteral() { this = TComplexLiteral(g) }

  final override ConstantValue::ConstantComplexValue getConstantValue() {
    result.isComplex(0, getComplexValue(g))
  }

  final override string toString() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "ComplexLiteral" }
}

/** A `nil` literal. */
class NilLiteral extends Literal, TNilLiteral {
  private Ruby::Nil g;

  NilLiteral() { this = TNilLiteral(g) }

  final override ConstantValue::ConstantNilValue getConstantValue() { any() }

  final override string toString() { result = g.getValue() }

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

  /** Holds if the Boolean literal is `true` or `TRUE`. */
  predicate isTrue() { none() }

  /** Holds if the Boolean literal is `false` or `FALSE`. */
  predicate isFalse() { none() }

  /** Gets the value of this Boolean literal. */
  boolean getValue() {
    this.isTrue() and result = true
    or
    this.isFalse() and result = false
  }

  final override ConstantValue::ConstantBooleanValue getConstantValue() {
    result.isBoolean(this.getValue())
  }
}

private class TrueLiteral extends BooleanLiteral, TTrueLiteral {
  private Ruby::True g;

  TrueLiteral() { this = TTrueLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override predicate isTrue() { any() }
}

private class FalseLiteral extends BooleanLiteral, TFalseLiteral {
  private Ruby::False g;

  FalseLiteral() { this = TFalseLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override predicate isFalse() { any() }
}

private class RequiredEncodingLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = "UTF-8" }
}

/**
 * An `__ENCODING__` literal.
 */
class EncodingLiteral extends Literal, TEncoding {
  final override string getAPrimaryQlClass() { result = "EncodingLiteral" }

  final override string toString() { result = "__ENCODING__" }

  // TODO: return the encoding defined by a magic encoding: comment, if any.
  override ConstantValue::ConstantStringValue getConstantValue() { result.isString("UTF-8") }
}

private class RequiredLineLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredInt(int i) { i = any(LineLiteral ll).getLocation().getStartLine() }
}

/**
 * A `__LINE__` literal.
 */
class LineLiteral extends Literal, TLine {
  final override string getAPrimaryQlClass() { result = "LineLiteral" }

  final override string toString() { result = "__LINE__" }

  final override ConstantValue::ConstantIntegerValue getConstantValue() {
    result.isInt(this.getLocation().getStartLine())
  }
}

private class RequiredFileLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(FileLiteral fl).getLocation().getFile().getAbsolutePath()
  }
}

/**
 * A `__FILE__` literal.
 */
class FileLiteral extends Literal, TFile {
  final override string getAPrimaryQlClass() { result = "FileLiteral" }

  final override string toString() { result = "__FILE__" }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(this.getLocation().getFile().getAbsolutePath())
  }
}

/**
 * The base class for a component of a string: `StringTextComponent`,
 * `StringEscapeSequenceComponent`, or `StringInterpolationComponent`.
 */
class StringComponent extends AstNode, TStringComponent {
  /**
   * DEPRECATED: Use `getConstantValue` instead.
   *
   * Gets the source text for this string component. Has no result if this is
   * a `StringInterpolationComponent`.
   */
  deprecated string getValueText() { result = this.getConstantValue().toString() }

  /** Gets the constant value of this string component, if any. */
  ConstantValue::ConstantStringValue getConstantValue() { none() }
}

private class RequiredStringTextComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(Ruby::Token t | exists(TStringTextComponentNonRegexp(t))).getValue()
  }
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
class StringTextComponent extends StringComponent, TStringTextComponentNonRegexp {
  private Ruby::Token g;

  StringTextComponent() { this = TStringTextComponentNonRegexp(g) }

  final override string toString() { result = g.getValue() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(g.getValue())
  }

  final override string getAPrimaryQlClass() { result = "StringTextComponent" }
}

private class RequiredStringEscapeSequenceComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(Ruby::Token t | exists(TStringEscapeSequenceComponentNonRegexp(t))).getValue()
  }
}

/**
 * An escape sequence component of a string or string-like literal.
 */
class StringEscapeSequenceComponent extends StringComponent, TStringEscapeSequenceComponentNonRegexp {
  private Ruby::EscapeSequence g;

  StringEscapeSequenceComponent() { this = TStringEscapeSequenceComponentNonRegexp(g) }

  final override string toString() { result = g.getValue() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(g.getValue())
  }

  final override string getAPrimaryQlClass() { result = "StringEscapeSequenceComponent" }
}

/**
 * An interpolation expression component of a string or string-like literal.
 */
class StringInterpolationComponent extends StringComponent, StmtSequence,
  TStringInterpolationComponentNonRegexp {
  private Ruby::Interpolation g;

  StringInterpolationComponent() { this = TStringInterpolationComponentNonRegexp(g) }

  final override string toString() { result = "#{...}" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  deprecated final override string getValueText() { none() }

  final override ConstantValue::ConstantStringValue getConstantValue() { none() }

  final override string getAPrimaryQlClass() { result = "StringInterpolationComponent" }
}

private class TRegExpComponent =
  TStringTextComponentRegexp or TStringEscapeSequenceComponentRegexp or
      TStringInterpolationComponentRegexp;

/**
 * The base class for a component of a regular expression literal.
 */
class RegExpComponent extends AstNode, TRegExpComponent {
  /**
   * DEPRECATED: Use `getConstantValue` instead.
   *
   * Gets the source text for this regex component, if any.
   */
  deprecated string getValueText() { result = this.getConstantValue().toString() }

  /** Gets the constant value of this regex component, if any. */
  ConstantValue::ConstantStringValue getConstantValue() { none() }
}

// Exclude components that are children of a free-spacing regex.
// We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
private string getRegExpTextComponentValue(RegExpTextComponent c) {
  exists(Ruby::Token t |
    c = TStringTextComponentRegexp(t) and
    not c.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = t.getValue()
  )
}

private class RequiredRegExpTextComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getRegExpTextComponentValue(_) }
}

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
class RegExpTextComponent extends RegExpComponent, TStringTextComponentRegexp {
  private Ruby::Token g;

  RegExpTextComponent() { this = TStringTextComponentRegexp(g) }

  final override string toString() { result = g.getValue() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(getRegExpTextComponentValue(this))
  }

  final override string getAPrimaryQlClass() { result = "RegExpTextComponent" }
}

// Exclude components that are children of a free-spacing regex.
// We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
private string getRegExpEscapeSequenceComponentValue(RegExpEscapeSequenceComponent c) {
  exists(Ruby::EscapeSequence e |
    c = TStringEscapeSequenceComponentRegexp(e) and
    not c.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = e.getValue()
  )
}

private class RequiredRegExpEscapeSequenceComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getRegExpEscapeSequenceComponentValue(_) }
}

/**
 * An escape sequence component of a regex literal.
 */
class RegExpEscapeSequenceComponent extends RegExpComponent, TStringEscapeSequenceComponentRegexp {
  private Ruby::EscapeSequence g;

  RegExpEscapeSequenceComponent() { this = TStringEscapeSequenceComponentRegexp(g) }

  final override string toString() { result = g.getValue() }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(getRegExpEscapeSequenceComponentValue(this))
  }

  final override string getAPrimaryQlClass() { result = "RegExpEscapeSequenceComponent" }
}

/**
 * An interpolation expression component of a regex literal.
 */
class RegExpInterpolationComponent extends RegExpComponent, StmtSequence,
  TStringInterpolationComponentRegexp {
  private Ruby::Interpolation g;

  RegExpInterpolationComponent() { this = TStringInterpolationComponentRegexp(g) }

  final override string toString() { result = "#{...}" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }

  deprecated final override string getValueText() { none() }

  final override ConstantValue::ConstantStringValue getConstantValue() { none() }

  final override string getAPrimaryQlClass() { result = "RegExpInterpolationComponent" }
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

  override string toString() {
    exists(string full, string summary |
      full =
        concat(StringComponent c, int i, string s |
          c = this.getComponent(i) and
          (
            s = toGenerated(c).(Ruby::Token).getValue()
            or
            not toGenerated(c) instanceof Ruby::Token and
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
  private Ruby::String g;

  RegularStringLiteral() { this = TRegularStringLiteral(g) }

  final override StringComponent getComponent(int n) { toGenerated(result) = g.getChild(n) }
}

private class BareStringLiteral extends StringLiteral, TBareStringLiteral {
  private Ruby::BareString g;

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
  private Ruby::Regex g;

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

// Tree-sitter gives us value text including the colon, which we skip.
private string getSimpleSymbolValue(Ruby::SimpleSymbol ss) { result = ss.getValue().suffix(1) }

private class RequiredSimpleSymbolConstantValue extends RequiredConstantValue {
  override predicate requiredSymbol(string s) { s = getSimpleSymbolValue(_) }
}

private class SimpleSymbolLiteral extends SymbolLiteral, TSimpleSymbolLiteral {
  private Ruby::SimpleSymbol g;

  SimpleSymbolLiteral() { this = TSimpleSymbolLiteral(g) }

  final override ConstantValue::ConstantSymbolValue getConstantValue() {
    result.isSymbol(getSimpleSymbolValue(g))
  }

  final override string toString() { result = g.getValue() }
}

private class ComplexSymbolLiteral extends SymbolLiteral, TComplexSymbolLiteral { }

private class DelimitedSymbolLiteral extends ComplexSymbolLiteral, TDelimitedSymbolLiteral {
  private Ruby::DelimitedSymbol g;

  DelimitedSymbolLiteral() { this = TDelimitedSymbolLiteral(g) }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

private class BareSymbolLiteral extends ComplexSymbolLiteral, TBareSymbolLiteral {
  private Ruby::BareSymbol g;

  BareSymbolLiteral() { this = TBareSymbolLiteral(g) }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

private class RequiredHashKeySymbolConstantValue extends RequiredConstantValue {
  override predicate requiredSymbol(string s) { s = any(Ruby::HashKeySymbol h).getValue() }
}

private class HashKeySymbolLiteral extends SymbolLiteral, THashKeySymbolLiteral {
  private Ruby::HashKeySymbol g;

  HashKeySymbolLiteral() { this = THashKeySymbolLiteral(g) }

  final override ConstantValue::ConstantSymbolValue getConstantValue() {
    result.isSymbol(g.getValue())
  }

  final override string toString() { result = ":" + g.getValue() }
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
  private Ruby::Subshell g;

  SubshellLiteral() { this = TSubshellLiteral(g) }

  final override string getAPrimaryQlClass() { result = "SubshellLiteral" }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

private class RequiredCharacterConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = any(Ruby::Character c).getValue() }
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
  private Ruby::Character g;

  CharacterLiteral() { this = TCharacterLiteral(g) }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(g.getValue())
  }

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
  final Expr getElement(int n) { result = this.(ArrayLiteralImpl).getElementImpl(n) }

  /** Gets an element in this array literal. */
  final Expr getAnElement() { result = this.getElement(_) }

  /** Gets the number of elements in this array literal. */
  final int getNumberOfElements() { result = this.(ArrayLiteralImpl).getNumberOfElementsImpl() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }
}

abstract private class ArrayLiteralImpl extends ArrayLiteral {
  abstract Expr getElementImpl(int n);

  abstract int getNumberOfElementsImpl();
}

private class RegularArrayLiteral extends ArrayLiteralImpl, TRegularArrayLiteral {
  private Ruby::Array g;

  RegularArrayLiteral() { this = TRegularArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "[...]" }
}

private class StringArrayLiteral extends ArrayLiteralImpl, TStringArrayLiteral {
  private Ruby::StringArray g;

  StringArrayLiteral() { this = TStringArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "%w(...)" }
}

private class SymbolArrayLiteral extends ArrayLiteralImpl, TSymbolArrayLiteral {
  private Ruby::SymbolArray g;

  SymbolArrayLiteral() { this = TSymbolArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

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
  private Ruby::Range g;

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

private string getMethodName(MethodName::Token t) {
  result = t.(Ruby::Token).getValue()
  or
  result = t.(Ruby::Setter).getName().getValue() + "="
}

private class RequiredMethodNameConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getMethodName(_) }
}

private class TokenMethodName extends MethodName, TTokenMethodName {
  private MethodName::Token g;

  TokenMethodName() { this = TTokenMethodName(g) }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(getMethodName(g))
  }

  final override string toString() { result = getMethodName(g) }
}
