/**
 * Provides classes and predicates related to capturing summary, source,
 * and sink models of the Standard or a 3rd party library.
 */

private import CaptureModelsSpecific
private import CaptureModelsPrinting

/**
 * A node from which flow can return to the caller. This is either a regular
 * `ReturnNode` or a `PostUpdateNode` corresponding to the value of a parameter.
 */
private class ReturnNodeExt extends DataFlow::Node {
  private DataFlowImplCommon::ReturnKindExt kind;

  ReturnNodeExt() {
    kind = DataFlowImplCommon::getValueReturnPosition(this).getKind() or
    kind = DataFlowImplCommon::getParamReturnPosition(this, _).getKind()
  }

  string getOutput() {
    kind instanceof DataFlowImplCommon::ValueReturnKind and
    result = "ReturnValue"
    or
    exists(ParameterPosition pos |
      pos = kind.(DataFlowImplCommon::ParamUpdateReturnKind).getPosition() and
      result = paramReturnNodeAsOutput(returnNodeEnclosingCallable(this), pos)
    )
  }
}

class DataFlowSummaryTargetApi extends SummaryTargetApi {
  DataFlowSummaryTargetApi() { not isUninterestingForDataFlowModels(this) }
}

class DataFlowSourceTargetApi = SourceTargetApi;

class DataFlowSinkTargetApi = SinkTargetApi;

private module ModelPrintingInput implements ModelPrintingSig {
  class Api = TargetApiBase;

  string getProvenance() { result = "df-generated" }
}

module Printing = ModelPrinting<ModelPrintingInput>;

/**
 * Holds if `c` is a relevant content kind, where the underlying type is relevant.
 */
private predicate isRelevantTypeInContent(DataFlow::Content c) {
  isRelevantType(getUnderlyingContentType(c))
}

/**
 * Holds if data can flow from `node1` to `node2` either via a read or a write of an intermediate field `f`.
 */
private predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    DataFlowPrivate::readStep(node1, f, node2) and
    // Partially restrict the content types used for intermediate steps.
    (not exists(getUnderlyingContentType(f)) or isRelevantTypeInContent(f))
  )
  or
  exists(DataFlow::Content f | DataFlowPrivate::storeStep(node1, f, node2) |
    DataFlowPrivate::containerContent(f)
  )
}

/**
 * Holds if content `c` is either a field, a synthetic field or language specific
 * content of a relevant type or a container like content.
 */
private predicate isRelevantContent(DataFlow::Content c) {
  isRelevantTypeInContent(c) or
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
 * Gets the summary model of `api`, if it follows the `fluent` programming pattern (returns `this`).
 */
string captureQualifierFlow(DataFlowSummaryTargetApi api) {
  exists(ReturnNodeExt ret |
    api = returnNodeEnclosingCallable(ret) and
    isOwnInstanceAccessNode(ret)
  ) and
  result = Printing::asValueModel(api, qualifierString(), "ReturnValue")
}

private int accessPathLimit0() { result = 2 }

private newtype TTaintState =
  TTaintRead(int n) { n in [0 .. accessPathLimit0()] } or
  TTaintStore(int n) { n in [1 .. accessPathLimit0()] }

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
module PropagateFlowConfig implements DataFlow::StateConfigSig {
  class FlowState = TaintState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof DataFlowSummaryTargetApi and
    state.(TaintRead).getStep() = 0
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof ReturnNodeExt and
    not isOwnInstanceAccessNode(sink) and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    exists(DataFlow::Content c |
      DataFlowImplCommon::store(node1, c, node2, _, _) and
      isRelevantContent(c) and
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

  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

private module PropagateFlow = TaintTracking::GlobalWithState<PropagateFlowConfig>;

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow(DataFlowSummaryTargetApi api) {
  exists(DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt, string input, string output |
    PropagateFlow::flow(p, returnNodeExt) and
    returnNodeExt.(DataFlow::Node).getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = returnNodeExt.getOutput() and
    input != output and
    result = Printing::asTaintModel(api, input, output)
  )
}

/**
 * A dataflow configuration used for finding new sources.
 * The sources are the already known existing sources and the sinks are the API return nodes.
 *
 * This can be used to generate Source summaries for an API, if the API expose an already known source
 * via its return (then the API itself becomes a source).
 */
module PropagateFromSourceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(string kind |
      isRelevantSourceKind(kind) and
      ExternalFlow::sourceNode(source, kind)
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof ReturnNodeExt and
    sink.getEnclosingCallable() instanceof DataFlowSourceTargetApi
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSinkCallContext }

  predicate isBarrier(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }
}

private module PropagateFromSource = TaintTracking::Global<PropagateFromSourceConfig>;

/**
 * Gets the source model(s) of `api`, if there is flow from an existing known source to the return of `api`.
 */
string captureSource(DataFlowSourceTargetApi api) {
  exists(DataFlow::Node source, ReturnNodeExt sink, string kind |
    PropagateFromSource::flow(source, sink) and
    ExternalFlow::sourceNode(source, kind) and
    api = sink.getEnclosingCallable() and
    not irrelevantSourceSinkApi(source.getEnclosingCallable(), api) and
    result = Printing::asSourceModel(api, sink.getOutput(), kind)
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
  predicate isSource(DataFlow::Node source) {
    apiSource(source) and source.getEnclosingCallable() instanceof DataFlowSinkTargetApi
  }

  predicate isSink(DataFlow::Node sink) {
    exists(string kind | isRelevantSinkKind(kind) and ExternalFlow::sinkNode(sink, kind))
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(Type t | t = node.getType() and not isRelevantType(t))
    or
    sinkModelSanitizer(node)
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }
}

private module PropagateToSink = TaintTracking::Global<PropagateToSinkConfig>;

/**
 * Gets the sink model(s) of `api`, if there is flow from a parameter to an existing known sink.
 */
string captureSink(DataFlowSinkTargetApi api) {
  exists(DataFlow::Node src, DataFlow::Node sink, string kind |
    PropagateToSink::flow(src, sink) and
    ExternalFlow::sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    result = Printing::asSinkModel(api, asInputArgument(src), kind)
  )
}
