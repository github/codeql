/**
 * Provides models the `RawRepresentable` Swift class.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `RawRepresentable` class members that permit taint flow.
 */
private class RawRepresentableSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";RawRepresentable;true;init(rawValue:);;;Argument[0];ReturnValue;taint",
        ";OptionSet;true;init(rawValue:);;;Argument[0];ReturnValue;taint"
      ]
  }
}

/**
 * A content implying that, if a `RawRepresentable` is tainted, then the
 * `rawValue` field is tainted as well. This model has been extended to assume
 * that any object's `rawValue` field also inherits taint.
 */
private class RawRepresentableFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  RawRepresentableFieldsInheritTaint() { this.getField().getName() = "rawValue" }
}
