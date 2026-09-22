/**
 * Provides an approximate interpreter for MaD models imported from legacy Swift.
 */

private import unified
private import codeql.dataflow.internal.AccessPathSyntax

extensible predicate legacySourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
);

extensible predicate legacySinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
);

extensible predicate legacySummaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
);

private predicate modelContainsMethodName(string name) {
  legacySourceModel(_, _, _, name, _, _, _, _, _)
  or
  legacySinkModel(_, _, _, name, _, _, _, _, _)
  or
  legacySummaryModel(_, _, _, name, _, _, _, _, _, _)
}

private predicate parsedRawMethodName(string rawName, string name, string argLabels) {
  modelContainsMethodName(rawName) and
  exists(string regex |
    regex = "([^(]+)\\((.*)\\)" and
    name = rawName.regexpCapture(regex, 1) and
    argLabels = rawName.regexpCapture(regex, 2)
  )
}

private string getNameFromExpr(Expr e) {
  result = e.(Identifier).getValue()
  or
  result = e.(MemberAccessExpr).getMemberName()
}

private string getCalleeName(CallExpr call) { result = getNameFromExpr(call.getCallee()) }

private string getArgLabelsFromCall(CallExpr call) {
  result =
    concat(Argument arg, string name, int group |
      arg = call.getAnArgument() and
      (
        arg.isPositional() and
        name = "_" and
        group = 0
        or
        name = arg.getName() and
        group = 1
      )
    |
      name + ":" order by group, name
    )
}

pragma[nomagic]
private predicate callSelector(CallExpr call, string name, string argLabels) {
  name = getCalleeName(call) and
  argLabels = getArgLabelsFromCall(call)
}

private newtype TSelector =
  MkSelector(string type, boolean subtypes, string name, string argLabels, string argTypes) {
    exists(string rawName |
      legacySourceModel(_, type, subtypes, rawName, argTypes, _, _, _, _)
      or
      legacySinkModel(_, type, subtypes, rawName, argTypes, _, _, _, _)
      or
      legacySummaryModel(_, type, subtypes, rawName, argTypes, _, _, _, _, _)
    |
      parsedRawMethodName(rawName, name, argLabels)
    )
  }

/**
 * A tuple from a model that identifies call sites.
 */
private class Selector extends TSelector {
  string getTypeString() { this = MkSelector(result, _, _, _, _) }

  boolean getSubtypesFlag() { this = MkSelector(_, result, _, _, _) }

  string getName() { this = MkSelector(_, _, result, _, _) }

  string getArgLabels() { this = MkSelector(_, _, _, result, _) }

  string getArgTypes() { this = MkSelector(_, _, _, _, result) }

  private string ppSubtypes() {
    if this.getSubtypesFlag() = true then result = "+" else result = ""
  }

  string toString() {
    result =
      this.getTypeString() + this.ppSubtypes() + "." + this.getName() + "(" + this.getArgLabels() +
        ")" + this.getArgTypes()
  }

  /** Holds if `name,argLabels` should be used to join with `callSelector`. */
  private predicate effectiveSelector(string name, string argLabels) {
    this = MkSelector(_, _, name, argLabels, _) and
    name != "init"
    or
    // For "init" models there are two issues at play:
    // - Constructor calls do not mention "init", they just mention the type name, e.g. `String(...)` not `String.init(...)`.
    // - The name "init" is too common to match on anyway. It is more precise to match on the type name in this case.
    //
    // So to wire up "init" calls correctly, we just use the type name as the method name.
    this = MkSelector(name, _, "init", argLabels, _)
  }

  predicate matchesCall(CallExpr call) {
    exists(string name, string argLabels |
      this.effectiveSelector(name, argLabels) and
      callSelector(call, name, argLabels)
    )
  }
}

private predicate isAccessPath(string path) {
  legacySourceModel(_, _, _, _, _, _, path, _, _) // output
  or
  legacySinkModel(_, _, _, _, _, _, path, _, _) // input
  or
  legacySummaryModel(_, _, _, _, _, _, path, _, _, _) // input
  or
  legacySummaryModel(_, _, _, _, _, _, _, path, _, _) // output
}

private module AccessPathOutput = AccessPath<isAccessPath/1>;

private import AccessPathOutput

/**
 * Gets the input to `call` specified by `token`. Only singleton access paths are supported.
 */
bindingset[call, token]
private DataFlow::Node getCallInput(CallExpr call, AccessPathToken token) {
  token.getName() = ["Parameter", "Argument"] and
  exists(Argument arg |
    arg = call.getAnArgument() and
    result.asExpr() = arg.getValue()
  |
    arg.getPositionalIndex() = parseIntUnbounded(token.getAnArgument())
    or
    arg.getName() + ":" = token.getAnArgument()
  )
  or
  token = ["Parameter[self]", "Argument[self]"] and
  result.isReceiverArgument(call)
}

private import codeql.unified.internal.dataflow.AllDataFlow

/**
 * Gets the output from `call` specified by `token`. Only singleton access paths are supported.
 */
bindingset[call, token]
private DataFlow::Node getCallOutput(CallExpr call, AccessPathToken token) {
  token = "ReturnValue" and
  result.asExpr() = call
  or
  result = getPostUpdateNode(getCallInput(call, token))
}

private predicate normalizedSourceModel(
  Selector selector, AccessPath output, string kind, string provenance
) {
  exists(
    string type, boolean subtypes, string rawName, string name, string argLabels, string argTypes
  |
    legacySourceModel(_, type, subtypes, rawName, argTypes, _, output, kind, provenance) and
    parsedRawMethodName(rawName, name, argLabels) and
    selector = MkSelector(type, subtypes, name, argLabels, argTypes)
  )
}

private predicate normalizedSinkModel(
  Selector selector, AccessPath output, string kind, string provenance
) {
  exists(
    string type, boolean subtypes, string rawName, string name, string argLabels, string argTypes
  |
    legacySinkModel(_, type, subtypes, rawName, argTypes, _, output, kind, provenance) and
    parsedRawMethodName(rawName, name, argLabels) and
    selector = MkSelector(type, subtypes, name, argLabels, argTypes)
  )
}

/**
 * Gets a flow source with the given `kind` and `provenance`.
 */
DataFlow::Node getASource(string kind, string provenance) {
  exists(CallExpr call, Selector selector, AccessPath output |
    normalizedSourceModel(selector, output, kind, provenance) and
    selector.matchesCall(call) and
    result = getCallOutput(call, output)
  )
}

/**
 * Gets a sink with the given `kind` and `provenance`.
 */
DataFlow::Node getASink(string kind, string provenance) {
  exists(CallExpr call, Selector selector, AccessPath input |
    normalizedSinkModel(selector, input, kind, provenance) and
    selector.matchesCall(call) and
    result = getCallInput(call, input)
  )
}
