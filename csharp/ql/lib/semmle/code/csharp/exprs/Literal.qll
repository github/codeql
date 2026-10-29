/**
 * Provides all literal classes.
 *
 * All literals have the common base class `Literal`.
 */

import Expr

/**
 * A literal. Either a Boolean literal (`BoolLiteral`), a Unicode character
 * literal (`CharLiteral`), an integer literal (`IntegerLiteral`), a floating
 * point literal (`RealLiteral`), a `string` literal (`StringLiteral`), or a
 * `null` literal (`NullLiteral`).
 */
class Literal extends Expr, @literal_expr {
  override string toString() { result = this.getValue() }
}

/**
 * A Boolean literal, for example `true`.
 */
class BoolLiteral extends Literal, @bool_literal_expr {
  /** Gets the value of this Boolean literal. */
  boolean getBoolValue() {
    this.getValue() = "true" and result = true
    or
    this.getValue() = "false" and result = false
  }

  override string getAPrimaryQlClass() { result = "BoolLiteral" }
}

/**
 * A Unicode character literal, for example `'a'`.
 */
class CharLiteral extends Literal, @char_literal_expr {
  override string getAPrimaryQlClass() { result = "CharLiteral" }
}

/**
 * An integer literal. Either an `int` literal (`IntLiteral`), a `long`
 * literal (`LongLiteral`), a `uint` literal (`UIntLiteral`), or a `ulong`
 * literal (`ULongLiteral`).
 */
class IntegerLiteral extends Literal, @integer_literal_expr { }

/**
 * An `int` literal, for example `0`.
 */
class IntLiteral extends IntegerLiteral, @int_literal_expr {
  override string getAPrimaryQlClass() { result = "IntLiteral" }
}

/**
 * A `long` literal, for example `-5L`.
 */
class LongLiteral extends IntegerLiteral, @long_literal_expr {
  override string getAPrimaryQlClass() { result = "LongLiteral" }
}

/**
 * A `uint` literal, for example `5U`.
 */
class UIntLiteral extends IntegerLiteral, @uint_literal_expr {
  override string getAPrimaryQlClass() { result = "UIntLiteral" }
}

/**
 * A `ulong` literal, for example `5UL`.
 */
class ULongLiteral extends IntegerLiteral, @ulong_literal_expr {
  override string getAPrimaryQlClass() { result = "ULongLiteral" }
}

/**
 * A floating point literal. Either a `float` literal (`FloatLiteral`), a
 * `double` literal (`DoubleLiteral`), or a `decimal` literal
 * (`DecimalLiteral`).
 */
class RealLiteral extends Literal, @real_literal_expr { }

/**
 * A `float` literal, for example `5F`.
 */
class FloatLiteral extends RealLiteral, @float_literal_expr {
  override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

/**
 * A `double` literal, for example `5D`.
 */
class DoubleLiteral extends RealLiteral, @double_literal_expr {
  override string getAPrimaryQlClass() { result = "DoubleLiteral" }
}

/**
 * A `decimal` literal, for example `5m`.
 */
class DecimalLiteral extends RealLiteral, @decimal_literal_expr {
  override string getAPrimaryQlClass() { result = "DecimalLiteral" }
}

/**
 * A `string` literal. Either a `string` literal (`StringLiteralUtf16`),
 * or a `u8` literal (`StringLiteralUtf8`).
 */
class StringLiteral extends Literal, @string_literal_expr {
  override string toString() { result = "\"" + this.getValue().replaceAll("\"", "\\\"") + "\"" }

  override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/**
 * A `string` literal, for example `"Hello, World!"`.
 */
class StringLiteralUtf16 extends StringLiteral, @utf16_string_literal_expr {
  override string getAPrimaryQlClass() { result = "StringLiteralUtf16" }
}

/**
 * A `u8` literal, for example `"AUTH"u8`
 */
class StringLiteralUtf8 extends StringLiteral, @utf8_string_literal_expr {
  override string getAPrimaryQlClass() { result = "StringLiteralUtf8" }
}

/**
 * A `null` literal.
 */
class NullLiteral extends Literal, @null_literal_expr {
  override string getAPrimaryQlClass() { result = "NullLiteral" }
}
