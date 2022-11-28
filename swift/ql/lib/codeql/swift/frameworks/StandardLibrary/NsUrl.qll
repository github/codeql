import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `NSURL` members that permit taint flow.
 */
private class NsUrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSURL;true;init(string:);(String);;Argument[0];ReturnValue;taint",
        // TODO
      ]
  }
}
