private import cpp
private import semmle.code.cpp.ir.dataflow.internal.ProductFlow
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.ir.IR
private import codeql.util.Unit

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
    semBounded(getSemanticExpr(i), bound, delta, true, _) and
    b = getABoundIn(bound, func) and
    i.getEnclosingIRFunction() = func
  )
}

bindingset[i]
pragma[inline_late]
predicate bounded1(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

bindingset[b]
pragma[inline_late]
predicate bounded2(Instruction i, Instruction b, int delta) { boundedImpl(i, b, delta) }

predicate bounded = boundedImpl/3;
