import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `URL` members that are sources of remote flow.
 */
private class UrlRemoteFlowSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";URL;true;resourceBytes;;;;remote", ";URL;true;lines;;;;remote",
        ";URL.AsyncBytes;true;lines;;;;remote"
      ]
  }
}

/**
 * A model for `URL` members that permit taint flow.
 */
private class UrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue;taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue;taint"
      ]
  }
}
