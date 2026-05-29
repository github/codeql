/**
 * Provides classes for operations that also have compound assignment forms.
 */

import Expr

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
