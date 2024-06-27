/**
 * Provides models for the `FilePath` Swift class.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * The struct `FilePath`.
 */
class FilePath extends StructDecl {
  FilePath() { this.getFullName() = "FilePath" }
}

/**
 * A model for `FilePath` members that permit taint flow.
 */
private class FilePathSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";FilePath;true;init(stringLiteral:);(String);;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(extendedGraphemeClusterLiteral:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(unicodeScalarLiteral:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(from:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(cString:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(platformString:);;;Argument[0];ReturnValue;taint",
        ";FilePath;true;init(root:_:);;;Argument[0..1];ReturnValue;taint",
        ";FilePath;true;init(root:components:);;;Argument[0..1];ReturnValue;taint",
        ";FilePath;true;encode(to:);;;Argument[-1];Argument[0];taint",
        ";FilePath;true;withCString(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";FilePath;true;withCString(_:);;;Argument[0].ReturnValue;ReturnValue;taint",
        ";FilePath;true;withPlatformString(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";FilePath;true;withPlatformString(_:);;;Argument[0].ReturnValue;ReturnValue;taint",
        ";FilePath;true;append(_:);;;Argument[0];Argument[-1];taint",
        ";FilePath;true;appending(_:);;;Argument[-1..0];ReturnValue;taint",
        ";FilePath;true;lexicallyNormalized();;;Argument[-1];ReturnValue;taint",
        ";FilePath;true;lexicallyResolving(_:);;;Argument[-1..0];ReturnValue;taint",
        ";FilePath;true;push(_:);;;Argument[0];Argument[-1];taint",
        ";FilePath;true;pushing(_:);;;Argument[-1..0];ReturnValue;taint",
        ";FilePath;true;removingLastComponent();;;Argument[-1];ReturnValue;taint",
        ";FilePath;true;removingRoot();;;Argument[-1];ReturnValue;taint",
        ";FilePath.Component;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FilePath.Component;true;init(platformString:);;;Argument[0];ReturnValue;taint",
        ";FilePath.Component;true;withPlatformString(_:);;;Argument[-1];Argument[0].Parameter[0];taint",
        ";FilePath.Root;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";FilePath.Root;true;init(platformString:);;;Argument[0];ReturnValue;taint",
        ";FilePath.Root;true;withPlatformString(_:);;;Argument[-1];Argument[0].Parameter[0];taint"
      ]
  }
}

/**
 * A content implying that, if a `FilePath` is tainted, certain fields are also
 * tainted.
 */
private class FilePathFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  FilePathFieldsInheritTaint() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl().asNominalTypeDecl() instanceof FilePath and
      f.getName() = ["components", "extension", "lastComponent", "root", "stem", "string"]
    )
  }
}

/**
 * A content implying that, if a `FilePath.Component` or `FilePath.Root` is tainted, certain fields
 * are also tainted.
 */
private class FilePathComponentFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  FilePathComponentFieldsInheritTaint() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl().asNominalTypeDecl().getFullName() =
        ["FilePath.Component", "FilePath.Root"] and
      f.getName() = ["extension", "stem", "string"]
    )
  }
}
