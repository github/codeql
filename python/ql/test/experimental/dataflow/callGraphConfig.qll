import experimental.dataflow.DataFlow

/**
 * A configuration to find the call graph edges. 
 */
class CallGraphConfig extends DataFlow::Configuration {
  CallGraphConfig() { this = "CallGraphConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlow::ReturnNode
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlow::OutNode
  }
}
