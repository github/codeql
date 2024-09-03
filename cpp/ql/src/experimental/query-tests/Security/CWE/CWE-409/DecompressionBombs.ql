/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File
import DecompressionBomb

module DecompressionTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc, DecompressionFunction f | fc.getTarget() = f |
      fc.getArgument(f.getArchiveParameterIndex()) = [sink.asExpr(), sink.asIndirectExpr()]
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(DecompressionFlowStep f).isAdditionalFlowStep(node1, node2) or
    nextInAdditionalFlowStep(node1, node2)
  }
}

module DecompressionTaint = TaintTracking::Global<DecompressionTaintConfig>;

import DecompressionTaint::PathGraph

from DecompressionTaint::PathNode source, DecompressionTaint::PathNode sink
where DecompressionTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression output $@.", source.getNode(),
  "is not limited"
