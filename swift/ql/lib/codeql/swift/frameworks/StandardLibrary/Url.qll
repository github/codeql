/**
 * Provides models for the `URL` Swift class.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/** The struct `URL`. */
class UrlDecl extends StructDecl {
  UrlDecl() { this.getFullName() = "URL" }
}

/**
 * A content implying that, if a `URL` is tainted, then all its fields are tainted.
 */
private class UrlFieldsInheritTaint extends TaintInheritingContent, DataFlow::Content::FieldContent {
  UrlFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl() instanceof UrlDecl
  }
}

/**
 * A content implying that, if a `URLRequest` is tainted, then certain fields tainted.
 */
private class UrlRequestFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UrlRequestFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "URLRequest" and
    this.getField().getName() =
      [
        "url", "httpBody", "httpBodyStream", "mainDocument", "mainDocumentURL",
        "allHTTPHeaderFields"
      ]
  }
}

/**
 * A content implying that, if a `URLResource` is tainted, then its fields `name`
 * and `subdirectory` are tainted.
 */
private class UrlResourceFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UrlResourceFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "URLResource" and
    this.getField().getName() = ["name", "subdirectory"]
  }
}

/**
 * A content implying that, if a `URLResourceValues` is tainted, then certain
 * fields are tainted.
 */
private class UrlResourceValuesFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UrlResourceValuesFieldsInheritTaint() {
    this.getField().getEnclosingDecl().asNominalTypeDecl().getName() = "URLResourceValues" and
    this.getField().getName() =
      [
        "name", "path", "canonicalPath", "localizedLabel", "localizedName", "parentDirectory",
        "thumbnail"
      ]
  }
}

/**
 * A model for `URL` members that are sources of remote flow.
 */
private class UrlRemoteFlowSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";URL;true;resourceBytes;;;;remote", ";URL;true;lines;;;;remote",
        ";URL.AsyncBytes;true;lines;;;;remote"
      ]
  }
}

/**
 * A model for `URL` and related class members that permit taint flow.
 */
private class UrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1].OptionalSome;ReturnValue.OptionalSome;taint",
        ";URL;true;init(fileURLWithPath:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(fileURLWithPath:isDirectory:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(fileURLWithPath:relativeTo:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(fileURLWithPath:relativeTo:);;;Argument[1].OptionalSome;ReturnValue;taint",
        ";URL;true;init(fileURLWithPath:isDirectory:relativeTo:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(fileURLWithPath:isDirectory:relativeTo:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;init(fileURLWithFileSystemRepresentation:isDirectory:relativeTo:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(fileURLWithFileSystemRepresentation:isDirectory:relativeTo:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;init(fileReferenceLiteralResourceName:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(_:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(_:isDirectory:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(resolvingBookmarkData:options:relativeTo:bookmarkDataIsStale:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(resolvingBookmarkData:options:relativeTo:bookmarkDataIsStale:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;init(resolvingAliasFileAt:options:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(resource:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(dataRepresentation:relativeTo:isAbsolute:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(dataRepresentation:relativeTo:isAbsolute:);;;Argument[1].OptionalSome;ReturnValue;taint",
        ";URL;true;init(_:strategy:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(filePath:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(filePath:isDirectory:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(filePath:directoryHint:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;init(filePath:directoryHint:relativeTo:);;;Argument[0];ReturnValue;taint",
        ";URL;true;init(filePath:directoryHint:relativeTo:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;init(for:in:appropriateFor:create:);;;Argument[0..1];ReturnValue;taint",
        ";URL;true;init(for:in:appropriateFor:create:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;init(string:encodingInvalidCharacters:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";URL;true;resourceValues(forKeys:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;setResourceValues(_:);;;Argument[0];Argument[-1];taint",
        ";URL;true;setTemporaryResourceValue(_:forKey:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;withUnsafeFileSystemRepresentation(_:);;;Argument[-1];Argument[0].Parameter[0].OptionalSome.CollectionElement;taint",
        ";URL;true;withUnsafeFileSystemRepresentation(_:);;;Argument[0].ReturnValue;ReturnValue;taint",
        ";URL;true;resolvingSymlinksInPath();;;Argument[-1];ReturnValue;taint",
        ";URL;true;appendPathComponent(_:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;appendPathComponent(_:isDirectory:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;appendPathComponent(_:conformingTo:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;appendingPathComponent(_:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appendingPathComponent(_:isDirectory:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appendingPathComponent(_:conformingTo:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appendPathExtension(_:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;appendingPathExtension(_:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appendingPathExtension(for:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;deletingLastPathComponent();;;Argument[-1];ReturnValue;taint",
        ";URL;true;deletingPathExtension();;;Argument[-1];ReturnValue;taint",
        ";URL;true;bookmarkData(options:includingResourceValuesForKeys:relativeTo:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;bookmarkData(options:includingResourceValuesForKeys:relativeTo:);;;Argument[1].OptionalSome.CollectionElement;ReturnValue;taint",
        ";URL;true;bookmarkData(options:includingResourceValuesForKeys:relativeTo:);;;Argument[2].OptionalSome;ReturnValue;taint",
        ";URL;true;bookmarkData(withContentsOf:);;;Argument[0];ReturnValue;taint",
        ";URL;true;resourceValues(forKeys:fromBookmarkData:);;;Argument[1];ReturnValue;taint",
        ";URL;true;promisedItemResourceValues(forKeys:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;append(component:directoryHint:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;append(components:directoryHint:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;append(path:directoryHint:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;append(queryItems:);;;Argument[-1..0];Argument[-1];taint",
        ";URL;true;appending(component:directoryHint:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appending(components:directoryHint:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appending(path:directoryHint:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;appending(queryItems:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;formatted();;;Argument[-1];ReturnValue;taint",
        ";URL;true;formatted(_:);;;Argument[-1..0];ReturnValue;taint",
        ";URL;true;fragment(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;host(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;password(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;path(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;query(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;user(percentEncoded:);;;Argument[-1];ReturnValue;taint",
        ";URL;true;homeDirectory(forUser:);;;Argument[0];ReturnValue;taint",
        ";URLResource;true;init(name:subdirectory:locale:bundle:);;;Argument[0..1];ReturnValue;taint",
      ]
  }
}
