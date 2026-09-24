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
  // NOTE: We only support method names at the moment, not property names like `String.count`.
  modelContainsMethodName(rawName) and
  exists(string regex |
    regex = "([^(]+)\\((.*)\\)" and
    name = rawName.regexpCapture(regex, 1) and
    argLabels = rawName.regexpCapture(regex, 2)
  )
}

private string getSimpleNameFromExpr(Expr e) {
  result = e.(Identifier).getValue()
  or
  result = e.(MemberAccessExpr).getMemberName()
}

private string getQualifiedNameFromExpr(Expr e) {
  result = e.(Identifier).getValue()
  or
  exists(MemberAccessExpr access | e = access |
    result = getQualifiedNameFromExpr(access.getBase()) + "." + access.getMemberName()
  )
}

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
private predicate methodCallSelector(CallExpr call, string name, string argLabels) {
  name = getSimpleNameFromExpr(call.getCallee()) and
  argLabels = getArgLabelsFromCall(call)
}

pragma[nomagic]
private predicate constructorCallSelector(CallExpr call, string name, string argLabels) {
  name = getQualifiedNameFromExpr(call.getCallee()) and
  argLabels = getArgLabelsFromCall(call)
}

private import codeql.unified.internal.NameBinding as NameBinding

private predicate isSubclassOfType(ClassLikeDeclaration cls, string typeName) {
  typeName = any(Selector s).getTypeString() and
  (
    getQualifiedNameFromExpr(cls.getABaseType().getType()) = typeName
    or
    isSubclassOfType(cls.getABaseClass(), typeName)
  )
}

private string getArgLabelsFromCallable(Callable callable) {
  result =
    concat(Parameter param, string name, int group |
      param.getParent() = callable and
      (
        param.isPositional() and
        name = "_" and
        group = 0
        or
        name = param.getExternalName() and
        group = 1
      )
    |
      name + ":" order by group, name
    )
}

pragma[nomagic]
private predicate callableSelector(
  FunctionDeclaration callable, string type, string name, string argLabels
) {
  name = callable.getName() and
  argLabels = getArgLabelsFromCallable(callable) and
  exists(ClassLikeDeclaration cls |
    callable = cls.getAMember() and
    isSubclassOfType(cls, type)
  )
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

  /** Holds if `name,argLabels` should be used to join with `methodCallSelector`. */
  pragma[nomagic]
  private predicate matchesMethodCallSelector(string name, string argLabels) {
    this = MkSelector(_, _, name, argLabels, _) and
    name != "init"
  }

  /** Holds if `name,argLabels` should be used to join with `constructorCallSelector`. */
  pragma[nomagic]
  private predicate matchesConstructorCallSelector(string name, string argLabels) {
    this = MkSelector(name, _, "init", argLabels, _)
  }

  predicate matchesCall(CallExpr call) {
    exists(string name, string argLabels |
      this.matchesMethodCallSelector(name, argLabels) and
      methodCallSelector(call, name, argLabels)
      or
      this.matchesConstructorCallSelector(name, argLabels) and
      constructorCallSelector(call, name, argLabels)
    )
  }

  predicate matchesCallable(Callable callable) {
    exists(string type, string name, string argLabels |
      callableSelector(callable, type, name, argLabels) and
      this = MkSelector(type, true, name, argLabels, _)
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
private DataFlow::Node getSinkFromCall(CallExpr call, AccessPathToken token) {
  token.getName() = "Argument" and
  exists(Argument arg |
    arg = call.getAnArgument() and
    result.asExpr() = arg.getValue()
  |
    arg.getPositionalIndex() = parseIntUnbounded(token.getAnArgument())
    or
    arg.getName() + ":" = token.getAnArgument()
  )
  or
  token = "Argument[self]" and
  result.isReceiverArgument(call)
}

/**
 * Gets the output from `call` specified by `token`. Only singleton access paths are supported.
 */
bindingset[call, token]
private DataFlow::Node getSourceFromCall(CallExpr call, AccessPathToken token) {
  token = "ReturnValue" and
  result.asExpr() = call
  or
  result = getSinkFromCall(call, token).getPostUpdateNode()
}

/**
 * Gets the sink from `callable` specified by `token`. Only singleton access paths are supported.
 */
bindingset[callable, token]
private DataFlow::Node getSinkFromCallable(Callable callable, AccessPathToken token) {
  token = "ReturnValue" and
  result.asExpr() = any(ReturnExpr r | r.getEnclosingCallable() = callable).getValue() // TODO: expose canonical return node in data flow
}

/**
 * Gets the source from `callable` specified by `token`. Only singleton access paths are supported.
 */
bindingset[callable, token]
private DataFlow::Node getSourceFromCallable(Callable callable, AccessPathToken token) {
  token.getName() = "Parameter" and
  exists(Parameter param |
    param.getParent() = callable and
    result.asExpr() = param.getPattern()
  |
    param.getPositionalIndex() = parseIntUnbounded(token.getAnArgument())
    or
    param.getExternalName() + ":" = token.getAnArgument()
  )
  or
  token = "Parameter[self]" and
  result.isReceiverParameter(callable)
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
  exists(Selector selector, AccessPath output |
    normalizedSourceModel(selector, output, kind, provenance)
  |
    exists(CallExpr call |
      selector.matchesCall(call) and
      result = getSourceFromCall(call, output)
    )
    or
    exists(Callable callable |
      selector.matchesCallable(callable) and
      result = getSourceFromCallable(callable, output)
    )
  )
}

/**
 * Gets a sink with the given `kind` and `provenance`.
 */
DataFlow::Node getASink(string kind, string provenance) {
  exists(Selector selector, AccessPath input |
    normalizedSinkModel(selector, input, kind, provenance)
  |
    exists(CallExpr call |
      selector.matchesCall(call) and
      result = getSinkFromCall(call, input)
    )
    or
    exists(Callable callable |
      selector.matchesCallable(callable) and
      result = getSinkFromCallable(callable, input)
    )
  )
}

module Public {
  /** Provides access to data from library models. */
  module Models {
    /** Holds if `node` is a source of the given `kind`. */
    predicate isSource(DataFlow::Node node, string kind) { node = getASource(kind, _) }

    /** Holds if `node` is a sink of the given `kind`. */
    predicate isSink(DataFlow::Node node, string kind) { node = getASink(kind, _) }
  }
}
