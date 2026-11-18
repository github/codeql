/**
 * Provides an approximate interpreter for MaD models imported from legacy Swift.
 */

private import unified
private import codeql.dataflow.internal.AccessPathSyntax
private import codeql.unified.internal.typeinference.TypeInference as T
private import codeql.unified.internal.typeinference.Type as Types
private import codeql.unified.internal.StaticNameBinding as N

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
private predicate constructorCallSelector(CallExpr call, TypeSelector type, string argLabels) {
  (
    if call.getCallee().(MemberAccessExpr).getMemberName() = "init"
    then type.getAStaticRef() = call.getCallee().(MemberAccessExpr).getBase()
    else type.getAStaticRef() = call.getCallee()
  ) and
  argLabels = getArgLabelsFromCall(call)
}

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
    callable = cls.getAMemberIncludingExtensions() and
    isSubclassOfType(cls, type)
  )
}

/** Holds if `name` from a model refers to a property, such as `count` in `String.count`. */
private predicate isRawPropertyName(string name) {
  modelContainsMethodName(name) and
  not name.matches("%(%")
}

/**
 * Holds if `access` may be an access to the property `name`, and its base has the inferred
 * type `baseType`.
 */
pragma[nomagic]
private predicate propertyAccessSelector(MemberAccess access, T::Type baseType, string name) {
  name = access.getMemberName() and
  name = any(Selector s).getPropertyName() and
  not access = any(CallExpr call).getCallee() and
  baseType = T::inferBaseType(access)
}

private newtype TSelector =
  MkCallSelector(string type, boolean subtypes, string name, string argLabels, string argTypes) {
    exists(string rawName |
      legacySourceModel(_, type, subtypes, rawName, argTypes, _, _, _, _)
      or
      legacySinkModel(_, type, subtypes, rawName, argTypes, _, _, _, _)
      or
      legacySummaryModel(_, type, subtypes, rawName, argTypes, _, _, _, _, _)
    |
      parsedRawMethodName(rawName, name, argLabels)
    )
  } or
  MkPropertySelector(string type, boolean subtypes, string name) {
    (
      legacySourceModel(_, type, subtypes, name, _, _, _, _, _)
      or
      legacySinkModel(_, type, subtypes, name, _, _, _, _, _)
    ) and
    isRawPropertyName(name)
  }

/**
 * A tuple from a model that identifies call sites, callables, or property accesses.
 */
class Selector extends TSelector {
  string getTypeString() {
    this = MkCallSelector(result, _, _, _, _) or this = MkPropertySelector(result, _, _)
  }

  boolean getSubtypesFlag() {
    this = MkCallSelector(_, result, _, _, _) or this = MkPropertySelector(_, result, _)
  }

  string getName() {
    this = MkCallSelector(_, _, result, _, _) or this = MkPropertySelector(_, _, result)
  }

  /** Gets the property name, if this is a property selector. */
  string getPropertyName() { this = MkPropertySelector(_, _, result) }

  string getArgLabels() { this = MkCallSelector(_, _, _, result, _) }

  string getArgTypes() { this = MkCallSelector(_, _, _, _, result) }

  private string ppSubtypes() {
    if this.getSubtypesFlag() = true then result = "+" else result = ""
  }

  string toString() {
    result =
      this.getTypeString() + this.ppSubtypes() + "." + this.getName() + "(" + this.getArgLabels() +
        ")" + this.getArgTypes()
    or
    result = this.getTypeString() + this.ppSubtypes() + "." + this.getPropertyName()
  }

  /** Holds if `name,argLabels` should be used to join with `methodCallSelector`. */
  pragma[nomagic]
  private predicate matchesMethodCallSelector(string name, string argLabels) {
    this = MkCallSelector(_, _, name, argLabels, _) and
    name != "init"
  }

  /** Holds if `name,argLabels` should be used to join with `constructorCallSelector`. */
  pragma[nomagic]
  private predicate matchesConstructorCallSelector(string name, string argLabels) {
    this = MkCallSelector(name, _, "init", argLabels, _)
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
      this = MkCallSelector(type, true, name, argLabels, _)
    )
  }

  /**
   * Holds if `access` is an access to the property identified by this selector, as determined
   * by the inferred type of its base.
   */
  predicate matchesPropertyAccess(MemberAccess access) {
    exists(TypeSelector type, boolean subtypes, string name |
      this = MkPropertySelector(type, subtypes, name) and
      propertyAccessSelector(access, type.getAnInstanceType([false, subtypes]), name)
    )
  }

  int getPositionalArity() { result = count(int n | this.getArgLabels().splitAt(":", n) = "_") }

  string getANamedArgument() { result = this.getArgLabels().splitAt(":") and result != "_" }
}

/** Gets the `n`th `.`-separated component in the given `type` string. */
pragma[nomagic]
private string getTypeComponent(string type, int n) {
  type = any(Selector s).getTypeString() and
  result = type.splitAt(".", n)
}

/** Holds if the `n`th prefix of `type` is `prefix`, which itself consists of `qualifier` followed by a single `component`. */
private predicate splitTypeString(
  string type, int n, string qualifier, string component, string prefix
) {
  component = getTypeComponent(type, n) and
  (
    n = 0 and qualifier = "" and prefix = component
    or
    splitTypeString(type, n - 1, _, _, qualifier) and
    prefix = qualifier + "." + component
  )
}

