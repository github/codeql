/**
 * @name Capture Summary Models Partial Path
 * @description Capture Summary Models Partial Path
 * @kind path-problem
 * @precision low
 * @id csharp/utils/modelgenerator/summary-models-partial-path
 * @severity info
 * @tags modelgenerator
 */

import csharp
import utils.modelgenerator.internal.CaptureModels
import PartialFlow::PartialPathGraph

int explorationLimit() { result = 3 }

module PartialFlow = PropagateFlow::FlowExplorationFwd<explorationLimit/0>;

from
  PartialFlow::PartialPathNode source, PartialFlow::PartialPathNode sink,
  DataFlowSummaryTargetApi api, DataFlow::ParameterNode p
where
  PartialFlow::partialFlow(source, sink, _) and
  p = source.getNode() and
  p.asParameter() = api.getAParameter()
select sink.getNode(), source, sink, "There is flow from a $@ to $@.", source.getNode(),
  "parameter", sink.getNode(), "intermediate value"
