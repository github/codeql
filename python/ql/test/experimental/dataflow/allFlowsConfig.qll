import experimental.dataflow.DataFlow

/**
 * A configuration to find "all" flows.
 * To be used on small programs.
 */
class AllFlowsConfig extends DataFlow::Configuration {
  AllFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    // node.asCfgNode().isEntryNode()
    node instanceof DataFlow::ParameterNode
    or
    node = DataFlow::TEssaNode(_) and
    not exists(DataFlow::Node pred |
      pred = DataFlow::TEssaNode(_) and
      DataFlow::localFlowStep(pred, node)
    )
  }

  override predicate isSink(DataFlow::Node node) {
    node instanceof DataFlow::ReturnNode
    or
    node = DataFlow::TEssaNode(_) and
    not exists(node.asEssaNode().getASourceUse())
  }
}
