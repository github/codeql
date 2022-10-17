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
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0,1];ReturnValue;taint",
        // The base string taints all the URL fields (except baseURL)
        ";URL;true;init(string:);(String);;Argument[0];ReturnValue.Field[absoluteURL];taint",
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
        // The base string taints all the URL fields (except baseURL) if it's an absolute URL when relativeTo is used
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[absoluteURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[fragment];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[host];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[lastPathComponent];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[path];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[pathComponents];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[pathExtension];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[port];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[query];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[relativePath];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[relativeString];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[scheme];taint",
        // Not mapping precise field taint to standardized/standardizedFileURL even if the return values are URLs too
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[standardized];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[standardizedFileURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[user];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[0];ReturnValue.Field[password];taint",
        // The relativeTo URL taints fields not related to the path, query or fragment if the base string is a relative path
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[absoluteURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[baseURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[host];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[port];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[scheme];taint",
        // Not mapping precise field taint to standardized/standardizedFileURL even if the return values are URLs too
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[standardized];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[standardizedFileURL];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[user];taint",
        ";URL;true;init(string:relativeTo:);(String,URL?);;Argument[1];ReturnValue.Field[password];taint",
      ]
  }
}
