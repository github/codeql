/**
 * @name Capture summary model through flows
 * @description Debug query to find summary models to be used by other queries.
 * @kind path-problem
 * @id java/utils/model-generator/summary-models-through-flow-path-problem
 * @severity info
 * @tags model-generator
 *       debug
 */

import utils.modelgenerator.internal.CaptureModels as CaptureModels
import utils.modelgenerator.internal.CaptureModelsSpecific as CaptureModelsSpecific
import java
import DataFlow::PathGraph
import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.java.dataflow.FlowSources

class Activate extends CaptureModels::ActiveConfiguration {
  override predicate activateThroughFlowConfig() { any() }
}

class ThroughFlowConfig extends CaptureModels::ThroughFlowConfig {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    CaptureModels::ThroughFlowConfig.super.isSource(source, state) and
    filter(source.getEnclosingCallable())
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    CaptureModels::ThroughFlowConfig.super.isSink(sink, state) and
    filter(sink.getEnclosingCallable())
  }

  private predicate filter(Callable c) {
    none()
    // todo: filter for specific API:
    //c.hasQualifiedName("java.applet", "Applet", "getAudioClip")
  }
}

from
  ThroughFlowConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::ParameterNode p, DataFlowImplCommon::ReturnNodeExt returnNodeExt, Callable api,
  string input, string output
where
  cfg.hasFlowPath(source, sink) and
  source.getNode() = p and
  sink.getNode() = returnNodeExt and
  api = returnNodeExt.getEnclosingCallable() and
  input = CaptureModelsSpecific::parameterNodeAsInput(p) and
  output = CaptureModelsSpecific::returnNodeAsOutput(returnNodeExt) and
  input != output
select source.getNode(), source, sink, "$@", source.getNode(),
  CaptureModels::asTaintModel(api, input, output)
