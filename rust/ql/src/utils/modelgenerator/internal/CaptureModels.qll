private import codeql.util.Unit
private import rust
private import rust as R
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.Node as Node
private import codeql.rust.dataflow.internal.Content
private import codeql.rust.dataflow.FlowSource as FlowSource
private import codeql.rust.dataflow.FlowSink as FlowSink
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl
private import codeql.rust.dataflow.internal.FlowSummaryImpl as FlowSummary

module ModelGeneratorInput implements ModelGeneratorInputSig<Location, RustDataFlow> {
  // NOTE: We are not using type information for now.
  class Type = Unit;

  class Parameter = R::ParamBase;

  class Callable = R::Callable;

  class NodeExtended extends DataFlow::Node {
    Type getType() { any() }
  }

  Callable getAsExprEnclosingCallable(NodeExtended node) { result = node.asExpr().getScope() }

  Callable getEnclosingCallable(NodeExtended node) {
    result = node.(Node::Node).getEnclosingCallable().asCfgScope()
  }

  Parameter asParameter(NodeExtended node) { result = node.asParameter() }

  private predicate relevant(Function api) {
    // Only include functions that have a resolved path.
    api.hasCrateOrigin() and
    api.hasExtendedCanonicalPath() and
    (
      // This excludes closures (these are not exported API endpoints) and
      // functions without a `pub` visiblity. A function can be `pub` without
      // ultimately being exported by a crate, so this is an overapproximation.
      api.hasVisibility()
      or
      // If a method implements a public trait it is exposed through the trait.
      // We overapproximate this by including all trait method implementations.
      exists(Impl impl | impl.hasTrait() and impl.getAssocItemList().getAssocItem(_) = api)
    )
  }

  predicate isUninterestingForDataFlowModels(Callable api) { none() }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) { none() }

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi { }

  class SourceTargetApi extends SourceOrSinkTargetApi { }

  class SummaryTargetApi extends Callable {
    private Callable lift;

    SummaryTargetApi() {
      lift = this and
      relevant(this)
    }

    Callable lift() { result = lift }

    predicate isRelevant() { relevant(this) }
  }

  predicate isRelevantType(Type t) { any() }

  /**
   * Gets the underlying type of the content `c`.
   */
  Type getUnderlyingContentType(DataFlow::ContentSet c) { result = any(Type t) and exists(c) }

  string qualifierString() { result = "Argument[self]" }

  string parameterAccess(R::ParamBase p) {
    result = "Argument[" + any(ParameterPosition pos | p = pos.getParameterIn(_)).toString() + "]"
  }

  string parameterContentAccess(R::ParamBase p) { result = parameterAccess(p) }

  class InstanceParameterNode extends DataFlow::ParameterNode {
    InstanceParameterNode() { this.asParameter() instanceof SelfParam }
  }

  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, ParameterPosition pos) {
    result = paramReturnNodeAsContentOutput(c, pos)
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
    result = parameterContentAccess(c.getParamList().getParam(pos.getPosition()))
    or
    pos.isSelf() and result = qualifierString()
  }

  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    result = ret.(Node::Node).getEnclosingCallable().asCfgScope()
  }

  predicate isOwnInstanceAccessNode(RustDataFlow::ReturnNode node) {
    // This is probably not relevant to implement for Rust, as we only use
    // `captureMixedFlow` which doesn't explicitly distinguish between
    // functions that return `self` and those that don't.
    none()
  }

  predicate sinkModelSanitizer(DataFlow::Node node) { none() }

  /**
   * Holds if `source` is an API entrypoint, i.e., a source of input where data
   * can flow in to a library. This is used for creating sink models, as we
   * only want to mark functions as sinks if input to the function can reach
   * (from an input source) a known sink.
   */
  predicate apiSource(DataFlow::Node source) { source instanceof DataFlow::ParameterNode }

  bindingset[sourceEnclosing, api]
  predicate irrelevantSourceSinkApi(Callable sourceEnclosing, SourceTargetApi api) { none() }

  string getInputArgument(DataFlow::Node source) {
    result = "Argument[" + source.(Node::SourceParameterNode).getPosition().toString() + "]"
  }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) { any() }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  predicate containerContent(DataFlow::ContentSet c) {
    c.(SingletonContentSet).getContent() instanceof ElementContent
  }

  predicate isAdditionalContentFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }

  predicate isField(DataFlow::ContentSet c) {
    c.(SingletonContentSet).getContent() instanceof FieldContent
  }

  predicate isCallback(DataFlow::ContentSet cs) {
    exists(Content c | c = cs.(SingletonContentSet).getContent() |
      c instanceof FunctionCallReturnContent or
      c instanceof FunctionCallArgumentContent
    )
  }

  string getSyntheticName(DataFlow::ContentSet c) { none() }

  private string encodeContent(ContentSet cs, string arg) {
    result = FlowSummary::Input::encodeContent(cs, arg)
    or
    exists(Content c | cs = TSingletonContentSet(c) |
      exists(int pos |
        pos = c.(FunctionCallArgumentContent).getPosition() and
        result = "Parameter" and
        arg = pos.toString()
      )
      or
      c instanceof FunctionCallReturnContent and result = "ReturnValue" and arg = ""
    )
  }

  string printContent(DataFlow::ContentSet cs) {
    exists(string name, string arg |
      name = encodeContent(cs, arg) and
      if arg = "" then result = name else result = name + "[" + arg + "]"
    )
  }

  string partialModelRow(Callable api, int i) {
    i = 0 and result = api.(Function).getCrateOrigin() // crate
    or
    i = 1 and result = api.(Function).getExtendedCanonicalPath() // name
  }

  string partialNeutralModelRow(Callable api, int i) { result = partialModelRow(api, i) }

  predicate sourceNode(DataFlow::Node node, string kind) { FlowSource::sourceNode(node, kind) }

  predicate sinkNode(DataFlow::Node node, string kind) { FlowSink::sinkNode(node, kind) }
}

import MakeModelGenerator<Location, RustDataFlow, RustTaintTracking, ModelGeneratorInput>
