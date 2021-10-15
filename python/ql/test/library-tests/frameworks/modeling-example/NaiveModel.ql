/**
 * @kind path-problem
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
import DataFlow::PathGraph
import SharedCode

class MyClassGetValueAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // obj -> obj.get_value()
    exists(DataFlow::Node bound_method |
      bound_method = myClassGetValue(nodeFrom) and
      nodeTo.asCfgNode().(CallNode).getFunction() = bound_method.asCfgNode()
    )
  }
}

from SharedConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "test flow (naive): " + source.getNode().asCfgNode().getScope().getName()
