/**
 * Provides classes for operations that also have compound assignment forms.
 */

import Expr

/**
 * An addition operation, either `x + y` or `x += y`.
 */
class AddOperation extends BinaryOperation, @add_operation { }

/**
 * A subtraction operation, either `x - y` or `x -= y`.
 */
class SubOperation extends BinaryOperation, @sub_operation { }

/**
 * A multiplication operation, either `x * y` or `x *= y`.
 */
class MulOperation extends BinaryOperation, @mul_operation { }

/**
 * A division operation, either `x / y` or `x /= y`.
 */
class DivOperation extends BinaryOperation, @div_operation {
  /** Gets the numerator of this division operation. */
  Expr getNumerator() { result = this.getLeftOperand() }

  /** Gets the denominator of this division operation. */
  Expr getDenominator() { result = this.getRightOperand() }
}

/**
 * A remainder operation, either `x % y` or `x %= y`.
 */
class RemOperation extends BinaryOperation, @rem_operation { }

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
