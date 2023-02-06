/**
 * Provides models for the `URLSession` Swift class.
 */

private import codeql.swift.dataflow.ExternalFlow

private class UrlSessionSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ";URLSession;true;dataTask(with:completionHandler:);;;Argument[0];Argument[1].Parameter[0];taint"
  }
}
