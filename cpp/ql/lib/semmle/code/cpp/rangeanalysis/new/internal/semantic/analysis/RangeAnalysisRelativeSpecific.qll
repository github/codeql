/**
 * C++-specific implementation of range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisImpl
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
private import codeql.rangeanalysis.RangeAnalysis

module CppLangImplRelative implements LangSig<Sem> {
  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(SemExpr e) {
    exists(
      boolean upper, QlBuiltins::BigInt delta, ConstantBounds::SemZeroBound b, float lb, float ub
    |
      ConstantStage::semBounded(e, b, delta, upper, _) and
      typeBounds(e.getSemType(), lb, ub) and
      (
        upper = false and
        delta < lb.toString().toBigInt()
        or
        upper = true and
        delta > ub.toString().toBigInt()
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
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(SemExpr e, QlBuiltins::BigInt bound, boolean upper) { none() }

  /**
   * Holds if `e2 >= e1 + delta` (if `upper = false`) or `e2 <= e1 + delta` (if `upper = true`).
   */
  predicate additionalBoundFlowStep(SemExpr e2, SemExpr e1, QlBuiltins::BigInt delta, boolean upper) {
    none()
  }

  predicate includeConstantBounds() { none() }

  predicate includeRelativeBounds() { any() }
}
