/**
 * C++-specific implementation of range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisStage
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.FloatDelta
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.IntDelta
private import RangeAnalysisImpl
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

module CppLangImplRelative implements LangSig<FloatDelta> {
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
  predicate ignoreExprBound(SemExpr e) {
    exists(boolean upper, float delta, ConstantBounds::SemZeroBound b, float lb, float ub |
      ConstantStage::semBounded(e, b, delta, upper, _) and
      typeBounds(e.getSemType(), lb, ub) and
      (
        upper = false and
        delta < lb
        or
        upper = true and
        delta > ub
      )
    )
  }

  private predicate typeBounds(SemType t, float lb, float ub) {
    exists(SemIntegerType integralType, float limit |
      integralType = t and limit = 2.pow(8 * integralType.getByteSize())
    |
      if integralType instanceof SemBooleanType
      then lb = 0 and ub = 1
      else
        if integralType.isSigned()
        then (
          lb = -(limit / 2) and ub = (limit / 2) - 1
        ) else (
          lb = 0 and ub = limit - 1
        )
    )
    or
    // This covers all floating point types. The range is (-Inf, +Inf).
    t instanceof SemFloatingPointType and lb = -(1.0 / 0.0) and ub = 1.0 / 0.0
  }

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
  SemExpr specificSsaRead(SemSsaVariable v, float delta) { none() }

  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(SemExpr e, float bound, boolean upper) { none() }

  /**
   * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
   */
  predicate hasBound(SemExpr e, SemExpr bound, float delta, boolean upper) { none() }

  /**
   * Holds if the value of `dest` is known to be `src + delta`.
   */
  predicate additionalValueFlowStep(SemExpr dest, SemExpr src, float delta) { none() }

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
}
