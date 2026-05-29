/**
 * Provides classes for operations that also have compound assignment forms.
 */

import Expr

/**
 * A binary arithmetic operation. Either a binary arithmetic expression (`BinaryArithmeticExpr`) or
 * an arithmetic assignment operation (`AssignArithmeticExpr`).
 */
class BinaryArithmeticOperation extends ArithmeticOperation, BinaryOperation, @bin_arith_operation {
  override string getOperator() { none() }
}

/**
 * An addition operation, either `x + y` or `x += y`.
 */
class AddOperation extends BinaryArithmeticOperation, @add_operation { }

/**
 * A subtraction operation, either `x - y` or `x -= y`.
 */
class SubOperation extends BinaryArithmeticOperation, @sub_operation { }

/**
 * A multiplication operation, either `x * y` or `x *= y`.
 */
class MulOperation extends BinaryArithmeticOperation, @mul_operation { }

/**
 * A division operation, either `x / y` or `x /= y`.
 */
class DivOperation extends BinaryArithmeticOperation, @div_operation {
  /** Gets the numerator of this division operation. */
  Expr getNumerator() { result = this.getLeftOperand() }

  /** Gets the denominator of this division operation. */
  Expr getDenominator() { result = this.getRightOperand() }
}

/**
 * A remainder operation, either `x % y` or `x %= y`.
 */
class RemOperation extends BinaryArithmeticOperation, @rem_operation { }

/**
 * A bitwise-and operation, either `x & y` or `x &= y`.
 */
class BitwiseAndOperation extends BinaryOperation, @and_operation { }

/**
 * A bitwise-or operation, either `x | y` or `x |= y`.
 */
class BitwiseOrOperation extends BinaryOperation, @or_operation { }

/**
 * A bitwise exclusive-or operation, either `x ^ y` or `x ^= y`.
 */
class BitwiseXorOperation extends BinaryOperation, @xor_operation { }

/**
 * A left-shift operation, either `x << y` or `x <<= y`.
 */
class LeftShiftOperation extends BinaryOperation, @lshift_operation { }

/**
 * A right-shift operation, either `x >> y` or `x >>= y`.
 */
class RightShiftOperation extends BinaryOperation, @rshift_operation { }

/**
 * An unsigned right-shift operation, either `x >>> y` or `x >>>= y`.
 */
class UnsignedRightShiftOperation extends BinaryOperation, @urshift_operation { }

/**
 * A null-coalescing operation, either `x ?? y` or `x ??= y`.
 */
class NullCoalescingOperation extends BinaryOperation, @null_coalescing_operation { }
