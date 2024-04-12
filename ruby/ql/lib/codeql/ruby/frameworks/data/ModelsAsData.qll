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
