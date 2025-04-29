private import AstImport
private import codeql.util.Boolean

private newtype TConstantValue =
  TConstInteger(int value) {
    exists(Raw::ConstExpr ce | ce.getType() = "Int32" and ce.getValue().getValue().toInt() = value)
    or
    value = [0 .. 10] // needed for `trackKnownValue` in `DataFlowPrivate`
  } or
  TConstDouble(float double) {
    exists(Raw::ConstExpr ce |
      ce.getType() = "Double" and ce.getValue().getValue().toFloat() = double
    )
  } or
  TConstString(string value) { exists(Raw::StringLiteral sl | sl.getValue() = value) } or
  TConstBoolean(Boolean b) or
  TNull()

/** A constant value. */
class ConstantValue extends TConstantValue {
  /** Gets a string representation of this value. */
  final string toString() { result = this.getValue() }

  /** Gets the value of this consant. */
  string getValue() { none() }

  bindingset[s]
  pragma[inline_late]
  final predicate stringMatches(string s) { this.asString().toLowerCase() = s.toLowerCase() }

  /** Gets the integer value of this constant, if any. */
  int asInt() { none() }

  /** Gets the floating point value of this constant, if any. */
  float asDouble() { none() }

  /** Gets the string value of this constant, if any. */
  string asString() { none() }

  /** Gets the boolean value of this constant, if any. */
  boolean asBoolean() { none() }

  /** Holds if this constant represents the null value. */
  predicate isNull() { none() }

  /** Gets a (unique) serialized version of this value. */
  string serialize() { none() }

  /** Gets an exprssion that has this value. */
  Expr getAnExpr() { none() }
}

/** A constant integer value */
class ConstInteger extends ConstantValue, TConstInteger {
  final override int asInt() { this = TConstInteger(result) }

  final override string getValue() { result = this.asInt().toString() }

  final override string serialize() { result = this.getValue() }

  final override ConstExpr getAnExpr() { result.getValueString() = this.getValue() }
}

/** A constant floating point value. */
class ConstDouble extends ConstantValue, TConstDouble {
  final override float asDouble() { this = TConstDouble(result) }

  final override string getValue() { result = this.asDouble().toString() }

  final override string serialize() {
    exists(string res | res = this.asDouble().toString() |
      if exists(res.indexOf(".")) then result = res else result = res + ".0"
    )
  }

  final override ConstExpr getAnExpr() {
    exists(Raw::ConstExpr ce |
      ce.getValue().getValue() = this.getValue() and
      result = fromRaw(ce)
    )
  }
}

/** A constant string value. */
class ConstString extends ConstantValue, TConstString {
  final override string asString() { this = TConstString(result) }

  final override string getValue() { result = this.asString() }

  final override string serialize() {
    result = "\"" + this.asString().replaceAll("\"", "\\\"") + "\""
  }

  final override StringConstExpr getAnExpr() { result.getValueString() = this.getValue() }
}

/** A constant boolean value. */
class ConstBoolean extends ConstantValue, TConstBoolean {
  final override boolean asBoolean() { this = TConstBoolean(result) }

  final override string getValue() { result = this.asBoolean().toString() }

  final override string serialize() { result = this.getValue() }

  final override BoolLiteral getAnExpr() { result.getBoolValue() = this.asBoolean() }
}

/** The constant null value. */
class NullConst extends ConstantValue, TNull {
  final override predicate isNull() { any() }

  final override string getValue() { result = "null" }

  final override string serialize() { result = this.getValue() }

  final override NullLiteral getAnExpr() { any() }
}
