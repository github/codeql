/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

predicate taintedChild(Expr e, Expr tainted) {
  (
    isAllocationExpr(e)
    or
    any(MulExpr me | me.getAChild() instanceof SizeofOperator) = e
  ) and
  tainted = e.getAChild() and
  tainted.getUnspecifiedType() instanceof IntegralType
}

class TaintedAllocationSizeConfiguration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) { taintedChild(_, tainted) }
}

predicate taintedAllocSize(
  Expr e, Expr source, PathNode sourceNode, PathNode sinkNode, string taintCause
) {
  isUserInput(source, taintCause) and
  exists(Expr tainted |
    taintedChild(e, tainted) and
    taintedWithPath(source, tainted, sourceNode, sinkNode)
  )
}

from Expr e, Expr source, PathNode sourceNode, PathNode sinkNode, string taintCause
where taintedAllocSize(e, source, sourceNode, sinkNode, taintCause)
select e, sourceNode, sinkNode, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
