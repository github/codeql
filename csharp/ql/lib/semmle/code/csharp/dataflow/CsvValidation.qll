/** Provides a query predicate to check the CSV data for validation errors. */

import csharp
private import internal.AccessPathSyntax
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific
private import ExternalFlow

private string getInvalidModelInput() {
  exists(string pred, AccessPath input, string part |
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
      part = input.getToken(_) and
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
    not kind = ["code", "sql", "xss", "remote", "html"] and
    result = "Invalid kind \"" + kind + "\" in sink model."
  )
  or
  exists(string row, string kind | sourceModel(row) |
    kind = row.splitAt(";", 7) and
    not kind = "local" and
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

/** Holds if some row in a CSV-based flow model appears to contain typos. */
query predicate invalidModelRow(string msg) {
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
    msg = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
    or
    not type.regexpMatch("[a-zA-Z0-9_<>,\\+]+") and
    msg = "Dubious type \"" + type + "\" in " + pred + " model."
    or
    not name.regexpMatch("[a-zA-Z0-9_<>,]*") and
    msg = "Dubious member name \"" + name + "\" in " + pred + " model."
    or
    not signature.regexpMatch("|\\([a-zA-Z0-9_<>\\.\\+\\*,\\[\\]]*\\)") and
    msg = "Dubious signature \"" + signature + "\" in " + pred + " model."
    or
    not ext.regexpMatch("|Attribute") and
    msg = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
    or
    not provenance = ["manual", "generated"] and
    msg = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
  )
  or
  msg = getInvalidModelInput()
  or
  msg = getInvalidModelOutput()
  or
  msg = getInvalidModelSubtype()
  or
  msg = getInvalidModelColumnCount()
  or
  msg = getInvalidModelKind()
}
