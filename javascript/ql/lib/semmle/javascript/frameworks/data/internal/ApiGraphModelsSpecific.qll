/**
 * Contains the language-specific part of the models-as-data implementation found in `ApiGraphModels.qll`.
 *
 * It must export the following members:
 * ```codeql
 * class Unit // a unit type
 * module API // the API graph module
 * predicate isPackageUsed(string package)
 * API::Node getExtraNodeFromPath(string package, string type, string path, int n)
 * API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token)
 * API::Node getExtraSuccessorFromInvoke(API::InvokeNode node, AccessPathToken token)
 * predicate invocationMatchesExtraCallSiteFilter(API::InvokeNode invoke, AccessPathToken token)
 * ```
 */

private import javascript as js
private import js::DataFlow as DataFlow
private import ApiGraphModels

class Unit = js::Unit;

module API = js::API;

import semmle.javascript.frameworks.data.internal.AccessPathSyntax as AccessPathSyntax
private import AccessPathSyntax

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

/** Holds if `global` is a global variable referenced via a the `global` package in a CSV row. */
private predicate isRelevantGlobal(string global) {
  exists(AccessPath path, AccessPathToken token |
    isRelevantFullPath("global", "", path) and
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

  override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef(global) }

  override DataFlow::Node getARhs() { none() }

  /** Gets the name of the global variable. */
  string getGlobal() { result = global }
}

/**
 * Gets an API node referring to the given global variable (if relevant).
 */
private API::Node getGlobalNode(string globalName) {
  result = any(GlobalApiEntryPoint e | e.getGlobal() = globalName).getNode()
}

/** Gets a JavaScript-specific interpretation of the `(package, type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[package, type, path]
API::Node getExtraNodeFromPath(string package, string type, AccessPath path, int n) {
  type = "" and
  n = 0 and
  result = API::moduleImport(package)
  or
  // Global variable accesses is via the 'global' package
  exists(AccessPathToken token |
    package = getAPackageAlias("global") and
    type = "" and
    token = path.getToken(0) and
    token.getName() = "Member" and
    result = getGlobalNode(token.getAnArgument()) and
    n = 1
  )
  or
  // Access instance of a type based on type annotations
  n = 0 and
  result = API::Node::ofType(getAPackageAlias(package), type)
}

/**
 * Gets a JavaScript-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token) {
  token.getName() = "Member" and
  result = node.getMember(token.getAnArgument())
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
}

/**
 * Gets a JavaScript-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(API::InvokeNode node, AccessPathToken token) {
  token.getName() = "Instance" and
  result = node.getInstance()
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
}

/**
 * Holds if `path` is an input or output spec for a summary with the given `base` node.
 */
pragma[nomagic]
private predicate relevantInputOutputPath(API::InvokeNode base, AccessPath path) {
  ModelOutput::resolvedSummaryBase(base, path, _, _)
  or
  ModelOutput::resolvedSummaryBase(base, _, path, _)
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
  exists(API::InvokeNode base, AccessPath input, AccessPath output |
    ModelOutput::resolvedSummaryBase(base, input, output, kind) and
    pred = getNodeFromInputOutputPath(base, input) and
    succ = getNodeFromInputOutputPath(base, output)
  )
}

class InvokeNode = API::InvokeNode;

/** Gets an `InvokeNode` corresponding to an invocation of `node`. */
InvokeNode getAnInvocationOf(API::Node node) { result = node.getAnInvocation() }
