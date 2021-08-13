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
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph
import Bounded

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
  TaintedAllocationSizeConfiguration() { this = "TaintedAllocationSizeConfigurations" }

  override predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  override predicate isSink(DataFlow::Node sink) { allocSink(_, sink.asExpr()) }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Expr e | e = node.asExpr() |
      bounded(e)
      or
      // Subtracting two pointers is either well-defined (and the result will likely be small), or
      // terribly undefined and dangerous. Here, we assume that the programmer has ensured that the
      // result is well-defined (i.e., the two pointers point to the same object), and thus the result
      // will likely be small.
      e = any(PointerDiffExpr diff).getAnOperand()
    )
  }
}

from
  Expr source, Expr alloc, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause, TaintedAllocationSizeConfiguration conf
where
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  conf.hasFlowPath(sourceNode, sinkNode) and
  allocSink(alloc, sinkNode.getNode().asExpr()) and
  source = sourceNode.getNode().asExpr()
select alloc, sourceNode, sinkNode, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
