/**
 * Provides models for the `IteratorProtocol` Swift protocol.
 */

private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `IteratorProtocol` members that permit taint flow.
 */
private class IteratorProtocolSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";IteratorProtocol;true;next();;;Argument[-1].CollectionElement;ReturnValue.OptionalSome;value"
      ]
  }
}
