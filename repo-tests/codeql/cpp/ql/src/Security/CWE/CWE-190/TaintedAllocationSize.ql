/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision medium
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-789
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

/**
 * Holds if `alloc` is an allocation, and `tainted` is a child of it that is a
 * taint sink.
 */
predicate allocSink(Expr alloc, Expr tainted) {
  isAllocationExpr(alloc) and
  tainted = alloc.getAChild() and
  tainted.getUnspecifiedType() instanceof IntegralType
}

class TaintedAllocationSizeConfiguration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) { allocSink(_, tainted) }

  override predicate isBarrier(Expr e) {
    super.isBarrier(e)
    or
    // There can be two separate reasons for `convertedExprMightOverflow` not holding:
    // 1. `e` really cannot overflow.
    // 2. `e` isn't analyzable.
    // If we didn't rule out case 2 we would place barriers on anything that isn't analyzable.
    (
      e instanceof UnaryArithmeticOperation or
      e instanceof BinaryArithmeticOperation or
      e instanceof AssignArithmeticOperation
    ) and
    not convertedExprMightOverflow(e)
    or
    // Subtracting two pointers is either well-defined (and the result will likely be small), or
    // terribly undefined and dangerous. Here, we assume that the programmer has ensured that the
    // result is well-defined (i.e., the two pointers point to the same object), and thus the result
    // will likely be small.
    e = any(PointerDiffExpr diff).getAnOperand()
  }
}

predicate taintedAllocSize(
  Expr source, Expr alloc, PathNode sourceNode, PathNode sinkNode, string taintCause
) {
  isUserInput(source, taintCause) and
  exists(Expr tainted |
    allocSink(alloc, tainted) and
    taintedWithPath(source, tainted, sourceNode, sinkNode)
  )
}

from Expr source, Expr alloc, PathNode sourceNode, PathNode sinkNode, string taintCause
where taintedAllocSize(source, alloc, sourceNode, sinkNode, taintCause)
select alloc, sourceNode, sinkNode, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
