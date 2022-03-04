import CaptureSummaryModelsSpecific

/**
 * Capture fluent APIs that return `this`.
 * Example of a fluent API:
 * ```
 * public class Foo {
 *   public Foo someAPI() {
 *    // some side-effect
 *    return this;
 *  }
 * }
 * ```
 */
string captureQualifierFlow(TargetAPI api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    isOwnInstanceAccess(rtn)
  ) and
  result = asValueModel(api, qualifierString(), "ReturnValue")
}

class TaintRead extends DataFlow::FlowState {
  TaintRead() { this = "TaintRead" }
}

class TaintStore extends DataFlow::FlowState {
  TaintStore() { this = "TaintStore" }
}

class ThroughFlowConfig extends TaintTracking::Configuration {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof TargetAPI and
    state instanceof TaintRead
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof ReturnNodeExt and
    not isOwnInstanceAccessNode(sink) and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  override predicate isAdditionalFlowStep(
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

string captureThroughFlow(TargetAPI api) {
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
