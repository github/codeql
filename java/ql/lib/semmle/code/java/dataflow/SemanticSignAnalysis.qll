/**
 * Semantic wrapper around shared sign analysis.
 */

private import SignAnalysis as SignAnalysis
private import semmle.code.java.semantic.SemanticExpr

predicate anySign = SignAnalysis::anySign/1;

/** Holds if `e` can be positive and cannot be negative. */
predicate positive(SemExpr e) { SignAnalysis::positive(getJavaExpr(e)) }

/** Holds if `e` can be negative and cannot be positive. */
predicate negative(SemExpr e) { SignAnalysis::negative(getJavaExpr(e)) }

/** Holds if `e` is strictly positive. */
predicate strictlyPositive(SemExpr e) { SignAnalysis::strictlyPositive(getJavaExpr(e)) }

/** Holds if `e` is strictly negative. */
predicate strictlyNegative(SemExpr e) { SignAnalysis::strictlyNegative(getJavaExpr(e)) }
