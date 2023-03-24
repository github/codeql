/**
 * Provides classes and predicates related to capturing summary, source,
 * and sink models of the Standard or a 3rd party library.
 */

private import CaptureModelsSpecific

class DataFlowTargetApi extends TargetApiSpecific {
  DataFlowTargetApi() { isRelevantForDataFlowModels(this) }
}

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
 * Gets the MaD string representation of the parameter node `p`.
 */
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = qualifierString() and p instanceof InstanceParameterNode
}

/**
 * Gets the MaD input string representation of `source`.
 */
string asInputArgument(DataFlow::Node source) { result = asInputArgumentSpecific(source) }

/**
 * Gets the summary model for `api` with `input`, `output` and `kind`.
 */
bindingset[input, output, kind]
private string asSummaryModel(TargetApiSpecific api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind + ";" //
      + "generated"
}

string asNeutralModel(TargetApiSpecific api) { result = asPartialNeutralModel(api) + "generated" }

/**
 * Gets the value summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
string asValueModel(TargetApiSpecific api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

/**
 * Gets the taint summary model for `api` with `input` and `output`.
 */
bindingset[input, output]
private string asTaintModel(TargetApiSpecific api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

/**
 * Gets the sink model for `api` with `input` and `kind`.
 */
bindingset[input, kind]
private string asSinkModel(TargetApiSpecific api, string input, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + kind + ";" //
      + "generated"
}

/**
 * Gets the source model for `api` with `output` and `kind`.
 */
bindingset[output, kind]
private string asSourceModel(TargetApiSpecific api, string output, string kind) {
  result =
    asPartialModel(api) + output + ";" //
      + kind + ";" //
      + "generated"
}

/**
 * Gets the summary model of `api`, if it follows the `fluent` programming pattern (returns `this`).
 */
string captureQualifierFlow(TargetApiSpecific api) {
  exists(DataFlowImplCommon::ReturnNodeExt ret |
    api = returnNodeEnclosingCallable(ret) and
    isOwnInstanceAccessNode(ret)
  ) and
  result = asValueModel(api, qualifierString(), "ReturnValue")
}

private int accessPathLimit() { result = 2 }

private newtype TTaintState =
  TTaintRead(int n) { n in [0 .. accessPathLimit()] } or
  TTaintStore(int n) { n in [1 .. accessPathLimit()] }

abstract private class TaintState extends TTaintState {
  abstract string toString();
}

/**
 * A FlowState representing a tainted read.
 */
private class TaintRead extends TaintState, TTaintRead {
  private int step;

  TaintRead() { this = TTaintRead(step) }

  /**
   * Gets the flow state step number.
   */
  int getStep() { result = step }

  override string toString() { result = "TaintRead(" + step + ")" }
}

/**
 * A FlowState representing a tainted write.
 */
private class TaintStore extends TaintState, TTaintStore {
  private int step;

  TaintStore() { this = TTaintStore(step) }

  /**
   * Gets the flow state step number.
   */
  int getStep() { result = step }

  override string toString() { result = "TaintStore(" + step + ")" }
}

/**
 * A data-flow configuration for tracking flow through APIs.
 * The sources are the parameters of an API and the sinks are the return values (excluding `this`) and parameters.
 *
 * This can be used to generate Flow summaries for APIs from parameter to return.
 */
module ThroughFlowConfig implements DataFlow::StateConfigSig {
  class FlowState = TaintState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof DataFlowTargetApi and
    state.(TaintRead).getStep() = 0
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof DataFlowImplCommon::ReturnNodeExt and
    not isOwnInstanceAccessNode(sink) and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(DataFlowImplCommon::TypedContent tc |
      DataFlowImplCommon::store(node1, tc, node2, _) and
      isRelevantContent(tc.getContent()) and
      (
        state1 instanceof TaintRead and state2.(TaintStore).getStep() = 1
        or
        state1.(TaintStore).getStep() + 1 = state2.(TaintStore).getStep()
      )
    )
    or
    exists(DataFlow::Content c |
      DataFlowPrivate::readStep(node1, c, node2) and
      isRelevantContent(c) and
      state1.(TaintRead).getStep() + 1 = state2.(TaintRead).getStep()
    )
  }

  predicate isBarrier(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

private module ThroughFlow = TaintTracking::GlobalWithState<ThroughFlowConfig>;

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow(DataFlowTargetApi api) {
  exists(
    DataFlow::ParameterNode p, DataFlowImplCommon::ReturnNodeExt returnNodeExt, string input,
    string output
  |
    ThroughFlow::flow(p, returnNodeExt) and
    returnNodeExt.getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = returnNodeAsOutput(returnNodeExt) and
    input != output and
    result = asTaintModel(api, input, output)
  )
}

/**
 * A dataflow configuration used for finding new sources.
 * The sources are the already known existing sources and the sinks are the API return nodes.
 *
 * This can be used to generate Source summaries for an API, if the API expose an already known source
 * via its return (then the API itself becomes a source).
 */
module FromSourceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { ExternalFlow::sourceNode(source, _) }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlowTargetApi c |
      sink instanceof DataFlowImplCommon::ReturnNodeExt and
      sink.getEnclosingCallable() = c
    )
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSinkCallContext }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }
}

private module FromSource = TaintTracking::Global<FromSourceConfig>;

/**
 * Gets the source model(s) of `api`, if there is flow from an existing known source to the return of `api`.
 */
string captureSource(DataFlowTargetApi api) {
  exists(DataFlow::Node source, DataFlow::Node sink, string kind |
    FromSource::flow(source, sink) and
    ExternalFlow::sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    isRelevantSourceKind(kind) and
    result = asSourceModel(api, returnNodeAsOutput(sink), kind)
  )
}

/**
 * A dataflow configuration used for finding new sinks.
 * The sources are the parameters of the API and the fields of the enclosing type.
 *
 * This can be used to generate Sink summaries for APIs, if the API propagates a parameter (or enclosing type field)
 * into an existing known sink (then the API itself becomes a sink).
 */
module PropagateToSinkConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { apiSource(source) }

  predicate isSink(DataFlow::Node sink) { ExternalFlow::sinkNode(sink, _) }

  predicate isBarrier(DataFlow::Node node) { sinkModelSanitizer(node) }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

private module PropagateToSink = TaintTracking::Global<PropagateToSinkConfig>;

/**
 * Gets the sink model(s) of `api`, if there is flow from a parameter to an existing known sink.
 */
string captureSink(DataFlowTargetApi api) {
  exists(DataFlow::Node src, DataFlow::Node sink, string kind |
    PropagateToSink::flow(src, sink) and
    ExternalFlow::sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    isRelevantSinkKind(kind) and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}
