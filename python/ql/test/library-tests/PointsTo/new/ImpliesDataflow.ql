/**
 * Test that the new data-flow analysis can connect any two
 * data-flow nodes that the points-to analysis can.
 */

private import python
import semmle.python.dataflow.new.DataFlow

predicate pointsToOrigin(DataFlow::CfgNode pointer, DataFlow::CfgNode origin) {
  origin.getNode() = pointer.getNode().pointsTo().getOrigin()
}

class PointsToConfiguration extends DataFlow::Configuration {
  PointsToConfiguration() { this = "PointsToConfiguration" }

  override predicate isSource(DataFlow::Node node) { pointsToOrigin(_, node) }

  override predicate isSink(DataFlow::Node node) { pointsToOrigin(node, _) }
}

predicate hasFlow(DataFlow::Node origin, DataFlow::Node pointer) {
  exists(PointsToConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink |
    source.getNode() = origin and
    sink.getNode() = pointer and
    config.hasFlowPath(source, sink)
  )
}

from DataFlow::Node pointer, DataFlow::Node origin
where
  exists(pointer.getLocation().getFile().getRelativePath()) and
  exists(origin.getLocation().getFile().getRelativePath()) and
  pointsToOrigin(pointer, origin) and
  not hasFlow(origin, pointer)
select origin, pointer
