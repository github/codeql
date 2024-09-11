/**
 * @name Capture Summary Models Path
 * @description Capture Summary Models Path
 * @kind path-problem
 * @precision low
 * @id csharp/utils/modelgenerator/summary-models-path
 * @severity warning
 * @tags modelgenerator
 */

import csharp
import utils.modelgenerator.internal.CaptureModels
import PropagateFlow::PathGraph

from
  PropagateFlow::PathNode source, PropagateFlow::PathNode sink, DataFlowSummaryTargetApi api,
  DataFlow::Node p, DataFlow::Node returnNodeExt
where
  PropagateFlow::flowPath(source, sink) and
  p = source.getNode() and
  returnNodeExt = sink.getNode() and
  exists(captureThroughFlow0(api, p, returnNodeExt))
select sink.getNode(), source, sink, "There is flow from $@ to the $@.", source.getNode(),
  "parameter", sink.getNode(), "return value"
