private import codeql.ruby.AST
private import AST
private import Constant
private import TreeSitter
private import codeql.ruby.ast.internal.Scope
private import codeql.ruby.controlflow.CfgNodes
private import codeql.util.Numbers

int parseInteger(Ruby::Integer i) {
  exists(string s | s = i.getValue().toLowerCase().replaceAll("_", "") |
    s.charAt(0) != "0" and
    result = s.toInt()
    or
    s.matches("0b%") and result = parseBinaryInt(s.suffix(2))
    or
    s.matches("0x%") and result = parseHexInt(s.suffix(2))
    or
    s.charAt(0) = "0" and
    not s.charAt(1) = ["b", "x", "o"] and
    result = parseOctalInt(s.suffix(1))
    or
    s.matches("0o%") and
    result = parseOctalInt(s.suffix(2))
  )
}

abstract class IntegerLiteralImpl extends Expr, TIntegerLiteral {
  abstract int getValue();
}

class IntegerLiteralReal extends IntegerLiteralImpl, TIntegerLiteralReal {
  private Ruby::Integer g;

  IntegerLiteralReal() { this = TIntegerLiteralReal(g) }

  final override int getValue() { result = parseInteger(g) }

  final override string toString() { result = g.getValue() }
}

class IntegerLiteralSynth extends IntegerLiteralImpl, TIntegerLiteralSynth {
  private int value;

  IntegerLiteralSynth() { this = TIntegerLiteralSynth(_, _, value) }

  final override int getValue() { result = value }

  final override string toString() { result = value.toString() }
}

// TODO: implement properly
float parseFloat(Ruby::Float f) { result = f.getValue().toFloat() }

class FloatLiteralImpl extends Expr, TFloatLiteral {
  private Ruby::Float g;

  FloatLiteralImpl() { this = TFloatLiteral(g) }

  final float getValue() { result = parseFloat(g) }

  final override string toString() { result = g.getValue() }
}

