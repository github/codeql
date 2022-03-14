/**
 * Provides classes and predicates related to capturing summary models
 * of the Standard or a 3rd party library.
 */

import CaptureSummaryModelsSpecific

/**
 * Gets the summary model of `api`, if it follows the `fluent` programming pattern (returns `this`).
 */
string captureQualifierFlow(TargetApi api) {
  exists(ReturnNodeExt ret |
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
class ThroughFlowConfig extends TaintTracking::Configuration {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof TargetApi and
    state instanceof TaintRead
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof ReturnNodeExt and
    not isOwnInstanceAccessNode(sink) and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(TypedContent tc |
      store(node1, tc, node2, _) and
      isRelevantContent(tc.getContent()) and
      (state1 instanceof TaintRead or state1 instanceof TaintStore) and
      state2 instanceof TaintStore
    )
    or
    exists(DataFlow::Content c |
      readStep(node1, c, node2) and
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
    ThroughFlowConfig config, DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt, string input,
    string output
  |
    config.hasFlow(p, returnNodeExt) and
    returnNodeExt.getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = returnNodeAsOutput(returnNodeExt) and
    input != output and
    result = asTaintModel(api, input, output)
  )
}
