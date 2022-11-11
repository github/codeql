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

private import codeql.ruby.AST
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import ApiGraphModels

class Unit = DataFlowPrivate::Unit;

// Re-export libraries needed by ApiGraphModels.qll
import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.internal.AccessPathSyntax as AccessPathSyntax
import codeql.ruby.DataFlow::DataFlow as DataFlow
private import AccessPathSyntax
private import codeql.ruby.dataflow.internal.FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import codeql.ruby.dataflow.internal.FlowSummaryImpl::Public
private import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

pragma[nomagic]
private predicate isUsedTopLevelConstant(string name) {
  exists(ConstantAccess access |
    access.getName() = name and
    not exists(access.getScopeExpr())
  )
}

bindingset[rawType]
predicate isTypeUsed(string rawType) {
  exists(string consts |
    parseType(rawType, consts, _) and
    isUsedTopLevelConstant(consts.splitAt("::", 0))
  )
  or
  rawType = ["", "any"]
}

bindingset[rawType]
private predicate parseType(string rawType, string consts, string suffix) {
  exists(string regexp |
    regexp = "([^!]+)(!|)" and
    consts = rawType.regexpCapture(regexp, 1) and
    suffix = rawType.regexpCapture(regexp, 2)
  )
}

/**
 * Holds if `type` can be obtained from an instance of `otherType` due to
 * language semantics modeled by `getExtraNodeFromType`.
 */
bindingset[otherType]
predicate hasImplicitTypeModel(string type, string otherType) {
  // A::B! can be used to obtain A::B
  parseType(otherType, type, _)
}

private predicate parseRelevantType(string rawType, string consts, string suffix) {
  isRelevantType(rawType) and
  parseType(rawType, consts, suffix)
}

pragma[nomagic]
private string getConstComponent(string consts, int n) {
  parseRelevantType(_, consts, _) and
  result = consts.splitAt("::", n)
}

private int getNumConstComponents(string consts) {
  result = strictcount(int n | exists(getConstComponent(consts, n)))
}

private DataFlow::ConstRef getConstantFromConstPath(string consts, int n) {
  n = 1 and
  result = DataFlow::getConstant(getConstComponent(consts, 0))
  or
  result = getConstantFromConstPath(consts, n - 1).getConstant(getConstComponent(consts, n - 1))
}

private DataFlow::ConstRef getConstantFromConstPath(string consts) {
  result = getConstantFromConstPath(consts, getNumConstComponents(consts))
}

/** Gets a Ruby-specific interpretation of the `(type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[type, path]
API::Node getExtraNodeFromPath(string type, AccessPath path, int n) {
  // A row of form `any;Method[foo]` should match any method named `foo`.
  type = "any" and
  n = 1 and
  exists(EntryPointFromAnyType entry |
    methodMatchedByName(path, entry.getName()) and
    result = entry.getANode()
  )
}

/** Gets a Ruby-specific interpretation of the given `type`. */
API::Node getExtraNodeFromType(string type) {
  exists(string consts, string suffix, DataFlow::ConstRef constRef |
    parseRelevantType(type, consts, suffix) and
    constRef = getConstantFromConstPath(consts)
  |
    suffix = "!" and
    (
      result.asSource() = constRef
      or
      result.asSource() = constRef.getADescendentModule().getAnOwnModuleSelf()
    )
    or
    suffix = "" and
    (
      result.asSource() = constRef.getAMethodCall("new")
      or
      result.asSource() = constRef.getADescendentModule().getAnInstanceSelf()
    )
  )
  or
  type = "" and
  result = API::root()
}

/**
 * Holds if `path` occurs in a CSV row with type `any`, meaning it can start
 * matching anywhere, and the path begins with `Method[methodName]`.
 */
private predicate methodMatchedByName(AccessPath path, string methodName) {
  isRelevantFullPath("any", path) and
  exists(AccessPathToken token |
    token = path.getToken(0) and
    token.getName() = "Method" and
    methodName = token.getAnArgument()
  )
}

/**
 * An API graph entry point corresponding to a method name such as `foo` in `;any;Method[foo]`.
 *
 * This ensures that the API graph rooted in that method call is materialized.
 */
private class EntryPointFromAnyType extends API::EntryPoint {
  string name;

  EntryPointFromAnyType() { this = "AnyMethod[" + name + "]" and methodMatchedByName(_, name) }

  override DataFlow::CallNode getACall() { result.getMethodName() = name }

  string getName() { result = name }
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
  or
  token.getName() = "Parameter" and
  result =
    node.getASuccessor(API::Label::getLabelFromParameterPosition(FlowSummaryImplSpecific::parseArgBody(token
              .getAnArgument())))
  or
  exists(DataFlow::ContentSet contents |
    SummaryComponent::content(contents) = FlowSummaryImplSpecific::interpretComponentSpecific(token) and
    result = node.getContents(contents)
  )
}

/**
 * Gets a Ruby-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathToken token) {
  token.getName() = "Argument" and
  result =
    node.getASuccessor(API::Label::getLabelFromArgumentPosition(FlowSummaryImplSpecific::parseParamBody(token
              .getAnArgument())))
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

/**
 * Holds if `name` is a valid name for an access path token in the identifying access path.
 */
bindingset[name]
predicate isExtraValidTokenNameInIdentifyingAccessPath(string name) {
  name = ["Member", "Method", "Instance", "WithBlock", "WithoutBlock", "Element", "Field"]
}

/**
 * Holds if `name` is a valid name for an access path token with no arguments, occurring
 * in an identifying access path.
 */
predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name) {
  name = ["Instance", "WithBlock", "WithoutBlock"]
}

/**
 * Holds if `argument` is a valid argument to an access path token with the given `name`, occurring
 * in an identifying access path.
 */
bindingset[name, argument]
predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument) {
  name = ["Member", "Method", "Element", "Field"] and
  exists(argument)
  or
  name = ["Argument", "Parameter"] and
  (
    argument = ["self", "block", "any", "any-named"]
    or
    argument.regexpMatch("\\w+:") // keyword argument
  )
}

module ModelOutputSpecific { }
