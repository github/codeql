/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 */

import cpp
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
