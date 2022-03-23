private import CaptureSourceModelsSpecific
private import ModelGeneratorUtils

private class FromSourceConfiguration extends TaintTracking::Configuration {
  FromSourceConfiguration() { this = "FromSourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(TargetApi c |
      sink instanceof ReturnNodeExt and
      sink.getEnclosingCallable() = c
    )
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSinkCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }
}

/**
 * Gets the source model(s) of `api`, if there is flow from an existing known source to the return of `api`.
 */
string captureSource(TargetApi api) {
  exists(DataFlow::Node source, DataFlow::Node sink, FromSourceConfiguration config, string kind |
    config.hasFlow(source, sink) and
    sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    result = asSourceModel(api, returnNodeAsOutput(sink), kind)
  )
}
