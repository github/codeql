private import python
import experimental.dataflow.DataFlow

predicate pointsToOrigin(DataFlow::DataFlowCfgNode pointer, DataFlow::DataFlowCfgNode pointed) {
  pointed = pointer.pointsTo().getOrigin()
}

class PointsToConfiguration extends DataFlow::Configuration {
  PointsToConfiguration() { this = "PointsToConfiguration" }

  override predicate isSource(DataFlow::Node node) { pointsToOrigin(_, node.asCfgNode()) }

  override predicate isSink(DataFlow::Node node) { pointsToOrigin(node.asCfgNode(), _) }
}

predicate hasFlow(ControlFlowNode pointed, ControlFlowNode pointer) {
  exists(PointsToConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink |
    source.getNode().asCfgNode() = pointed and
    sink.getNode().asCfgNode() = pointer and
    config.hasFlowPath(source, sink)
  )
}

from DataFlow::DataFlowCfgNode pointer, DataFlow::DataFlowCfgNode pointed
where
  pointsToOrigin(pointer, pointed) and
  not hasFlow(pointed, pointer)
select pointer, pointed
