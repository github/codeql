/**
 * This file contains the range-analysis specific parts of the `cpp/invalid-pointer-deref`
 * and `cpp/overrun-write` query.
 */

private import cpp
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.Bound
private import semmle.code.cpp.ir.ValueNumbering

/** Holds if `i < vn + delta` */
predicate boundedByValueNumber(Instruction i, ValueNumber vn, int delta) {
  exists(ValueNumberBound b |
    b.getValueNumber() = vn and
    delta = min(float cand | semBounded(getSemanticExpr(i), b, cand, true, _)) and
    semBounded(getSemanticExpr(i), b, delta, true, _)
  )
}