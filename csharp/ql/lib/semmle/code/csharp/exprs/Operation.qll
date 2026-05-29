/**
 * Provides classes for operations that also have compound assignment forms.
 */

import Expr

/**
 * A null-coalescing operation, either `x ?? y` or `x ??= y`.
 */
class NullCoalescingOperation extends BinaryLogicalOperation, @null_coalescing_operation { }
