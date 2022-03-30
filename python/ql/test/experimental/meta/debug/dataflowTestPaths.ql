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
import experimental.dataflow.testConfig
// import DataFlow::PartialPathGraph
import DataFlow::PathGraph

class Conf extends TestConfiguration {
  override int explorationLimit() { result = 5 }
}

// from Conf config, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
// where config.hasPartialFlow(source, sink, _)
from Conf config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This node receives taint from $@.", source.getNode(),
  "this source"
