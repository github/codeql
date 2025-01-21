/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/user-controlled-data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-522
 */

import javascript
import DecompressionBombs

module DecompressionBombConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionBomb::Sink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DecompressionBomb::AdditionalTaintStep addstep |
      addstep.isAdditionalTaintStep(node1, node2)
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module DecompressionBombFlow = TaintTracking::Global<DecompressionBombConfig>;

import DecompressionBombFlow::PathGraph

from DecompressionBombFlow::PathNode source, DecompressionBombFlow::PathNode sink
where DecompressionBombFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
