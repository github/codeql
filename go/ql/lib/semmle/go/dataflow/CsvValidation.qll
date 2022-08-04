/** Provides a query predicate to check the CSV data for validation errors. */

private import go
private import ExternalFlow
private import internal.FlowSummaryImpl::Private::External
private import internal.AccessPathSyntax

private string getInvalidModelInput() {
  exists(string pred, AccessPath input, string part |
    sinkModel(_, _, _, _, _, _, input, _) and pred = "sink"
    or
    summaryModel(_, _, _, _, _, _, input, _, _) and pred = "summary"
  |
    (
      invalidSpecComponent(input, part) and
      not part = "" and
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
    sourceModel(_, _, _, _, _, _, output, _) and pred = "source"
    or
    summaryModel(_, _, _, _, _, _, _, output, _) and pred = "summary"
  |
    invalidSpecComponent(output, part) and
    not part = "" and
    not (part = "Parameter" and pred = "source") and
    result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
  )
}

private string getInvalidModelKind() { none() }

private string getInvalidModelSubtype() {
  exists(string pred, string row, int expect |
    sourceModel(row) and expect = 8 and pred = "source"
    or
    sinkModel(row) and expect = 8 and pred = "sink"
    or
    summaryModel(row) and expect = 9 and pred = "summary"
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
    sourceModel(row) and expect = 8 and pred = "source"
    or
    sinkModel(row) and expect = 8 and pred = "sink"
    or
    summaryModel(row) and expect = 9 and pred = "summary"
  |
    exists(int cols |
      cols = 1 + max(int n | exists(row.splitAt(";", n))) and
      cols != expect and
      result =
        "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
          "."
    )
  )
}

private string getInvalidModelSignature() {
  exists(string pred, string namespace, string type, string name, string signature, string ext |
    sourceModel(namespace, type, _, name, signature, ext, _, _) and pred = "source"
    or
    sinkModel(namespace, type, _, name, signature, ext, _, _) and pred = "sink"
    or
    summaryModel(namespace, type, _, name, signature, ext, _, _, _) and pred = "summary"
  |
    not namespace.regexpMatch("[a-zA-Z0-9_\\./]*") and
    result = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
    or
    not type.regexpMatch("[a-zA-Z0-9_\\$<>]*") and
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
