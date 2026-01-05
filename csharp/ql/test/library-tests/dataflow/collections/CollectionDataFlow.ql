/**
 * @kind path-problem
 */

import CollectionFlowCommon
import utils.test.ProvenancePathGraph::ShowProvenance<ArrayFlow::PathNode, ArrayFlow::PathGraph>

module ArrayFlow = DataFlow::Global<ArrayFlowConfig>;

from ArrayFlow::PathNode source, ArrayFlow::PathNode sink
where ArrayFlow::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
