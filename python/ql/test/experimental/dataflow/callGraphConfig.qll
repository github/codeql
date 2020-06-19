import experimental.dataflow.DataFlow

/**
 * A configuration to find the call graph edges. 
 */
class CallGraphConfig extends DataFlow::Configuration {
  CallGraphConfig() { this = "CallGraphConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlow::ReturnNode
    or
    node instanceof DataFlow::ArgumentNode
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlow::OutNode
    or
    node instanceof DataFlow::ParameterNode
  }
}
