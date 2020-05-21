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
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

/**
 * Holds if `alloc` is an allocation, and `tainted` is a child of it that is a
 * taint sink.
 */
predicate allocSink(Expr alloc, Expr tainted) {
  isAllocationExpr(alloc) and
  tainted = alloc.getAChild() and
  tainted.getUnspecifiedType() instanceof IntegralType
}

class TaintedAllocationSizeConfiguration extends TaintTracking::Configuration {
  TaintedAllocationSizeConfiguration() { this = "TaintedAllocationSizeConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or source instanceof LocalFlowSource
  }

  override predicate isSink(DataFlow::Node sink) { allocSink(_, sink.asExpr()) }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof UpperBoundGuard
  }
}

class UpperBoundGuard extends DataFlow::BarrierGuard {
  UpperBoundGuard() { this.comparesLt(_, _, _, _, _) }

  override predicate checks(Instruction i, boolean b) { this.comparesLt(i.getAUse(), _, _, _, b) }
}

/*
 * class TaintedAllocationSizeConfiguration extends TaintTrackingConfiguration {
 *  override predicate isSink(Element tainted) { allocSink(_, tainted) }
 * }
 */

predicate taintedAllocSize(
  Expr source, Expr alloc, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause
) {
  exists(Expr tainted, DataFlow::Node rawSourceNode, TaintedAllocationSizeConfiguration config |
    allocSink(alloc, tainted) and
    (
      rawSourceNode.asExpr() = source or
      rawSourceNode.asDefiningArgument() = source
    ) and
    sourceNode.getNode() = rawSourceNode and
    config.hasFlowPath(sourceNode, sinkNode) and
    tainted = sinkNode.getNode().(DataFlow::ExprNode).getConvertedExpr() and
    (
      taintCause = rawSourceNode.(RemoteFlowSource).getSourceType() or
      taintCause = rawSourceNode.(LocalFlowSource).getSourceType()
    )
  )
}

from
  Expr source, Expr alloc, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause
where taintedAllocSize(source, alloc, sourceNode, sinkNode, taintCause)
select alloc, sourceNode, sinkNode, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
