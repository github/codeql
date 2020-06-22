import experimental.dataflow.DataFlow

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asCfgNode().(NameNode).getId() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      node.asCfgNode() = call.getAnArg()
    )
  }
}
