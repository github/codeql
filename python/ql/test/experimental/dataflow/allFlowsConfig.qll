import experimental.dataflow.DataFlow

/**
 * A configuration to find "all" flows.
 * To be used on small programs.
 */
class AllFlowsConfig extends DataFlow::Configuration {
  AllFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asCfgNode().isEntryNode()
  }

  override predicate isSink(DataFlow::Node node) {
    node.asCfgNode().isNormalExit()
    or
    node = DataFlow::TEssaNode(_) and
    not exists(DataFlow::Node succ |
      DataFlow::localFlowStep(node, succ)
    )
  }
}
