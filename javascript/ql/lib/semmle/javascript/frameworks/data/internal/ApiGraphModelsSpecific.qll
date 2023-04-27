/**
 * Contains the language-specific part of the models-as-data implementation found in `ApiGraphModels.qll`.
 *
 * It must export the following members:
 * ```ql
 * class Unit // a unit type
 * module AccessPathSyntax // a re-export of the AccessPathSyntax module
 * class InvokeNode // a type representing an invocation connected to the API graph
 * module API // the API graph module
 * predicate isPackageUsed(string package)
 * API::Node getExtraNodeFromPath(string package, string type, string path, int n)
 * API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token)
 * API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathToken token)
 * predicate invocationMatchesExtraCallSiteFilter(InvokeNode invoke, AccessPathToken token)
 * InvokeNode getAnInvocationOf(API::Node node)
 * predicate isExtraValidTokenNameInIdentifyingAccessPath(string name)
 * predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name)
 * predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument)
 * ```
 */

private import javascript as JS
private import ApiGraphModels

// Re-export libraries needed by ApiGraphModels.qll
module API = JS::API;

import semmle.javascript.frameworks.data.internal.AccessPathSyntax as AccessPathSyntax
import JS::DataFlow as DataFlow
private import AccessPathSyntax

/**
 * Holds if `rawType` represents the JavaScript type `qualifiedName` from the given NPM `package`.
 *
 * Type names have form `package.type` or just `package` if referring to the package export
 * object. If `package` contains a `.` character it must be enclosed in single quotes, such as `'package'.type`.
 */
bindingset[rawType]
predicate parseTypeString(string rawType, string package, string qualifiedName) {
  exists(string regexp |
    regexp = "('[^']+'|[^.]+)(.*)" and
    package = rawType.regexpCapture(regexp, 1).regexpReplaceAll("^'|'$", "") and
    qualifiedName = rawType.regexpCapture(regexp, 2).regexpReplaceAll("^\\.", "")
  )
}

/**
 * Holds if models describing `package` may be relevant for the analysis of this database.
 */
predicate isPackageUsed(string package) {
  exists(DataFlow::moduleImport(package))
  or
  package = "global"
  or
  any(DataFlow::SourceNode sn).hasUnderlyingType(package, _)
}

bindingset[type]
predicate isTypeUsed(string type) {
  exists(string package |
    parseTypeString(type, package, _) and
    isPackageUsed(package)
  )
}

/**
 * Holds if `type` can be obtained from an instance of `otherType` due to
 * language semantics modeled by `getExtraNodeFromType`.
 */
predicate hasImplicitTypeModel(string type, string otherType) { none() }

pragma[nomagic]
private predicate parseRelevantTypeString(string rawType, string package, string qualifiedName) {
  isRelevantFullPath(rawType, _) and
  parseTypeString(rawType, package, qualifiedName)
}

/** Holds if `global` is a global variable referenced via a the `global` package in a CSV row. */
private predicate isRelevantGlobal(string global) {
  exists(AccessPath path, AccessPathToken token |
    isRelevantFullPath("global", path) and
    token = path.getToken(0) and
    token.getName() = "Member" and
    global = token.getAnArgument()
  )
}

/** An API graph entry point for global variables mentioned in a model. */
private class GlobalApiEntryPoint extends API::EntryPoint {
  string global;

  GlobalApiEntryPoint() {
    isRelevantGlobal(global) and
    this = "GlobalApiEntryPoint:" + global
  }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef(global) }

  /** Gets the name of the global variable. */
  string getGlobal() { result = global }
}

/**
 * Gets an API node referring to the given global variable (if relevant).
 */
private API::Node getGlobalNode(string globalName) {
  result = any(GlobalApiEntryPoint e | e.getGlobal() = globalName).getANode()
}

/** Gets a JavaScript-specific interpretation of the `(type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[type, path]
API::Node getExtraNodeFromPath(string type, AccessPath path, int n) {
  // Global variable accesses is via the 'global' package
  exists(AccessPathToken token |
    type = "global" and
    token = path.getToken(0) and
    token.getName() = "Member" and
    result = getGlobalNode(token.getAnArgument()) and
    n = 1
  )
}

/** Gets a JavaScript-specific interpretation of the `(package, type)` tuple. */
API::Node getExtraNodeFromType(string type) {
  exists(string package, string qualifiedName |
    parseRelevantTypeString(type, package, qualifiedName)
  |
    qualifiedName = "" and
    result = API::moduleImport(package)
    or
    // Access instance of a type based on type annotations
    result = API::Internal::getANodeOfTypeRaw(package, qualifiedName)
  )
}

