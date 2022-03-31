/**
 * Provides modeling for the `ActiveStorage` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.frameworks.data.ModelsAsData

/** A call to `ActiveStorage::Filename#sanitized`, considered as a path sanitizer. */
class ActiveStorageFilenameSanitizedCall extends Path::PathSanitization::Range, DataFlow::CallNode {
  ActiveStorageFilenameSanitizedCall() {
    this.getReceiver() =
      API::getTopLevelMember("ActiveStorage").getMember("Filename").getAnInstantiation() and
    this.getMethodName() = "sanitized"
  }
}

/** Taint related to `ActiveStorage::Filename`. */
private class Summaries extends ModelInput::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "activestorage;;Member[ActiveStorage].Member[Filename].Method[new];Argument[0];ReturnValue;taint",
        "activestorage;;Member[ActiveStorage].Member[Filename].Instance.Method[sanitized];Argument[self];ReturnValue;taint",
      ]
  }
}
