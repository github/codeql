/**
 * @kind path-problem
 */

import experimental.dataflow.testConfig
import DataFlow::PartialPathGraph

from TestConfiguration config, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
where
  config.hasPartialFlow(source, sink, _) and
  source.hasLocationInfo(_, 45, _, _, _) and
  config.isSink(sink.getNode())
select sink.getNode(), source, sink, "<message>"
