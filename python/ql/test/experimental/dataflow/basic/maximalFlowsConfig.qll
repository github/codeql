import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to find all "maximal" flows.
 * To be used on small programs.
 */
class MaximalFlowsConfig extends DataFlow::Configuration {
  MaximalFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlow::ParameterNode
    or
    node instanceof DataFlow::LocalSourceNode
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlowPrivate::ReturnNode
    or
    not DataFlowPrivate::LocalFlow::localFlowStep(node, _)
  }
}
