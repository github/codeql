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
        ";Sequence;true;sorted();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;sorted();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;sorted(by:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;sorted(by:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;reversed();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;reversed();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;shuffled();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;shuffled();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;shuffled(using:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";Sequence;true;shuffled(using:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;prefix(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;prefix(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;prefix(while:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;prefix(while:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;suffix(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;suffix(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;dropFirst(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;dropFirst(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;dropLast(_:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;dropLast(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;drop(while:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;drop(while:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;split(separator:maxSplits:omittingEmptySubsequences:);;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;split(separator:maxSplits:omittingEmptySubsequences:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;joined();;;Argument[-1];ReturnValue;taint",
        ";Sequence;true;joined();;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";Sequence;true;joined();;;Argument[-1].CollectionElement.CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;joined(separator:);;;Argument[0..-1];ReturnValue;taint",
        ";Sequence;true;joined(separator:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";Sequence;true;joined(separator:);;;Argument[-1].CollectionElement.CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;first(where:);;;Argument[-1].CollectionElement;ReturnValue;value",
        ";Sequence;true;withContiguousStorageIfAvailable(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Sequence;true;withContiguousStorageIfAvailable(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;value",
        ";Sequence;true;withContiguousStorageIfAvailable(_:);;;Argument[0].ReturnValue;ReturnValue.OptionalSome;value",
        ";Sequence;true;forEach(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0];value",
        ";Sequence;true;enumerated();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement.TupleElement[1];value",
        ";Sequence;true;makeIterator();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";Sequence;true;min();;;Argument[-1].CollectionElement;ReturnValue.OptionalSome;taint",
        ";Sequence;true;min(by:);;;Argument[-1].CollectionElement;ReturnValue.OptionalSome;taint",
        ";Sequence;true;max();;;Argument[-1].CollectionElement;ReturnValue.OptionalSome;taint",
        ";Sequence;true;max(by:);;;Argument[-1].CollectionElement;ReturnValue.OptionalSome;taint",
        ";Sequence;true;formatted();;;Argument[-1].CollectionElement;ReturnValue;taint",
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
  SequenceFieldsInheritTaint() { this.getField().hasQualifiedName("Sequence", "lazy") }
}
