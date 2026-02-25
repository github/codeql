overlay[local]
module;

private import minimal.minimal
private import codeql.util.Boolean

private newtype TConstant =
  TInt(int n) {
    n = [0 .. 10] or
    n = any(Expr e).getIntValue() or
    n = any(Parameter p).getIndex() or
    exists(any(InvokeExpr e).getArgument(n))
  } or
  TString(string s) { s = any(Expr e).getStringValue() } or
  TBoolean(Boolean b) or
  TNull() or
  TUndefined()

class Constant extends TConstant {
  int asInt() { this = TInt(result) }

  string asString() { this = TString(result) }

  boolean asBoolean() { this = TBoolean(result) }

  predicate isNull() { this = TNull() }

  predicate isUndefined() { this = TUndefined() }

  string toString() {
    result = this.asInt().toString()
    or
    result = "\"" + this.asString() + "\""
    or
    result = this.asBoolean().toString()
    or
    this.isNull() and result = "null"
    or
    this.isUndefined() and result = "undefined"
  }

  int asArrayIndex() { result = this.asInt() and result >= 0 }

  string getAsOperand() {
    result = this.asInt().toString()
    or
    result = "\"" + this.asString() + "\""
  }
}

module Constant {
  Constant fromInt(int n) { result = TInt(n) }

  Constant fromString(string s) { result = TString(s) }

  Constant fromBoolean(boolean b) { result = TBoolean(b) }

  Constant null() { result = TNull() }

  Constant undefined() { result = TUndefined() }
}
