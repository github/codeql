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
        ";Set;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";Set;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";Set;true;insert(_:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Set;true;insert(_:);;;Argument[0];ReturnValue.TupleElement[1];taint",
        ";Set;true;update(with:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Set;true;update(with:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";Set;true;remove(_:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";Set;true;removeFirst();;;Argument[-1].CollectionElement;ReturnValue;value",
        ";Set;true;remove(at:);;;Argument[-1].CollectionElement;ReturnValue;value",
        ";Set;true;filter(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Set;true;union(_:);;;Argument[-1..0].CollectionElement;ReturnValue.CollectionElement;value",
        ";Set;true;formUnion(_:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Set;true;symmetricDifference(_:);;;Argument[-1..0].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Set;true;formSymmetricDifference(_:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Set;true;intersection(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Set;true;subtracting(_:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
      ]
  }
}
