/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import codeql.util.Unit
private import python as P
// DataFlow
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowImpl
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.dataflow.new.internal.DataFlowImplSpecific
private import semmle.python.dataflow.new.internal.TaintTrackingImplSpecific
// ApiGraph
private import semmle.python.frameworks.data.internal.ApiGraphModels as ExternalFlow
private import semmle.python.dataflow.new.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl
private import modeling.ModelEditor

module ModelGeneratorInput implements ModelGeneratorInputSig<P::Location, PythonDataFlow> {
  class Type = Unit;

  class Parameter = DataFlow::ParameterNode;

  class Callable instanceof DataFlowCallable {
    string toString() { result = super.toString() }
  }

  class NodeExtended extends DataFlow::Node {
    Callable getAsExprEnclosingCallable() { result = this.getEnclosingCallable() }

    Type getType() { any() }

    override Callable getEnclosingCallable() { result = super.getEnclosingCallable() }

    Parameter asParameter() { result = this }
  }

  private predicate relevant(Callable api) { any() }

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

  Type getUnderlyingContentType(DataFlow::ContentSet c) { result = any(Type t) and exists(c) }

  string qualifierString() { result = "Argument[this]" }

  string parameterAccess(Parameter p) {
    result = "Argument[" + p.getParameter().getName() + "]"
    or
    not exists(p.getParameter().getName()) and
    result = "Argument[" + p.getParameter().getPosition().toString() + "]"
  }

  string parameterContentAccess(Parameter p) { result = "Argument[]" }

  class InstanceParameterNode extends DataFlow::ParameterNode {
    InstanceParameterNode() { this.getParameter().isSelf() }
  }

  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, ParameterPosition pos) {
    result = parameterAccess(c.(DataFlowCallable).getParameter(pos))
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
    result = parameterContentAccess(c.(DataFlowCallable).getParameter(pos))
    or
    pos.isSelf() and result = qualifierString()
  }

  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    // TODO: Check if we need the complexity of the Java implementation.
    result = DataFlowImplCommon::getNodeEnclosingCallable(ret)
  }

  predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) { none() }

  predicate sinkModelSanitizer(DataFlow::Node node) { none() }

  predicate apiSource(DataFlow::Node source) { none() }

  predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

  string getInputArgument(DataFlow::Node source) { result = "getInputArgument(" + source + ")" }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) {
    not kind = "log-injection" and
    not kind.matches("regex-use%") and
    not kind = "file-content-store"
  }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  predicate containerContent(DataFlow::ContentSet c) {
    // TODO
    any()
  }

  predicate isAdditionalContentFlowStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  predicate isField(DataFlow::ContentSet c) { any() }

  predicate isCallback(DataFlow::ContentSet c) { none() }

  string getSyntheticName(DataFlow::ContentSet c) { none() }

  string printContent(DataFlow::ContentSet c) { result = c.toString() }

  string partialModelRow(Callable api, int i) {
    exists(Endpoint e | e = api.(DataFlowFunction).getScope() |
      i = 0 and result = e.getNamespace() + "." + e.getClass()
      or
      i = 1 and result = "Member[" + e.getFunctionName() + "]"
    )
  }

  string partialNeutralModelRow(Callable api, int i) { result = partialModelRow(api, i) }

  // TODO: Implement this when we want to generate sources.
  predicate sourceNode(DataFlow::Node node, string kind) { none() }

  // TODO: Implement this when we want to generate sinks.
  predicate sinkNode(DataFlow::Node node, string kind) { none() }
}

import MakeModelGenerator<P::Location, PythonDataFlow, PythonTaintTracking, ModelGeneratorInput>
