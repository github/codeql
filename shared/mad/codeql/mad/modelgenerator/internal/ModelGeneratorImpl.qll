/**
 * INTERNAL: Do not use.
 *
 * Provides classes and predicates related to capturing summary, source,
 * and sink models of the Standard or a 3rd party library.
 */

private import codeql.dataflow.DataFlow
private import codeql.dataflow.TaintTracking as Tt
private import codeql.dataflow.internal.ContentDataFlowImpl
private import codeql.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import codeql.util.Location
private import ModelPrinting

/**
 * Provides language-specific model generator parameters.
 */
signature module ModelGeneratorInputSig<LocationSig Location, InputSig<Location> Lang> {
  /**
   * A Type.
   */
  class Type;

  /**
   * A Parameter.
   */
  class Parameter;

  /**
   * A Callable.
   */
  class Callable {
    /**
     * Gets a string representation of this callable.
     */
    string toString();
  }

  /**
   * A node.
   */
  class NodeExtended extends Lang::Node {
    /**
     * Gets the type of this node.
     */
    Type getType();

    /**
     * Gets the enclosing callable of this node.
     */
    Callable getEnclosingCallable();

    /**
     * Gets the enclosing callable of this node, when considered as an expression.
     */
    Callable getAsExprEnclosingCallable();

    /**
     * Gets the parameter corresponding to this node, if any.
     */
    Parameter asParameter();
  }

  /**
   * A class of callables that are potentially relevant for generating summary or
   * neutral models.
   *
   * In the Standard library and 3rd party libraries it is the callables (or callables that have a
   * super implementation) that can be called from outside the library itself.
   */
  class SummaryTargetApi extends Callable {
    /**
     * Gets the callable that a model will be lifted to.
     *
     * The lifted callable is relevant in terms of model
     * generation (this is ensured by `liftedImpl`).
     */
    Callable lift();

    /**
     * Holds if `this` is relevant in terms of model generation.
     */
    predicate isRelevant();
  }

  /**
   * A class of callables that are potentially relevant for generating source or
   * sink models.
   */
  class SourceOrSinkTargetApi extends Callable;

  /**
   * A class of callables that are potentially relevant for generating source models.
   */
  class SourceTargetApi extends SourceOrSinkTargetApi;

  /**
   * A class of callables that are potentially relevant for generating sink models.
   */
  class SinkTargetApi extends SourceOrSinkTargetApi;

  /**
   * An instance parameter node.
   */
  class InstanceParameterNode extends Lang::Node;

  /**
   * Holds for type `t` for fields that are relevant as an intermediate
   * read or write step in the data flow analysis.
   * That is, flow through any data-flow node that does not have a relevant type
   * will be excluded.
   */
  predicate isRelevantType(Type t);

  /**
   * Gets the underlying type of the content `c`.
   */
  Type getUnderlyingContentType(Lang::ContentSet c);

  /**
   * Gets the MaD string representation of the qualifier.
   */
  string qualifierString();

  /**
   * Gets the MaD string representation of the parameter `p`.
   */
  string parameterAccess(Parameter p);

  /**
   * Gets the MaD string representation of the parameter `p`
   * when used in content flow.
   */
  string parameterContentAccess(Parameter p);

  /**
   * Gets the MaD string representation of return through parameter at position
   * `pos` of callable `c`.
   */
  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, Lang::ParameterPosition p);

  /**
   * Gets the MaD string representation of return through parameter at position
   * `pos` of callable `c` when used in content flow.
   */
  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, Lang::ParameterPosition pos);

  /**
   * Gets the enclosing callable of `ret`.
   */
  Callable returnNodeEnclosingCallable(Lang::Node node);

  /**
   * Holds if `node` is an own instance access.
   */
  predicate isOwnInstanceAccessNode(Lang::ReturnNode node);

  /**
   * Holds if `node` is a sanitizer for sink model construction.
   */
  predicate sinkModelSanitizer(Lang::Node node);

  /**
   * Holds if `source` is an api entrypoint relevant for creating sink models.
   */
  predicate apiSource(Lang::Node source);

  /**
   * Gets the MaD input string representation of `source`.
   */
  string getInputArgument(Lang::Node source);

  /**
   * Holds if it is not relevant to generate a source model for `api`, even
   * if flow is detected from a node within `source` to a sink within `api`.
   */
  bindingset[sourceEnclosing, api]
  predicate irrelevantSourceSinkApi(Callable sourceEnclosing, SourceTargetApi api);

  /**
   * Holds if `kind` is a relevant sink kind for creating sink models.
   */
  bindingset[kind]
  predicate isRelevantSinkKind(string kind);

  /**
   * Holds if `kind` is a relevant source kind for creating source models.
   */
  bindingset[kind]
  predicate isRelevantSourceKind(string kind);

  /**
   * Holds if the the content `c` is a container.
   */
  predicate containerContent(Lang::ContentSet c);

  /**
   * Holds if there is a taint step from `node1` to `node2` in content flow.
   */
  predicate isAdditionalContentFlowStep(Lang::Node nodeFrom, Lang::Node nodeTo);

  /**
   * Holds if the content set `c` is field like.
   */
  predicate isField(Lang::ContentSet c);

  /**
   * Holds if the content set `c` is callback like.
   */
  predicate isCallback(Lang::ContentSet c);

  /**
   * Gets the MaD synthetic name string representation for the content set `c`, if any.
   */
  string getSyntheticName(Lang::ContentSet c);

  /**
   * Gets the MaD string representation of the content set `c`.
   */
  string printContent(Lang::ContentSet c);

  /**
   * Holds if it is irrelevant to generate models for `api` based on data flow analysis.
   *
   * This serves as an extra filter for the `relevant` predicate.
   */
  predicate isUninterestingForDataFlowModels(Callable api);

  /**
   * Holds if it is irrelevant to generate models for `api` based on the heuristic
   * (non-content) flow analysis.
   *
   * This serves as an extra filter for the `relevant`
   * and `isUninterestingForDataFlowModels` predicates.
   */
  predicate isUninterestingForHeuristicDataFlowModels(Callable api);

  /**
   * Gets the string representation for the `i`th column in the MaD row for `api`.
   */
  string partialModelRow(Callable api, int i);

  /**
   * Gets the string representation for the `i`th column in the neutral MaD row for `api`.
   */
  string partialNeutralModelRow(Callable api, int i);

  /**
   * Holds if `node` is specified as a source with the given kind in a MaD flow
   * model.
   */
  predicate sourceNode(Lang::Node node, string kind);

  /**
   * Holds if `node` is specified as a sink with the given kind in a MaD flow
   * model.
   */
  predicate sinkNode(Lang::Node node, string kind);
}

