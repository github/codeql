/**
 * @kind path-problem
 */

// This query is for debugging InlineTaintTestFailures.
// The intended usage is
// 1. load the database of the failing test
// 2. run this query to see actual paths
// 3. if necessary, look at partial paths by (un)commenting appropriate lines
import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.meta.InlineTaintTest::Conf

module Conf implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    any (TestTaintTrackingConfiguration c).isSource(source)
  }
  predicate isSink(DataFlow::Node source) {
    any (TestTaintTrackingConfiguration c).isSink(source)
  }
}
int explorationLimit() { result = 5 }

module Flows = TaintTracking::Global<Conf>;

module FlowsPartial = Flows::FlowExploration<explorationLimit/0>;

// import FlowsPartial::PartialPathGraph
import Flows::PathGraph

// from FlowsPartial::PartialPathNode source, FlowsPartial::PartialPathNode sink
// where FlowsPartial::partialFlow(source, sink, _)
from Flows::PathNode source, Flows::PathNode sink
where Flows::flowPath(source, sink)
select sink.getNode(), source, sink, "This node receives taint from $@.", source.getNode(),
  "this source"
