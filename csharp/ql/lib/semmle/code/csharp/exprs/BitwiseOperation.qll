/**
 * Provides all bitwise operation classes.
 *
 * All bitwise operations have the common base class `BitwiseOperation`.
 */

import Expr

/**
 * A bitwise operation. Either a unary bitwise operation (`UnaryBitwiseOperation`)
 * or a binary bitwise operation (`BinaryBitwiseOperation`).
 */
class BitwiseOperation extends Operation, @bit_operation { }

/**
 * A unary bitwise operation, that is, a bitwise complement operation
 * (`ComplementExpr`).
 */
class UnaryBitwiseOperation extends BitwiseOperation, UnaryOperation, @un_bit_operation { }

/**
 * A bitwise complement expression, for example `~x`.
 */
class ComplementExpr extends UnaryBitwiseOperation, @bit_not_expr {
  override string getOperator() { result = "~" }

  override string getAPrimaryQlClass() { result = "ComplementExpr" }
}

/**
 * A binary bitwise operation. Either a binary bitwise expression (`BinaryBitwiseExpr`) or
 * a bitwise assignment expression (`AssignBitwiseExpr`).
 */
class BinaryBitwiseOperation extends BitwiseOperation, BinaryOperation, @bin_bit_operation {
  override string getOperator() { none() }
}

/**
 * A binary bitwise expression. Either a bitwise-and expression
 * (`BitwiseAndExpr`), a bitwise-or expression (`BitwiseOrExpr`),
 * a bitwise exclusive-or expression (`BitwiseXorExpr`), a left-shift
 * expression (`LeftShiftExpr`), a right-shift expression (`RightShiftExpr`),
 * or an unsigned right-shift expression (`UnsignedRightShiftExpr`).
 */
class BinaryBitwiseExpr extends BinaryBitwiseOperation, @bin_bit_expr { }

/**
 * A left-shift expression, for example `x << y`.
 */
class LeftShiftExpr extends BinaryBitwiseExpr, LeftShiftOperation, @lshift_expr {
  override string getOperator() { result = "<<" }

  override string getAPrimaryQlClass() { result = "LeftShiftExpr" }
}

/**
 * A right-shift expression, for example `x >> y`.
 */
class RightShiftExpr extends BinaryBitwiseExpr, RightShiftOperation, @rshift_expr {
  override string getOperator() { result = ">>" }

  override string getAPrimaryQlClass() { result = "RightShiftExpr" }
}

/**
 * An unsigned right-shift expression, for example `x >>> y`.
 */
class UnsignedRightShiftExpr extends BinaryBitwiseExpr, UnsignedRightShiftOperation, @urshift_expr {
  override string getOperator() { result = ">>>" }

  override string getAPrimaryQlClass() { result = "UnsignedRightShiftExpr" }
}

/**
 * A bitwise-and expression, for example `x & y`.
 */
class BitwiseAndExpr extends BinaryBitwiseExpr, BitwiseAndOperation, @bit_and_expr {
  override string getOperator() { result = "&" }

  override string getAPrimaryQlClass() { result = "BitwiseAndExpr" }
}

/**
 * A bitwise-or expression, for example `x | y`.
 */
class BitwiseOrExpr extends BinaryBitwiseExpr, BitwiseOrOperation, @bit_or_expr {
  override string getOperator() { result = "|" }

  override string getAPrimaryQlClass() { result = "BitwiseOrExpr" }
}

/**
 * A bitwise exclusive-or expression, for example `x ^ y`.
 */
class BitwiseXorExpr extends BinaryBitwiseExpr, BitwiseXorOperation, @bit_xor_expr {
  override string getOperator() { result = "^" }

  override string getAPrimaryQlClass() { result = "BitwiseXorExpr" }
}
