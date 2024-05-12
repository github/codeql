/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
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
import experimental.semmle.code.java.security.DecompressionBomb

module DecompressionBombsConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    (
      source instanceof RemoteFlowSource
      or
      source instanceof FormRemoteFlowSource
      or
      source instanceof FileUploadRemoteFlowSource
    ) and
    state = ["ZipFile", "Zip4j", "inflator", "UtilZip", "ApacheCommons", "XerialSnappy"]
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    any(DecompressionBomb::Sink s).sink(sink, state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    any(DecompressionBomb::AdditionalStep ads).step(nodeFrom, stateFrom, nodeTo, stateTo)
  }

  predicate isBarrier(DataFlow::Node sanitizer, FlowState state) { none() }
}

module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