pragma[nomagic]
private string typeSelectorCons(string qualifier, string component) {
  splitTypeString(_, _, qualifier, component, result)
}

/** A type, or prefix thereof, mentioned in a model. */
class TypeSelector extends string {
  TypeSelector() { splitTypeString(_, _, _, _, this) }

  TypeSelector append(string component) { result = typeSelectorCons(this, component) }

  TypeSelector getQualifier() { this = result.append(_) }

  string getHead() { this = typeSelectorCons(_, result) }

  /** Gets a static reference to this type. */
  AstNode getAStaticRef() {
    N::trackTypeSelector(this) = N::getNodeFromRef(result)
    or
    // When the class has a declaration in the database, such as a built-in or stub class in a test case,
    // also include references to that class.
    N::getStaticBindingTargetFromRef(result) = this.getDeclaration().getNameNode()
  }

  /** Gets the declaration of this type, if any. */
  ClassLikeDeclaration getDeclaration() {
    result.getQualifiedName() = this and not exists(result.getExtensionTarget())
  }

  /** Gets the declaration of a proper subtype of this type (not the type itself). */
  ClassLikeDeclaration getASubtypeDeclaration() {
    result.getABaseClass*().getABaseType().getType() = this.getAStaticRef()
  }

  /** Gets a `Type` corresponding to instances of this type. */
  T::Type getAnInstanceType(boolean subtype) {
    subtype = false and
    (
      result.(Types::ModelType).getTypeSelector() = this
      or
      result.asClass() = this.getDeclaration()
    )
    or
    subtype = true and
    result.asClass() = this.getASubtypeDeclaration()
  }

  /**
   * Gets a call to the constructor of this type.
   *
   * Used as a seed for type inference for when the constructor itself is not in the database.
   */
  CallExpr getAConstructorCall() { constructorCallSelector(result, this, _) }
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
  token.getName() = "Argument" and
  token.getAnArgument() = "self" and
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
  result.isReturnNode(callable)
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
  token.getName() = "Parameter" and
  token.getAnArgument() = "self" and
  result.isReceiverParameter(callable)
}

/**
 * Gets the source from the property `access` specified by `path`.
 */
bindingset[access, path]
private DataFlow::Node getSourceFromPropertyAccess(MemberAccess access, AccessPath path) {
  path = "" and
  result.isResultValue(access)
}

/**
 * Gets the sink from the property `access` specified by `path`.
 */
bindingset[access, path]
private DataFlow::Node getSinkFromPropertyAccess(MemberAccess access, AccessPath path) {
  path = "PostUpdate" and
  (
    // The value being assigned to the property, as in `x.prop = value`
    result.isIncomingValue(access)
    or
    // The property value after being mutated in-place, as in `x.prop.append(value)`
    result.isPostUpdate(access)
  )
}

private predicate normalizedSourceModel(
  Selector selector, AccessPath output, string kind, string provenance
) {
  exists(string type, boolean subtypes, string rawName, string argTypes |
    legacySourceModel(_, type, subtypes, rawName, argTypes, _, output, kind, provenance)
  |
    exists(string name, string argLabels |
      parsedRawMethodName(rawName, name, argLabels) and
      selector = MkCallSelector(type, subtypes, name, argLabels, argTypes)
    )
    or
    selector = MkPropertySelector(type, subtypes, rawName)
  )
}

private predicate normalizedSinkModel(
  Selector selector, AccessPath output, string kind, string provenance
) {
  exists(string type, boolean subtypes, string rawName, string argTypes |
    legacySinkModel(_, type, subtypes, rawName, argTypes, _, output, kind, provenance)
  |
    exists(string name, string argLabels |
      parsedRawMethodName(rawName, name, argLabels) and
      selector = MkCallSelector(type, subtypes, name, argLabels, argTypes)
    )
    or
    selector = MkPropertySelector(type, subtypes, rawName)
  )
}

predicate normalizedSummaryModel(
  Selector selector, string input, string output, string kind, string provenance
) {
  exists(
    string type, boolean subtypes, string rawName, string name, string argLabels, string argTypes
  |
    legacySummaryModel(_, type, subtypes, rawName, argTypes, _, input, output, kind, provenance) and
    parsedRawMethodName(rawName, name, argLabels) and
    selector = MkCallSelector(type, subtypes, name, argLabels, argTypes)
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
    or
    exists(MemberAccess access |
      selector.matchesPropertyAccess(access) and
      result = getSourceFromPropertyAccess(access, output)
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
    or
    exists(MemberAccess access |
      selector.matchesPropertyAccess(access) and
      result = getSinkFromPropertyAccess(access, input)
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

private module Debug {
  query predicate invalidAccessPath(Selector selector, AccessPathToken ap) {
    (
      normalizedSourceModel(selector, ap, _, _)
      or
      normalizedSinkModel(selector, ap, _, _)
      or
      normalizedSummaryModel(selector, ap, _, _, _)
      or
      normalizedSummaryModel(selector, _, ap, _, _)
    ) and
    ap.getName() = ["Argument", "Parameter"] and
    (
      exists(int n |
        parseInt(ap.getAnArgument()) = n and
        not n in [0 .. selector.getPositionalArity() - 1]
      )
      or
      exists(string name |
        name = ap.getAnArgument().regexpCapture("(.*):", 1) and
        not name = selector.getANamedArgument()
      )
    )
  }
}
