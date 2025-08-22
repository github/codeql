/**
 * Provides models for Swift "Manual Memory Management" functions.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

private class ManualMemoryManagementSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;swap(_:_:);;;Argument[0];Argument[1];value",
        ";;false;swap(_:_:);;;Argument[1];Argument[0];value",
      ]
  }
}
