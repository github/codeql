/**
 * Provides models for the `Sequence` Swift class.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `Sequence` members that permit taint flow.
 */
private class SequenceSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Sequence;true;reversed();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;prefix(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;prefix(while:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;suffix(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;dropFirst(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;dropLast(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;split(separator:maxSplits:omittingEmptySubsequences:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;joined();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;joined(separator:);;;Argument[-1..0];ReturnValue;taint",
        ";Sequence;true;first(where:);;;Argument[-1];ReturnValue;taint",
      ]
  }
}

/**
 * A content implying that, if a `Sequence` is tainted, certain fields are also
 * tainted.
 */
private class SequenceFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  SequenceFieldsInheritTaint() {
    exists(FieldDecl f | this.getField() = f |
      (
        f.getEnclosingDecl().(NominalTypeDecl).getName() = "Sequence" or
        f.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl().getName() = "Sequence"
      ) and
      f.getName() = "lazy"
    )
  }
}
