/**
 * This file contains the range-analysis specific parts of the `cpp/invalid-pointer-deref`
 * and `cpp/overrun-write` query.
 */

private import cpp
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
private import semmle.code.cpp.ir.IR

pragma[nomagic]
private Instruction getABoundIn(SemBound b, IRFunction func) {
  getSemanticExpr(result) = b.getExpr(0) and
  result.getEnclosingIRFunction() = func
}

/**
 * Holds if `i <= b + delta`.
 */
pragma[inline]
private predicate boundedImplCand(Instruction i, Instruction b, int delta) {
  exists(SemBound bound, IRFunction func |
    semBounded(getSemanticExpr(i), bound, delta, true, _) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
}

/**
 * Holds if `i <= b + delta` and `delta` is the smallest integer that satisfies
 * this condition.
 */
pragma[inline]
private predicate boundedImpl(Instruction i, Instruction b, int delta) {
  delta = min(int cand | boundedImplCand(i, b, cand))
}

/**
 * Holds if `i <= b + delta`.
 *
 * This predicate enforces a join-order that ensures that `i` has already been bound.
 */
bindingset[i]
pragma[inline_late]
predicate bounded1(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

/**
 * Holds if `i <= b + delta`.
 *
 * This predicate enforces a join-order that ensures that `b` has already been bound.
 */
bindingset[b]
pragma[inline_late]
predicate bounded2(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

/** Holds if `i <= b + delta`. */
predicate bounded = boundedImpl/3;
