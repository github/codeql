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

  /**
   * Gets the kind of the return node.
   */
  DataFlowImplCommon::ReturnKindExt getKind() { result = kind }
}

bindingset[c]
private signature string printCallableParamSig(Callable c, ParameterPosition p);

private module PrintReturnNodeExt<printCallableParamSig/2 printCallableParam> {
  string getOutput(ReturnNodeExt node) {
    node.getKind() instanceof DataFlowImplCommon::ValueReturnKind and
    result = "ReturnValue"
    or
    exists(ParameterPosition pos |
      pos = node.getKind().(DataFlowImplCommon::ParamUpdateReturnKind).getPosition() and
      result = printCallableParam(returnNodeEnclosingCallable(node), pos)
    )
  }
}

string getOutput(ReturnNodeExt node) {
  result = PrintReturnNodeExt<paramReturnNodeAsOutput/2>::getOutput(node)
}

string getContentOutput(ReturnNodeExt node) {
  result = PrintReturnNodeExt<paramReturnNodeAsContentOutput/2>::getOutput(node)
}

class DataFlowSummaryTargetApi extends SummaryTargetApi {
  DataFlowSummaryTargetApi() { not isUninterestingForDataFlowModels(this) }
}

class DataFlowSourceTargetApi = SourceTargetApi;

class DataFlowSinkTargetApi = SinkTargetApi;

private module ModelPrintingInput implements ModelPrintingSig {
  class SummaryApi = DataFlowSummaryTargetApi;

  class SourceOrSinkApi = SourceOrSinkTargetApi;

  string getProvenance() { result = "df-generated" }
}

module Printing = ModelPrinting<ModelPrintingInput>;

/**
 * Holds if `c` is a relevant content kind, where the underlying type is relevant.
 */
private predicate isRelevantTypeInContent(DataFlow::ContentSet c) {
  isRelevantType(getUnderlyingContentType(c))
}

/**
 * Holds if data can flow from `node1` to `node2` either via a read or a write of an intermediate field `f`.
 */
private predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::ContentSet f |
    DataFlowPrivate::readStep(node1, f, node2) and
    // Partially restrict the content types used for intermediate steps.
    (not exists(getUnderlyingContentType(f)) or isRelevantTypeInContent(f))
  )
  or
  exists(DataFlow::ContentSet f | DataFlowPrivate::storeStep(node1, f, node2) | containerContent(f))
}

/**
 * Holds if content `c` is either a field, a synthetic field or language specific
 * content of a relevant type or a container like content.
 */
