/**
 * @name Potential use after free (no dominance requirement between source and sink)
 * @description An allocated memory block is used after it has been freed. Behavior in such cases is undefined and can cause memory corruption.
 * @kind path-problem
 * @id cpp/use-after-free-no-dominance
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 * @precision low
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.security.flowafterfree.FlowAfterFree
import semmle.code.cpp.security.flowafterfree.UseAfterFree
import UseAfterFreeTrace::PathGraph

/**
 * Force source and sink to be in the same function to limit the number of false positives.
 */
bindingset[source, sink]
predicate defaultSourceSinkIsRelated(DataFlow::Node source, DataFlow::Node sink) { any() }

predicate simpleUse(DataFlow::Node n, Expr e) { isUse0(e) and n.asExpr() = e }

module UseAfterFreeParam implements FlowFromFreeParamSig {
  predicate isSink = simpleUse/2;

  predicate isExcluded = isExcludedMmFreePageFromMdl/2;

  predicate sourceSinkIsRelated = defaultSourceSinkIsRelated/2;

    /**
   * Keep source and sink in the same function to limit false positives
   */
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureEqualSourceSinkCallContext}
}

import UseAfterFreeParam

module UseAfterFreeTrace = FlowFromFree<UseAfterFreeParam>;

from UseAfterFreeTrace::PathNode source, UseAfterFreeTrace::PathNode sink, DeallocationExpr dealloc
where
  UseAfterFreeTrace::flowPath(source, sink) and
  isFree(source.getNode(), _, _, dealloc)
select sink.getNode(), source, sink, "Memory may have been previously freed by $@.", dealloc,
  dealloc.toString()
