/**
 * Provides classes for contributing a model, or using the interpreted results
 * of a model represented as data.
 *
 * - Use the `ModelInput` module to contribute new models.
 * - Use the `ModelOutput` module to access the model results in terms of API nodes.
 *
 * The package name refers to the top-level module the import comes from, and not a PyPI package.
 * So for `from foo.bar import baz`, the package will be `foo`.
 */

private import python
private import internal.ApiGraphModels as Shared
private import internal.ApiGraphModelsSpecific as Specific
import Shared::ModelInput as ModelInput
import Shared::ModelOutput as ModelOutput
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.Concepts

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

private class SummarizedCallableFromModel extends SummarizedCallable {
  string type;
  string path;

  SummarizedCallableFromModel() {
    ModelOutput::relevantSummaryModel(type, path, _, _, _, _) and
    this = type + ";" + path
  }

  override DataFlow::CallCfgNode getACall() { ModelOutput::resolvedSummaryBase(type, path, result) }

  override DataFlow::ArgumentNode getACallback() {
    exists(API::Node base |
      ModelOutput::resolvedSummaryRefBase(type, path, base) and
      result = base.getAValueReachableFromSource()
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
