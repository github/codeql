/**
 * @name Capture Summary Models Path
 * @description Capture Summary Models Path
 * @kind path-problem
 * @precision low
 * @id csharp/utils/modelgenerator/summary-models-path
 * @severity warning
 * @tags debugmodelgenerator
 */

import csharp
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import Heuristic
import PropagateTaintFlow::PathGraph

from
  PropagateTaintFlow::PathNode source, PropagateTaintFlow::PathNode sink,
  DataFlowSummaryTargetApi api, DataFlow::Node p, DataFlow::Node returnNodeExt
where
  PropagateTaintFlow::flowPath(source, sink) and
  p = source.getNode() and
  returnNodeExt = sink.getNode() and
  captureThroughFlow0(api, p, returnNodeExt)
select sink.getNode(), source, sink, "There is flow from $@ to the $@.", source.getNode(),
  "parameter", sink.getNode(), "return value"
