/**
 * Provides models for the `NSURL` Swift class.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A content implying that, if an `NSURL` is tainted, then all its fields are tainted.
 */
private class NSUrlFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  NSUrlFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getFullName() = "NSURL"
  }
}

/**
 * A model for `NSURL` members that permit taint flow.
 */
private class NsUrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSURL;true;init(string:);(String);;Argument[0];ReturnValue.OptionalSome;taint",
        ";NSURL;true;appendingPathComponent(_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSURL;true;appendingPathComponent(_:isDirectory:);;;Argument[-1..0];ReturnValue;taint",
        ";NSURL;true;appendingPathComponent(_:conformingTo:);;;Argument[-1..0];ReturnValue;taint",
        ";NSURL;true;appendingPathExtension(_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSURL;true;appendingPathExtension(for:);;;Argument[-1];ReturnValue;taint",
      ]
  }
}
