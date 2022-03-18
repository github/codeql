private import CaptureSinkModelsSpecific

class PropagateToSinkConfiguration extends PropagateToSinkConfigurationSpecific {
  PropagateToSinkConfiguration() { this = "parameters or fields flowing into sinks" }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, _) }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

string captureSink(TargetApi api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    not kind = "logging" and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}
