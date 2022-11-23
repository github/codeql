/**
 * @name Capture sink models flows
 * @description Debug query to find public methods that act as sinks as they flow into a known sink.
 * @kind path-problem
 * @id java/utils/model-generator/sink-models-path-problem
 * @severity info
 * @tags model-generator
 *       debug
 */

import utils.modelgenerator.internal.CaptureModels as CaptureModels
import utils.modelgenerator.internal.CaptureModelsSpecific as CaptureModelsSpecific
import java
import DataFlow::PathGraph
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow as ExternalFlow

class Activate extends CaptureModels::ActiveConfiguration {
  override predicate activateToSinkConfig() { any() }
}

class PropagateToSinkConfiguration extends CaptureModels::PropagateToSinkConfiguration {
  PropagateToSinkConfiguration() { this = "parameters or fields flowing into sinks" }

  override predicate sinkGrouping(DataFlow::Node sink, string sinkGroup) {
    ExternalFlow::sinkNode(sink, sinkGroup)
  }
}

bindingset[kind]
predicate isRelevantSinkKind(string kind) {
  CaptureModelsSpecific::isRelevantSinkKind(kind) and
  not kind = "create-file"
}

from
  PropagateToSinkConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string kind,
  CaptureModels::DataFlowTargetApi api
where
  cfg.hasFlowPath(source, sink) and
  not ExternalFlow::hasSink(api, kind, false) and
  isRelevantSinkKind(kind) and
  kind = sink.toString() and
  api = source.getNode().getEnclosingCallable()
select source.getNode(), source, sink, "$@", source.getNode(),
  CaptureModels::asSinkModel(api.(Callable),
    CaptureModelsSpecific::asInputArgument(source.getNode()), kind)