pragma[nomagic]
private predicate isRelevantContent0(DataFlow::ContentSet c) {
  isRelevantTypeInContent(c) or
  containerContent(c)
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
 * Gets the MaD string representation of the parameter `p`
 * when used in content flow.
 */
string parameterNodeAsContentInput(DataFlow::ParameterNode p) {
  result = parameterContentAccess(p.asParameter())
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
  result = Printing::asLiftedValueModel(api, qualifierString(), "ReturnValue")
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
    exists(DataFlow::ContentSet c |
      DataFlowImplCommon::store(node1, c.getAStoreContent(), node2, _, _) and
      isRelevantContent0(c) and
      (
        state1 instanceof TaintRead and state2.(TaintStore).getStep() = 1
        or
        state1.(TaintStore).getStep() + 1 = state2.(TaintStore).getStep()
      )
    )
    or
    exists(DataFlow::ContentSet c |
      DataFlowPrivate::readStep(node1, c, node2) and
      isRelevantContent0(c) and
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

module PropagateFlow = TaintTracking::GlobalWithState<PropagateFlowConfig>;

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow0(
  DataFlowSummaryTargetApi api, DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt
) {
  exists(string input, string output |
    p.getEnclosingCallable() = api and
    returnNodeExt.(DataFlow::Node).getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = getOutput(returnNodeExt) and
    input != output and
    result = Printing::asLiftedTaintModel(api, input, output)
  )
}

/**
 * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
 */
string captureThroughFlow(DataFlowSummaryTargetApi api) {
  exists(DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt |
    PropagateFlow::flow(p, returnNodeExt) and
    result = captureThroughFlow0(api, p, returnNodeExt)
  )
}

private module PropagateContentFlowConfig implements ContentDataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof DataFlowSummaryTargetApi
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof ReturnNodeExt and
    sink.getEnclosingCallable() instanceof DataFlowSummaryTargetApi
  }

  predicate isAdditionalFlowStep = isAdditionalContentFlowStep/2;

  predicate isBarrier(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  int accessPathLimit() { result = 2 }

  predicate isRelevantContent(DataFlow::ContentSet s) { isRelevantContent0(s) }

  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

private module PropagateContentFlow = ContentDataFlow::Global<PropagateContentFlowConfig>;

private string getContent(PropagateContentFlow::AccessPath ap, int i) {
  exists(ContentSet head, PropagateContentFlow::AccessPath tail |
    head = ap.getHead() and
    tail = ap.getTail()
  |
    i = 0 and
    result = "." + printContent(head)
    or
    i > 0 and result = getContent(tail, i - 1)
  )
}

/**
 * Gets the MaD string representation of a store step access path.
 */
private string printStoreAccessPath(PropagateContentFlow::AccessPath ap) {
  result = concat(int i | | getContent(ap, i), "" order by i)
}

/**
 * Gets the MaD string representation of a read step access path.
 */
private string printReadAccessPath(PropagateContentFlow::AccessPath ap) {
  result = concat(int i | | getContent(ap, i), "" order by i desc)
}

/**
 * Holds if the access path `ap` contains a field or synthetic field access.
 */
private predicate mentionsField(PropagateContentFlow::AccessPath ap) {
  exists(ContentSet head, PropagateContentFlow::AccessPath tail |
    head = ap.getHead() and
    tail = ap.getTail()
  |
    mentionsField(tail) or isField(head)
  )
}

private predicate apiFlow(
  DataFlowSummaryTargetApi api, DataFlow::ParameterNode p, PropagateContentFlow::AccessPath reads,
  ReturnNodeExt returnNodeExt, PropagateContentFlow::AccessPath stores, boolean preservesValue
) {
  PropagateContentFlow::flow(p, reads, returnNodeExt, stores, preservesValue) and
  returnNodeExt.getEnclosingCallable() = api and
  p.getEnclosingCallable() = api
}

/**
 * A class of APIs relevant for modeling using content flow.
 * The following heuristic is applied:
 * Content flow is only relevant for an API, if
 *    #content flow <= 2 * #parameters + 3
 * If an API produces more content flow, it is likely that
 * 1. Types are not sufficiently constrained leading to a combinatorial
 * explosion in dispatch and thus in the generated summaries.
 * 2. It is a reasonable approximation to use the non-content based flow
 * detection instead, as reads and stores would use a significant
 * part of an objects internal state.
 */
private class ContentDataFlowSummaryTargetApi extends DataFlowSummaryTargetApi {
  ContentDataFlowSummaryTargetApi() {
    count(string input, string output |
      exists(
        DataFlow::ParameterNode p, PropagateContentFlow::AccessPath reads,
        ReturnNodeExt returnNodeExt, PropagateContentFlow::AccessPath stores
      |
        apiFlow(this, p, reads, returnNodeExt, stores, _) and
        input = parameterNodeAsContentInput(p) + printReadAccessPath(reads) and
        output = getContentOutput(returnNodeExt) + printStoreAccessPath(stores)
      )
    ) <= 2 * this.getNumberOfParameters() + 3
  }
}

pragma[nomagic]
private predicate apiContentFlow(
  ContentDataFlowSummaryTargetApi api, DataFlow::ParameterNode p,
  PropagateContentFlow::AccessPath reads, ReturnNodeExt returnNodeExt,
  PropagateContentFlow::AccessPath stores, boolean preservesValue
) {
  PropagateContentFlow::flow(p, reads, returnNodeExt, stores, preservesValue) and
  returnNodeExt.getEnclosingCallable() = api and
  p.getEnclosingCallable() = api
}

/**
 * Holds if any of the content sets in `path` translates into a synthetic field.
 */
private predicate hasSyntheticContent(PropagateContentFlow::AccessPath path) {
  exists(PropagateContentFlow::AccessPath tail, ContentSet head |
    head = path.getHead() and
    tail = path.getTail()
  |
    exists(getSyntheticName(head)) or
    hasSyntheticContent(tail)
  )
}

/**
 * A module containing predicates for validating access paths containing content sets
 * that translates into synthetic fields, when used for generated summary models.
 */
private module AccessPathSyntheticValidation {
  /**
   * Holds if there exists an API that has content flow from `read` (on type `t1`)
   * to `store` (on type `t2`).
   */
  private predicate step(
    Type t1, PropagateContentFlow::AccessPath read, Type t2, PropagateContentFlow::AccessPath store
  ) {
    exists(DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt |
      p.getType() = t1 and
      returnNodeExt.getType() = t2 and
      apiContentFlow(_, p, read, returnNodeExt, store, _)
    )
  }

  /**
   * Holds if there exists an API that has content flow from `read` (on type `t1`)
   * to `store` (on type `t2`), where `read` does not have synthetic content and `store` does.
   *
   * Step A -> Synth.
   */
  private predicate synthPathEntry(
    Type t1, PropagateContentFlow::AccessPath read, Type t2, PropagateContentFlow::AccessPath store
  ) {
    not hasSyntheticContent(read) and
    hasSyntheticContent(store) and
    step(t1, read, t2, store)
  }

  /**
   * Holds if there exists an API that has content flow from `read` (on type `t1`)
   * to `store` (on type `t2`), where `read` has synthetic content
   * and `store` does not.
   *
   * Step Synth -> A.
   */
  private predicate synthPathExit(
    Type t1, PropagateContentFlow::AccessPath read, Type t2, PropagateContentFlow::AccessPath store
  ) {
    hasSyntheticContent(read) and
    not hasSyntheticContent(store) and
    step(t1, read, t2, store)
  }

  /**
   * Holds if there exists a path of steps from `read` to an exit.
   *
   * read ->* Synth -> A
   */
  private predicate reachesSynthExit(Type t, PropagateContentFlow::AccessPath read) {
    synthPathExit(t, read, _, _)
    or
    hasSyntheticContent(read) and
    exists(PropagateContentFlow::AccessPath mid, Type midType |
      hasSyntheticContent(mid) and
      step(t, read, midType, mid) and
      reachesSynthExit(midType, mid.reverse())
    )
  }

  /**
   * Holds if there exists a path of steps from an entry to `store`.
   *
   * A -> Synth ->* store
   */
  private predicate synthEntryReaches(Type t, PropagateContentFlow::AccessPath store) {
    synthPathEntry(_, _, t, store)
    or
    hasSyntheticContent(store) and
    exists(PropagateContentFlow::AccessPath mid, Type midType |
      hasSyntheticContent(mid) and
      step(midType, mid, t, store) and
      synthEntryReaches(midType, mid.reverse())
    )
  }

  /**
   * Holds if at least one of the access paths `read` (on type `t1`) and `store` (on type `t2`)
   * contain content that will be translated into a synthetic field, when being used in
   * a MaD summary model, and if there is a range of APIs, such that
   * when chaining their flow access paths, there exists access paths `A` and `B` where
   * A ->* read -> store ->* B and where `A` and `B` do not contain content that will
   * be translated into a synthetic field.
   *
   * This is needed because we don't want to include summaries that reads from or
   * stores into a "dead" synthetic field.
   *
   * Example:
   * Assume we have a type `t` (in this case `t1` = `t2`) with methods `getX` and
   * `setX`, which gets and sets a private field `X` on `t`.
   * This would lead to the following content flows
   * getX : Argument[this].SyntheticField[t.X] -> ReturnValue.
   * setX : Argument[0] -> Argument[this].SyntheticField[t.X]
   * As the reads and stores are on synthetic fields we should only make summaries
   * if both of these methods exist.
   */
  pragma[nomagic]
  predicate acceptReadStore(
    Type t1, PropagateContentFlow::AccessPath read, Type t2, PropagateContentFlow::AccessPath store
  ) {
    synthPathEntry(t1, read, t2, store) and reachesSynthExit(t2, store.reverse())
    or
    exists(PropagateContentFlow::AccessPath store0 | store0.reverse() = read |
      synthEntryReaches(t1, store0) and synthPathExit(t1, read, t2, store)
      or
      synthEntryReaches(t1, store0) and
      step(t1, read, t2, store) and
      reachesSynthExit(t2, store.reverse())
    )
  }
}

/**
 * Holds, if the API `api` has relevant flow from `read` on `p` to `store` on `returnNodeExt`.
 * Flow is considered relevant,
 * 1. If `read` or `store` do not contain a content set that translates into a synthetic field.
 * 2. If `read` or `store` contain a content set that translates into a synthetic field, and if
 * the synthetic content is "live" on the relevant declaring type.
 */
private predicate apiRelevantContentFlow(
  ContentDataFlowSummaryTargetApi api, DataFlow::ParameterNode p,
  PropagateContentFlow::AccessPath read, ReturnNodeExt returnNodeExt,
  PropagateContentFlow::AccessPath store, boolean preservesValue
) {
  apiContentFlow(api, p, read, returnNodeExt, store, preservesValue) and
  (
    not hasSyntheticContent(read) and not hasSyntheticContent(store)
    or
    AccessPathSyntheticValidation::acceptReadStore(p.getType(), read, returnNodeExt.getType(), store)
  )
}

pragma[nomagic]
private predicate captureContentFlow0(
  ContentDataFlowSummaryTargetApi api, string input, string output, boolean preservesValue,
  boolean lift
) {
  exists(
    DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt, PropagateContentFlow::AccessPath reads,
    PropagateContentFlow::AccessPath stores
  |
    apiRelevantContentFlow(api, p, reads, returnNodeExt, stores, preservesValue) and
    input = parameterNodeAsContentInput(p) + printReadAccessPath(reads) and
    output = getContentOutput(returnNodeExt) + printStoreAccessPath(stores) and
    input != output and
    (if mentionsField(reads) or mentionsField(stores) then lift = false else lift = true)
  )
}

/**
 * Gets the content based summary model(s) of the API `api` (if there is flow from a parameter to
 * the return value or a parameter).
 *
 * Models are lifted to the best type in case the read and store access paths do not
 * contain a field or synthetic field access.
 */
string captureContentFlow(ContentDataFlowSummaryTargetApi api) {
  exists(string input, string output, boolean lift, boolean preservesValue |
    captureContentFlow0(api, input, output, _, lift) and
    preservesValue = max(boolean p | captureContentFlow0(api, input, output, p, lift)) and
    result = Printing::asModel(api, input, output, preservesValue, lift)
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
    result = Printing::asSourceModel(api, getOutput(sink), kind)
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
