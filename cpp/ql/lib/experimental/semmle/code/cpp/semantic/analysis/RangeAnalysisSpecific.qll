/**
 * C++-specific implementation of range analysis.
 */

private import experimental.semmle.code.cpp.semantic.Semantic

/**
 * Holds if the specified expression should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we have the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadCopy(SemExpr e) { none() }

/**
 * Ignore the bound on this expression.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we have the new implementation matching the old results exactly.
 */
predicate ignoreExprBound(SemExpr e) { none() }

/**
 * Ignore any inferred zero lower bound on this expression.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we have the new implementation matching the old results exactly.
 */
predicate ignoreZeroLowerBound(SemExpr e) { none() }

/**
 * Holds if the specified expression should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we have the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadArithmeticExpr(SemExpr e) { none() }

/**
 * Holds if the specified variable should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we have the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadAssignment(SemSsaVariable v) { none() }

/**
 * Adds additional results to `ssaRead()` that are specific to Java.
 *
 * This predicate handles propagation of offsets for post-increment and post-decrement expressions
 * in exactly the same way as the old Java implementation. Once the new implementation matches the
 * old one, we should remove this predicate and propagate deltas for all similar patterns, whether
 * or not they come from a post-increment/decrement expression.
 */
SemExpr specificSsaRead(SemSsaVariable v, int delta) { none() }

/**
 * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
 */
predicate hasConstantBound(SemExpr e, int bound, boolean upper) { none() }

/**
 * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
 */
predicate hasBound(SemExpr e, SemExpr bound, int delta, boolean upper) { none() }

/**
 * Holds if the value of `dest` is known to be `src + delta`.
 */
predicate additionalValueFlowStep(SemExpr dest, SemExpr src, int delta) { none() }

/**
 * Gets the type that range analysis should use to track the result of the specified expression,
 * if a type other than the original type of the expression is to be used.
 *
 * This predicate is commonly used in languages that support immutable "boxed" types that are
 * actually references but whose values can be tracked as the type contained in the box.
 */
SemType getAlternateType(SemExpr e) { none() }

/**
 * Gets the type that range analysis should use to track the result of the specified source
 * variable, if a type other than the original type of the expression is to be used.
 *
 * This predicate is commonly used in languages that support immutable "boxed" types that are
 * actually references but whose values can be tracked as the type contained in the box.
 */
SemType getAlternateTypeForSsaVariable(SemSsaVariable var) { none() }
