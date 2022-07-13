/**
 * C++-specific implementation of modulus analysis.
 */
module Private {
  private import experimental.semmle.code.cpp.semantic.Semantic

  predicate ignoreExprModulus(SemExpr e) { none() }
}
