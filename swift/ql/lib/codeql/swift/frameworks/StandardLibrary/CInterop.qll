/**
 * Provides models for Swift "C Interoperability" functions.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

private class CInteropSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;getVaList(_:);;;Argument[0].CollectionElement;ReturnValue;value",
        ";;false;withVaList(_:_:);;;Argument[0];Argument[1].Parameter[0];value"
      ]
  }
}
