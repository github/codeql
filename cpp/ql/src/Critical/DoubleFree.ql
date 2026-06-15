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
import semmle.code.cpp.security.flowafterfree.FlowAfterFree
import DoubleFree::PathGraph

/**
 * Holds if `n` is a dataflow node that represents a pointer going into a
 * deallocation function, and `e` is the corresponding expression.
 */
predicate isFree(DataFlow::Node n, Expr e) { isFree(_, n, e, _) }

module DoubleFreeParam implements FlowFromFreeParamSig {
  predicate isSink = isFree/2;

  predicate isExcluded = isExcludedMmFreePageFromMdl/2;

  predicate sourceSinkIsRelated = defaultSourceSinkIsRelated/2;
}

module DoubleFree = FlowFromFree<DoubleFreeParam>;

from DoubleFree::PathNode source, DoubleFree::PathNode sink, DeallocationExpr dealloc, Expr e2
where
  DoubleFree::flowPath(source, sink) and
  isFree(source.getNode(), _, _, dealloc) and
  isFree(sink.getNode(), e2)
select sink.getNode(), source, sink, "Memory pointed to by $@ may already have been freed by $@.",
  e2, e2.toString(), dealloc, dealloc.toString()
