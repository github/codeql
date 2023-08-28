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
predicate jumpStep = DataFlowPrivate::jumpStepTypeTracker/2;

/** Holds if there is direct flow from `param` to a return. */
pragma[nomagic]
private predicate flowThrough(DataFlowPublic::ParameterNode param) {
  exists(DataFlowPrivate::SourceReturnNode returnNode, DataFlowDispatch::ReturnKind rk |
    param.flowsTo(returnNode) and
    returnNode.hasKind(rk, param.(DataFlowPrivate::NodeImpl).getCfgScope())
  |
    rk instanceof DataFlowDispatch::NormalReturnKind
    or
    rk instanceof DataFlowDispatch::BreakReturnKind
  )
}

/** Holds if there is flow from `arg` to `p` via the call `call`, not counting `new -> initialize` call steps. */
pragma[nomagic]
predicate callStepNoInitialize(
  ExprNodes::CallCfgNode call, Node arg, DataFlowPrivate::ParameterNodeImpl p
) {
  exists(DataFlowDispatch::ParameterPosition pos |
    argumentPositionMatch(call, arg, pos) and
    p.isSourceParameterOf(DataFlowDispatch::getTarget(call), pos)
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
pragma[nomagic]
predicate levelStepCall(Node nodeFrom, Node nodeTo) {
  exists(DataFlowPublic::ParameterNode param |
    flowThrough(param) and
    callStepNoInitialize(nodeTo.asExpr(), nodeFrom, param)
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
pragma[nomagic]
predicate levelStepNoCall(Node nodeFrom, Node nodeTo) {
  TypeTrackerSummaryFlow::levelStepNoCall(nodeFrom, nodeTo)
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
predicate callStep(Node nodeFrom, Node nodeTo) { callStep(_, nodeFrom, nodeTo) }

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
    not nodeFrom instanceof DataFlowPrivate::InitializeReturnNode and
    nodeFrom.(DataFlowPrivate::NodeImpl).getCfgScope() = DataFlowDispatch::getTarget(call) and
    // deliberately do not include `getInitializeTarget`, since calls to `new` should not
    // get the return value from `initialize`. Any fields being set in the initializer
    // will reach all reads via `callStep` and `localFieldStep`.
    nodeTo.asExpr().getAstNode() = call.getAstNode()
  )
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
  TypeTrackerSummaryFlow::basicStoreStep(nodeFrom, nodeTo, contents)
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
  readStepIntoSourceNode(nodeFrom, nodeTo, contents)
  or
  exists(ExprNodes::MethodCallCfgNode call |
    call.getExpr().getNumberOfArguments() = 0 and
    contents.isSingleton(DataFlowPublic::Content::getAttributeName(call.getExpr().getMethodName())) and
    nodeFrom.asExpr() = call.getReceiver() and
    nodeTo.asExpr() = call
  )
  or
  TypeTrackerSummaryFlow::basicLoadStep(nodeFrom, nodeTo, contents)
}

/**
 * Holds if a read step `nodeFrom -> nodeTo` with `contents` exists, where the destination node
 * should be treated as a local source node.
 */
predicate readStepIntoSourceNode(Node nodeFrom, Node nodeTo, DataFlow::ContentSet contents) {
  DataFlowPrivate::readStepCommon(nodeFrom, contents, nodeTo)
}

/**
 * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
 */
predicate basicLoadStoreStep(
  Node nodeFrom, Node nodeTo, DataFlow::ContentSet loadContent, DataFlow::ContentSet storeContent
) {
  readStoreStepIntoSourceNode(nodeFrom, nodeTo, loadContent, storeContent)
  or
  TypeTrackerSummaryFlow::basicLoadStoreStep(nodeFrom, nodeTo, loadContent, storeContent)
}

/**
 * Holds if a read+store step `nodeFrom -> nodeTo` exists, where the destination node
 * should be treated as a local source node.
 */
predicate readStoreStepIntoSourceNode(
  Node nodeFrom, Node nodeTo, DataFlow::ContentSet loadContent, DataFlow::ContentSet storeContent
) {
  exists(DataFlowPrivate::SynthSplatParameterElementNode mid |
    nodeFrom
        .(DataFlowPrivate::SynthSplatArgParameterNode)
        .isParameterOf(mid.getEnclosingCallable(), _) and
    loadContent = DataFlowPrivate::getPositionalContent(mid.getReadPosition()) and
    nodeTo = mid.getSplatParameterNode(_) and
    storeContent = DataFlowPrivate::getPositionalContent(mid.getStorePosition())
  )
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
 */
predicate basicWithoutContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  TypeTrackerSummaryFlow::basicWithoutContentStep(nodeFrom, nodeTo, filter)
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
predicate basicWithContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) {
  TypeTrackerSummaryFlow::basicWithContentStep(nodeFrom, nodeTo, filter)
}

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

private import SummaryComponentStack

/**
 * Holds if the given component can't be evaluated by `evaluateSummaryComponentStackLocal`.
 */
pragma[nomagic]
predicate isNonLocal(SummaryComponent component) {
  component = SC::content(_)
  or
  component = SC::withContent(_)
}

private import internal.SummaryTypeTracker as SummaryTypeTracker
private import codeql.ruby.dataflow.FlowSummary as FlowSummary

private module SummaryTypeTrackerInput implements SummaryTypeTracker::Input {
  // Dataflow nodes
  class Node = DataFlow::Node;

  // Content
  class TypeTrackerContent = DataFlowPublic::ContentSet;

  class TypeTrackerContentFilter = ContentFilter;

  TypeTrackerContentFilter getFilterFromWithoutContentStep(TypeTrackerContent content) {
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

  TypeTrackerContentFilter getFilterFromWithContentStep(TypeTrackerContent content) {
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

  // Summaries and their stacks
  class SummaryComponent = FlowSummary::SummaryComponent;

  class SummaryComponentStack = FlowSummary::SummaryComponentStack;

  predicate singleton = FlowSummary::SummaryComponentStack::singleton/1;

  predicate push = FlowSummary::SummaryComponentStack::push/2;

  // Relating content to summaries
  predicate content = FlowSummary::SummaryComponent::content/1;

  predicate withoutContent = FlowSummary::SummaryComponent::withoutContent/1;

  predicate withContent = FlowSummary::SummaryComponent::withContent/1;

  predicate return = FlowSummary::SummaryComponent::return/0;

  // Callables
  class SummarizedCallable = FlowSummary::SummarizedCallable;

  // Relating nodes to summaries
  Node argumentOf(Node call, SummaryComponent arg) {
    exists(DataFlowDispatch::ParameterPosition pos |
      arg = SummaryComponent::argument(pos) and
      argumentPositionMatch(call.asExpr(), result, pos)
    )
  }

  Node parameterOf(Node callable, SummaryComponent param) {
    exists(DataFlowDispatch::ArgumentPosition apos, DataFlowDispatch::ParameterPosition ppos |
      param = SummaryComponent::parameter(apos) and
      DataFlowDispatch::parameterMatch(ppos, apos) and
      result
          .(DataFlowPrivate::ParameterNodeImpl)
          .isSourceParameterOf(callable.asExpr().getExpr(), ppos)
    )
  }

  Node returnOf(Node callable, SummaryComponent return) {
    return = SummaryComponent::return() and
    result.(DataFlowPrivate::ReturnNode).(DataFlowPrivate::NodeImpl).getCfgScope() =
      callable.asExpr().getExpr()
  }

  // Relating callables to nodes
  Node callTo(SummarizedCallable callable) { result.asExpr().getExpr() = callable.getACallSimple() }
}

private module TypeTrackerSummaryFlow = SummaryTypeTracker::SummaryFlow<SummaryTypeTrackerInput>;
