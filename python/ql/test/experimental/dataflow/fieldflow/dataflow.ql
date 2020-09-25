/**
 * @kind path-problem
 */

import experimental.dataflow.testConfig
import DataFlow::PathGraph

from TestConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Flow found"
