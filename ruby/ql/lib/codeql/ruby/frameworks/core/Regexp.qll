/**
 * Provides modeling for the `Regexp` class.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.frameworks.data.ModelsAsData

/**
 * Provides modeling for the `Regexp` class.
 */
module Regexp {
  /** A flow summary for `Regexp.escape` and its alias, `Regexp.quote`. */
  class RegexpEscapeSummary extends ModelInput::SummaryModelCsv {
    override predicate row(string row) {
      row = ";;Member[Regexp].Method[escape,quote];Argument[0];ReturnValue;taint"
    }
  }
}
