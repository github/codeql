private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG as Cfg
private import Cfg::CfgNodes
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import codeql.ruby.dataflow.internal.DataFlowPublic as DataFlowPublic
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import codeql.ruby.dataflow.internal.SsaImpl as SsaImpl
private import codeql.ruby.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.dataflow.internal.FlowSummaryImplSpecific as FlowSummaryImplSpecific
private import codeql.ruby.dataflow.internal.AccessPathSyntax

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::LocalSourceNode;

class TypeTrackerContent = DataFlowPublic::ContentSet;

/**
 * An optional content set, that is, a `ContentSet` or the special "no content set" value.
 */
class OptionalTypeTrackerContent extends DataFlowPrivate::TOptionalContentSet {
  /** Gets a textual representation of this content set. */
  string toString() {
    this instanceof DataFlowPrivate::TNoContentSet and
    result = "no content"
    or
    result = this.(DataFlowPublic::ContentSet).toString()
  }
}

/**
 * Holds if a value stored with `storeContents` can be read back with `loadContents`.
 */
pragma[inline]
predicate compatibleContents(TypeTrackerContent storeContents, TypeTrackerContent loadContents) {
  storeContents.getAStoreContent() = loadContents.getAReadContent()
}

/** Gets the "no content set" value to use for a type tracker not inside any content. */
OptionalTypeTrackerContent noContent() { result = DataFlowPrivate::TNoContentSet() }

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
  or
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponent input,
    SummaryComponent output
  |
    hasLevelSummary(callable, input, output) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentLocal(call, input) and
    nodeTo = evaluateSummaryComponentLocal(call, output)
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`. */
predicate levelStep(Node nodeFrom, Node nodeTo) { summarizedLocalStep(nodeFrom, nodeTo) }

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
  exists(Cfg::CfgScope callable |
    DataFlowDispatch::getTarget(call) = callable and
    p.isSourceParameterOf(callable, ppos)
  )
}

/** Holds if there is flow from `arg` to `p` via the call `call`. */
pragma[nomagic]
predicate callStep(ExprNodes::CallCfgNode call, Node arg, DataFlowPrivate::ParameterNodeImpl p) {
  exists(DataFlowDispatch::ParameterPosition pos |
    argumentPositionMatch(call, arg, pos) and
    viableParam(call, p, pos)
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
 * Holds if `nodeFrom` is being written to the `contents` of the object
 * in `nodeTo`.
 *
 * Note that the choice of `nodeTo` does not have to make sense
 * "chronologically". All we care about is whether the `contents` of
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
 * for the content write `x.content = y`, we will have `contents` being the
 * literal string `"content"`, `nodeFrom` will be `y`, and `nodeTo` will be the
 * `Foo` object created on the first line of the function. This means we will
 * track the fact that `x.content` can have the type of `y` into the assignment
 * to `z` inside `bar`, even though this content write happens _after_ `bar` is
 * called.
 */
predicate basicStoreStep(Node nodeFrom, Node nodeTo, DataFlow::ContentSet contents) {
  postUpdateStoreStep(nodeFrom, nodeTo, contents)
  or
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponent input,
    SummaryComponent output
  |
    hasStoreSummary(callable, contents, input, output) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentLocal(call, input) and
    nodeTo = evaluateSummaryComponentLocal(call, output)
  )
}

/**
 * Holds if a store step `nodeFrom -> nodeTo` with `contents` exists, where the destination node
 * is a post-update node that should be treated as a local source node.
 */
predicate postUpdateStoreStep(Node nodeFrom, Node nodeTo, DataFlow::ContentSet contents) {
  // TODO: support SetterMethodCall inside TuplePattern
  exists(ExprNodes::MethodCallCfgNode call |
    contents
        .isSingleton(DataFlowPublic::Content::getAttributeName(call.getExpr()
                .(Ast::SetterMethodCall)
                .getTargetName())) and
    nodeTo.(DataFlowPublic::PostUpdateNode).getPreUpdateNode().asExpr() = call.getReceiver() and
    call.getExpr() instanceof Ast::SetterMethodCall and
    call.getArgument(call.getNumberOfArguments() - 1) =
      nodeFrom.(DataFlowPublic::ExprNode).getExprNode()
  )
}

/**
 * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
 */
predicate basicLoadStep(Node nodeFrom, Node nodeTo, DataFlow::ContentSet contents) {
  exists(ExprNodes::MethodCallCfgNode call |
    call.getExpr().getNumberOfArguments() = 0 and
    contents.isSingleton(DataFlowPublic::Content::getAttributeName(call.getExpr().getMethodName())) and
    nodeFrom.asExpr() = call.getReceiver() and
    nodeTo.asExpr() = call
  )
  or
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponent input,
    SummaryComponent output
  |
    hasLoadSummary(callable, contents, input, output) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentLocal(call, input) and
    nodeTo = evaluateSummaryComponentLocal(call, output)
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

private import SummaryComponentStack

private predicate hasLevelSummary(
  SummarizedCallable callable, SummaryComponent input, SummaryComponent output
) {
  callable.propagatesFlow(singleton(input), singleton(output), true)
}

private predicate hasStoreSummary(
  SummarizedCallable callable, DataFlow::ContentSet contents, SummaryComponent input,
  SummaryComponent output
) {
  callable
      .propagatesFlow(singleton(input),
        push(SummaryComponent::content(contents), singleton(output)), true)
}

private predicate hasLoadSummary(
  SummarizedCallable callable, DataFlow::ContentSet contents, SummaryComponent input,
  SummaryComponent output
) {
  callable
      .propagatesFlow(push(SummaryComponent::content(contents), singleton(input)),
        singleton(output), true)
}

/**
 * Gets a data flow node corresponding an argument or return value of `call`,
 * as specified by `component`.
 */
bindingset[call, component]
private DataFlowPublic::Node evaluateSummaryComponentLocal(
  DataFlowPublic::CallNode call, SummaryComponent component
) {
  exists(DataFlowDispatch::ParameterPosition pos |
    component = SummaryComponent::argument(pos) and
    argumentPositionMatch(call.asExpr(), result, pos)
  )
  or
  component = SummaryComponent::return() and
  result = call
}
