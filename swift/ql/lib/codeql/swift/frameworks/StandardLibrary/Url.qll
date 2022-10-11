import swift
private import codeql.swift.dataflow.ExternalFlow

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
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[absoluteURL];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[baseURL];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[fragment];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[host];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[lastPathComponent];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[path];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[pathComponents];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[pathExtension];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[port];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[query];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[relativePath];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[relativeString];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[scheme];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[standardized];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[standardizedFileURL];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[user];taint",
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[password];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue;taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[absoluteURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[baseURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[fragment];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[host];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[lastPathComponent];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[path];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[pathComponents];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[pathExtension];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[port];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[query];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[relativePath];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[relativeString];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[scheme];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[standardized];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[standardizedFileURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[user];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue.Field[password];taint",
      ]
  }
}
