import experimental.dataflow.DataFlow

/**
 * A configuration to find all "maximal" flows.
 * To be used on small programs.
 */
class MaximalFlowsConfig extends DataFlow::Configuration {
  MaximalFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof DataFlow::ParameterNode
    or
    node instanceof DataFlow::EssaNode and
    not exists(DataFlow::EssaNode pred | DataFlow::localFlowStep(pred, node))
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlow::ReturnNode
    or
    node instanceof DataFlow::EssaNode and
    not exists(node.(DataFlow::EssaNode).getVar().getASourceUse())
  }
}
