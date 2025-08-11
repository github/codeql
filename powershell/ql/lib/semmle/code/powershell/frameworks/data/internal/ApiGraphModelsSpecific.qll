/**
 * Contains the language-specific part of the models-as-data implementation found in `ApiGraphModels.qll`.
 *
 * It must export the following members:
 * ```ql
 * class Unit // a unit type
 * class InvokeNode // a type representing an invocation connected to the API graph
 * module API // the API graph module
 * predicate isPackageUsed(string package)
 * API::Node getExtraNodeFromPath(string package, string type, string path, int n)
 * API::Node getExtraSuccessorFromNode(API::Node node, AccessPathTokenBase token)
 * API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathTokenBase token)
 * predicate invocationMatchesExtraCallSiteFilter(InvokeNode invoke, AccessPathTokenBase token)
 * InvokeNode getAnInvocationOf(API::Node node)
 * predicate isExtraValidTokenNameInIdentifyingAccessPath(string name)
 * predicate isExtraValidNoArgumentTokenInIdentifyingAccessPath(string name)
 * predicate isExtraValidTokenArgumentInIdentifyingAccessPath(string name, string argument)
 * ```
 */

private import powershell
private import ApiGraphModels
private import semmle.code.powershell.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax
// Re-export libraries needed by ApiGraphModels.qll
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow::DataFlow as DataFlow
private import FlowSummaryImpl::Public
private import semmle.code.powershell.controlflow.Cfg
private import semmle.code.powershell.dataflow.internal.DataFlowDispatch as DataFlowDispatch

extensible predicate cmdletModel(string mod, string cmdlet);

extensible predicate aliasModel(string cmdlet, string alias);

bindingset[rawType]
predicate isTypeUsed(string rawType) { any() }

bindingset[rawType]
private predicate parseType(string rawType, string consts, string suffix) {
  exists(string regexp |
    regexp = "([^!]+)(!|)" and
    consts = rawType.regexpCapture(regexp, 1) and
    suffix = rawType.regexpCapture(regexp, 2)
  )
}

predicate parseRelevantType(string rawType, string consts, string suffix) {
  isRelevantType(rawType) and
  parseType(rawType, consts, suffix)
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

/** Gets a Powershell-specific interpretation of the `(type, path)` tuple after resolving the first `n` access path tokens. */
bindingset[type, path]
API::Node getExtraNodeFromPath(string type, AccessPath path, int n) { none() }

bindingset[type, name, namespace]
private predicate typeMatches(string type, string name, string namespace) {
  if namespace = "" then type.matches("%" + name) else type.matches("%" + namespace + "." + name)
}

bindingset[type]
private DataFlow::TypeNameNode getTypeNameNode(string type) {
  exists(string name, string namespace |
    name = result.getLowerCaseName() and
    namespace = result.getNamespace() and
    typeMatches(type, name, namespace)
  )
}

private string getTypeNameComponent(string type, int index) {
  index = [0 .. strictcount(type.indexOf("."))] and
  parseRelevantType(_, type, _) and
  result =
    strictconcat(int i, string s | s = type.splitAt(".", i) and i <= index | s, "." order by i)
}

predicate needsExplicitTypeNameNode(DataFlow::TypeNameNode typeName, string component) {
  exists(string type, int index |
    component = getTypeNameComponent(type, index) and
    typeName = getTypeNameNode(type) and
    index = [0 .. strictcount(type.indexOf(".")) - 1]
  )
}

predicate needsImplicitTypeNameNode(string component) {
  exists(string type, int index |
    component = getTypeNameComponent(type, index) and
    index = [0 .. strictcount(type.indexOf("."))] and
    type.matches("microsoft.powershell.%")
  )
}

/** Gets a Powershell-specific interpretation of the given `type`. */
API::Node getExtraNodeFromType(string rawType) {
  exists(string type, string suffix, DataFlow::TypeNameNode typeName |
    parseRelevantType(rawType, type, suffix) and
    typeName = getTypeNameNode(type)
  |
    suffix = "!" and
    result = typeName.(DataFlow::LocalSourceNode).track()
    or
    suffix = "" and
    result = typeName.(DataFlow::LocalSourceNode).track().getInstance()
  )
  or
  exists(string name, API::TypeNameNode typeName |
    parseRelevantType(rawType, name, _) and
    typeName = API::getTopLevelMember(name) and
    typeName.isImplicit() and
    result = typeName
  )
}

/**
 * Gets a Powershell-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromNode(API::Node node, AccessPathTokenBase token) {
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
  exists(DataFlowDispatch::ArgumentPosition argPos, DataFlowDispatch::ParameterPosition paramPos |
    token.getAnArgument() = FlowSummaryImpl::Input::encodeArgumentPosition(argPos) and
    DataFlowDispatch::parameterMatch(paramPos, argPos) and
    result = node.getParameterAtPosition(paramPos)
  )
  or
  exists(DataFlow::ContentSet contents |
    token.getName() = FlowSummaryImpl::Input::encodeContent(contents, token.getAnArgument()) and
    result = node.getContents(contents)
  )
}

/**
 * Gets a Powershell-specific API graph successor of `node` reachable by resolving `token`.
 */
bindingset[token]
API::Node getExtraSuccessorFromInvoke(InvokeNode node, AccessPathTokenBase token) {
  token.getName() = "Argument" and
  exists(DataFlowDispatch::ArgumentPosition argPos, DataFlowDispatch::ParameterPosition paramPos |
    token.getAnArgument() = FlowSummaryImpl::Input::encodeParameterPosition(paramPos) and
    DataFlowDispatch::parameterMatch(paramPos, argPos) and
    result = node.getArgumentAtPosition(argPos)
  )
}

pragma[inline]
API::Node getAFuzzySuccessor(API::Node node) {
  result = node.getMethod(_)
  or
  result =
    node.getArgumentAtPosition(any(DataFlowDispatch::ArgumentPosition apos | not apos.isThis()))
  or
  result =
    node.getParameterAtPosition(any(DataFlowDispatch::ParameterPosition ppos | not ppos.isThis()))
  or
  result = node.getReturn()
  or
  result = node.getAnElement()
  or
  result = node.getInstance()
}

/**
 * Holds if `invoke` matches the Powershell-specific call site filter in `token`.
 */
bindingset[token]
predicate invocationMatchesExtraCallSiteFilter(InvokeNode invoke, AccessPathTokenBase token) {
  none()
}

/** An API graph node representing a method call. */
class InvokeNode extends API::MethodAccessNode {
  /** Gets the number of arguments to the call. */
  int getNumArgument() { result = count(this.asCall().getAnArgument()) }
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
    argument = ["self", "lambda-self", "block", "any", "any-named"]
    or
    argument.regexpMatch("\\w+:") // keyword argument
  )
}

module ModelOutputSpecific { }
