/**
 * Provides models for the Swift `Dictionary` class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * An instance of the `Dictionary` type.
 */
class CanonicalDictionaryType extends BoundGenericType {
  CanonicalDictionaryType() { this.getName().matches("Dictionary<%") }
}

/**
 * A model for `Dictionary` and related class members that permit data flow.
 */
private class DictionarySummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Dictionary;true;updateValue(_:forKey:);;;Argument[0];Argument[-1].CollectionElement.TupleElement[1];value",
        ";Dictionary;true;updateValue(_:forKey:);;;Argument[1];Argument[-1].CollectionElement.TupleElement[0];value",
        ";Dictionary;true;updateValue(_:forKey:);;;Argument[-1].CollectionElement.TupleElement[1];ReturnValue.OptionalSome;value",
        ";Dictionary;true;makeIterator();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
      ]
  }
}
