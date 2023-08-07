/**
 * Provides models for `Set` and related Swift classes.
 */

private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `Set` and related class members that permit data flow.
 */
private class SetSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Set;true;insert(_:);;;Argument[-1].CollectionElement;ReturnValue.TupleElement[1];value",
        ";Set;true;insert(_:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Set;true;insert(_:);;;Argument[0];ReturnValue.TupleElement[1];value",
        ";Set;true;init(_:);;;Argument[0].ArrayElement;ReturnValue.CollectionElement;value"
      ]
  }
}
