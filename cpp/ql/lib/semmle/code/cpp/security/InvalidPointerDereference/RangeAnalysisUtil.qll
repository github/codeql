/**
 * This file contains the range-analysis specific parts of the `cpp/invalid-pointer-deref` query
 * that is used by both `AllocationToInvalidPointer.qll` and `InvalidPointerToDereference.qll`.
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
private predicate boundedImpl(Instruction i, Instruction b, int delta) {
  exists(SemBound bound, IRFunction func |
    semBounded(getSemanticExpr(i), bound, delta, true,
      any(SemReason reason | not reason instanceof SemTypeReason)) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
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
