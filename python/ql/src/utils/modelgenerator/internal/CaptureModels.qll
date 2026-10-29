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
private import semmle.python.dataflow.new.TaintTracking
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl
private import modeling.ModelEditor
private import modeling.Util as ModelEditorUtil
// Concepts
private import semmle.python.Concepts
private import semmle.python.security.dataflow.CodeInjectionCustomizations
private import semmle.python.security.dataflow.ServerSideRequestForgeryCustomizations
private import semmle.python.security.dataflow.UnsafeDeserializationCustomizations

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

  private predicate relevant(Callable api) {
    api.(DataFlowCallable).getScope() instanceof ModelEditorUtil::RelevantScope
  }

  predicate isUninterestingForDataFlowModels(Callable api) { none() }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) { none() }

  private predicate hasManualSourceModel(Callable api) {
    exists(Endpoint endpoint |
      endpoint = api.(DataFlowCallable).getScope() and
      ExternalFlow::sourceModel(endpoint.getNamespace(), _, endpoint.getKind(), _)
    )
    or
    api.(DataFlowCallable).getScope() = any(ActiveThreatModelSource ats).getScope()
  }

  private predicate hasManualSinkModel(Callable api) {
    exists(Endpoint endpoint |
      endpoint = api.(DataFlowCallable).getScope() and
      ExternalFlow::sinkModel(endpoint.getNamespace(), _, endpoint.getKind(), _)
    )
  }

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi {
    SinkTargetApi() { not hasManualSinkModel(this) }
  }

  class SourceTargetApi extends SourceOrSinkTargetApi {
    SourceTargetApi() { not hasManualSourceModel(this) }
  }

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

  string qualifierString() { result = "Argument[self]" }

  private string parameterMad(Parameter p) {
    exists(P::Parameter param |
      param = p.getParameter() and
      (
        not param.isSelf() and
        result = "Argument[" + param.getPosition().toString() + "," + param.getName() + ":]"
      )
    )
  }

  string parameterAccess(Parameter p) { result = parameterMad(p) }

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

  predicate sinkModelSanitizer(DataFlow::Node node) {
    // Any Sanitizer
    node instanceof Escaping
  }

  predicate apiSource(DataFlow::Node source) {
    // TODO: Non-Function Parameter support
    source instanceof DataFlow::ParameterNode
  }

  predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

  string getInputArgument(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    result = parameterMad(source)
  }

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

  private string modelEndpoint(Endpoint endpoint) {
    endpoint.getKind() = ["Function", "StaticMethod"] and
    (
      endpoint.getClass() != "" and
    result =
      "Member[" + endpoint.getClass().replaceAll(".", "].Member[") + "].Member[" +
        endpoint.getFunctionName() + "]"
      or
      endpoint.getClass() = "" and
      result = "Member[" + endpoint.getFunctionName() + "]"
    )
    or
    endpoint.getKind() = ["InstanceMethod", "ClassMethod", "InitMethod"] and
    result =
      "Member[" + endpoint.getClass().replaceAll(".", "].Member[") + "].Instance.Member[" +
        endpoint.getFunctionName() + "]"
  }

  string partialModelRow(Callable api, int i) {
    exists(Endpoint e |
      e = api.(DataFlowFunction).getScope() and
      (
        i = 0 and result = e.getNamespace()
        or
        i = 1 and
        result = modelEndpoint(e)
      )
    )
  }

  string partialNeutralModelRow(Callable api, int i) { result = partialModelRow(api, i) }

  /**
   *  Holds if the given node is a source node of the given kind.
   */
  predicate sourceNode(DataFlow::Node node, string kind) {
    exists(ThreatModelSource tms |
      node.getScope() = tms.getScope() and
      kind = tms.getThreatModel()
    )
  }

  /**
   *  Holds if the given node is a sink node of the given kind.
   */
  predicate sinkNode(DataFlow::Node node, string kind) {
    // Command Injection
    node = any(SystemCommandExecution sce).getCommand() and
    kind = "command-injection"
    or
    // Code Injection
    node = any(CodeInjection::Sink ci) and
    kind = "code-injection"
    or
    // Unsafe Deserialization
    node = any(UnsafeDeserialization::Sink ud) and
    kind = "unsafe-deserialization"
    or
    // SQL Injection
    node = any(SqlExecution sql).getSql() and
    kind = "sql-injection"
    or
    // File
    node = any(FileSystemAccess fcs).getAPathArgument() and
    kind = "path-injection"
    or
    // Template Injection
    node = any(TemplateConstruction tc).getSourceArg() and
    kind = "template-injection"
    or
    // Server Side Request Forgery
    node = any(ServerSideRequestForgery::Sink ssrf).getRequest() and
    kind = "request-forgery"
  }
}

import MakeModelGenerator<P::Location, PythonDataFlow, PythonTaintTracking, ModelGeneratorInput>
