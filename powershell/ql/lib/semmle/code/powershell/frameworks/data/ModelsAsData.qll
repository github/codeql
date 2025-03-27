/**
 * Provides classes for contributing a model, or using the interpreted results
 * of a model represented as data.
 */

private import powershell
private import semmle.code.powershell.ApiGraphs
private import internal.ApiGraphModels as Shared
private import internal.ApiGraphModelsSpecific as Specific
import Shared::ModelInput as ModelInput
import Shared::ModelOutput as ModelOutput
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.dataflow.FlowSummary

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

  override CallExpr getACall() {
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
