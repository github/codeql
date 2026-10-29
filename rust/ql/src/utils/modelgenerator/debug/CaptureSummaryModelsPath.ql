/**
 * @name Capture Summary Models Path
 * @description Capture Summary Models Path
 * @kind path-problem
 * @precision low
 * @id rust/utils/modelgenerator/summary-models-path
 * @severity warning
 * @tags debugmodelgenerator
 */

private import codeql.rust.dataflow.DataFlow
import utils.modelgenerator.internal.CaptureModels
import SummaryModels
import Heuristic::PropagateTaintFlow::PathGraph

from
  Heuristic::PropagateTaintFlow::PathNode source, Heuristic::PropagateTaintFlow::PathNode sink,
  DataFlowSummaryTargetApi api, DataFlow::Node p, DataFlow::Node returnNodeExt
where
  Heuristic::PropagateTaintFlow::flowPath(source, sink) and
  p = source.getNode() and
  returnNodeExt = sink.getNode() and
  Heuristic::captureThroughFlow0(api, p, returnNodeExt)
select sink.getNode(), source, sink, "There is flow from $@ to the $@.", source.getNode(),
  "parameter", sink.getNode(), "return value"
