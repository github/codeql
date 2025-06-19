private import codeql.util.Unit
private import rust as R
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl as DataFlowImpl
private import codeql.rust.dataflow.internal.Node as Node
private import codeql.rust.dataflow.internal.Content
private import codeql.rust.dataflow.FlowSource as FlowSource
private import codeql.rust.dataflow.FlowSink as FlowSink
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl
private import codeql.rust.dataflow.internal.FlowSummaryImpl as FlowSummary

private newtype TCallable =
  TFunction(R::Function api, string path) {
    path = api.getCanonicalPath() and
    (
      // This excludes closures (these are not exported API endpoints) and
      // functions without a `pub` visibility. A function can be `pub` without
      // ultimately being exported by a crate, so this is an overapproximation.
      api.hasVisibility()
      or
      // If a method implements a public trait it is exposed through the trait.
      // We overapproximate this by including all trait method implementations.
      exists(R::Impl impl | impl.hasTrait() and impl.getAssocItemList().getAssocItem(_) = api)
    )
  }

class QualifiedCallable extends TCallable {
  R::Function api;
  string path;

  QualifiedCallable() { this = TFunction(api, path) }

  string toString() { result = path }

  R::Function asFunction() { result = api }

  string getCanonicalPath() { result = path }
}

module ModelGeneratorCommonInput implements
  ModelGeneratorCommonInputSig<R::Location, DataFlowImpl::RustDataFlow>
{
  // NOTE: We are not using type information for now.
  class Type = Unit;

  class Parameter = R::ParamBase;

  class Callable = QualifiedCallable;

  class NodeExtended extends DataFlow::Node {
    Type getType() { any() }
  }

  QualifiedCallable getEnclosingCallable(NodeExtended node) {
    result.asFunction() = node.(Node::Node).getEnclosingCallable().asCfgScope()
  }

  predicate isRelevantType(Type t) { any() }

  /**
   * Gets the underlying type of the content `c`.
   */
  Type getUnderlyingContentType(DataFlow::ContentSet c) { result = any(Type t) and exists(c) }

  string qualifierString() { result = "Argument[self]" }

  string parameterExactAccess(R::ParamBase p) {
    result =
      "Argument[" + any(DataFlowImpl::ParameterPosition pos | p = pos.getParameterIn(_)).toString() +
        "]"
  }

  string parameterApproximateAccess(R::ParamBase p) { result = parameterExactAccess(p) }

  class InstanceParameterNode extends DataFlow::ParameterNode {
    InstanceParameterNode() { this.asParameter() instanceof R::SelfParam }
  }

  bindingset[c]
  string paramReturnNodeAsApproximateOutput(QualifiedCallable c, DataFlowImpl::ParameterPosition pos) {
    result = paramReturnNodeAsExactOutput(c, pos)
  }

  bindingset[c]
  string paramReturnNodeAsExactOutput(QualifiedCallable c, DataFlowImpl::ParameterPosition pos) {
    result = parameterExactAccess(c.asFunction().getParam(pos.getPosition()))
    or
    pos.isSelf() and result = qualifierString()
  }

  QualifiedCallable returnNodeEnclosingCallable(DataFlow::Node ret) {
    result.asFunction() = ret.(Node::Node).getEnclosingCallable().asCfgScope()
  }

  predicate isOwnInstanceAccessNode(DataFlowImpl::RustDataFlow::ReturnNode node) {
    // This is probably not relevant to implement for Rust, as we only use
    // `captureMixedFlow` which doesn't explicitly distinguish between
    // functions that return `self` and those that don't.
    none()
  }

  predicate containerContent(DataFlow::ContentSet c) {
    c.(SingletonContentSet).getContent() instanceof ElementContent
  }

  string partialModelRow(Callable api, int i) { i = 0 and result = api.getCanonicalPath() }

  string partialNeutralModelRow(Callable api, int i) { result = partialModelRow(api, i) }
}

private import ModelGeneratorCommonInput
private import MakeModelGeneratorFactory<R::Location, DataFlowImpl::RustDataFlow, RustTaintTracking, ModelGeneratorCommonInput>

private module SummaryModelGeneratorInput implements SummaryModelGeneratorInputSig {
  class SummaryTargetApi extends QualifiedCallable {
    QualifiedCallable lift() { result = this }

    predicate isRelevant() { any() }
  }

  QualifiedCallable getAsExprEnclosingCallable(NodeExtended node) {
    result.asFunction() = node.asExpr().getScope()
  }

  Parameter asParameter(NodeExtended node) { result = node.asParameter() }

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
    exists(Content c | cs = DataFlowImpl::TSingletonContentSet(c) |
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
}

private module SourceModelGeneratorInput implements SourceModelGeneratorInputSig {
  class SourceTargetApi extends QualifiedCallable { }

  predicate sourceNode(DataFlow::Node node, string kind) { FlowSource::sourceNode(node, kind) }
}

private module SinkModelGeneratorInput implements SinkModelGeneratorInputSig {
  class SinkTargetApi extends QualifiedCallable { }

  /**
   * Holds if `source` is an API entrypoint, i.e., a source of input where data
   * can flow in to a library. This is used for creating sink models, as we
   * only want to mark functions as sinks if input to the function can reach
   * (from an input source) a known sink.
   */
  predicate apiSource(DataFlow::Node source) { source instanceof DataFlow::ParameterNode }

  string getInputArgument(DataFlow::Node source) {
    result = "Argument[" + source.(Node::SourceParameterNode).getPosition().toString() + "]"
  }

  predicate sinkNode(DataFlow::Node node, string kind) { FlowSink::sinkNode(node, kind) }
}

import MakeSummaryModelGenerator<SummaryModelGeneratorInput> as SummaryModels
import MakeSourceModelGenerator<SourceModelGeneratorInput> as SourceModels
import MakeSinkModelGenerator<SinkModelGeneratorInput> as SinkModels