/**
 * Gets a JavaScript-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token) {
  token.getName() = "Member" and
  result = node.getMember(token.getAnArgument())
  or
  token.getName() = "AnyMember" and
  result = node.getAMember()
  or
  token.getName() = "Instance" and
  result = node.getInstance()
  or
  token.getName() = "Awaited" and
  result = node.getPromised()
  or
  token.getName() = "ArrayElement" and
  result = node.getMember(DataFlow::PseudoProperties::arrayElement())
  or
  token.getName() = "Element" and
  result = node.getMember(DataFlow::PseudoProperties::arrayLikeElement())
  or
  // Note: MapKey not currently supported
  token.getName() = "MapValue" and
  result = node.getMember(DataFlow::PseudoProperties::mapValueAll())
  or
  // Currently we need to include the "unknown member" for ArrayElement and Element since
  // API graphs do not use store/load steps for arrays
  token.getName() = ["ArrayElement", "Element"] and
  result = node.getUnknownMember()
  or
  token.getName() = "Parameter" and
  token.getAnArgument() = "this" and
  result = node.getReceiver()
  or
  token.getName() = "DecoratedClass" and
  result = node.getADecoratedClass()
  or
  token.getName() = "DecoratedMember" and
  result = node.getADecoratedMember()
  or
  token.getName() = "DecoratedParameter" and
  result = node.getADecoratedParameter()
}

/**
 * Gets a JavaScript-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(API::InvokeNode node, AccessPathToken token) {
  token.getName() = "Instance" and
  result = node.getInstance()
  or
  token.getName() = "Argument" and
  token.getAnArgument() = "this" and
  result.asSink() = node.(DataFlow::CallNode).getReceiver()
}

/**
 * Holds if `invoke` matches the JS-specific call site filter in `token`.
 */
bindingset[token]
predicate invocationMatchesExtraCallSiteFilter(API::InvokeNode invoke, AccessPathToken token) {
  token.getName() = "NewCall" and
  invoke instanceof API::NewNode
  or
  token.getName() = "Call" and
  invoke instanceof API::CallNode and
  invoke instanceof DataFlow::CallNode // Workaround compiler bug
  or
  token.getName() = "WithStringArgument" and
  exists(string operand, string argIndex, string stringValue |
    operand = token.getAnArgument() and
    argIndex = operand.splitAt("=", 0) and
    stringValue = operand.splitAt("=", 1) and
    invoke
        .getArgument(AccessPath::parseIntWithArity(argIndex, invoke.getNumArgument()))
        .getStringValue() = stringValue
  )
}

/**
 * Holds if `path` is an input or output spec for a summary with the given `base` node.
 */
pragma[nomagic]
private predicate relevantInputOutputPath(API::InvokeNode base, AccessPath inputOrOutput) {
  exists(string type, string input, string output, string path |
    ModelOutput::relevantSummaryModel(type, path, input, output, _) and
    ModelOutput::resolvedSummaryBase(type, path, base) and
    inputOrOutput = [input, output]
  )
}

/**
 * Gets the API node for the first `n` tokens of the given input/output path, evaluated relative to `baseNode`.
 */
private API::Node getNodeFromInputOutputPath(API::InvokeNode baseNode, AccessPath path, int n) {
  relevantInputOutputPath(baseNode, path) and
  (
    n = 1 and
    result = getSuccessorFromInvoke(baseNode, path.getToken(0))
    or
    result =
      getSuccessorFromNode(getNodeFromInputOutputPath(baseNode, path, n - 1), path.getToken(n - 1))
  )
}

/**
 * Gets the API node for the given input/output path, evaluated relative to `baseNode`.
 */
private API::Node getNodeFromInputOutputPath(API::InvokeNode baseNode, AccessPath path) {
  result = getNodeFromInputOutputPath(baseNode, path, path.getNumToken())
}

/**
 * Holds if a CSV summary contributed the step `pred -> succ` of the given `kind`.
 */
predicate summaryStep(API::Node pred, API::Node succ, string kind) {
  exists(string type, string path, API::InvokeNode base, AccessPath input, AccessPath output |
    ModelOutput::relevantSummaryModel(type, path, input, output, kind) and
    ModelOutput::resolvedSummaryBase(type, path, base) and
    pred = getNodeFromInputOutputPath(base, input) and
    succ = getNodeFromInputOutputPath(base, output)
  )
}

class InvokeNode = API::InvokeNode;

/** Gets an `InvokeNode` corresponding to an invocation of `node`. */
InvokeNode getAnInvocationOf(API::Node node) { result = node.getAnInvocation() }

/**
 * Holds if `name` is a valid name for an access path token in the identifying access path.
 */
bindingset[name]
predicate isExtraValidTokenNameInIdentifyingAccessPath(string name) {
  name =
    [
      "Member", "AnyMember", "Instance", "Awaited", "ArrayElement", "Element", "MapValue",
      "NewCall", "Call", "DecoratedClass", "DecoratedMember", "DecoratedParameter",
      "WithStringArgument"
    ]
}

/**
 * Holds if `name` is a valid name for an access path token with no arguments, occurring
 * in an identifying access path.
 */
predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name) {
  name =
    [
      "AnyMember", "Instance", "Awaited", "ArrayElement", "Element", "MapValue", "NewCall", "Call",
      "DecoratedClass", "DecoratedMember", "DecoratedParameter"
    ]
}

/**
 * Holds if `argument` is a valid argument to an access path token with the given `name`, occurring
 * in an identifying access path.
 */
bindingset[name, argument]
predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument) {
  name = ["Member"] and
  exists(argument)
  or
  name = "WithStringArgument" and
  exists(argument.indexOf("=")) and
  exists(AccessPath::parseIntWithArity(argument.splitAt("=", 0), 10))
}

module ModelOutputSpecific {
  /**
   * Gets a node that should be seen as an instance of `package,type` due to a type definition
   * contributed by a CSV model.
   */
  cached
  API::Node getATypeNode(string package, string qualifiedName) {
    exists(string rawType |
      result = ModelOutput::getATypeNode(rawType) and
      parseTypeString(rawType, package, qualifiedName)
    )
  }
}
