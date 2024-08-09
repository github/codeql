/**
 * Provides classes for contributing a model, or using the interpreted results
 * of a model represented as data.
 *
 * - Use the `ModelInput` module to contribute new models.
 * - Use the `ModelOutput` module to access the model results in terms of API nodes.
 *
 * The `package` part of a CSV row should be the name of a Ruby gem, or the empty
 * string if it's referring to the standard library.
 *
 * The `type` part can be one of the following:
 *   - the empty string, referring to the global scope,
 *   - the string `any`, referring to any expression, or
 *   - the name of a type definition from `ModelInput::TypeModelCsv`
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import internal.ApiGraphModels as Shared
private import internal.ApiGraphModelsSpecific as Specific
import Shared::ModelInput as ModelInput
import Shared::ModelOutput as ModelOutput
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.FlowSummary

/**
 * A remote flow source originating from a CSV source row.
 */
private class RemoteFlowSourceFromCsv extends RemoteFlowSource::Range {
  RemoteFlowSourceFromCsv() { this = ModelOutput::getASourceNode("remote").asSource() }

  override string getSourceType() { result = "Remote flow (from model)" }
}

private class SummarizedCallableFromModel extends SummarizedCallable {
  string type;
  string path;

  SummarizedCallableFromModel() {
    ModelOutput::relevantSummaryModel(type, path, _, _, _, _) and
    this = type + ";" + path
  }

  override Call getACall() {
    exists(API::MethodAccessNode base |
      ModelOutput::resolvedSummaryBase(type, path, base) and
      result = base.asCall().asExpr().getExpr()
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    exists(string kind | ModelOutput::relevantSummaryModel(type, path, input, output, kind, model) |
      kind = "value" and
      preservesValue = true
      or
      kind = "taint" and
      preservesValue = false
    )
  }
}

/**
 * Specifies which parts of the API graph to export in `ModelExport`.
 */
signature module ModelExportSig {
  /**
   * Holds if the exported model should contain `node`, if it is publicly accessible.
   *
   * This ensures that all ways to access `node` will be exported in type models.
   */
  predicate shouldContain(API::Node node);

  /**
   * Holds if a named must be generated for `node` if it is to be included in the exported graph.
   */
  default predicate mustBeNamed(API::Node node) { none() }

  /**
   * Holds if the exported model should preserve all paths leading to an instance of `type`,
   * including partial ones. It does not need to be closed transitively, `ModelExport` will
   * extend this to include type models from which `type` can be derived.
   */
  default predicate shouldContainType(string type) { none() }
}

/**
 * Module for exporting type models for a given set of nodes in the API graph.
 */
module ModelExport<ModelExportSig S> {
  private import codeql.mad.dynamic.GraphExport
  private import internal.ApiGraphModelsExport

  private module GraphExportConfig implements GraphExportSig<Location, API::Node> {
    predicate edge = Specific::apiGraphHasEdge/3;

    predicate shouldContain = S::shouldContain/1;

    predicate shouldNotContain(API::Node node) {
      // Only export def-nodes, exclude use-nodes
      node instanceof API::Internal::MkModuleObjectDown
      or
      node instanceof API::Internal::MkModuleInstanceDown
      or
      node instanceof API::Internal::MkForwardNode
      or
      node instanceof API::Internal::MkMethodAccessNode
    }

    predicate mustBeNamed(API::Node node) { S::mustBeNamed(node) }

    predicate exposedName(API::Node node, string type, string path) {
      path = "" and
      exists(DataFlow::ModuleNode mod |
        node = API::Internal::MkModuleObjectUp(mod) and
        type = mod.getQualifiedName() + "!"
        or
        node = API::Internal::MkModuleInstanceUp(mod) and
        type = mod.getQualifiedName()
      )
    }

    private string suggestedMethodName(DataFlow::MethodNode method) {
      exists(DataFlow::ModuleNode mod, string name |
        method = mod.getOwnSingletonMethod(name) and
        result = mod.getQualifiedName() + "." + name
        or
        method = mod.getOwnInstanceMethod(name) and
        result = mod.getQualifiedName() + "#" + name
      )
    }

    predicate suggestedName(API::Node node, string type) {
      // exists(DataFlow::MethodNode method |
      //   node.asSink() = method.getAReturnNode() and type = suggestedMethodName(method) + "()"
      // )
      none()
    }

    bindingset[host]
    predicate hasTypeSummary(API::Node host, string path) {
      exists(string methodName |
        methodReturnsReceiver(host.getMethod(methodName).asCallable()) and
        path = "Method[" + methodName + "].ReturnValue"
      )
    }

    pragma[nomagic]
    private predicate methodReturnsReceiver(DataFlow::MethodNode func) {
      getAReceiverRef(func).flowsTo(func.getAReturnNode())
    }

    pragma[nomagic]
    private DataFlow::CallNode getAReceiverCall(DataFlow::MethodNode func) {
      result = getAReceiverRef(func).getAMethodCall()
    }

    pragma[nomagic]
    private predicate callReturnsReceiver(DataFlow::CallNode call) {
      methodReturnsReceiver(call.getATarget())
    }

    pragma[nomagic]
    private DataFlow::LocalSourceNode getAReceiverRef(DataFlow::MethodNode func) {
      result = func.getSelfParameter()
      or
      result = getAReceiverCall(func) and
      callReturnsReceiver(result)
    }
  }

  private module ExportedGraph = TypeGraphExport<GraphExportConfig, S::shouldContainType/1>;

  import ExportedGraph
}
