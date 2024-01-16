/**
 * @name Potential double free
 * @description Freeing a resource more than once can lead to undefined behavior and cause memory corruption.
 * @kind path-problem
 * @precision high
 * @id cpp/double-free
 * @problem.severity warning
 * @security-severity 9.3
 * @tags reliability
 *       security
 *       external/cwe/cwe-415
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import FlowAfterFree
import DoubleFree::PathGraph

/**
 * Holds if `n` is a dataflow node that represents a pointer going into a
 * deallocation function, and `e` is the corresponding expression.
 */
predicate isFree(DataFlow::Node n, Expr e) { isFree(_, n, e, _) }

/**
 * `dealloc1` is a deallocation expression and `e` is an expression such
 * that is deallocated by a deallocation expression, and the `(dealloc1, e)` pair
 * should be excluded by the `FlowFromFree` library.
 *
 * Note that `e` is not necessarily the expression deallocated by `dealloc1`. It will
 * be bound to the second deallocation as identified by the `FlowFromFree` library.
 */
bindingset[dealloc1, e]
predicate isExcludeFreePair(DeallocationExpr dealloc1, Expr e) {
  exists(DeallocationExpr dealloc2 | isFree(_, _, e, dealloc2) |
    dealloc1.(FunctionCall).getTarget().hasGlobalName("MmFreePagesFromMdl") and
    // From https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/nf-wdm-mmfreepagesfrommdl:
    // "After calling MmFreePagesFromMdl, the caller must also call ExFreePool
    // to release the memory that was allocated for the MDL structure."
    isExFreePoolCall(dealloc2, _)
  )
}

module DoubleFree = FlowFromFree<isFree/2, isExcludeFreePair/2>;

/*
 * In order to reduce false positives, the set of sinks is restricted to only those
 * that satisfy at least one of the following two criteria:
 * 1. The source dominates the sink, or
 * 2. The sink post-dominates the source.
 */

from
  DoubleFree::PathNode source, DoubleFree::PathNode sink, DeallocationExpr dealloc, Expr e2,
  DataFlow::Node srcNode, DataFlow::Node sinkNode
where
  DoubleFree::flowPath(source, sink) and
  source.getNode() = srcNode and
  sink.getNode() = sinkNode and
  isFree(srcNode, _, _, dealloc) and
  isFree(sinkNode, e2) and
  (
    sinkStrictlyPostDominatesSource(srcNode, sinkNode) or
    sourceStrictlyDominatesSink(srcNode, sinkNode)
  )
select sinkNode, source, sink,
  "Memory pointed to by '" + e2.toString() + "' may already have been freed by $@.", dealloc,
  dealloc.toString()
