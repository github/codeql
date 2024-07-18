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
import DataFlow::PathGraph
import DecompressionBombs

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionBomb::Sink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DecompressionBomb::AdditionalTaintStep addstep |
      addstep.isAdditionalTaintStep(pred, succ)
    )
  }
}

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
