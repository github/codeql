/**
 * Provides models for `Collection` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `Collection` members that permit taint flow.
 */
private class CollectionSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Collection;true;prefix(_:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;prefix(through:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;prefix(upTo:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;prefix(while:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;suffix(_:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;suffix(from:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;dropFirst(_:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;dropLast(_:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;split(separator:maxSplits:omittingEmptySubsequences:);;;Argument[-1];ReturnValue;taint",
        ";Collection;true;removeFirst();;;Argument[-1];ReturnValue;taint",
        ";RangeReplaceableCollection;true;append(_:);;;Argument[0];Argument[-1];taint",
        ";RangeReplaceableCollection;true;append(contentsOf:);;;Argument[0];Argument[-1];taint",
        ";RangeReplaceableCollection;true;remove(at:);;;Argument[-1];ReturnValue;taint",
        ";RangeReplaceableCollection;true;removeFirst();;;Argument[-1];ReturnValue;taint",
        ";RangeReplaceableCollection;true;removeLast();;;Argument[-1];ReturnValue;taint",
        ";BidirectionalCollection;true;joined(separator:);;;Argument[-1..0];ReturnValue;taint",
      ]
  }
}
