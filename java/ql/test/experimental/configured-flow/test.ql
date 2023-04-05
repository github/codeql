/**
 * @name Testing the threat model
 * @kind path-problem
 * @problem.severity warning
 * @precision low
 * @id java/threat-model
 * @tags security
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import ThreatModel::PathGraph
import semmle.code.java.dataflow.TaintTracking

private module ThreatModelConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    sourceNode(source, _)
  }

  predicate isSink(DataFlow::Node sink) {
    sinkNode(sink, _)
  }
}

module ThreatModel = TaintTracking::Global<ThreatModelConfig>;

from ThreatModel::PathNode source, ThreatModel::PathNode sink
where ThreatModel::flowPath(source, sink)
select sink.getNode(), source, sink, "This is some kind of threat model thingy $@.", source.getNode(),
  "Source of that thingy"

// from DataFlow::Node source, DataFlow::Node sink
// where ThreatModel::flow(source, sink)
// select source, sink


// from DataFlow::Node node, string kind
// where sourceNode(node, kind)
// select node, kind
