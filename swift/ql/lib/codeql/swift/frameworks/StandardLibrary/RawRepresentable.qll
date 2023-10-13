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
    row = ";RawRepresentable;true;init(rawValue:);;;Argument[0];ReturnValue;taint"
  }
}

/**
 * A content implying that, if an `RawRepresentable` is tainted, then
 * the `rawValue` field is tainted as well.
 */
private class RawRepresentableFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  RawRepresentableFieldsInheritTaint() {
    exists(FieldDecl fieldDecl, Decl declaringDecl, TypeDecl namedTypeDecl |
      namedTypeDecl.getFullName() = "RawRepresentable" and
      fieldDecl.getName() = "rawValue" and
      declaringDecl.getAMember() = fieldDecl and
      declaringDecl.asNominalTypeDecl() = namedTypeDecl.getADerivedTypeDecl*() and
      this.getField() = fieldDecl
    )
  }
}
