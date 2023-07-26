/**
 * Provides models for `Array` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * An instance of the `Array` type.
 */
class ArrayType extends Type {
  ArrayType() { this.getName().matches("Array<%") or this.getName().matches("[%]") }
}

/**
 * A model for `Array` and related class members that permit data flow.
 */
private class ArraySummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Array;true;insert(_:at:);;;Argument[0];Argument[-1].ArrayElement;value",
        ";Array;true;insert(_:at:);;;Argument[1];Argument[-1];taint"
      ]
  }
}
