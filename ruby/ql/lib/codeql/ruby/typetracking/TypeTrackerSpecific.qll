private import codeql.ruby.AST as AST
private import codeql.ruby.CFG as CFG
private import CFG::CfgNodes
private import codeql.ruby.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlowPublic
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import codeql.ruby.dataflow.internal.SsaImpl as SsaImpl

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::LocalSourceNode;

/** Holds if there is a simple local flow step from `nodeFrom` to `nodeTo` */
predicate simpleLocalFlowStep = DataFlowPrivate::localFlowStepTypeTracker/2;

/**
 * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
 */
predicate jumpStep = DataFlowPrivate::jumpStep/2;

/**
 * Holds if there is a summarized local flow step from `nodeFrom` to `nodeTo`,
 * because there is direct flow from a parameter to a return. That is, summarized
 * steps are not applied recursively.
 */
pragma[nomagic]
private predicate summarizedLocalStep(Node nodeFrom, Node nodeTo) {
  exists(DataFlowPublic::ParameterNode param, DataFlowPrivate::ReturningNode returnNode |
    DataFlowPrivate::LocalFlow::getParameterDefNode(param.getParameter())
        .(TypeTrackingNode)
        .flowsTo(returnNode) and
    callStep(nodeTo.asExpr(), nodeFrom, param)
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`. */
predicate levelStep(Node nodeFrom, Node nodeTo) { summarizedLocalStep(nodeFrom, nodeTo) }

/**
 * Gets the name of a possible piece of content. This will usually include things like
 *
 * - Attribute names (in Python)
 * - Property names (in JavaScript)
 */
string getPossibleContentName() { result = getSetterCallAttributeName(_) }

pragma[noinline]
private predicate argumentPositionMatch(
  ExprNodes::CallCfgNode call, DataFlowPrivate::ArgumentNode arg,
  DataFlowDispatch::ParameterPosition ppos
) {
  exists(DataFlowDispatch::ArgumentPosition apos |
    arg.sourceArgumentOf(call, apos) and
    DataFlowDispatch::parameterMatch(ppos, apos)
  )
}

pragma[noinline]
private predicate viableParam(
  ExprNodes::CallCfgNode call, DataFlowPrivate::ParameterNodeImpl p,
  DataFlowDispatch::ParameterPosition ppos
) {
  exists(CFG::CfgScope callable |
    DataFlowDispatch::getTarget(call) = callable and
    p.isSourceParameterOf(callable, ppos)
  )
}

private predicate callStep(ExprNodes::CallCfgNode call, Node nodeFrom, Node nodeTo) {
  exists(DataFlowDispatch::ParameterPosition pos |
    argumentPositionMatch(call, nodeFrom, pos) and
    viableParam(call, nodeTo, pos)
  )
}

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
 *
 * Flow into summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
predicate callStep(Node nodeFrom, Node nodeTo) {
  callStep(_, nodeFrom, nodeTo)
  or
  // In normal data-flow, this will be a local flow step. But for type tracking
  // we model it as a call step, in order to avoid computing a potential
  // self-cross product of all calls to a function that returns one of its parameters
  // (only to later filter that flow out using `TypeTracker::append`).
  DataFlowPrivate::LocalFlow::localFlowSsaParamInput(nodeFrom, nodeTo)
}

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
 *
 * Flow out of summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
predicate returnStep(Node nodeFrom, Node nodeTo) {
  exists(ExprNodes::CallCfgNode call |
    nodeFrom instanceof DataFlowPrivate::ReturnNode and
    nodeFrom.(DataFlowPrivate::NodeImpl).getCfgScope() = DataFlowDispatch::getTarget(call) and
    nodeTo.asExpr().getNode() = call.getNode()
  )
  or
  // In normal data-flow, this will be a local flow step. But for type tracking
  // we model it as a returning flow step, in order to avoid computing a potential
  // self-cross product of all calls to a function that returns one of its parameters
  // (only to later filter that flow out using `TypeTracker::append`).
  nodeTo.(DataFlowPrivate::SynthReturnNode).getAnInput() = nodeFrom
}

/**
 * Holds if `nodeFrom` is being written to the `content` content of the object
 * in `nodeTo`.
 *
 * Note that the choice of `nodeTo` does not have to make sense
 * "chronologically". All we care about is whether the `content` content of
 * `nodeTo` can have a specific type, and the assumption is that if a specific
 * type appears here, then any access of that particular content can yield
 * something of that particular type.
 *
 * Thus, in an example such as
 *
 * ```rb
 * def foo(y)
 *    x = Foo.new
 *    bar(x)
 *    x.content = y
 *    baz(x)
 * end
 *
 * def bar(x)
 *    z = x.content
 * end
 * ```
 * for the content write `x.content = y`, we will have `content` being the
 * literal string `"content"`, `nodeFrom` will be `y`, and `nodeTo` will be the
 * `Foo` object created on the first line of the function. This means we will
 * track the fact that `x.content` can have the type of `y` into the assignment
 * to `z` inside `bar`, even though this content write happens _after_ `bar` is
 * called.
 */
predicate basicStoreStep(Node nodeFrom, Node nodeTo, string content) {
  // TODO: support SetterMethodCall inside TuplePattern
  exists(ExprNodes::MethodCallCfgNode call |
    content = getSetterCallAttributeName(call.getExpr()) and
    nodeTo.(DataFlowPublic::PostUpdateNode).getPreUpdateNode().asExpr() = call.getReceiver() and
    call.getExpr() instanceof AST::SetterMethodCall and
    call.getArgument(call.getNumberOfArguments() - 1) =
      nodeFrom.(DataFlowPublic::ExprNode).getExprNode()
  )
}

/**
 * Returns the name of the attribute being set by the setter method call, i.e.
 * the name of the setter method without the trailing `=`. In the following
 * example, the result is `"bar"`.
 *
 * ```rb
 * foo.bar = 1
 * ```
 */
private string getSetterCallAttributeName(AST::SetterMethodCall call) {
  // TODO: this should be exposed in `SetterMethodCall`
  exists(string setterName |
    setterName = call.getMethodName() and result = setterName.prefix(setterName.length() - 1)
  )
}

/**
 * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
 */
predicate basicLoadStep(Node nodeFrom, Node nodeTo, string content) {
  exists(ExprNodes::MethodCallCfgNode call |
    call.getExpr().getNumberOfArguments() = 0 and
    content = call.getExpr().getMethodName() and
    nodeFrom.asExpr() = call.getReceiver() and
    nodeTo.asExpr() = call
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}
