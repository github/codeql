/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @precision low
 * @id cpp/data-decompression-bomb
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

predicate isSink(FunctionCall fc, DataFlow::Node sink) {
  exists(DecompressionFunction f | fc.getTarget() = f |
    fc.getArgument(f.getArchiveParameterIndex()) = [sink.asExpr(), sink.asIndirectExpr()]
  )
}

module DecompressionTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) { isSink(_, sink) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(DecompressionFlowStep s).isAdditionalFlowStep(node1, node2)
  }
}

module DecompressionTaint = TaintTracking::Global<DecompressionTaintConfig>;

import DecompressionTaint::PathGraph

from DecompressionTaint::PathNode source, DecompressionTaint::PathNode sink, FunctionCall fc
where DecompressionTaint::flowPath(source, sink) and isSink(fc, sink.getNode())
select sink.getNode(), source, sink, "The decompression output of $@ is not limited", fc,
  fc.getTarget().getName()
