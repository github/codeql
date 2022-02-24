/**
 * Contains the language-specific part of the models-as-data implementation found in `ApiGraphModels.qll`.
 *
 * It must export the following members:
 * ```codeql
 * class Unit // a unit type
 * class InvokeNode // a type representing an invocation connected to the API graph
 * module API // the API graph module
 * predicate isPackageUsed(string package)
 * API::Node getExtraNodeFromPath(string package, string type, string path, int n)
 * API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token)
 * API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathToken token)
 * predicate invocationMatchesExtraCallSiteFilter(InvokeNode invoke, AccessPathToken token)
 * InvokeNode getAnInvocationOf(API::Node node)
 * ```
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import ApiGraphModels

class Unit = DataFlowPrivate::Unit;

import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.internal.AccessPathSyntax as AccessPathSyntax
private import AccessPathSyntax

/**
 * Holds if models describing `package` may be relevant for the analysis of this database.
 *
 * In the context of Ruby, this is the name of a Ruby gem.
 */
bindingset[package]
predicate isPackageUsed(string package) {
  // For now everything is modelled as an access path starting at any top-level, so the package name has no effect.
  //
  // We allow an arbitrary package name so that the model can record the name of the package in case it's needed in the future.
  //
  // In principle we should consider a package to be "used" if there is a transitive dependency on it, but we can only
  // reliably see the direct dependencies.
  //
  // In practice, packages try to use unique top-level module names, which mitigates the precision loss of not checking
  // the package name.
  any()
}

/** Gets a Ruby-specific interpretation of the `(package, type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[package, type, path]
API::Node getExtraNodeFromPath(string package, string type, AccessPath path, int n) {
  isRelevantFullPath(package, type, path) and
  package = any(string s) and // Allow any package name, see `isPackageUsed`.
  type = "" and
  n = 0 and
  result = API::root()
}

/**
 * Gets a Ruby-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromNode(API::Node node, AccessPathToken token) {
  token.getName() = "Member" and
  result = node.getMember(token.getAnArgument())
  or
  token.getName() = "Method" and
  result = node.getMethod(token.getAnArgument())
  or
  token.getName() = "Instance" and
  result = node.getInstance()
  // Note: The "ArrayElement" token is not implemented yet, as it ultimately requires type-tracking and
  // API graphs to be aware of the steps involving ArrayElement contributed by the standard library model.
  // Type-tracking cannot summarize function calls on its own, so it doesn't benefit from synthesized callables.
}

/**
 * Gets a Ruby-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathToken token) {
  token.getName() = "Instance" and
  result = node.getInstance()
}

/**
 * Holds if `invoke` matches the Ruby-specific call site filter in `token`.
 */
bindingset[token]
predicate invocationMatchesExtraCallSiteFilter(InvokeNode invoke, AccessPathToken token) {
  token.getName() = "WithBlock" and
  exists(invoke.getBlock())
  or
  token.getName() = "WithoutBlock" and
  not exists(invoke.getBlock())
}

/** An API graph node representing a method call. */
class InvokeNode extends API::MethodAccessNode {
  /** Gets the number of arguments to the call. */
  int getNumArgument() { result = getCallNode().getNumberOfArguments() }
}

/** Gets the `InvokeNode` corresponding to a specific invocation of `node`. */
InvokeNode getAnInvocationOf(API::Node node) { result = node }
