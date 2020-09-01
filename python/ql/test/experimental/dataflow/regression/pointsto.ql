private import python
import experimental.dataflow.DataFlow

predicate pointsToOrigin(DataFlow::DataFlowCfgNode pointer, DataFlow::DataFlowCfgNode origin) {
  origin = pointer.pointsTo().getOrigin()
}

class PointsToConfiguration extends DataFlow::Configuration {
  PointsToConfiguration() { this = "PointsToConfiguration" }

  override predicate isSource(DataFlow::Node node) { pointsToOrigin(_, node.asCfgNode()) }

  override predicate isSink(DataFlow::Node node) { pointsToOrigin(node.asCfgNode(), _) }
}

predicate hasFlow(ControlFlowNode origin, ControlFlowNode pointer) {
  exists(PointsToConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink |
    source.getNode().asCfgNode() = origin and
    sink.getNode().asCfgNode() = pointer and
    config.hasFlowPath(source, sink)
  )
}

from DataFlow::DataFlowCfgNode pointer, DataFlow::DataFlowCfgNode origin
where
  pointsToOrigin(pointer, origin) and
  not hasFlow(origin, pointer)
select origin, pointer
