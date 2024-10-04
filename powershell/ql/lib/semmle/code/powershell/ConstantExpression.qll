import powershell

class ConstExpr extends @constant_expression, BaseConstExpr {
  override SourceLocation getLocation() { constant_expression_location(this, result) }

  string getType() { constant_expression(this, result) }

  StringLiteral getValue() { constant_expression_value(this, result) }

  override string toString() { result = this.getValue().toString() }
}

private newtype TConstantValue =
  TConstInteger(int value) {
    exists(ConstExpr ce | ce.getType() = "Int32" and ce.getValue().getValue().toInt() = value)
  } or
  TConstDouble(float double) {
    exists(ConstExpr ce | ce.getType() = "Double" and ce.getValue().getValue().toFloat() = double)
  } or
  TConstString(string value) { exists(StringLiteral sl | sl.getValue() = value) } or
  TConstBoolean(boolean value) {
    exists(VarAccess va |
      value = true and
      va.getUserPath() = "true"
      or
      value = false and
      va.getUserPath() = "false"
    )
  } or
  TNull()

/** A constant value. */
class ConstantValue extends TConstantValue {
  /** Gets a string representation of this value. */
  final string toString() { result = this.getValue() }

  /** Gets the value of this consant. */
  string getValue() { none() }

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

  final override ConstExpr getAnExpr() { result.getValue().getValue() = this.getValue() }
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

  final override ConstExpr getAnExpr() { result.getValue().getValue() = this.getValue() }
}

/** A constant string value. */
class ConstString extends ConstantValue, TConstString {
  final override string asString() { this = TConstString(result) }

  final override string getValue() { result = this.asString() }

  final override string serialize() {
    result = "\"" + this.asString().replaceAll("\"", "\\\"") + "\""
  }

  final override ConstExpr getAnExpr() { result.getValue().getValue() = this.getValue() }
}

/** A constant boolean value. */
class ConstBoolean extends ConstantValue, TConstBoolean {
  final override boolean asBoolean() { this = TConstBoolean(result) }

  final override string getValue() { result = this.asBoolean().toString() }

  final override string serialize() { result = this.getValue() }

  final override VarAccess getAnExpr() {
    this.asBoolean() = true and
    result.getUserPath() = "true"
    or
    this.asBoolean() = false and
    result.getUserPath() = "false"
  }
}

/** The constant null value. */
class NullConst extends ConstantValue, TNull {
  final override predicate isNull() { any() }

  final override string getValue() { result = "null" }

  final override string serialize() { result = this.getValue() }

  final override VarAccess getAnExpr() { result.getUserPath() = "null" }
}
