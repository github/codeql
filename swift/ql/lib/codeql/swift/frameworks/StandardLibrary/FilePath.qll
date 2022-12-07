import swift
private import codeql.swift.dataflow.ExternalFlow

/** The struct `FilePath`. */
class FilePath extends StructDecl {
  FilePath() { this.getFullName() = "FilePath" }
}

/**
 * A model for `FilePath` members that permit taint flow.
 */
private class FilePathSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    // TODO: Properly model this class
    row = ";FilePath;true;init(stringLiteral:);(String);;Argument[0];ReturnValue;taint"
  }
}
