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
    // obj -> obj.get_value
    nodeTo.asCfgNode().(AttrNode).getObject("get_value") = nodeFrom.asCfgNode() and
    nodeTo = myClassGetValue(_)
    or
    // get_value -> get_value()
    nodeFrom = myClassGetValue(_) and
    nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode()
  }
}

from SharedConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "test flow (proper): " + source.getNode().asCfgNode().getScope().getName()
