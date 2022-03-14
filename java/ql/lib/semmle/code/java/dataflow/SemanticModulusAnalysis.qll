/**
 * Semantic wrapper around shared modulus analysis.
 */

private import ModulusAnalysis as ModulusAnalysis
private import semmle.code.java.semantic.SemanticExpr
private import SemanticBound

cached
predicate exprModulus(SemExpr e, SemBound b, int val, int mod) {
  ModulusAnalysis::exprModulus(getJavaExpr(e), getLanguageBound(b), val, mod)
}
