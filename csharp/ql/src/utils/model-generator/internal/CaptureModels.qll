/**
 * Provides classes and predicates related to capturing summary, source,
 * and sink models of the Standard or a 3rd party library.
 */

private import CaptureModelsSpecific

class TargetApi = TargetApiSpecific;

/**
 * Holds if data can flow from `node1` to `node2` either via a read or a write of an intermediate field `f`.
 */
private predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    DataFlowPrivate::readStep(node1, f, node2) and
    if f instanceof DataFlow::FieldContent
    then isRelevantType(f.(DataFlow::FieldContent).getField().getType())
    else
      if f instanceof DataFlow::SyntheticFieldContent
      then isRelevantType(f.(DataFlow::SyntheticFieldContent).getField().getType())
      else any()
  )
  or
  exists(DataFlow::Content f | DataFlowPrivate::storeStep(node1, f, node2) |
    DataFlowPrivate::containerContent(f)
  )
}

/**
 * Holds if content `c` is either a field or synthetic field of a relevant type
 * or a container like content.
 */
private predicate isRelevantContent(DataFlow::Content c) {
  isRelevantType(c.(DataFlow::FieldContent).getField().getType()) or
  isRelevantType(c.(DataFlow::SyntheticFieldContent).getField().getType()) or
  DataFlowPrivate::containerContent(c)
}

/**
 * Gets the summary model for `api` with `input`, `output` and `kind`.
 */
bindingset[input, output, kind]
private string asSummaryModel(TargetApi api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + "generated:" + kind
}

/**
 * Gets the value summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
private string asValueModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

/**
 * Gets the taint summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
private string asTaintModel(TargetApi api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

/**
 * Gets the sink model for `api` with `input` and `kind`.
 */
bindingset[input, kind]
private string asSinkModel(TargetApi api, string input, string kind) {
  result = asPartialModel(api) + input + ";" + "generated:" + kind
}

/**
 * Gets the source model for `api` with `output` and `kind`.
 */
bindingset[output, kind]
private string asSourceModel(TargetApi api, string output, string kind) {
  result = asPartialModel(api) + output + ";" + "generated:" + kind
}

/**
 * Gets the summary model of `api`, if it follows the `fluent` programming pattern (returns `this`).
 */
string captureQualifierFlow(TargetApi api) {
  exists(DataFlowImplCommon::ReturnNodeExt ret |
    api = returnNodeEnclosingCallable(ret) and
    isOwnInstanceAccessNode(ret)
  ) and
  result = asValueModel(api, qualifierString(), "ReturnValue")
}

/**
 * A FlowState representing a tainted read.
 */
private class TaintRead extends DataFlow::FlowState {
  TaintRead() { this = "TaintRead" }
}

/**
 * A FlowState representing a tainted write.
 */
private class TaintStore extends DataFlow::FlowState {
  TaintStore() { this = "TaintStore" }
}

/**
 * A TaintTracking Configuration used for tracking flow through APIs.
 * The sources are the parameters of an API and the sinks are the return values (excluding `this`) and parameters.
 *
 * This can be used to generate Flow summaries for APIs from parameter to return.
 */
private class ThroughFlowConfig extends TaintTracking::Configuration {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof TargetApi and
    state instanceof TaintRead
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof DataFlowImplCommon::ReturnNodeExt and
    not isOwnInstanceAccessNode(sink) and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(DataFlowImplCommon::TypedContent tc |
      DataFlowImplCommon::store(node1, tc, node2, _) and
      isRelevantContent(tc.getContent()) and
      (state1 instanceof TaintRead or state1 instanceof TaintStore) and
      state2 instanceof TaintStore
    )
    or
    exists(DataFlow::Content c |
      DataFlowPrivate::readStep(node1, c, node2) and
      isRelevantContent(c) and
      state1 instanceof TaintRead and
      state2 instanceof TaintRead
    )
  }

  override predicate isSanitizer(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow(TargetApi api) {
  exists(
    ThroughFlowConfig config, DataFlow::ParameterNode p,
    DataFlowImplCommon::ReturnNodeExt returnNodeExt, string input, string output
  |
    config.hasFlow(p, returnNodeExt) and
    returnNodeExt.getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = returnNodeAsOutput(returnNodeExt) and
    input != output and
    result = asTaintModel(api, input, output)
  )
}

/**
 * A TaintTracking Configuration used for tracking flow through APIs.
 * The sources are the already known existing sources and the sinks are the API return nodes.
 *
 * This can be used to generate Source summaries for an API, if the API expose an already known source
 * via its return (then the API itself becomes a source).
 */
private class FromSourceConfiguration extends TaintTracking::Configuration {
  FromSourceConfiguration() { this = "FromSourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { ExternalFlow::sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(TargetApi c |
      sink instanceof DataFlowImplCommon::ReturnNodeExt and
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
    ExternalFlow::sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    result = asSourceModel(api, returnNodeAsOutput(sink), kind)
  )
}

/**
 * A TaintTracking Configuration used for tracking flow through APIs.
 * The sources are the parameters of the API and the fields of the enclosing type.
 *
 * This can be used to generate Sink summaries for APIs, if the API propgates a parameter (or enclosing type field)
 * into an existing known sink (then the API itself becomes a sink).
 */
private class PropagateToSinkConfiguration extends PropagateToSinkConfigurationSpecific {
  PropagateToSinkConfiguration() { this = "parameters or fields flowing into sinks" }

  override predicate isSink(DataFlow::Node sink) { ExternalFlow::sinkNode(sink, _) }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

/**
 * Gets the sink model(s) of `api`, if there is flow from a parameter to an existing known sink.
 */
string captureSink(TargetApi api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    ExternalFlow::sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    isRelevantSinkKind(kind) and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}
