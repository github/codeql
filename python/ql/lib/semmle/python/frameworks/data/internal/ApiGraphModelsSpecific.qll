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
 * API::Node getExtraSuccessorFromInvoke(API::InvokeNode node, AccessPathToken token)
 * predicate invocationMatchesExtraCallSiteFilter(API::InvokeNode invoke, AccessPathToken token)
 * InvokeNode getAnInvocationOf(API::Node node)
 * predicate isExtraValidTokenNameInIdentifyingAccessPath(string name)
 * predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name)
 * predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument)
 * ```
 */

private import python as PY
private import ApiGraphModels
import semmle.python.ApiGraphs::API as API
// Re-export libraries needed by ApiGraphModels.qll
import semmle.python.dataflow.new.internal.AccessPathSyntax as AccessPathSyntax
import semmle.python.dataflow.new.DataFlow::DataFlow as DataFlow
private import AccessPathSyntax

/**
 * Holds if models describing `type` may be relevant for the analysis of this database.
 */
predicate isTypeUsed(string type) { API::moduleImportExists(type) }

/**
 * Holds if `type` can be obtained from an instance of `otherType` due to
 * language semantics modeled by `getExtraNodeFromType`.
 */
predicate hasImplicitTypeModel(string type, string otherType) { none() }

/** Gets a Python-specific interpretation of the `(type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[type, path]
API::Node getExtraNodeFromPath(string type, AccessPath path, int n) { none() }

/** Gets a Python-specific interpretation of the given `type`. */
API::Node getExtraNodeFromType(string type) { result = API::moduleImport(type) }

/**
 * Gets a Python-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token) {
  token.getName() = "Member" and
  result = node.getMember(token.getAnArgument())
  or
  token.getName() = "Instance" and
  result = node.getReturn() // In Python `Instance` is just an alias for `ReturnValue`
  or
  token.getName() = "Awaited" and
  result = node.getAwaited()
  or
  token.getName() = "Subclass" and
  result = node.getASubclass*()
  or
  token.getName() = "Method" and
  result = node.getMember(token.getAnArgument()).getReturn()
  or
  token.getName() = ["Argument", "Parameter"] and
  (
    token.getAnArgument() = "self" and
    result = node.getSelfParameter()
    or
    exists(string name | token.getAnArgument() = name + ":" |
      result = node.getKeywordParameter(name)
    )
    or
    token.getAnArgument() = "any" and
    result = [node.getParameter(_), node.getKeywordParameter(_)]
    or
    token.getAnArgument() = "any-named" and
    result = node.getKeywordParameter(_)
  )
  // Some features don't have MaD tokens yet, they would need to be added to API-graphs first.
  // - decorators ("DecoratedClass", "DecoratedMember", "DecoratedParameter")
  // - Array/Map elements ("ArrayElement", "Element", "MapKey", "MapValue")
}

/**
 * Gets a Python-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(API::CallNode node, AccessPathToken token) {
  token.getName() = "Instance" and
  result = node.getReturn()
  or
  token.getName() = ["Argument", "Parameter"] and
  (
    token.getAnArgument() = "self" and
    result = node.getSelfParameter()
    or
    token.getAnArgument() = "any" and
    result = [node.getParameter(_), node.getKeywordParameter(_)]
    or
    token.getAnArgument() = "any-named" and
    result = node.getKeywordParameter(_)
    or
    exists(string arg | arg + ":" = token.getAnArgument() | result = node.getKeywordParameter(arg))
  )
}

/**
 * Holds if `invoke` matches the PY-specific call site filter in `token`.
 */
bindingset[token]
predicate invocationMatchesExtraCallSiteFilter(API::CallNode invoke, AccessPathToken token) {
  token.getName() = "Call" and exists(invoke) // there is only one kind of call in Python.
}

/**
 * Holds if `path` is an input or output spec for a summary with the given `base` node.
 */
pragma[nomagic]
private predicate relevantInputOutputPath(API::CallNode base, AccessPath inputOrOutput) {
  exists(string type, string input, string output, string path |
    ModelOutput::relevantSummaryModel(type, path, input, output, _) and
    ModelOutput::resolvedSummaryBase(type, path, base) and
    inputOrOutput = [input, output]
  )
}

/**
 * Gets the API node for the first `n` tokens of the given input/output path, evaluated relative to `baseNode`.
 */
private API::Node getNodeFromInputOutputPath(API::CallNode baseNode, AccessPath path, int n) {
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
private API::Node getNodeFromInputOutputPath(API::CallNode baseNode, AccessPath path) {
  result = getNodeFromInputOutputPath(baseNode, path, path.getNumToken())
}

/**
 * Holds if a CSV summary contributed the step `pred -> succ` of the given `kind`.
 */
predicate summaryStep(API::Node pred, API::Node succ, string kind) {
  exists(string type, string path, API::CallNode base, AccessPath input, AccessPath output |
    ModelOutput::relevantSummaryModel(type, path, input, output, kind) and
    ModelOutput::resolvedSummaryBase(type, path, base) and
    pred = getNodeFromInputOutputPath(base, input) and
    succ = getNodeFromInputOutputPath(base, output)
  )
}

class InvokeNode = API::CallNode;

/** Gets an `InvokeNode` corresponding to an invocation of `node`. */
InvokeNode getAnInvocationOf(API::Node node) { result = node.getACall() }

/**
 * Holds if `name` is a valid name for an access path token in the identifying access path.
 */
bindingset[name]
predicate isExtraValidTokenNameInIdentifyingAccessPath(string name) {
  name = ["Member", "Instance", "Awaited", "Call", "Method", "Subclass"]
}

/**
 * Holds if `name` is a valid name for an access path token with no arguments, occurring
 * in an identifying access path.
 */
predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name) {
  name = ["Instance", "Awaited", "Call", "Subclass"]
}

/**
 * Holds if `argument` is a valid argument to an access path token with the given `name`, occurring
 * in an identifying access path.
 */
bindingset[name, argument]
predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument) {
  name = ["Member", "Method"] and
  exists(argument)
  or
  name = ["Argument", "Parameter"] and
  (
    argument = ["self", "any", "any-named"]
    or
    argument.regexpMatch("\\w+:") // keyword argument
  )
}

module ModelOutputSpecific { }
