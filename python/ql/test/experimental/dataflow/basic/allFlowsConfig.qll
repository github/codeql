import experimental.dataflow.DataFlow

/**
 * A configuration to find all flows.
 * To be used on tiny programs.
 */
class AllFlowsConfig extends DataFlow::Configuration {
  AllFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) { any() }

  override predicate isSink(DataFlow::Node node) { any() }
}
