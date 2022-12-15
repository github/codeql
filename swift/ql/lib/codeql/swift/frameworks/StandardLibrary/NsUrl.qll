import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `NSURL` members that permit taint flow.
 */
private class NsUrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    // TODO: Properly model this class
    row = ";NSURL;true;init(string:);(String);;Argument[0];ReturnValue;taint"
  }
}
