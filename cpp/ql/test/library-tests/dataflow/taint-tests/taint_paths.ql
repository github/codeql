import TaintTestCommon

import DataFlow::PathGraph

from DataFlow::PathNode sink, DataFlow::PathNode source, TestAllocationConfig cfg
where cfg.hasFlowPath(source, sink)
select sink, source
