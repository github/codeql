/**
 * Test that the new data-flow analysis can connect any two
 * data-flow nodes that the points-to analysis can.
 */

private import python
import semmle.python.dataflow.new.DataFlow

predicate pointsToOrigin(DataFlow::CfgNode pointer, DataFlow::CfgNode origin) {
  origin.getNode() = pointer.getNode().pointsTo().getOrigin()
}

module PointsToConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { pointsToOrigin(_, node) }

  predicate isSink(DataFlow::Node node) { pointsToOrigin(node, _) }
}

module PointsToFlow = DataFlow::Global<PointsToConfig>;

from DataFlow::Node pointer, DataFlow::Node origin
where
  exists(pointer.getLocation().getFile().getRelativePath()) and
  exists(origin.getLocation().getFile().getRelativePath()) and
  pointsToOrigin(pointer, origin) and
  not PointsToFlow::flow(origin, pointer)
select origin, pointer
