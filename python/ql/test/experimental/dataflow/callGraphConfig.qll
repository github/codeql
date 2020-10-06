private import python
import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to find the call graph edges.
 */
class CallGraphConfig extends DataFlow::Configuration {
  CallGraphConfig() { this = "CallGraphConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlowPrivate::ReturnNode
    or
    node instanceof DataFlowPrivate::ArgumentNode
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlowPrivate::OutNode
    or
    node instanceof DataFlow::ParameterNode
  }
}
