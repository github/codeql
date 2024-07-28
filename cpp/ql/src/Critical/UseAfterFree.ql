/**
 * @name Potential use after free
 * @description An allocated memory block is used after it has been freed. Behavior in such cases is undefined and can cause memory corruption.
 * @kind path-problem
 * @precision high
 * @id cpp/use-after-free
 * @problem.severity warning
 * @security-severity 9.3
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.security.flowafterfree.FlowAfterFree
import semmle.code.cpp.security.flowafterfree.UseAfterFree
import UseAfterFreeTrace::PathGraph

module UseAfterFreeParam implements FlowFromFreeParamSig {
  predicate isSink = isUse/2;

  predicate isExcluded = isExcludedMmFreePageFromMdl/2;

  predicate sourceSinkIsRelated = defaultSourceSinkIsRelated/2;
}

import UseAfterFreeParam

module UseAfterFreeTrace = FlowFromFree<UseAfterFreeParam>;

from UseAfterFreeTrace::PathNode source, UseAfterFreeTrace::PathNode sink, DeallocationExpr dealloc
where
  UseAfterFreeTrace::flowPath(source, sink) and
  isFree(source.getNode(), _, _, dealloc)
select sink.getNode(), source, sink, "Memory may have been previously freed by $@.", dealloc,
  dealloc.toString()
