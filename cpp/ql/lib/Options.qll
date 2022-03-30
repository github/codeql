/**
 * Provides custom predicates that specify information about
 * the behavior of the program being analyzed.
 *
 * By default they fall back to the reasonable defaults provided in
 * `DefaultOptions.qll`, but by modifying this file, you can customize
 * the standard analyses to give better results for your project.
 */

import cpp

/**
 * Customizable predicates that specify information about
 * the behavior of the program being analyzed.
 */
class CustomOptions extends Options {
  /**
   * Holds if we wish to override the "may return NULL" inference for this
   * call. If this holds, then rather than trying to infer whether this
   * call might return NULL, we will instead test whether `returnsNull`
   * holds for it.
   *
   * By default, this handles the `Xstrdup` function used by the CVS
   * project.
   */
  override predicate overrideReturnsNull(Call call) { Options.super.overrideReturnsNull(call) }

  /**
   * Holds if this call may return NULL. This is only used if
   * `overrideReturnsNull` holds for the call.
   *
   * By default, this handles the `Xstrdup` function used by the CVS
   * project.
   */
  override predicate returnsNull(Call call) { Options.super.returnsNull(call) }

  /**
   * Holds if a call to this function will never return.
   *
   * By default, this holds for `exit`, `_exit`, `abort`, `__assert_fail`,
   * `longjmp`, `error`, `__builtin_unreachable` and any function with a
   * `noreturn` attribute or specifier.
   */
  override predicate exits(Function f) { Options.super.exits(f) }

  /**
   * Holds if evaluating expression `e` will never return, or can be assumed
   * to never return.  For example:
   * ```
   *   __assume(0);
   * ```
   * (note that in this case if the hint is wrong and the expression is reached at
   * runtime, the program's behavior is undefined)
   */
  override predicate exprExits(Expr e) { Options.super.exprExits(e) }

  /**
   * Holds if function `f` should always have its return value checked.
   *
   * By default holds only for `fgets`.
   */
  override predicate alwaysCheckReturnValue(Function f) { Options.super.alwaysCheckReturnValue(f) }

  /**
   * Holds if it is reasonable to ignore the return value of function
   * call `fc`.
   *
   * By default holds for calls to `select` where the first argument is
   * `0` (commonly used as a way of sleeping), and any call inside a
   * macro expansion.
   */
  override predicate okToIgnoreReturnValue(FunctionCall fc) {
    Options.super.okToIgnoreReturnValue(fc)
  }
}

/**
 * A type that acts as a mutex.
 */
class CustomMutexType extends MutexType {
  CustomMutexType() { none() }

  /**
   * Holds if `fc` is a call that always locks mutex `arg`
   * of this type.
   */
  override predicate mustlockAccess(FunctionCall fc, Expr arg) { none() }

  /**
   * Holds if `fc` is a call that tries to lock mutex `arg`
   * of this type, but may return without success.
   */
  override predicate trylockAccess(FunctionCall fc, Expr arg) { none() }

  /**
   * Holds if `fc` is a call that unlocks mutex `arg`
   * of this type.
   */
  override predicate unlockAccess(FunctionCall fc, Expr arg) { none() }
}

/**
 * DEPRECATED: customize `CustomOptions.overrideReturnsNull` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate overrideReturnsNull(Call call) { none() }

/**
 * DEPRECATED: customize `CustomOptions.returnsNull` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate returnsNull(Call call) { none() }

/**
 * DEPRECATED: customize `CustomOptions.exits` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate exits(Function f) { none() }

/**
 * DEPRECATED: customize `CustomOptions.exprExits` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate exprExits(Expr e) { none() }

/**
 * DEPRECATED: customize `CustomOptions.alwaysCheckReturnValue` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate alwaysCheckReturnValue(Function f) { none() }

/**
 * DEPRECATED: customize `CustomOptions.okToIgnoreReturnValue` instead.
 *
 * This predicate is required to support backwards compatibility for
 * older `Options.qll` files.  It should not be removed or modified by
 * end users.
 */
predicate okToIgnoreReturnValue(FunctionCall fc) { none() }
