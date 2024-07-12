/**
 * C++-specific implementation of range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisImpl
private import codeql.rangeanalysis.RangeAnalysis

module CppLangImplConstant implements LangSig<Sem> {
  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(SemExpr e) { none() }

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

  predicate includeConstantBounds() { any() }

  predicate includeRelativeBounds() { none() }
}
