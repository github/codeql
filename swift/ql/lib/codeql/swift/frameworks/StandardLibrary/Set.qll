private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `Set` and related class members that permit data flow.
 */
private class SetSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Set;true;insert(_:);;;Argument[-1].SetElement;ReturnValue.TupleElement[1];value",
        ";Set;true;insert(_:);;;Argument[0];Argument[-1].SetElement;value",
        ";Set;true;insert(_:);;;Argument[0];ReturnValue.TupleElement[1];value",
        ";Set;true;init(_:);;;Argument[0].ArrayElement;ReturnValue.SetElement;value"
      ]
  }
}
