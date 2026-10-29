/**
 * @kind path-problem
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
import SharedFlow::PathGraph
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

from SharedFlow::PathNode source, SharedFlow::PathNode sink
where SharedFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "test flow (naive): " + source.getNode().asCfgNode().getScope().getName()
