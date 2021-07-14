/**
 * Provides all literal classes.
 *
 * All literals have the common base class `Literal`.
 */

import Expr
private import dotnet

/**
 * A literal. Either a Boolean literal (`BoolLiteral`), a Unicode character
 * literal (`CharLiteral`), an integer literal (`IntegerLiteral`), a floating
 * point literal (`RealLiteral`), a `string` literal (`StringLiteral`), or a
 * `null` literal (`NullLiteral`).
 */
class Literal extends DotNet::Literal, Expr, @literal_expr {
  override string toString() { result = this.getValue() }
}

/**
 * A Boolean literal, for example `true`.
 */
class BoolLiteral extends Literal, @bool_literal_expr {
  /** Gets the value of this Boolean literal. */
  boolean getBoolValue() {
    getValue() = "true" and result = true
    or
    getValue() = "false" and result = false
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
class IntegerLiteral extends DotNet::IntLiteral, Literal, @integer_literal_expr { }

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
 * A `string` literal, for example `"Hello, World!"`.
 */
class StringLiteral extends DotNet::StringLiteral, Literal, @string_literal_expr {
  override string toString() { result = "\"" + getValue().replaceAll("\"", "\\\"") + "\"" }

  override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/**
 * A `null` literal.
 */
class NullLiteral extends DotNet::NullLiteral, Literal, @null_literal_expr {
  override string getAPrimaryQlClass() { result = "NullLiteral" }
}
