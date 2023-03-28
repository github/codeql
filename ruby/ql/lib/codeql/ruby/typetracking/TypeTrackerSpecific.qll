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

private module SCS = SummaryComponentStack;

private module SC = SummaryComponent;

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

private newtype TContentFilter = MkElementFilter()

/**
 * A label to use for `WithContent` and `WithoutContent` steps, restricting
 * which `ContentSet` may pass through.
 */
class ContentFilter extends TContentFilter {
  /** Gets a string representation of this content filter. */
  string toString() { this = MkElementFilter() and result = "elements" }

  /** Gets the content of a type-tracker that matches this filter. */
  TypeTrackerContent getAMatchingContent() {
    this = MkElementFilter() and
    result.getAReadContent() instanceof DataFlow::Content::ElementContent
  }
}

/** Module for getting `ContentFilter` values. */
module ContentFilter {
  /** Gets the filter that only allow element contents. */
  ContentFilter hasElements() { result = MkElementFilter() }
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

/** Holds if there is direct flow from `param` to a return. */
pragma[nomagic]
private predicate flowThrough(DataFlowPublic::ParameterNode param) {
  exists(DataFlowPrivate::ReturningNode returnNode, DataFlowDispatch::ReturnKind rk |
    DataFlowPrivate::LocalFlow::getParameterDefNode(param.getParameter())
        .(TypeTrackingNode)
        .flowsTo(returnNode) and
    rk = returnNode.getKind()
  |
    rk instanceof DataFlowDispatch::NormalReturnKind
    or
    rk instanceof DataFlowDispatch::BreakReturnKind
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
pragma[nomagic]
predicate levelStepCall(Node nodeFrom, Node nodeTo) {
  exists(DataFlowPublic::ParameterNode param |
    flowThrough(param) and
    callStep(nodeTo.asExpr(), nodeFrom, param)
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
pragma[nomagic]
predicate levelStepNoCall(Node nodeFrom, Node nodeTo) {
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    callable.propagatesFlow(input, output, true) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
  or
  localFieldStep(nodeFrom, nodeTo)
}

/**
 * Gets a method of `mod`, with `instance` indicating if this is an instance method.
 *
 * Does not take inheritance or the various forms of inclusion into account.
 */
pragma[nomagic]
private MethodBase getAMethod(ModuleBase mod, boolean instance) {
  not mod instanceof SingletonClass and
  result = mod.getAMethod() and
  if result instanceof SingletonMethod then instance = false else instance = true
  or
  exists(SingletonClass cls |
    cls.getValue().(SelfVariableAccess).getVariable().getDeclaringScope() = mod and
    result = cls.getAMethod().(Method) and
    instance = false
  )
}

/**
 * Gets a value flowing into `field` in `mod`, with `instance` indicating if it's
 * a field on an instance of `mod` (as opposed to the module object itself).
 */
pragma[nomagic]
private Node fieldPredecessor(ModuleBase mod, boolean instance, string field) {
  exists(InstanceVariableWriteAccess access, AssignExpr assign |
    access.getReceiver().getVariable().getDeclaringScope() = getAMethod(mod, instance) and
    field = access.getVariable().getName() and
    assign.getLeftOperand() = access and
    result.asExpr().getExpr() = assign.getRightOperand()
  )
}

/**
 * Gets a reference to `field` in `mod`, with `instance` indicating if it's
 * a field on an instance of `mod` (as opposed to the module object itself).
 */
pragma[nomagic]
private Node fieldSuccessor(ModuleBase mod, boolean instance, string field) {
  exists(InstanceVariableReadAccess access |
    access.getReceiver().getVariable().getDeclaringScope() = getAMethod(mod, instance) and
    result.asExpr().getExpr() = access and
    field = access.getVariable().getName()
  )
}

/**
 * Holds if `pred -> succ` should be used a level step, from a field assignment to
 * a read within the same class.
 */
private predicate localFieldStep(Node pred, Node succ) {
  exists(ModuleBase mod, boolean instance, string field |
    pred = fieldPredecessor(mod, instance, field) and
    succ = fieldSuccessor(mod, instance, field)
  )
}

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
    DataFlowDispatch::getTarget(call) = callable or
    DataFlowDispatch::getInitializeTarget(call) = callable
  |
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
    // deliberately do not include `getInitializeTarget`, since calls to `new` should not
    // get the return value from `initialize`. Any fields being set in the initializer
    // will reach all reads via `callStep` and `localFieldStep`.
    nodeTo.asExpr().getNode() = call.getNode()
  )
  or
  // In normal data-flow, this will be a local flow step. But for type tracking
  // we model it as a returning flow step, in order to avoid computing a potential
  // self-cross product of all calls to a function that returns one of its parameters
  // (only to later filter that flow out using `TypeTracker::append`).
  nodeTo.(DataFlowPrivate::SynthReturnNode).getAnInput() = nodeFrom and
  not nodeFrom instanceof DataFlowPrivate::InitializeReturnNode
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
  storeStepIntoSourceNode(nodeFrom, nodeTo, contents)
  or
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    hasStoreSummary(callable, contents, pragma[only_bind_into](input),
      pragma[only_bind_into](output)) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * Holds if a store step `nodeFrom -> nodeTo` with `contents` exists, where the destination node
 * is a post-update node that should be treated as a local source node.
 */
predicate storeStepIntoSourceNode(Node nodeFrom, Node nodeTo, DataFlow::ContentSet contents) {
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
  or
  DataFlowPrivate::storeStepCommon(nodeFrom, contents, nodeTo)
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
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    hasLoadSummary(callable, contents, pragma[only_bind_into](input), pragma[only_bind_into](output)) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
 */
predicate basicLoadStoreStep(
  Node nodeFrom, Node nodeTo, DataFlow::ContentSet loadContent, DataFlow::ContentSet storeContent
) {
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    hasLoadStoreSummary(callable, loadContent, storeContent, pragma[only_bind_into](input),
      pragma[only_bind_into](output)) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
 */
predicate basicWithoutContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    hasWithoutContentSummary(callable, filter, pragma[only_bind_into](input),
      pragma[only_bind_into](output)) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
predicate basicWithContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  exists(
    SummarizedCallable callable, DataFlowPublic::CallNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    hasWithContentSummary(callable, filter, pragma[only_bind_into](input),
      pragma[only_bind_into](output)) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

private import SummaryComponentStack

pragma[nomagic]
private predicate hasStoreSummary(
  SummarizedCallable callable, DataFlow::ContentSet contents, SummaryComponentStack input,
  SummaryComponentStack output
) {
  not isNonLocal(input.head()) and
  not isNonLocal(output.head()) and
  (
    callable.propagatesFlow(input, push(SummaryComponent::content(contents), output), true)
    or
    // Allow the input to start with an arbitrary WithoutContent[X].
    // Since type-tracking only tracks one content deep, and we're about to store into another content,
    // we're already preventing the input from being in a content.
    callable
        .propagatesFlow(push(SummaryComponent::withoutContent(_), input),
          push(SummaryComponent::content(contents), output), true)
  )
}

pragma[nomagic]
private predicate hasLoadSummary(
  SummarizedCallable callable, DataFlow::ContentSet contents, SummaryComponentStack input,
  SummaryComponentStack output
) {
  callable.propagatesFlow(push(SummaryComponent::content(contents), input), output, true) and
  not isNonLocal(input.head()) and
  not isNonLocal(output.head())
}

pragma[nomagic]
private predicate hasLoadStoreSummary(
  SummarizedCallable callable, DataFlow::ContentSet loadContents,
  DataFlow::ContentSet storeContents, SummaryComponentStack input, SummaryComponentStack output
) {
  callable
      .propagatesFlow(push(SummaryComponent::content(loadContents), input),
        push(SummaryComponent::content(storeContents), output), true) and
  not isNonLocal(input.head()) and
  not isNonLocal(output.head())
}

/**
 * Gets a content filter to use for a `WithoutContent[content]` step, or has no result if
 * the step should be treated as ordinary flow.
 *
 * `WithoutContent` is often used to perform strong updates on individual collection elements, but for
 * type-tracking this is rarely beneficial and quite expensive. However, `WithoutContent` can be quite useful
 * for restricting the type of an object, and in these cases we translate it to a filter.
 */
private ContentFilter getFilterFromWithoutContentStep(DataFlow::ContentSet content) {
  (
    content.isAnyElement()
    or
    content.isElementLowerBoundOrUnknown(_)
    or
    content.isElementOfTypeOrUnknown(_)
    or
    content.isSingleton(any(DataFlow::Content::UnknownElementContent c))
  ) and
  result = MkElementFilter()
}

pragma[nomagic]
private predicate hasWithoutContentSummary(
  SummarizedCallable callable, ContentFilter filter, SummaryComponentStack input,
  SummaryComponentStack output
) {
  exists(DataFlow::ContentSet content |
    callable.propagatesFlow(push(SummaryComponent::withoutContent(content), input), output, true) and
    filter = getFilterFromWithoutContentStep(content) and
    not isNonLocal(input.head()) and
    not isNonLocal(output.head()) and
    input != output
  )
}

/**
 * Gets a content filter to use for a `WithContent[content]` step, or has no result if
 * the step cannot be handled by type-tracking.
 *
 * `WithContent` is often used to perform strong updates on individual collection elements (or rather
 * to preserve those that didn't get updated). But for type-tracking this is rarely beneficial and quite expensive.
 * However, `WithContent` can be quite useful for restricting the type of an object, and in these cases we translate it to a filter.
 */
private ContentFilter getFilterFromWithContentStep(DataFlow::ContentSet content) {
  (
    content.isAnyElement()
    or
    content.isElementLowerBound(_)
    or
    content.isElementLowerBoundOrUnknown(_)
    or
    content.isElementOfType(_)
    or
    content.isElementOfTypeOrUnknown(_)
    or
    content.isSingleton(any(DataFlow::Content::ElementContent c))
  ) and
  result = MkElementFilter()
}

pragma[nomagic]
private predicate hasWithContentSummary(
  SummarizedCallable callable, ContentFilter filter, SummaryComponentStack input,
  SummaryComponentStack output
) {
  exists(DataFlow::ContentSet content |
    callable.propagatesFlow(push(SummaryComponent::withContent(content), input), output, true) and
    filter = getFilterFromWithContentStep(content) and
    not isNonLocal(input.head()) and
    not isNonLocal(output.head()) and
    input != output
  )
}

/**
 * Holds if the given component can't be evaluated by `evaluateSummaryComponentStackLocal`.
 */
pragma[nomagic]
predicate isNonLocal(SummaryComponent component) {
  component = SC::content(_)
  or
  component = SC::withContent(_)
}

/**
 * Gets a data flow node corresponding an argument or return value of `call`,
 * as specified by `component`.
 */
bindingset[call, component]
private DataFlow::Node evaluateSummaryComponentLocal(
  DataFlow::CallNode call, SummaryComponent component
) {
  exists(DataFlowDispatch::ParameterPosition pos |
    component = SummaryComponent::argument(pos) and
    argumentPositionMatch(call.asExpr(), result, pos)
  )
  or
  component = SummaryComponent::return() and
  result = call
}

/**
 * Holds if `callable` is relevant for type-tracking and we therefore want `stack` to
 * be evaluated locally at its call sites.
 */
pragma[nomagic]
private predicate dependsOnSummaryComponentStack(
  SummarizedCallable callable, SummaryComponentStack stack
) {
  exists(callable.getACallSimple()) and
  (
    callable.propagatesFlow(stack, _, true)
    or
    callable.propagatesFlow(_, stack, true)
    or
    // include store summaries as they may skip an initial step at the input
    hasStoreSummary(callable, _, stack, _)
  )
  or
  dependsOnSummaryComponentStackCons(callable, _, stack)
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackCons(
  SummarizedCallable callable, SummaryComponent head, SummaryComponentStack tail
) {
  dependsOnSummaryComponentStack(callable, SCS::push(head, tail))
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackConsLocal(
  SummarizedCallable callable, SummaryComponent head, SummaryComponentStack tail
) {
  dependsOnSummaryComponentStackCons(callable, head, tail) and
  not isNonLocal(head)
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackLeaf(
  SummarizedCallable callable, SummaryComponent leaf
) {
  dependsOnSummaryComponentStack(callable, SCS::singleton(leaf))
}

/**
 * Gets a data flow node corresponding to the local input or output of `call`
 * identified by `stack`, if possible.
 */
pragma[nomagic]
private DataFlow::Node evaluateSummaryComponentStackLocal(
  SummarizedCallable callable, DataFlow::CallNode call, SummaryComponentStack stack
) {
  exists(SummaryComponent component |
    dependsOnSummaryComponentStackLeaf(callable, component) and
    stack = SCS::singleton(component) and
    call.asExpr().getExpr() = callable.getACallSimple() and
    result = evaluateSummaryComponentLocal(call, component)
  )
  or
  exists(DataFlow::Node prev, SummaryComponent head, SummaryComponentStack tail |
    prev = evaluateSummaryComponentStackLocal(callable, call, tail) and
    dependsOnSummaryComponentStackConsLocal(callable, pragma[only_bind_into](head),
      pragma[only_bind_out](tail)) and
    stack = SCS::push(pragma[only_bind_out](head), pragma[only_bind_out](tail))
  |
    exists(DataFlowDispatch::ArgumentPosition apos, DataFlowDispatch::ParameterPosition ppos |
      head = SummaryComponent::parameter(apos) and
      DataFlowDispatch::parameterMatch(ppos, apos) and
      result.(DataFlowPrivate::ParameterNodeImpl).isSourceParameterOf(prev.asExpr().getExpr(), ppos)
    )
    or
    head = SummaryComponent::return() and
    result.(DataFlowPrivate::SynthReturnNode).getCfgScope() = prev.asExpr().getExpr()
    or
    exists(DataFlow::ContentSet content |
      head = SummaryComponent::withoutContent(content) and
      not exists(getFilterFromWithoutContentStep(content)) and
      result = prev
    )
  )
}
