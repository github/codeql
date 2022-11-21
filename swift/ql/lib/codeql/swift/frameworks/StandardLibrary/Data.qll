import swift
private import codeql.swift.dataflow.ExternalFlow

private class DataSummaries extends SummaryModelCsv {
  override predicate row(string row) { row = ";Data;true;init(_:);;;Argument[0];ReturnValue;taint" }
}