module MakeModelGenerator<
  LocationSig Location, InputSig<Location> Lang, Tt::InputSig<Location, Lang> TaintLang,
  ModelGeneratorInputSig<Location, Lang> ModelGeneratorInput>
{
  private module DataFlow {
    import Lang
    import DataFlowMake<Location, Lang>
    import DataFlowImplCommon::MakeImplCommon<Location, Lang>
  }

  private import ModelGeneratorInput
  private import Tt::TaintFlowMake<Location, Lang, TaintLang> as TaintTracking

  private module ModelPrintingLang implements ModelPrintingLangSig {
    class Callable = ModelGeneratorInput::Callable;

    predicate partialModelRow = ModelGeneratorInput::partialModelRow/2;

    predicate partialNeutralModelRow = ModelGeneratorInput::partialNeutralModelRow/2;
  }

  private import ModelPrintingImpl<ModelPrintingLang> as Printing

  final private class NodeExtendedFinal = NodeExtended;

  /**
   * A node from which flow can return to the caller. This is either a regular
   * `ReturnNode` or a `PostUpdateNode` corresponding to the value of a parameter.
   */
  private class ReturnNodeExt extends NodeExtendedFinal {
    private DataFlow::ReturnKindExt kind;

    ReturnNodeExt() {
      kind = DataFlow::getValueReturnPosition(this).getKind() or
      kind = DataFlow::getParamReturnPosition(this, _).getKind()
    }

    /**
     * Gets the kind of the return node.
     */
    DataFlow::ReturnKindExt getKind() { result = kind }
  }

  bindingset[c]
  private signature string printCallableParamSig(Callable c, DataFlow::ParameterPosition p);

  private module PrintReturnNodeExt<printCallableParamSig/2 printCallableParam> {
    string getOutput(ReturnNodeExt node) {
      node.getKind() instanceof DataFlow::ValueReturnKind and
      result = "ReturnValue"
      or
      exists(DataFlow::ParameterPosition pos |
        pos = node.getKind().(DataFlow::ParamUpdateReturnKind).getPosition() and
        result = printCallableParam(returnNodeEnclosingCallable(node), pos)
      )
    }
  }

  private string getOutput(ReturnNodeExt node) {
    result = PrintReturnNodeExt<paramReturnNodeAsOutput/2>::getOutput(node)
  }

  final private class SummaryTargetApiFinal = SummaryTargetApi;

  class DataFlowSummaryTargetApi extends SummaryTargetApiFinal {
    DataFlowSummaryTargetApi() { not isUninterestingForDataFlowModels(this) }
  }

  class DataFlowSourceTargetApi = SourceTargetApi;

  class DataFlowSinkTargetApi = SinkTargetApi;

  private module ModelPrintingInput implements Printing::ModelPrintingSig {
    class SummaryApi = DataFlowSummaryTargetApi;

    class SourceOrSinkApi = SourceOrSinkTargetApi;

    string getProvenance() { result = "df-generated" }
  }

  module ModelPrinting = Printing::ModelPrinting<ModelPrintingInput>;

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
      DataFlow::readStep(node1, f, node2) and
      // Partially restrict the content types used for intermediate steps.
      (not exists(getUnderlyingContentType(f)) or isRelevantTypeInContent(f))
    )
    or
    exists(DataFlow::ContentSet f | DataFlow::storeStep(node1, f, node2) | containerContent(f))
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
    result = parameterAccess(p.(NodeExtended).asParameter())
    or
    result = qualifierString() and p instanceof InstanceParameterNode
  }

  /**
   * Gets the MaD input string representation of `source`.
   */
  string asInputArgument(NodeExtended source) { result = getInputArgument(source) }

  /**
   * Gets the summary model of `api`, if it follows the `fluent` programming pattern (returns `this`).
   */
  private string captureQualifierFlow(DataFlowSummaryTargetApi api) {
    exists(ReturnNodeExt ret |
      api = returnNodeEnclosingCallable(ret) and
      isOwnInstanceAccessNode(ret)
    ) and
    result = ModelPrinting::asLiftedValueModel(api, qualifierString(), "ReturnValue")
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
   * A data flow configuration for tracking flow through APIs.
   * The sources are the parameters of an API and the sinks are the return values (excluding `this`) and parameters.
   *
   * This can be used to generate Flow summaries for APIs from parameter to return.
   */
  module PropagateFlowConfig implements DataFlow::StateConfigSig {
    class FlowState = TaintState;

    predicate isSource(DataFlow::Node source, FlowState state) {
      source instanceof DataFlow::ParameterNode and
      exists(Callable c |
        c = source.(NodeExtended).getEnclosingCallable() and
        c instanceof DataFlowSummaryTargetApi and
        not isUninterestingForHeuristicDataFlowModels(c)
      ) and
      state.(TaintRead).getStep() = 0
    }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      sink instanceof ReturnNodeExt and
      not isOwnInstanceAccessNode(sink) and
      not exists(captureQualifierFlow(sink.(NodeExtended).getAsExprEnclosingCallable())) and
      (state instanceof TaintRead or state instanceof TaintStore)
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
    ) {
      exists(DataFlow::NodeEx n1, DataFlow::NodeEx n2, DataFlow::ContentSet c |
        node1 = n1.asNode() and
        node2 = n2.asNode() and
        DataFlow::storeEx(n1, c.getAStoreContent(), n2, _, _) and
        isRelevantContent0(c) and
        (
          state1 instanceof TaintRead and state2.(TaintStore).getStep() = 1
          or
          state1.(TaintStore).getStep() + 1 = state2.(TaintStore).getStep()
        )
      )
      or
      exists(DataFlow::ContentSet c |
        DataFlow::readStep(node1, c, node2) and
        isRelevantContent0(c) and
        state1.(TaintRead).getStep() + 1 = state2.(TaintRead).getStep()
      )
    }

    predicate isBarrier(DataFlow::Node n) {
      exists(Type t | t = n.(NodeExtended).getType() and not isRelevantType(t))
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
      p.(NodeExtended).getEnclosingCallable() = api and
      returnNodeExt.getEnclosingCallable() = api and
      input = parameterNodeAsInput(p) and
      output = getOutput(returnNodeExt) and
      input != output and
      result = ModelPrinting::asLiftedTaintModel(api, input, output)
    )
  }

  /**
   * Gets the summary model(s) of `api`, if there is flow from parameters to return value or parameter.
   */
  private string captureThroughFlow(DataFlowSummaryTargetApi api) {
    exists(DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt |
      PropagateFlow::flow(p, returnNodeExt) and
      result = captureThroughFlow0(api, p, returnNodeExt)
    )
  }

  /**
   * Gets the summary model(s) of `api`, if there is flow from parameters to the
   * return value or parameter or if `api` is a fluent API.
   */
  string captureFlow(DataFlowSummaryTargetApi api) {
    result = captureQualifierFlow(api) or
    result = captureThroughFlow(api)
  }

  /**
   * Gets the neutral summary model for `api`, if any.
   * A neutral summary model is generated, if we are not generating
   * a summary model that applies to `api`.
   */
  string captureNoFlow(DataFlowSummaryTargetApi api) {
    not exists(DataFlowSummaryTargetApi api0 |
      exists(captureFlow(api0)) and api0.lift() = api.lift()
    ) and
    api.isRelevant() and
    result = ModelPrinting::asNeutralSummaryModel(api)
  }

  /**
   * Provides classes and predicates related to capturing summary models
   * based on content data flow.
   */
  module ContentSensitive {
    private import MakeImplContentDataFlow<Location, Lang> as ContentDataFlow

    private module PropagateContentFlowConfig implements ContentDataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) {
        source instanceof DataFlow::ParameterNode and
        source.(NodeExtended).getEnclosingCallable() instanceof DataFlowSummaryTargetApi
      }

      predicate isSink(DataFlow::Node sink) {
        sink.(ReturnNodeExt).getEnclosingCallable() instanceof DataFlowSummaryTargetApi
      }

      predicate isAdditionalFlowStep = isAdditionalContentFlowStep/2;

      predicate isBarrier(DataFlow::Node n) {
        exists(Type t | t = n.(NodeExtended).getType() and not isRelevantType(t))
      }

      int accessPathLimit() { result = 2 }

      predicate isRelevantContent(DataFlow::ContentSet s) { isRelevantContent0(s) }

      DataFlow::FlowFeature getAFeature() {
        result instanceof DataFlow::FeatureEqualSourceSinkCallContext
      }
    }

    private module PropagateContentFlow = ContentDataFlow::Global<PropagateContentFlowConfig>;

    private module ContentModelPrintingInput implements Printing::ModelPrintingSig {
      class SummaryApi = DataFlowSummaryTargetApi;

      class SourceOrSinkApi = SourceOrSinkTargetApi;

      string getProvenance() { result = "dfc-generated" }
    }

    private module ContentModelPrinting = Printing::ModelPrinting<ContentModelPrintingInput>;

    private string getContentOutput(ReturnNodeExt node) {
      result = PrintReturnNodeExt<paramReturnNodeAsContentOutput/2>::getOutput(node)
    }

    /**
     * Gets the MaD string representation of the parameter `p`
     * when used in content flow.
     */
    private string parameterNodeAsContentInput(DataFlow::ParameterNode p) {
      result = parameterContentAccess(p.(NodeExtended).asParameter())
      or
      result = qualifierString() and p instanceof InstanceParameterNode
    }

    private string getContent(PropagateContentFlow::AccessPath ap, int i) {
      result = "." + printContent(ap.getAtIndex(i))
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
      isField(ap.getAtIndex(_))
    }

    /**
     * Holds if this access path `ap` mentions a callback.
     */
    private predicate mentionsCallback(PropagateContentFlow::AccessPath ap) {
      isCallback(ap.getAtIndex(_))
    }

    /**
     * Holds if the access path `ap` is not a parameter or returnvalue of a callback
     * stored in a field.
     *
     * That is, we currently don't include summaries that rely on parameters or return values
     * of callbacks stored in fields.
     */
    private predicate validateAccessPath(PropagateContentFlow::AccessPath ap) {
      not (mentionsField(ap) and mentionsCallback(ap))
    }

    private predicate apiFlow(
      DataFlowSummaryTargetApi api, DataFlow::ParameterNode p,
      PropagateContentFlow::AccessPath reads, ReturnNodeExt returnNodeExt,
      PropagateContentFlow::AccessPath stores, boolean preservesValue
    ) {
      PropagateContentFlow::flow(p, reads, returnNodeExt, stores, preservesValue) and
      returnNodeExt.getEnclosingCallable() = api and
      p.(NodeExtended).getEnclosingCallable() = api
    }

    /**
     * A class of APIs relevant for modeling using content flow.
     * The following heuristic is applied:
     * Content flow is only relevant for an API on a parameter, if
     *    #content flow from parameter <= 3
     * If an API produces more content flow on a parameter, it is likely that
     * 1. Types are not sufficiently constrained on the parameter leading to a combinatorial
     * explosion in dispatch and thus in the generated summaries.
     * 2. It is a reasonable approximation to use the non-content based flow
     * detection instead, as reads and stores would use a significant
     * part of an objects internal state.
     */
    private class ContentDataFlowSummaryTargetApi extends DataFlowSummaryTargetApi {
      private DataFlow::ParameterNode parameter;

      ContentDataFlowSummaryTargetApi() {
        count(string input, string output |
          exists(
            PropagateContentFlow::AccessPath reads, ReturnNodeExt returnNodeExt,
            PropagateContentFlow::AccessPath stores
          |
            apiFlow(this, parameter, reads, returnNodeExt, stores, _) and
            input = parameterNodeAsContentInput(parameter) + printReadAccessPath(reads) and
            output = getContentOutput(returnNodeExt) + printStoreAccessPath(stores)
          )
        ) <= 3
      }

      /**
       * Gets a parameter node of `this` api, where there are less than 3 possible models, if any.
       */
      DataFlow::ParameterNode getARelevantParameterNode() { result = parameter }
    }

    pragma[nomagic]
    private predicate apiContentFlow(
      ContentDataFlowSummaryTargetApi api, DataFlow::ParameterNode p,
      PropagateContentFlow::AccessPath reads, ReturnNodeExt returnNodeExt,
      PropagateContentFlow::AccessPath stores, boolean preservesValue
    ) {
      PropagateContentFlow::flow(p, reads, returnNodeExt, stores, preservesValue) and
      returnNodeExt.getEnclosingCallable() = api and
      p.(NodeExtended).getEnclosingCallable() = api and
      p = api.getARelevantParameterNode()
    }

    /**
     * Holds if any of the content sets in `path` translates into a synthetic field.
     */
    private predicate hasSyntheticContent(PropagateContentFlow::AccessPath path) {
      exists(getSyntheticName(path.getAtIndex(_)))
    }

    private string getHashAtIndex(PropagateContentFlow::AccessPath ap, int i) {
      result = getSyntheticName(ap.getAtIndex(i))
    }

    private string getReversedHash(PropagateContentFlow::AccessPath ap) {
      result = strictconcat(int i | | getHashAtIndex(ap, i), "." order by i desc)
    }

    private string getHash(PropagateContentFlow::AccessPath ap) {
      result = strictconcat(int i | | getHashAtIndex(ap, i), "." order by i)
    }

    /**
     * Gets all access paths that contain the synthetic fields
     * from `ap` in reverse order (if `ap` contains at least one synthetic field).
     * These are the possible candidates for synthetic path continuations.
     */
    private PropagateContentFlow::AccessPath getSyntheticPathCandidate(
      PropagateContentFlow::AccessPath ap
    ) {
      getHash(ap) = getReversedHash(result)
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
        Type t1, PropagateContentFlow::AccessPath read, Type t2,
        PropagateContentFlow::AccessPath store
      ) {
        exists(DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt |
          p.(NodeExtended).getType() = t1 and
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
        Type t1, PropagateContentFlow::AccessPath read, Type t2,
        PropagateContentFlow::AccessPath store
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
        Type t1, PropagateContentFlow::AccessPath read, Type t2,
        PropagateContentFlow::AccessPath store
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
          reachesSynthExit(midType, getSyntheticPathCandidate(mid))
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
          synthEntryReaches(midType, getSyntheticPathCandidate(mid))
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
       * stores into an "internal" synthetic field.
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
        Type t1, PropagateContentFlow::AccessPath read, Type t2,
        PropagateContentFlow::AccessPath store
      ) {
        synthPathEntry(t1, read, t2, store) and
        reachesSynthExit(t2, getSyntheticPathCandidate(store))
        or
        exists(PropagateContentFlow::AccessPath store0 | getSyntheticPathCandidate(store0) = read |
          synthEntryReaches(t1, store0) and synthPathExit(t1, read, t2, store)
          or
          synthEntryReaches(t1, store0) and
          step(t1, read, t2, store) and
          reachesSynthExit(t2, getSyntheticPathCandidate(store))
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
        AccessPathSyntheticValidation::acceptReadStore(p.(NodeExtended).getType(), read,
          returnNodeExt.getType(), store)
      )
    }

    pragma[nomagic]
    private predicate captureFlow0(
      ContentDataFlowSummaryTargetApi api, string input, string output, boolean preservesValue,
      boolean lift
    ) {
      exists(
        DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt,
        PropagateContentFlow::AccessPath reads, PropagateContentFlow::AccessPath stores
      |
        apiRelevantContentFlow(api, p, reads, returnNodeExt, stores, preservesValue) and
        input = parameterNodeAsContentInput(p) + printReadAccessPath(reads) and
        output = getContentOutput(returnNodeExt) + printStoreAccessPath(stores) and
        input != output and
        validateAccessPath(reads) and
        validateAccessPath(stores) and
        (
          if mentionsField(reads) or mentionsField(stores)
          then lift = false and api.isRelevant()
          else lift = true
        )
      )
    }

    /**
     * Gets the content based summary model(s) of the API `api` (if there is flow from a parameter to
     * the return value or a parameter). `lift` is true, if the model should be lifted, otherwise false.
     *
     * Models are lifted to the best type in case the read and store access paths do not
     * contain a field or synthetic field access.
     */
    string captureFlow(ContentDataFlowSummaryTargetApi api, boolean lift) {
      exists(string input, string output, boolean preservesValue |
        captureFlow0(api, input, output, _, lift) and
        preservesValue = max(boolean p | captureFlow0(api, input, output, p, lift)) and
        result = ContentModelPrinting::asModel(api, input, output, preservesValue, lift)
      )
    }
  }

  /**
   * Gets the summary model(s) for `api`, if any. `lift` is true if the model is lifted
   * otherwise false.
   * The following heuristic is applied:
   * 1. If content based flow yields at lease one summary for an API, then we use that.
   * 2. If content based flow does not yield any summary for an API, then we try and
   * generate flow summaries using the non-content based summary generator.
   */
  string captureMixedFlow(DataFlowSummaryTargetApi api, boolean lift) {
    result = ContentSensitive::captureFlow(api, lift)
    or
    not exists(DataFlowSummaryTargetApi api0 |
      (api0 = api or api.lift() = api0) and
      exists(ContentSensitive::captureFlow(api0, false))
      or
      api0.lift() = api.lift() and
      exists(ContentSensitive::captureFlow(api0, true))
    ) and
    result = captureFlow(api) and
    lift = true
  }

  /**
   * Gets the neutral summary model for `api`, if any.
   * A neutral summary model is generated, if we are not generating
   * a mixed summary model that applies to `api`.
   */
  string captureMixedNeutral(DataFlowSummaryTargetApi api) {
    not exists(DataFlowSummaryTargetApi api0, boolean lift |
      exists(captureMixedFlow(api0, lift)) and
      (
        lift = false and
        (api0 = api or api0 = api.lift())
        or
        lift = true and api0.lift() = api.lift()
      )
    ) and
    api.isRelevant() and
    result = ModelPrinting::asNeutralSummaryModel(api)
  }

  /**
   * A data flow configuration used for finding new sources.
   * The sources are the already known existing sources and the sinks are the API return nodes.
   *
   * This can be used to generate Source summaries for an API, if the API expose an already known source
   * via its return (then the API itself becomes a source).
   */
  module PropagateFromSourceConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists(string kind |
        isRelevantSourceKind(kind) and
        sourceNode(source, kind)
      )
    }

    predicate isSink(DataFlow::Node sink) {
      sink.(ReturnNodeExt).getEnclosingCallable() instanceof DataFlowSourceTargetApi
    }

    DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSinkCallContext }

    predicate isBarrier(DataFlow::Node n) {
      exists(Type t | t = n.(NodeExtended).getType() and not isRelevantType(t))
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
    exists(NodeExtended source, ReturnNodeExt sink, string kind |
      PropagateFromSource::flow(source, sink) and
      sourceNode(source, kind) and
      api = sink.getEnclosingCallable() and
      not irrelevantSourceSinkApi(source.getEnclosingCallable(), api) and
      result = ModelPrinting::asSourceModel(api, getOutput(sink), kind)
    )
  }

  /**
   * A data flow configuration used for finding new sinks.
   * The sources are the parameters of the API and the fields of the enclosing type.
   *
   * This can be used to generate Sink summaries for APIs, if the API propagates a parameter (or enclosing type field)
   * into an existing known sink (then the API itself becomes a sink).
   */
  module PropagateToSinkConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      apiSource(source) and
      source.(NodeExtended).getEnclosingCallable() instanceof DataFlowSinkTargetApi
    }

    predicate isSink(DataFlow::Node sink) {
      exists(string kind | isRelevantSinkKind(kind) and sinkNode(sink, kind))
    }

    predicate isBarrier(DataFlow::Node node) {
      exists(Type t | t = node.(NodeExtended).getType() and not isRelevantType(t))
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
    exists(NodeExtended src, NodeExtended sink, string kind |
      PropagateToSink::flow(src, sink) and
      sinkNode(sink, kind) and
      api = src.getEnclosingCallable() and
      result = ModelPrinting::asSinkModel(api, asInputArgument(src), kind)
    )
  }
}
