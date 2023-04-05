/**
 * C++-specific implementation of modulus analysis.
 */
module Private {
  private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic

  predicate ignoreExprModulus(SemExpr e) { none() }
}
