/** Provides a query predicate to check the CSV data for validation errors. */

import java
private import ExternalFlow
private import internal.FlowSummaryImpl::Private::External
private import internal.AccessPathSyntax

private string getInvalidModelInput() {
  exists(string pred, string input, string part |
    sinkModel(_, _, _, _, _, _, input, _, _) and pred = "sink"
    or
    summaryModel(_, _, _, _, _, _, input, _, _, _) and pred = "summary"
  |
    (
      invalidSpecComponent(input, part) and
      not part = "" and
      not (part = "Argument" and pred = "sink") and
      not parseArg(part, _)
      or
      part = input.(AccessPath).getToken(0) and
      parseParam(part, _)
    ) and
    result = "Unrecognized input specification \"" + part + "\" in " + pred + " model."
  )
}

private string getInvalidModelOutput() {
  exists(string pred, string output, string part |
    sourceModel(_, _, _, _, _, _, output, _, _) and pred = "source"
    or
    summaryModel(_, _, _, _, _, _, _, output, _, _) and pred = "summary"
  |
    invalidSpecComponent(output, part) and
    not part = "" and
    not (part = ["Argument", "Parameter"] and pred = "source") and
    result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
  )
}

private string getInvalidModelKind() {
  exists(string row, string kind | summaryModel(row) |
    kind = row.splitAt(";", 8) and
    not kind = ["taint", "value"] and
    result = "Invalid kind \"" + kind + "\" in summary model."
  )
  or
  exists(string row, string kind | sinkModel(row) |
    kind = row.splitAt(";", 7) and
    not kind =
      [
        "open-url", "jndi-injection", "ldap", "sql", "jdbc-url", "logging", "mvel", "xpath",
        "groovy", "xss", "ognl-injection", "intent-start", "pending-intent-sent", "url-open-stream",
        "url-redirect", "create-file", "write-file", "set-hostname-verifier", "header-splitting",
        "information-leak", "xslt", "jexl", "bean-validation"
      ] and
    not kind.matches("regex-use%") and
    not kind.matches("qltest%") and
    result = "Invalid kind \"" + kind + "\" in sink model."
  )
  or
  exists(string row, string kind | sourceModel(row) |
    kind = row.splitAt(";", 7) and
    not kind = ["remote", "contentprovider", "android-widget", "android-external-storage-dir"] and
    not kind.matches("qltest%") and
    result = "Invalid kind \"" + kind + "\" in source model."
  )
}

private string getInvalidModelSubtype() {
  exists(string pred, string row, int expect |
    sourceModel(row) and expect = 9 and pred = "source"
    or
    sinkModel(row) and expect = 9 and pred = "sink"
    or
    summaryModel(row) and expect = 10 and pred = "summary"
  |
    exists(string b |
      b = row.splitAt(";", 2) and
      not b = ["true", "false"] and
      result = "Invalid boolean \"" + b + "\" in " + pred + " model."
    )
  )
}

private string getInvalidModelColumnCount() {
  exists(string pred, string row, int expect |
    sourceModel(row) and expect = 9 and pred = "source"
    or
    sinkModel(row) and expect = 9 and pred = "sink"
    or
    summaryModel(row) and expect = 10 and pred = "summary"
    or
    negativeSummaryModel(row) and expect = 5 and pred = "negative summary"
  |
    exists(int cols |
      cols = 1 + max(int n | exists(row.splitAt(";", n))) and
      cols != expect and
      result =
        "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
          " in " + row + "."
    )
  )
}

private string getInvalidModelSignature() {
  exists(
    string pred, string namespace, string type, string name, string signature, string ext,
    string provenance
  |
    sourceModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "source"
    or
    sinkModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "sink"
    or
    summaryModel(namespace, type, _, name, signature, ext, _, _, _, provenance) and
    pred = "summary"
    or
    negativeSummaryModel(namespace, type, name, signature, provenance) and
    ext = "" and
    pred = "nonesummary"
  |
    not namespace.regexpMatch("[a-zA-Z0-9_\\.]+") and
    result = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
    or
    not type.regexpMatch("[a-zA-Z0-9_\\$<>]+") and
    result = "Dubious type \"" + type + "\" in " + pred + " model."
    or
    not name.regexpMatch("[a-zA-Z0-9_]*") and
    result = "Dubious name \"" + name + "\" in " + pred + " model."
    or
    not signature.regexpMatch("|\\([a-zA-Z0-9_\\.\\$<>,\\[\\]]*\\)") and
    result = "Dubious signature \"" + signature + "\" in " + pred + " model."
    or
    not ext.regexpMatch("|Annotated") and
    result = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
    or
    not provenance = ["manual", "generated"] and
    result = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
  )
}

/** Holds if some row in a CSV-based flow model appears to contain typos. */
query predicate invalidModelRow(string msg) {
  msg =
    [
      getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
      getInvalidModelSubtype(), getInvalidModelColumnCount(), getInvalidModelKind()
    ]
}
