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
private class UriFieldsInheritTaint extends TaintInheritingContent, DataFlow::Content::FieldContent {
  UriFieldsInheritTaint() { this.getField().getEnclosingDecl() instanceof UrlDecl }
}

/**
 * A content implying that, if a `URLRequest` is tainted, then its fields `url`, `httpBody`,
 * `httpBodyStream`, `mainDocument` and `allHTTPHeaderFields` are tainted.
 */
private class UrlRequestFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  UrlRequestFieldsInheritTaint() {
    this.getField().getEnclosingDecl().(NominalTypeDecl).getName() = "URLRequest" and
    this.getField().getName() =
      ["url", "httpBody", "httpBodyStream", "mainDocument", "allHTTPHeaderFields"]
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
 * A model for `URL` members that permit taint flow.
 */
private class UrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue;taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue;taint"
      ]
  }
}
