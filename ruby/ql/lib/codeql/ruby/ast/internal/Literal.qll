private import codeql.ruby.AST
private import AST
private import Constant
private import TreeSitter
private import codeql.ruby.controlflow.CfgNodes

int parseInteger(Ruby::Integer i) {
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

abstract class IntegerLiteralImpl extends Expr, TIntegerLiteral {
  abstract int getValueImpl();
}

class IntegerLiteralReal extends IntegerLiteralImpl, TIntegerLiteralReal {
  private Ruby::Integer g;

  IntegerLiteralReal() { this = TIntegerLiteralReal(g) }

  final override int getValueImpl() { result = parseInteger(g) }

  final override string toString() { result = g.getValue() }
}

class IntegerLiteralSynth extends IntegerLiteralImpl, TIntegerLiteralSynth {
  private int value;

  IntegerLiteralSynth() { this = TIntegerLiteralSynth(_, _, value) }

  final override int getValueImpl() { result = value }

  final override string toString() { result = value.toString() }
}

// TODO: implement properly
float parseFloat(Ruby::Float f) { result = f.getValue().toFloat() }

private class RequiredFloatConstantValue extends RequiredConstantValue {
  override predicate requiredFloat(float f) { f = parseFloat(_) }
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

private class RequiredRationalConstantValue extends RequiredConstantValue {
  override predicate requiredRational(int numerator, int denominator) {
    isRationalValue(_, numerator, denominator)
  }
}

float getComplexValue(Ruby::Complex c) {
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

class TrueLiteral extends BooleanLiteral, TTrueLiteral {
  private Ruby::True g;

  TrueLiteral() { this = TTrueLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override predicate isTrue() { any() }
}

class FalseLiteral extends BooleanLiteral, TFalseLiteral {
  private Ruby::False g;

  FalseLiteral() { this = TFalseLiteral(g) }

  final override string toString() { result = g.getValue() }

  final override predicate isFalse() { any() }
}

private class RequiredEncodingLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = "UTF-8" }
}

private class RequiredLineLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredInt(int i) { i = any(LineLiteral ll).getLocation().getStartLine() }
}

private class RequiredFileLiteralConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(FileLiteral fl).getLocation().getFile().getAbsolutePath()
  }
}

private class RequiredStringTextComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(Ruby::Token t | exists(TStringTextComponentNonRegexp(t))).getValue()
  }
}

private class RequiredStringEscapeSequenceComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) {
    s = any(Ruby::Token t | exists(TStringEscapeSequenceComponentNonRegexp(t))).getValue()
  }
}

class TRegExpComponent =
  TStringTextComponentRegexp or TStringEscapeSequenceComponentRegexp or
      TStringInterpolationComponentRegexp;

// Exclude components that are children of a free-spacing regex.
// We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
string getRegExpTextComponentValue(RegExpTextComponent c) {
  exists(Ruby::Token t |
    c = TStringTextComponentRegexp(t) and
    not c.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = t.getValue()
  )
}

private class RequiredRegExpTextComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getRegExpTextComponentValue(_) }
}

// Exclude components that are children of a free-spacing regex.
// We do this because `ParseRegExp.qll` cannot handle free-spacing regexes.
string getRegExpEscapeSequenceComponentValue(RegExpEscapeSequenceComponent c) {
  exists(Ruby::EscapeSequence e |
    c = TStringEscapeSequenceComponentRegexp(e) and
    not c.getParent().(RegExpLiteral).hasFreeSpacingFlag() and
    result = e.getValue()
  )
}

private class RequiredRegExpEscapeSequenceComponentConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getRegExpEscapeSequenceComponentValue(_) }
}

class RegularStringLiteral extends StringLiteral, TRegularStringLiteral {
  private Ruby::String g;

  RegularStringLiteral() { this = TRegularStringLiteral(g) }

  final override StringComponent getComponent(int n) { toGenerated(result) = g.getChild(n) }
}

class BareStringLiteral extends StringLiteral, TBareStringLiteral {
  private Ruby::BareString g;

  BareStringLiteral() { this = TBareStringLiteral(g) }

  final override StringComponent getComponent(int n) { toGenerated(result) = g.getChild(n) }
}

// Tree-sitter gives us value text including the colon, which we skip.
string getSimpleSymbolValue(Ruby::SimpleSymbol ss) { result = ss.getValue().suffix(1) }

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

class ComplexSymbolLiteral extends SymbolLiteral, TComplexSymbolLiteral { }

class DelimitedSymbolLiteral extends ComplexSymbolLiteral, TDelimitedSymbolLiteral {
  private Ruby::DelimitedSymbol g;

  DelimitedSymbolLiteral() { this = TDelimitedSymbolLiteral(g) }

  final override StringComponent getComponent(int i) { toGenerated(result) = g.getChild(i) }
}

class BareSymbolLiteral extends ComplexSymbolLiteral, TBareSymbolLiteral {
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

private class RequiredCharacterConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = any(Ruby::Character c).getValue() }
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
}

class RangeLiteralReal extends RangeLiteral, TRangeLiteralReal {
  private Ruby::Range g;

  RangeLiteralReal() { this = TRangeLiteralReal(g) }

  final override Expr getBegin() { toGenerated(result) = g.getBegin() }

  final override Expr getEnd() { toGenerated(result) = g.getEnd() }

  final override predicate isInclusive() { g instanceof @ruby_range_dotdot }

  final override predicate isExclusive() { g instanceof @ruby_range_dotdotdot }
}

class RangeLiteralSynth extends RangeLiteral, TRangeLiteralSynth {
  private boolean inclusive;

  RangeLiteralSynth() { this = TRangeLiteralSynth(_, _, inclusive) }

  final override Expr getBegin() { result = TIntegerLiteralSynth(this, 0, _) }

  final override Expr getEnd() { result = TIntegerLiteralSynth(this, 1, _) }

  final override predicate isInclusive() { inclusive = true }

  final override predicate isExclusive() { inclusive = false }
}

private string getMethodName(MethodName::Token t) {
  result = t.(Ruby::Token).getValue()
  or
  result = t.(Ruby::Setter).getName().getValue() + "="
}

private class RequiredMethodNameConstantValue extends RequiredConstantValue {
  override predicate requiredString(string s) { s = getMethodName(_) }
}

class TokenMethodName extends MethodName, TTokenMethodName {
  private MethodName::Token g;

  TokenMethodName() { this = TTokenMethodName(g) }

  final override ConstantValue::ConstantStringValue getConstantValue() {
    result.isString(getMethodName(g))
  }

  final override string toString() { result = getMethodName(g) }
}
