/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @id java/utils/model-generator/sink-models
 */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.internal.DataFlowImplCommon
private import ModelGeneratorUtils

class FromSourceConfiguration extends TaintTracking::Configuration {
  FromSourceConfiguration() { this = "FromSourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(TargetApi c |
      sink instanceof ReturnNodeExt and
      sink.getEnclosingCallable() = c and
      c.isPublic() and
      c.fromSource()
    )
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSinkCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }
}

string captureSource(TargetApi api) {
  exists(DataFlow::Node source, DataFlow::Node sink, FromSourceConfiguration config, string kind |
    config.hasFlow(source, sink) and
    sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    result = asSourceModel(api, returnNodeAsOutput(sink), kind)
  )
}

from TargetApi api, string sink
where sink = captureSource(api)
select sink order by sink
