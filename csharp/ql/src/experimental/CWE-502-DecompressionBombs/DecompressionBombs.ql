/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled decompression without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id cs/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import experimental.dataflow.security.DecompressionBomb
import RemoteFlowSource

/**
 * A taint tracking configuration for Decompression Bomb.
 */
module DecompressionBombModule implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionBomb::Sink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(DecompressionBomb::AdditionalStep a).isAdditionalFlowStep(node1, node2)
  }
}

module DecompressionBombConfig = TaintTracking::Global<DecompressionBombModule>;

import DecompressionBombConfig::PathGraph

from DecompressionBombConfig::PathNode source, DecompressionBombConfig::PathNode sink
where DecompressionBombConfig::flowPath(source, sink)
select sink.getNode(), source, sink, "This uncontrolled depends on a $@.", source.getNode(), "this"
