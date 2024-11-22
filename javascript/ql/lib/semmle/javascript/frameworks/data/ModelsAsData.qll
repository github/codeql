/**
 * Provides classes for contributing a model, or using the interpreted results
 * of a model represented as data.
 *
 * - Use the `ModelInput` module to contribute new models.
 * - Use the `ModelOutput` module to access the model results in terms of API nodes.
 *
 * The package name refers to an NPM package name or a path within a package name such as `lodash/extend`.
 * The string `global` refers to the global object (whether it came from the `global` package or not).
 *
 * A `(package, type)` tuple may refer to the exported type named `type` from the NPM package `package`.
 * For example, `(express, Request)` would match a parameter below due to the type annotation:
 * ```ts
 * import * as express from 'express';
 * export function handler(req: express.Request) { ... }
 * ```
 */

private import javascript
private import internal.ApiGraphModels as Shared
private import internal.ApiGraphModelsSpecific as Specific
private import semmle.javascript.endpoints.EndpointNaming as EndpointNaming
import Shared::ModelInput as ModelInput
import Shared::ModelOutput as ModelOutput

/**
 * A remote flow source originating from a MaD source row.
 */
private class RemoteFlowSourceFromMaD extends RemoteFlowSource {
  RemoteFlowSourceFromMaD() { this = ModelOutput::getASourceNode("remote").asSource() }

  override string getSourceType() { result = "Remote flow" }
}

/**
 * A threat-model flow source originating from a data extension.
 */
private class ThreatModelSourceFromDataExtension extends ThreatModelSource::Range {
  ThreatModelSourceFromDataExtension() { this = ModelOutput::getASourceNode(_).asSource() }

  override string getThreatModel() { this = ModelOutput::getASourceNode(result).asSource() }

  override string getSourceType() {
    result = "Source node (" + this.getThreatModel() + ") [from data-extension]"
  }
}

/**
 * Like `ModelOutput::summaryStep` but with API nodes mapped to data-flow nodes.
 */
private predicate summaryStepNodes(DataFlow::Node pred, DataFlow::Node succ, string kind) {
  exists(API::Node predNode, API::Node succNode |
    Specific::summaryStep(predNode, succNode, kind) and
    pred = predNode.asSink() and
    succ = succNode.asSource()
  )
}

/** Data flow steps induced by summary models of kind `value`. */
private class DataFlowStepFromSummary extends DataFlow::SharedFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    summaryStepNodes(pred, succ, "value")
  }
}

/** Taint steps induced by summary models of kind `taint`. */
private class TaintStepFromSummary extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    summaryStepNodes(pred, succ, "taint")
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
   * Holds if `node` must be named if it is part of the exported graph.
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
      EndpointNaming::isPrivateLike(node)
      or
      node instanceof API::Use
    }

    predicate mustBeNamed(API::Node node) {
      node.getAValueReachingSink() instanceof DataFlow::ClassNode
      or
      node = API::Internal::getClassInstance(_)
      or
      S::mustBeNamed(node)
    }

    predicate exposedName(API::Node node, string type, string path) {
      exists(string moduleName |
        node = API::moduleExport(moduleName) and
        path = "" and
        type = "(" + moduleName + ")"
      )
    }

    predicate suggestedName(API::Node node, string type) {
      exists(string package, string name |
        (
          EndpointNaming::sinkHasPrimaryName(node, package, name) and
          not EndpointNaming::aliasDefinition(_, _, _, _, node)
          or
          EndpointNaming::aliasDefinition(_, _, package, name, node)
        ) and
        type = EndpointNaming::renderName(package, name)
      )
    }

    bindingset[host]
    predicate hasTypeSummary(API::Node host, string path) {
      exists(string methodName |
        functionReturnsReceiver(host.getMember(methodName).getAValueReachingSink()) and
        path = "Member[" + methodName + "].ReturnValue"
      )
    }

    pragma[nomagic]
    private predicate functionReturnsReceiver(DataFlow::FunctionNode func) {
      getAReceiverRef(func).flowsTo(func.getReturnNode())
    }

    pragma[nomagic]
    private DataFlow::MethodCallNode getAReceiverCall(DataFlow::FunctionNode func) {
      result = getAReceiverRef(func).getAMethodCall()
    }

    pragma[nomagic]
    private predicate callReturnsReceiver(DataFlow::MethodCallNode call) {
      functionReturnsReceiver(call.getACallee().flow())
    }

    pragma[nomagic]
    private DataFlow::SourceNode getAReceiverRef(DataFlow::FunctionNode func) {
      result = func.getReceiver()
      or
      result = getAReceiverCall(func) and
      callReturnsReceiver(result)
    }
  }

  private module ExportedGraph = TypeGraphExport<GraphExportConfig, S::shouldContainType/1>;

  import ExportedGraph
}