predicate isRationalValue(Ruby::Rational r, int numerator, int denominator) {
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

class RationalLiteralImpl extends Expr, TRationalLiteral {
  private Ruby::Rational g;

  RationalLiteralImpl() { this = TRationalLiteral(g) }

  final predicate hasValue(int numerator, int denominator) {
    isRationalValue(g, numerator, denominator)
  }

  final override string toString() { result = g.getChild().(Ruby::Token).getValue() + "r" }
}

float getComplexValue(Ruby::Complex c) {
  exists(int n, int d | isRationalValue(c.getChild(), n, d) and result = n.(float) / d.(float))
  or
  exists(string s |
    s = c.getChild().(Ruby::Token).getValue() and
    result = s.prefix(s.length()).toFloat()
  )
}

class ComplexLiteralImpl extends Expr, TComplexLiteral {
  private Ruby::Complex g;

  ComplexLiteralImpl() { this = TComplexLiteral(g) }

  final predicate hasValue(float real, float imaginary) {
    real = 0 and imaginary = getComplexValue(g)
  }

  final override string toString() {
    result = g.getChild().(Ruby::Token).getValue() + "i" or
    result = g.getChild().(Ruby::Rational).getChild().(Ruby::Token).getValue() + "ri"
  }
}

abstract class NilLiteralImpl extends Expr, TNilLiteral {
  final override string toString() { result = "nil" }
}

class NilLiteralReal extends NilLiteralImpl, TNilLiteralReal {
  private Ruby::Nil g;

  NilLiteralReal() { this = TNilLiteralReal(g) }
}

class NilLiteralSynth extends NilLiteralImpl, TNilLiteralSynth {
  NilLiteralSynth() { this = TNilLiteralSynth(_, _) }
}

abstract class BooleanLiteralImpl extends Expr, TBooleanLiteral {
  abstract boolean getValue();
}

class TrueLiteral extends BooleanLiteralImpl, TTrueLiteral {
  private Ruby::True g;

  TrueLiteral() { this = TTrueLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override boolean getValue() { result = true }
}

class FalseLiteral extends BooleanLiteralImpl, TFalseLiteral {
  private Ruby::False g;

  FalseLiteral() { this = TFalseLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override boolean getValue() { result = false }
}

class BooleanLiteralSynth extends BooleanLiteralImpl, TBooleanLiteralSynth {
  final override string toString() { result = this.getValue().toString() }

  final override boolean getValue() { this = TBooleanLiteralSynth(_, _, result) }
}

class EncodingLiteralImpl extends Expr, TEncoding {
  private Ruby::Encoding g;

  EncodingLiteralImpl() { this = TEncoding(g) }

  // TODO: return the encoding defined by a magic encoding: comment, if any.
  final string getValue() { result = "UTF-8" }

  final override string toString() { result = "__ENCODING__" }
}

class LineLiteralImpl extends Expr, TLine {
  private Ruby::Line g;

  LineLiteralImpl() { this = TLine(g) }

  final int getValue() { result = this.getLocation().getStartLine() }

  final override string toString() { result = "__LINE__" }
}

class FileLiteralImpl extends Expr, TFile {
  private Ruby::File g;

  FileLiteralImpl() { this = TFile(g) }

  final string getValue() { result = this.getLocation().getFile().getAbsolutePath() }

  final override string toString() { result = "__FILE__" }
}

abstract class ArrayLiteralImpl extends Literal, TArrayLiteral {
  abstract Expr getElementImpl(int n);

  abstract int getNumberOfElementsImpl();
}

class RegularArrayLiteral extends ArrayLiteralImpl, TRegularArrayLiteral {
  private Ruby::Array g;

  RegularArrayLiteral() { this = TRegularArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "[...]" }
}

class StringArrayLiteral extends ArrayLiteralImpl, TStringArrayLiteral {
  private Ruby::StringArray g;

  StringArrayLiteral() { this = TStringArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "%w(...)" }
}

class SymbolArrayLiteral extends ArrayLiteralImpl, TSymbolArrayLiteral {
  private Ruby::SymbolArray g;

  SymbolArrayLiteral() { this = TSymbolArrayLiteral(g) }

  final override Expr getElementImpl(int i) { toGenerated(result) = g.getChild(i) }

  final override int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "%i(...)" }
}

class HashLiteralImpl extends Literal, THashLiteral {
  Ruby::Hash g;

  HashLiteralImpl() { this = THashLiteral(g) }

  final int getNumberOfElementsImpl() { result = count(g.getChild(_)) }

  final override string toString() { result = "{...}" }
}

abstract class RangeLiteralImpl extends Literal, TRangeLiteral {
  abstract Expr getBeginImpl();

  abstract Expr getEndImpl();

  abstract predicate isInclusiveImpl();

  abstract predicate isExclusiveImpl();

  final override string toString() {
    exists(string op |
      this.isInclusiveImpl() and op = ".."
      or
      this.isExclusiveImpl() and op = "..."
    |
      result = "_ " + op + " _"
    )
  }
}

class RangeLiteralReal extends RangeLiteralImpl, TRangeLiteralReal {
  private Ruby::Range g;

  RangeLiteralReal() { this = TRangeLiteralReal(g) }

  final override Expr getBeginImpl() { toGenerated(result) = g.getBegin() }

  final override Expr getEndImpl() { toGenerated(result) = g.getEnd() }

  final override predicate isInclusiveImpl() { g instanceof @ruby_range_dotdot }

  final override predicate isExclusiveImpl() { g instanceof @ruby_range_dotdotdot }
}

class RangeLiteralSynth extends RangeLiteralImpl, TRangeLiteralSynth {
  private boolean inclusive;

  RangeLiteralSynth() { this = TRangeLiteralSynth(_, _, inclusive) }

  final override Expr getBeginImpl() { result = TIntegerLiteralSynth(this, 0, _) }

  final override Expr getEndImpl() { result = TIntegerLiteralSynth(this, 1, _) }

  final override predicate isInclusiveImpl() { inclusive = true }

  final override predicate isExclusiveImpl() { inclusive = false }
}

private string getMethodName(MethodName::Token t) {
  result = t.(Ruby::Token).getValue()
  or
  result = t.(Ruby::Setter).getName().getValue() + "="
}

class TokenMethodName extends Expr, TTokenMethodName {
  private MethodName::Token g;

  TokenMethodName() { this = TTokenMethodName(g) }

  final string getValue() { result = getMethodName(g) }

  final override string toString() { result = getMethodName(g) }
}

abstract class StringComponentImpl extends AstNode, TStringComponent {
  abstract string getValue();
}

abstract class StringTextComponentImpl extends StringComponentImpl, TStringTextComponentNonRegexp {
  abstract string getRawTextImpl();

  final override string toString() { result = this.getRawTextImpl() }
}

/**
 * Gets the result of unescaping a string text component by replacing `\\` and
 * `\'` with `\` and `'`, respectively.
 *
 * ```rb
 * 'foo\\bar \'baz\'' # foo\bar 'baz'
 * ```
 */
bindingset[text]
private string unescapeTextComponent(string text) {
  result = text.regexpReplaceAll("\\\\(['\\\\])", "$1")
}

class StringTextComponentStringOrHeredocContent extends StringTextComponentImpl,
  TStringTextComponentNonRegexpStringOrHeredocContent
{
  private Ruby::Token g;

  StringTextComponentStringOrHeredocContent() {
    this = TStringTextComponentNonRegexpStringOrHeredocContent(g)
  }

  final override string getValue() { result = this.getUnescapedText() }

  final override string getRawTextImpl() { result = g.getValue() }

  final private string getUnescapedText() { result = unescapeTextComponent(g.getValue()) }
}

private class StringTextComponentSimpleSymbol extends StringTextComponentImpl,
  TStringTextComponentNonRegexpSimpleSymbol
{
  private Ruby::SimpleSymbol g;

  StringTextComponentSimpleSymbol() { this = TStringTextComponentNonRegexpSimpleSymbol(g) }

  // Tree-sitter gives us value text including the colon, which we skip.
  private string getSimpleSymbolValue() { result = g.getValue().suffix(1) }

  final override string getValue() { result = this.getSimpleSymbolValue() }

  final override string getRawTextImpl() { result = this.getSimpleSymbolValue() }
}

private class StringTextComponentHashKeySymbol extends StringTextComponentImpl,
  TStringTextComponentNonRegexpHashKeySymbol
{
  private Ruby::HashKeySymbol g;

  StringTextComponentHashKeySymbol() { this = TStringTextComponentNonRegexpHashKeySymbol(g) }

  final override string getValue() { result = g.getValue() }

  final override string getRawTextImpl() { result = g.getValue() }
}

bindingset[escaped]
private string unescapeKnownEscapeSequence(string escaped) {
  escaped = "\\\\" and result = "\\"
  or
  escaped = "\\'" and result = "'"
  or
  escaped = "\\\"" and result = "\""
  or
  escaped = "\\a" and result = 7.toUnicode()
  or
  escaped = "\\b" and result = 8.toUnicode()
  or
  escaped = "\\t" and result = "\t"
  or
  escaped = "\\n" and result = "\n"
  or
  escaped = "\\v" and result = 11.toUnicode()
  or
  escaped = "\\f" and result = 12.toUnicode()
  or
  escaped = "\\r" and result = "\r"
  or
  escaped = "\\e" and result = 27.toUnicode()
  or
  escaped = "\\s" and result = " "
  or
  escaped = ["\\c?", "\\C-?"] and result = 127.toUnicode()
  or
  result = parseOctalInt(escaped.regexpCapture("\\\\([0-7]{1,3})", 1)).toUnicode()
  or
  result = parseHexInt(escaped.regexpCapture("\\\\x([0-9a-fA-F]{1,2})", 1)).toUnicode()
  or
  result = parseHexInt(escaped.regexpCapture("\\\\u([0-9a-fA-F]{4})", 1)).toUnicode()
  or
  result = parseHexInt(escaped.regexpCapture("\\\\u\\{([0-9a-fA-F]{1,6})\\}", 1)).toUnicode()
}

/**
 * Gets the string represented by the escape sequence in `escaped`. For example:
 *
 * ```
 * \\     => \
 * \141   => a
 * \u0078 => x
 * ```
 */
bindingset[escaped]
private string unescapeEscapeSequence(string escaped) {
  result = unescapeKnownEscapeSequence(escaped)
  or
  // Any other character following a backslash is just that character.
  not exists(unescapeKnownEscapeSequence(escaped)) and
  result = escaped.suffix(1)
}

/**
 * An escape sequence component of a string or string-like literal.
 */
class StringEscapeSequenceComponentImpl extends StringComponentImpl,
  TStringEscapeSequenceComponentNonRegexp
{
  private Ruby::EscapeSequence g;

  StringEscapeSequenceComponentImpl() { this = TStringEscapeSequenceComponentNonRegexp(g) }

  final override string getValue() { result = this.getUnescapedText() }

  final string getRawTextImpl() { result = g.getValue() }

  final private string getUnescapedText() { result = unescapeEscapeSequence(g.getValue()) }

  final override string toString() { result = this.getRawTextImpl() }
}

class StringInterpolationComponentImpl extends StringComponentImpl,
  TStringInterpolationComponentNonRegexp
{
  private Ruby::Interpolation g;

  StringInterpolationComponentImpl() { this = TStringInterpolationComponentNonRegexp(g) }

  // requires the CFG
  final override string getValue() { none() }

  final override string toString() { result = "#{...}" }
}

private class TRegExpComponent =
  TStringTextComponentRegexp or TStringEscapeSequenceComponentRegexp or
      TStringInterpolationComponentRegexp;

abstract class RegExpComponentImpl extends StringComponentImpl, TRegExpComponent { }

class RegExpTextComponentImpl extends RegExpComponentImpl, TStringTextComponentRegexp {
  private Ruby::Token g;

  RegExpTextComponentImpl() { this = TStringTextComponentRegexp(g) }

  final override string getValue() {
    // Exclude components that are children of a free-spacing regex.
    // We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
    not this.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = g.getValue()
  }

  final override string toString() { result = g.getValue() }
}

class RegExpEscapeSequenceComponentImpl extends RegExpComponentImpl,
  TStringEscapeSequenceComponentRegexp
{
  private Ruby::EscapeSequence g;

  RegExpEscapeSequenceComponentImpl() { this = TStringEscapeSequenceComponentRegexp(g) }

  final override string getValue() {
    // Exclude components that are children of a free-spacing regex.
    // We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
    not this.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = g.getValue()
  }

  final override string toString() { result = g.getValue() }
}

class RegExpInterpolationComponentImpl extends RegExpComponentImpl,
  TStringInterpolationComponentRegexp
{
  private Ruby::Interpolation g;

  RegExpInterpolationComponentImpl() { this = TStringInterpolationComponentRegexp(g) }

  // requires the CFG
  final override string getValue() { none() }

  final override string toString() { result = "#{...}" }
}

abstract class StringlikeLiteralImpl extends Expr, TStringlikeLiteral {
  abstract StringComponentImpl getComponentImpl(int n);

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
          c = this.getComponentImpl(i) and
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

  // 0 components results in the empty string
  // if all interpolations have a known string value, we will get a result
  language[monotonicAggregates]
  final string getStringValue() {
    result =
      concat(StringComponentImpl c, int i | c = this.getComponentImpl(i) | c.getValue() order by i)
  }
}

abstract class StringLiteralImpl extends StringlikeLiteralImpl, TStringLiteral { }

class RegularStringLiteral extends StringLiteralImpl, TRegularStringLiteral {
  private Ruby::String g;

  RegularStringLiteral() { this = TRegularStringLiteral(g) }

  final override StringComponent getComponentImpl(int n) { toGenerated(result) = g.getChild(n) }
}

class BareStringLiteral extends StringLiteralImpl, TBareStringLiteral {
  private Ruby::BareString g;

  BareStringLiteral() { this = TBareStringLiteral(g) }

  final override StringComponent getComponentImpl(int n) { toGenerated(result) = g.getChild(n) }
}

abstract class SymbolLiteralImpl extends StringlikeLiteralImpl, TSymbolLiteral { }

class SimpleSymbolLiteral extends SymbolLiteralImpl, TSimpleSymbolLiteral {
  private Ruby::SimpleSymbol g;

  SimpleSymbolLiteral() { this = TSimpleSymbolLiteral(g) }

  final override StringComponent getComponentImpl(int n) { n = 0 and toGenerated(result) = g }

  final override string toString() { result = g.getValue() }
}

abstract class ComplexSymbolLiteral extends SymbolLiteralImpl, TComplexSymbolLiteral { }

class DelimitedSymbolLiteral extends ComplexSymbolLiteral, TDelimitedSymbolLiteral {
  private Ruby::DelimitedSymbol g;

  DelimitedSymbolLiteral() { this = TDelimitedSymbolLiteral(g) }

  final override StringComponent getComponentImpl(int i) { toGenerated(result) = g.getChild(i) }
}

class BareSymbolLiteral extends ComplexSymbolLiteral, TBareSymbolLiteral {
  private Ruby::BareSymbol g;

  BareSymbolLiteral() { this = TBareSymbolLiteral(g) }

  final override StringComponent getComponentImpl(int i) { toGenerated(result) = g.getChild(i) }
}

private class HashKeySymbolLiteral extends SymbolLiteralImpl, THashKeySymbolLiteral {
  private Ruby::HashKeySymbol g;

  HashKeySymbolLiteral() { this = THashKeySymbolLiteral(g) }

  final override StringComponent getComponentImpl(int n) { n = 0 and toGenerated(result) = g }

  final override string toString() { result = ":" + g.getValue() }
}

class RegExpLiteralImpl extends StringlikeLiteralImpl, TRegExpLiteral {
  private Ruby::Regex g;

  RegExpLiteralImpl() { this = TRegExpLiteral(g) }

  final override RegExpComponentImpl getComponentImpl(int i) { toGenerated(result) = g.getChild(i) }
}

class SubshellLiteralImpl extends StringlikeLiteralImpl, TSubshellLiteral {
  private Ruby::Subshell g;

  SubshellLiteralImpl() { this = TSubshellLiteral(g) }

  final override StringComponent getComponentImpl(int i) { toGenerated(result) = g.getChild(i) }
}

class CharacterLiteralImpl extends Expr, TCharacterLiteral {
  private Ruby::Character g;

  CharacterLiteralImpl() { this = TCharacterLiteral(g) }

  final string getValue() { result = g.getValue() }

  final override string toString() { result = g.getValue() }
}

class HereDocImpl extends StringlikeLiteralImpl, THereDoc {
  private Ruby::HeredocBeginning g;

  HereDocImpl() { this = THereDoc(g) }

  final override StringComponent getComponentImpl(int n) {
    toGenerated(result) = getHereDocBody(g).getChild(n)
  }

  final override string toString() { result = g.getValue() }
}
