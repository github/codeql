/**
 * @name Uncontrolled file decompression
 * @description Decompressing user-controlled files without checking the compression ratio may allow attackers to perform denial-of-service attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import java
import semmle.code.java.dataflow.FlowSources
import experimental.semmle.code.java.security.FileAndFormRemoteSource
import experimental.semmle.code.java.security.DecompressionBomb::DecompressionBomb
import semmle.code.java.dataflow.TaintTracking

module DecompressionBombsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(AdditionalStep ads).step(nodeFrom, nodeTo)
  }
}

module DecompressionBombsFlow = TaintTracking::Global<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
