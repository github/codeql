import swift
private import codeql.swift.dataflow.ExternalFlow

private class StringSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // String(contentsOf:) is a remote flow source
        ";String;true;init(contentsOf:);(URL);;ReturnValue;remote"
      ]
  }
}
