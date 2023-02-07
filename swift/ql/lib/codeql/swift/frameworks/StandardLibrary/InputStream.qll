/**
 * Provides models for the `InputStream` Swift class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

private class InputStreamSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row = ";InputStream;true;init(data:);;;Argument[0];ReturnValue;taint"
  }
}
